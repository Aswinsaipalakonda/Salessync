#!/bin/bash

# Configuration
VPS_IP="145.223.18.5"
VPS_PATH="/var/www/salessync"
LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================="
echo "Starting SalesSyncVue Fast Deployment Script"
echo "========================================="

# 1. Build Vue Frontend Locally
echo "Step 1: Building Vue frontend locally..."
cd "$LOCAL_DIR/frontend" || exit 1
npm run build
if [ $? -ne 0 ]; then
    echo "ERROR: Frontend build failed!"
    exit 1
fi
cd "$LOCAL_DIR"

# 2. Transfer Files to VPS
echo "Step 2: Syncing files to VPS ($VPS_IP)..."

# Ensure VPS directories exist
ssh root@$VPS_IP "mkdir -p $VPS_PATH/backend $VPS_PATH/frontend/dist"

# Check if rsync is available locally
if command -v rsync >/dev/null 2>&1; then
    echo "Using rsync for fast transfer..."
    rsync -avz --delete \
        --exclude="venv/" \
        --exclude="db.sqlite3" \
        --exclude=".git/" \
        --exclude="node_modules/" \
        --exclude="*.pyc" \
        --exclude="__pycache__/" \
        "$LOCAL_DIR/backend/" root@$VPS_IP:$VPS_PATH/backend/

    rsync -avz --delete \
        "$LOCAL_DIR/frontend/dist/" root@$VPS_IP:$VPS_PATH/frontend/dist/
else
    echo "rsync not found. Falling back to temporary tar method..."
    TEMP_DIR="$LOCAL_DIR/temp_deploy"
    mkdir -p "$TEMP_DIR"
    BACKEND_TAR="$TEMP_DIR/backend.tar.gz"
    FRONTEND_TAR="$TEMP_DIR/frontend.tar.gz"

    # Tar files locally (using cross-platform tar parameters)
    echo "Compressing files locally..."
    cd "$LOCAL_DIR/backend" && tar -czf "$BACKEND_TAR" --exclude="*.git*" --exclude="venv*" --exclude="*__pycache__*" --exclude="*.pyc" --exclude="db.sqlite3" .
    cd "$LOCAL_DIR/frontend/dist" && tar -czf "$FRONTEND_TAR" .
    cd "$LOCAL_DIR"

    # SCP tars to VPS
    echo "Uploading compressed archives..."
    scp "$BACKEND_TAR" root@$VPS_IP:$VPS_PATH/backend.tar.gz
    scp "$FRONTEND_TAR" root@$VPS_IP:$VPS_PATH/frontend.tar.gz

    # Untar on VPS
    echo "Extracting archives on VPS..."
    ssh root@$VPS_IP "
        tar -xzf $VPS_PATH/backend.tar.gz -C $VPS_PATH/backend && rm $VPS_PATH/backend.tar.gz
        tar -xzf $VPS_PATH/frontend.tar.gz -C $VPS_PATH/frontend/dist && rm $VPS_PATH/frontend.tar.gz
    "

    # Clean up local tars
    rm -rf "$TEMP_DIR"
fi

# 3. Transfer Nginx Config
echo "Step 3: Syncing Nginx configuration file..."
scp "$LOCAL_DIR/salessync_nginx.conf" root@$VPS_IP:/etc/nginx/sites-available/salessync

# 4. Configure and restart services on VPS
echo "Step 4: Configuring backend dependencies and restarting services on VPS..."
ssh root@$VPS_IP "
    cd $VPS_PATH/backend
    if [ ! -d \"venv\" ]; then
        echo \"Creating Python virtual environment...\"
        python3 -m venv venv
    fi
    ./venv/bin/pip install -U pip
    ./venv/bin/pip install -r requirements.txt
    ./venv/bin/python manage.py migrate --noinput
    ./venv/bin/python manage.py collectstatic --noinput
    
    echo \"Testing Nginx configuration...\"
    nginx -t
    if [ \$? -ne 0 ]; then
        echo \"ERROR: Nginx configuration test failed!\"
        exit 1
    fi

    echo \"Restarting services...\"
    systemctl daemon-reload
    systemctl enable salessync
    systemctl restart salessync
    systemctl reload nginx
"

echo "========================================="
echo "Deployment completed successfully!"
echo "App URL: https://aa.thehps.in/"
echo "========================================="
