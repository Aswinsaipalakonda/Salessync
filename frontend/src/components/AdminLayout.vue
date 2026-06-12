<template>
    <MessageOverlay ref="messageOverlay" />
    <LoadingSpinner :isVisible="isLoading" />
    <div class="main-container">
      <div id="overlay-container"></div>
      <nav class="sidebar" id="mySidebar">
        <ul class="mainnavbar">
          <li class="dashboardtitle-li">
            <div id="dashboardtitle" style="display: flex; align-items: center; justify-content: center;">
                <div class="menu-toggle" style="margin-right: 5px;margin-top: 3px;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="#888" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" @click="toggleSidebar">
                        <line x1="3" y1="12" x2="21" y2="12"></line>
                        <line x1="3" y1="6" x2="21" y2="6"></line>
                        <line x1="3" y1="18" x2="21" y2="18"></line>
                    </svg>
                </div>
              <div id="dashboard_sub_title">
                <h5 id="title_name">Admin Dashboard</h5>
              </div>
            </div>
          </li>
          
          <li id="starting-li">
            
            <router-link
              class="nav-link"
              to="/users" :class="{ active: isRouteActive('/admin/users') }"
            >
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-people-fill" viewBox="0 0 16 16">
                <path d="M7 14s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1zm4-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6m-5.784 6A2.24 2.24 0 0 1 5 13c0-1.355.68-2.75 1.936-3.72A6.3 6.3 0 0 0 5 9c-4 0-5 3-5 4s1 1 1 1zM4.5 8a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5"/>
            </svg>
              Users
            </router-link>
          </li>
          <li >
            
            <router-link
              class="nav-link" :class="{ active: isRouteActive('/admin/sales') }"
              to="/sales"
            >
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-database" viewBox="0 0 16 16">
              <path d="M4.318 2.687C5.234 2.271 6.536 2 8 2s2.766.27 3.682.687C12.644 3.125 13 3.627 13 4c0 .374-.356.875-1.318 1.313C10.766 5.729 9.464 6 8 6s-2.766-.27-3.682-.687C3.356 4.875 3 4.373 3 4c0-.374.356-.875 1.318-1.313M13 5.698V7c0 .374-.356.875-1.318 1.313C10.766 8.729 9.464 9 8 9s-2.766-.27-3.682-.687C3.356 7.875 3 7.373 3 7V5.698c.271.202.58.378.904.525C4.978 6.711 6.427 7 8 7s3.022-.289 4.096-.777A5 5 0 0 0 13 5.698M14 4c0-1.007-.875-1.755-1.904-2.223C11.022 1.289 9.573 1 8 1s-3.022.289-4.096.777C2.875 2.245 2 2.993 2 4v9c0 1.007.875 1.755 1.904 2.223C4.978 15.71 6.427 16 8 16s3.022-.289 4.096-.777C13.125 14.755 14 14.007 14 13zm-1 4.698V10c0 .374-.356.875-1.318 1.313C10.766 11.729 9.464 12 8 12s-2.766-.27-3.682-.687C3.356 10.875 3 10.373 3 10V8.698c.271.202.58.378.904.525C4.978 9.71 6.427 10 8 10s3.022-.289 4.096-.777A5 5 0 0 0 13 8.698m0 3V13c0 .374-.356.875-1.318 1.313C10.766 14.729 9.464 15 8 15s-2.766-.27-3.682-.687C3.356 13.875 3 13.373 3 13v-1.302c.271.202.58.378.904.525C4.978 12.71 6.427 13 8 13s3.022-.289 4.096-.777c.324-.147.633-.323.904-.525"/>
            </svg>
              Sales
            </router-link>
          </li>
         
        </ul>
        <ul>
          <li class="logout-item">
            <a class="nav-link" @click="logout">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                    <polyline points="16 17 21 12 16 7" />
                    <line x1="21" y1="12" x2="9" y2="12" />
                </svg>
              Logout
            </a>
          </li>
        </ul>
      </nav>
      <main class="content">
        <header>
            <div class="header-container">
                    
                <div id="college_title" style="display: flex; gap: 10px; align-items: center;">    
                    <div class="sidebartoogler">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="#888" stroke="#333" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" @click="toggleSidebar">
                            <line x1="3" y1="12" x2="30" y2="12"></line>
                            <line x1="3" y1="6" x2="18" y2="6"></line>
                            <line x1="3" y1="18" x2="18" y2="18"></line>
                        </svg>
                    </div>
                    
                </div>
                <div style="display: flex; gap: 10px; align-items: center;">
                    
                </div>          
            </div>
        </header>
        <div class="message-overlay" id="delete-overlay">
              <div class="message-overlay-content">
                  <p>Are you sure you want to delete?</p>
                  <div style="display: flex;align-items: center;justify-content: space-evenly;">
                    <div>
                        <button id="cancelDelete">Cancel</button>
                    </div>
                    <div>
                      <button id="confirmDelete">Delete</button>
                    </div>
                  </div>
              </div>
            </div>
            <div class="message-overlay" id="success-overlay">
              <div class="message-overlay-content">
                  <p id="displaymessage"></p>
                  <div>
                      <button id="confirmMessage">Ok</button>
                  </div>
              </div>
            </div>
  
        <div id="content-container"> 
        <router-view />
      </div>
      </main>
    </div>
</template>

<script>
    import api from '../axios';
    import LoadingSpinner from './LoadingAnimation.vue';
    import MessageOverlay from './MessageOverlay.vue';
    import config from '@/config';

    export default {
    components: {
        LoadingSpinner,
        MessageOverlay,
    },
    data() {
        return {
        isLoading: false,
        };
    },
    methods: {
        toggleSidebar() {
        const sidebar = document.getElementById("mySidebar");
        sidebar.style.display =
            sidebar.style.display === "block" ? "none" : "block";
        },
        async logout() {
        try {
            
    await api.get(`${config.apiUrl}/logout_admin/`);
            localStorage.removeItem('access_token');
            localStorage.removeItem('refresh_token');
            this.$router.push('/adminlogin');
        } catch (error) {
            console.error('Logout failed:', error);
            this.showError('Logout failed');
        }
        },
        isRouteActive(route) {
        return this.$route.path === route;
        },
        showError(message) {
        this.$refs.messageOverlay.showMessage(message, 'warning');
        },
        showSuccess(message) {
        this.$refs.messageOverlay.showMessage(message, 'success');
        },
    },
    mounted() {
    },
    };
</script>
<style >
::-webkit-scrollbar {
display: none; 
}
  
* {
    scrollbar-width: none; 
}  
  ::-ms-overflow-style {
    display: none;
  }

body {
    font-family:'Poppins', sans-serif;
    margin: 0;
    padding: 0;
    min-height: 100vh;
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    overflow: hidden;
    -webkit-font-smoothing: antialiased;
}
#college_logo img {
    height: 55px;
}
#starting-li{
    margin-top: 20px;
}
#college_sub_title h5 {
    margin: 0;
    font-size: 1.43625rem;
    font-weight: 500;
    letter-spacing: -0.04em;
    margin-bottom: 0; 
    color: rgb(239, 79, 95);
}
body{
    margin: 0;
    padding: 0;
    min-height: 100vh;
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: flex-start; 
    background-color: #f5f7fa;
}
header {
    width: calc(100%-250px);
    background-color: rgba(255, 255, 255, 1);
    display: flex;
    align-items: center;
    justify-content: space-between;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    border-bottom: 0.5px solid #cbd0dd;
    width:100%;
    
}

.header-container {
    display: flex;
    justify-content: space-between;
    margin-left: 20px;
    margin-right: 20px;
    align-items: center;
    padding: 15px ;
    width: 100%; 
    
}

#dashboardtitle{
    background: linear-gradient(90deg, #e96443, #904e95);
}
#dashboard_sub_title {
    display: flex;
    flex-direction: column;
    justify-content: center;
    color: #f5f7fa;
    

}
#title_name{
    color: #f5f7fa;
    text-align: center;
    font-size: 1em;
    margin: 19px 0px;
}

.theme-control-toggle {
    position: relative;
    display: inline-block;
    width: 32px;
    height: 32px;
    cursor: pointer;
}

.theme-control-toggle-input {
    position: absolute;
    opacity: 0;
    width: 0;
    height: 0;
}

.theme-control-toggle-label {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: opacity 0.3s ease, visibility 0.3s ease;
}
.theme-control-toggle-light {
    opacity: 1;
    visibility: visible; 
}

.theme-control-toggle-dark {
    opacity: 0;
    visibility: hidden;
}
.theme-control-toggle-input:checked + .theme-control-toggle-light {
    opacity: 0;
    visibility: hidden; 
}

.theme-control-toggle-input:checked + .theme-control-toggle-light + .theme-control-toggle-dark {
    opacity: 1;
    visibility: visible;
}
.theme-control-toggle-light {
    background-color: rgba(255, 204, 133, 0.24);
    color: #e5780b;
    border-radius: 50%;
    cursor: pointer;
    transition: all 0.2s ease-in-out;
}

.theme-control-toggle-light:hover {
    background-color: #e5780b;
    color: white;
}

.theme-control-toggle-dark {
    background-color: rgba(133, 169, 255, 0.24);
    color: #3874ff;
    border-radius: 50%;
    cursor: pointer;
    transition: all 0.2s ease-in-out;
}

.theme-control-toggle-dark:hover {
    background-color: #3874ff;
    color: white;
}

.main-container {
    display: flex; 
    height: 100vh;
    width: 100%; 
}



.sidebar ul {
    list-style: none;
    padding: 0;
    margin: 0;
}

.sidebar a {
    display: block; 
    padding: 10px 25px;
    text-decoration: none;
    border-left: 5px solid transparent;
    transition: all 0.3s ease; 
    font-weight: 500 !important;
    color:  #707174;
    align-items: center;
    display: flex;
    gap: 8px;
    font-size: 15px;
    font-weight: 500 !important;
    margin-bottom: 10px;

}
.mainnavbar{
    height: calc(100vh - 60px);
    overflow: auto;
}
.sidebar .logout-item {
    position: fixed;
    bottom: 10px; 
    margin-left: 10px;
    align-items: center;
    transition: transform 0.3s ease-in-out;
}
.logout-item{
    width: 230px;
}
.logout-item a{
    border-radius: 8px;
}
.sidebar .logout-item :hover{
    background-color: #ea4335;
    color: white;
    border-radius: 8px;
    border-left: 5px solid transparent;
}

.content {
    overflow-y: scroll;
    flex: 1; 
    transition: all 0.3s ease; 
    scroll-behavior: smooth;
}
#sidebarToggle {
    display: none;
    background: none;
    border: none;
    cursor: pointer;
    margin-left: 1.5rem;
  }
  
  #sidebarToggle .bar {
    display: block;
    width: 25px;
    height: 3px;
    background-color: black; 
    margin: 5px 0; 
  }
body.dark-mode {
    background-color: #0f111a;
    color: #fff;
}
body.dark-mode header{
    border-bottom: 1px solid #31374a;
}
.dark-mode .sidebar {
    background-color: #141824; 
    border-right: 1px solid #31374a;
}

.dark-mode .sidebar a {
    color: #9fa6bc;; 
}

 
.dark-mode .sidebar a:hover {
    background-color: #31374a; 
    color: #eff2f6;
}
.dark-mode .sidebar a.active{
    color: #3874ff;
}
.dark-mode header {
    background-color: #141824; 
}

.dark-mode #college_sub_title h1, 
.dark-mode #title_name {
    color: #fff; 
}
.dark-mode .tablelist{
    background: #141824;
    border: 1px solid #373e53;
    border-left: none;
    border-right: none;
}
.dark-mode .tables th{
    color: #9fa6bc;
    border-bottom: 1px solid #373e53;
}
.dark-mode .complaintstatusgraph{
    background:#141824;
    border: 1px solid #373e53;
}
.dark-mode .tables  tbody tr{
    border-bottom: 1px solid #373e53;
}
.nav-item-wrapper {
  margin-bottom: 10px; 
}
.firstlink{
    margin-top: 30px;
}
.nav-link {
  display: flex;
  align-items: center;
  padding: 8px 16px;
  color: #333; 
  text-decoration: none; 
  transition: background-color 0.3s, color 0.3s; 
  cursor: pointer;
}

.nav-link:hover {
  color: #007bff;
  border-left: 5px solid #cf7b0e;
}
.nav-link-icon {
  margin-right: 10px;
  width: 1.2em; 
  height: 1.2em; 
}
.sidebar {
    width: 17rem;
    margin: 0;
    -webkit-transition: width .2s ease;
    -o-transition: width .2s ease;
    transition: width .2s ease;
    background-color: #ffffff;
    box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    border-right: 0.8px solid #cbd0dd;
}

.nav-list {
    list-style: none;
    padding: 0;
    margin: 0;
}


.nav-link {
    display: block;
    padding: 10px 15px;
    color: #333;
    text-decoration: none; 
    transition: background-color 0.3s, color 0.3s; 
    position: relative; 
}
#first-link{
    margin-top: 20px;
}
.nav-link.active{
    color: #007bff;
    border-left: 5px solid #cf7b0e;
}
.has-submenu .dropdown-icon {
    position: absolute;
    right: 15px; 
    top: 50%;
    transform: translateY(-50%);
    transition: transform 0.3s ease;
}

.has-submenu.active .dropdown-icon {
    transform: translateY(-50%) rotate(90deg);
}

.submenu {
    display: none; 
    padding-left: 20px !important;
    margin-top: 5px !important; 
    margin-left: 10px !important;
    max-height: 350px !important;
}

.submenu .nav-link {
    padding: 8px 15px; 
}
main{
    width: 100%;
}
.subnav{
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin: 20px;
}


body.dark-mode footer {
    border-top: 1px solid #31374a;
    background-color: #0f111a;
    border-left: 1px solid #31374a;

}
body.dark-mode footer p{
    color: rgb(159, 166, 188);
}
.footer {
    bottom: 0;
    width: calc(100% - 250px);
    height: 3.5rem;
    left: 4px;
    border-top: 1px solid #cbd0dd;
    border-left: 1px solid #cbd0dd;
    margin-left: 250px;
    font-size: 14px; 
    align-items: center;
    display: flex;
    background-color: #f5f7fa;;
    justify-content: space-between;
}
.footer p{
    padding: 0 1.3rem 0 1.3rem;
    font-weight: 100;
    color: rgb(49, 55, 74);

}
.footer a{
    color: #3874ff;
    text-decoration: none;
    font-weight: 100;
}
footer a:hover{
    text-decoration: underline;
}
.position-absolute {
    position: absolute !important;
}


.spinner-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.7); 
    z-index: 9999;
    display: flex;
    justify-content: center;
    align-items: center;
}
.spinner img{
    width: 30px;
    height: 30px;
}
.menu-toggle{
    display: none;
}
.message-overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.7);
    justify-content: center;
    align-items: center;
    z-index: 9999;
}

.message-overlay-content {
    background-color: white;
    border-radius: 8px;
    padding: 22px;
    text-align: center;
    max-width: 370px;
    width: 100%;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.8);
}
.message-overlay-content p{
    margin-top: 20px;
    margin-bottom: 3rem;
    font-weight: 100;
}
.message-overlay-content button {
    padding: 12px 22px;
    border: none;
    border-radius: 5px;
    font-size: 14px;
    cursor: pointer;
    width: 100%;
}
  
#confirmDelete,#confirmMessage {
    background-color: rgb(239, 79, 95);
    color: white;
}
#confirmDelete {
    border-radius: 30px;
}
#confirmDelete:hover,#confirmMessage:hover{
    background-color: #e74c3c;
}
#cancelDelete {
    background-color: transparent;
    color: black;
}
.delete-divider {
    margin: 10px 0;
    height: 1px;
}
.tablelist{
    font-weight: 100;
    font-size: 20px;
    margin-top: 10px;
    background-color: #fff;
    padding-left: 20px;
    padding-right: 20px;
    border: 1px solid rgba(203, 208, 221, 0.54);
    padding-bottom: 10px;
    overflow-x: auto;
    border-left: none;
    border-right: none;
    scrollbar-width: thin;
    max-height: 65vh;
    overflow: scroll;
}
.table-container{
    margin-top: 12px;
}
.tables {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 10px;
    table-layout: auto;
}
.tables th, .tables  td {
    padding:20px;
    font-size: 14px;
    text-align: left;
    font-weight: 300;
    white-space: nowrap;
    letter-spacing: 0px !important;
    
}
.tables  th {
    border-bottom: 1px solid rgba(203, 208, 221, 0.54);
    font-size: 16px;
    font-weight: 500;
    color: #31374a;
}

.tables  tbody tr{
    border-bottom: 1px solid rgba(203, 208, 221, 0.54);
}
@media only screen and (max-width: 375px) {
    .menu-toggle{
        display: block;
        font-size: 20px;
        font-weight: 100;
        width: 25px;
    }
    .header-container {
        flex-direction: row; 
        align-items: flex-start;
         align-items: center;
         padding: 10px;

    }
    #college_title{
        gap: 5px;
    }
    #college_logo a img{
        width: 60px;
        height: 40px;
    }
    .sidebar {
        width: 0;
        height: auto;
        position: relative;
        border: none;
    }
    .sidebar.show {
        width: 100%; 
    }
    .main-container {
        margin-left: 0;
    }
    .subnav{
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin: 5px;
        margin-left: 10px;
    }
    .sidebar .logout-item :hover{
        background-color: transparent;
        color: #525b75;
    }
    .nav-link:hover {
        background-color: transparent;
      }
      .dark-mode .sidebar a:hover {
        background-color: transparent; 
        color: #9fa6bc;
    }
    h3{
        font-size: 15px;
    }

    .theme-control-toggle-light:hover {
        background-color: rgba(255, 204, 133, 0.24);
        color: #e5780b;
    }

    .theme-control-toggle-dark:hover {
        background-color: rgba(133, 169, 255, 0.24);
        color: #3874ff;
    } 
    
    .footer {
        width: 100%;
        height: 1.5rem;
        left: 0;
        border-left: none;
        margin-left: 0px;
        font-size: 6px;
        
    }
    a:focus {
        outline: none;
    }
    @media (hover: none) and (pointer: coarse) {
        a:focus {
            outline: none;
        }
    }
    
    

}
@media only screen and (min-width: 376px) and (max-width: 480px) {
    .menu-toggle {
        display: block;
        font-size: 22px; 
        font-weight: 100;
        width: 28px; 
        cursor: pointer;
    }

    .header-container {
        flex-direction: row;
        align-items: center;
        padding: 12px; 
    }

    #college_title {
        gap: 8px; 
    }

    #college_logo a img {
        width: 70px;
        height: 45px; 
    }

    .sidebar {
        width: 0;
        height: auto;
        position: relative;
        border: none;
    }
    .sidebar.show {
        width: 100%; 
    }

    .main-container {
        margin-left: 0;
        transition: margin-left 0.5s;
    }

    .sidebar .logout-item:hover {
        background-color: transparent;
        color: #525b75; 
    }

    .nav-link:hover {
        background-color: transparent;
    }

    .dark-mode .sidebar a:hover {
        background-color: transparent; 
        color: #9fa6bc;
    }

    h3 {
        font-size: 18px; 
    }

    .theme-control-toggle-light:hover {
        background-color: rgba(255, 204, 133, 0.24);
        color: #e5780b;
    }

    .theme-control-toggle-dark:hover {
        background-color: rgba(133, 169, 255, 0.24);
        color: #3874ff;
    } 

    .footer {
        width: 100%; 
        height: 2rem; 
        left: 0; 
        border-left: none;
        margin-left: 0; 
        font-size: 6px; 
    }
    .sidebar .logout-item :hover{
        background-color: transparent;
        color: #525b75;
    }
    a:focus {
        outline: none;
    }
    @media (hover: none) and (pointer: coarse) {
        a:focus {
            outline: none;
        }
    }
    
}
@media only screen and (min-width: 481px) and (max-width: 768px) {
   .menu-toggle {
        display: block;
        font-size: 22px; 
        font-weight: 100;
        width: 28px; 
        cursor: pointer;
    }


    .header-container {
        flex-direction: row;
        align-items: center;
        padding: 12px; 
    }

    #college_title {
        gap: 8px; 
    }

    #college_logo a img {
        width: 70px;
        height: 45px; 
    }

    .sidebar {
        width: 0;
        height: auto;
        position: relative;
        border: none;
    }
    .sidebar.show {
        width: 100%; 
    }

    .main-container {
        margin-left: 0;
        transition: margin-left 0.5s;
    }

    .sidebar .logout-item:hover {
        background-color: transparent;
        color: #525b75; 
    }

    .nav-link:hover {
        background-color: transparent;
    }

    .dark-mode .sidebar a:hover {
        background-color: transparent; 
        color: #9fa6bc;
    }

    h3 {
        font-size: 18px; 
    }

    .theme-control-toggle-light:hover {
        background-color: rgba(255, 204, 133, 0.24);
        color: #e5780b;
    }

    .theme-control-toggle-dark:hover {
        background-color: rgba(133, 169, 255, 0.24);
        color: #3874ff;
    } 

    .footer {
        width: 100%; 
        height: 2rem; 
        left: 0; 
        border-left: none;
        margin-left: 0; 
        font-size: 9px; 
    }
    .sidebar .logout-item :hover{
        background-color: transparent;
        color: #525b75;
    }
    a:focus {
        outline: none;
    }
    
    @media (hover: none) and (pointer: coarse) {
        a:focus {
            outline: none;
        }
    }
    
}
@media only screen and (min-width: 769px) and (max-width: 979px) {

}
@media only screen and (min-width: 980px) and (max-width: 1024px){

}
@media only screen and (min-width: 1025px) and (max-width: 1399px){
    
}
</style>