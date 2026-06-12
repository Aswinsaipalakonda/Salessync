# SalesSync

SalesSync is a high-performance ERP and ledger management web application designed for sales tracking, customer database management, payment ledgers, and financial report exports. The project features a dual-domain setup running two independent instances with custom credentials and isolated databases on a single VPS.

---

## 🚀 Key Features

* **Dual User Roles**: Admin and Standard User views with appropriate access controls.
* **Brute-Force Login Prevention**: Logs failed login attempts by device ID and blocks IPs/devices after three consecutive failed attempts.
* **Authentication**: Django REST API endpoints coupled with JWT (JSON Web Tokens) stored securely in `httpOnly` cookies (`access_token` and `refresh_token`).
* **Interactive Dashboard**: Full visual reporting, transaction tables, and customer search engines.
* **Document Generation**: Automated PDF generation (using ReportLab) and Excel sheets download (using openpyxl/xlwt) for customer ledgers and daily sales reports.
* **Bulk Data Import**: Integrated Excel file parser to upload and synchronize historical sales records in bulk.
* **Advanced Routing Engine**: Nginx routing rules separating browser page loads (serving Vue History Mode) from Axios JSON API calls (proxying to Django).

---

## 🛠️ Tech Stack

### Frontend
* **Core**: Vue.js (SPA)
* **Styling**: Vanilla CSS with modern layout standards (CSS Grid/Flexbox), Poppins typography, and FontAwesome icons
* **API Client**: Axios with automatic JWT interceptors for silent token refreshes
* **Routing**: Vue Router configured in History Mode

### Backend
* **Core**: Django REST Framework
* **Auth**: SimpleJWT (JSON Web Token Authentication)
* **Middleware**: CORS headers, CSRF trust filters, and Django Session middleware
* **Static Serving**: WhiteNoise (configured for production static file delivery fallback)

### Production Server & Infrastructure
* **Web Server**: Nginx (reverse proxy, SSL termination, and static asset router)
* **Application Server**: Gunicorn (WSGI HTTP server for Django)
* **Process Manager**: Systemd service manager
* **SSL Certificate**: Let's Encrypt certificates managed by Certbot
* **Database**: SQLite3 (`db.sqlite3` / `db_kva.sqlite3`)

---

## 📦 Project Structure

```
salessyncvue/
│
├── frontend/                   # Vue.js SPA frontend
│   ├── src/                    # Source files (components, router, assets)
│   ├── dist/                   # Compiled static files (production bundle)
│   └── package.json            # Frontend dependencies
│
├── backend/                    # Django backend API
│   ├── api/                    # Core API app (views, models, migrations)
│   ├── backend/                # Project settings and URL routing
│   └── manage.py               # Django CLI management entry point
│
├── deploy.sh                   # Deployment script for aa.thehps.in (Port 8015)
├── deploy_kva.sh               # Deployment script for kva.thehps.in (Port 8016)
├── salessync_nginx.conf        # Nginx config template for aa.thehps.in
├── salessync_kva_nginx.conf    # Nginx config template for kva.thehps.in
└── README.md                   # This project documentation
```

---

## 💻 Local Development

### 1. Prerequisite Settings
Make sure you create a `.env` file in the `frontend` folder containing:
```env
VUE_APP_API_BASE_URL=http://127.0.0.1:8000/
```

### 2. Running the Backend
1. Navigate to the backend folder:
   ```bash
   cd backend
   ```
2. Create and activate a python virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: .\venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Run migrations and start the Django development server:
   ```bash
   python manage.py migrate
   python manage.py runserver
   ```
   *The local API will start listening at `http://127.0.0.1:8000/`.*

### 3. Running the Frontend
1. Navigate to the frontend folder:
   ```bash
   cd frontend
   ```
2. Install node dependencies:
   ```bash
   npm install
   ```
3. Start the hot-reloading development server:
   ```bash
   npm run serve
   ```
   *Open browser to `http://localhost:8080/` to test the application locally.*

---

## 🌐 Production Deployments (Multi-Domain VPS Setup)

The application is deployed on a Hostinger VPS (`145.223.18.5`) running two separate instances pointing to different domains:

### Instance 1: aa.thehps.in
* **Domain**: `https://aa.thehps.in`
* **Port**: `8015`
* **Systemd Service**: `salessync.service`
* **Root Path**: `/var/www/salessync`
* **Admin Login**: `aswiniassociates` / `admin123`
* **Deployment Trigger**:
  ```bash
  ./deploy.sh
  ```

### Instance 2: kva.thehps.in
* **Domain**: `https://kva.thehps.in`
* **Port**: `8016`
* **Systemd Service**: `salessync_kva.service`
* **Root Path**: `/var/www/salessync_kva`
* **Admin Login**: `kasi` / `admin123`
* **Deployment Trigger**:
  ```bash
  ./deploy_kva.sh
  ```

### Nginx Routing Configuration details (Both Sites)
Both Nginx configs are configured to support overlapping routing and `/api/` base prefixes cleanly:
1. **API Redirect**: Intercepts requests beginning with `/api/`, strips the prefix, and forwards them to the respective Gunicorn port (8015 or 8016).
2. **HTML Rewrite**: Checks browser requests on paths that overlap with API routes (like `/adminlogin`). If `Accept` header contains `html`, it rewrites internally to `/index.html` to allow the Vue History Mode Router to resolve the path.
3. **Admin Dashboard Isolation**: Requests targeting `/admin` bypass frontend rewrites to allow accessing the native Django admin dashboard interface.
