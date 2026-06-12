import { createRouter, createWebHistory } from 'vue-router';
import UserLogin from './components/UserLogin.vue';
import AdminLogin from './components/AdminLogin.vue';
import AdminLayout from './components/AdminLayout.vue';
import AdminUsers from './components/AdminUsers.vue';
import AdminDashboard from './components/AdminDashboard.vue';
import AdminSales from './components/AdminSales.vue';
import AdminAcquisition from './components/AdminAcquisition.vue';
import UserDashboard from './components/UserDashboard.vue';
import UserLayout from './components/UserLayout.vue';

const routes = [
  {
    path: '/',
    name: 'UserLogin',
    component: UserLogin,
  },
  {
    path: '/adminlogin',
    name: 'AdminLogin',
    component: AdminLogin,
  },
  {
    path: '/users',
    redirect: '/admin/users',
  },
  {
    path: '/dashboard',
    redirect: '/admin/dashboard',
  },
  {
    path: '/sales',
    redirect: '/admin/sales',
  },
  {
    path: '/acquisition',
    redirect: '/admin/acquisition',
  },
  {
    path: '/',
    component: UserLayout,
    meta: { requiresAuth: true },
    children: [
      {
        path: '/user/sales',
        name: 'UserDashboard',
        component: UserDashboard,
      },
    ],
  },
  
  {
    path: '/admin',
    component: AdminLayout,
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        redirect: '/admin/sales',
      },
      {
        path: 'dashboard',
        name: 'AdminDashboard',
        component: AdminDashboard,
      },
      {
        path: 'users',
        name: 'AdminUsers',
        component: AdminUsers,
      },
      {
        path: 'sales',
        name: 'AdminSales',
        component: AdminSales,
      },
      {
        path: 'acquisition',
        name: 'AdminAcquisition',
        component: AdminAcquisition,
      },
    ],
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  const requiresAuth = to.matched.some((record) => record.meta.requiresAuth);
  const isUserRoute = to.path.startsWith('/user'); 
  const isAdminRoute = to.path.startsWith('/admin');
  const isAuthenticated = localStorage.getItem('access_token') !== null;
  const userType = localStorage.getItem('userType');

  if (requiresAuth && !isAuthenticated) {
    next('/'); 
  } else if (isUserRoute && userType !== 'user') {
    
    next('/'); 
  } else if (isAdminRoute && userType == 'user') {
      localStorage.clear()
      next("/adminlogin")
  }
  
  
  else {
    next(); 
  }
});

export default router;