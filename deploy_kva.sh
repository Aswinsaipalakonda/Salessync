#!/bin/bash

# Configuration
VPS_IP="145.223.18.5"
VPS_PATH="/var/www/salessync_kva"
LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================="
echo "Starting SalesSyncVue KVA Fast Deployment Script"
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
        --exclude="db_kva.sqlite3" \
        --exclude=".git/" \
        --exclude="node_modules/" \
        --exclude="*.pyc" \
        --exclude="__pycache__/" \
        "$LOCAL_DIR/backend/" root@$VPS_IP:$VPS_PATH/backend/

    rsync -avz --delete \
        "$LOCAL_DIR/frontend/dist/" root@$VPS_IP:$VPS_PATH/frontend/dist/
else
    echo "rsync not found. Falling back to temporary tar method..."
    TEMP_DIR="$LOCAL_DIR/temp_deploy_kva"
    mkdir -p "$TEMP_DIR"
    BACKEND_TAR="$TEMP_DIR/backend.tar.gz"
    FRONTEND_TAR="$TEMP_DIR/frontend.tar.gz"

    # Tar files locally (using cross-platform tar parameters)
    echo "Compressing files locally..."
    cd "$LOCAL_DIR/backend" && tar -czf "$BACKEND_TAR" --exclude="*.git*" --exclude="venv*" --exclude="*__pycache__*" --exclude="*.pyc" --exclude="db.sqlite3" --exclude="db_kva.sqlite3" .
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

# 3. Transfer KVA specific SQLite database
echo "Step 3: Transferring KVA database (db_kva.sqlite3)..."
scp "$LOCAL_DIR/backend/db_kva.sqlite3" root@$VPS_IP:$VPS_PATH/backend/db.sqlite3

# 4. Transfer systemd Service and Nginx Config
echo "Step 4: Uploading systemd service and Nginx configuration files..."
scp "$LOCAL_DIR/salessync_kva.service" root@$VPS_IP:/etc/systemd/system/salessync_kva.service
scp "$LOCAL_DIR/salessync_kva_nginx.conf" root@$VPS_IP:/etc/nginx/sites-available/salessync_kva

# 5. Configure, install dependencies, enable Nginx site, request SSL, and restart services
echo "Step 5: Configuring environment and starting services on VPS..."
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
    
    # Enable Nginx site
    ln -sf /etc/nginx/sites-available/salessync_kva /etc/nginx/sites-enabled/salessync_kva
    
    echo \"Testing Nginx configuration...\"
    nginx -t
    if [ \$? -ne 0 ]; then
        echo \"ERROR: Nginx configuration test failed!\"
        exit 1
    fi

    echo \"Requesting SSL certificate using Certbot for kva.thehps.in...\"
    certbot --nginx -d kva.thehps.in --non-interactive --agree-tos --email webmaster@thehps.in --redirect

    echo \"Restarting services...\"
    systemctl daemon-reload
    systemctl enable salessync_kva
    systemctl restart salessync_kva
    systemctl reload nginx
"

echo "========================================="
echo "Deployment of kva.thehps.in completed successfully!"
echo "App URL: https://kva.thehps.in/"
echo "========================================="
