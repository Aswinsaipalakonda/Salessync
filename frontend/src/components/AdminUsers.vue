<template>
    <MessageOverlay ref="messageOverlay" />
    <LoadingSpinner :isVisible="isLoading" />
    <div class="subnav-container">
      <div class="subnav">
        <h3>Users</h3>
        <div class="addbutton">
          <button id="addusers" @click="showAddPersonnelForm()">
            <span>Add User</span>
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24">
              <circle cx="12" cy="12" r="10" fill="none" stroke="currentColor" stroke-width="2"/>
              <path d="M12 7v10M7 12h10" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            </svg>
          </button>
        </div>
      </div>
    </div>
    <div class="filters">
      <div>
      </div>
      <div style="display: flex;align-items: center;gap: 10px;">
        <div class="glass-effect" id="delete-btn" @click="deleteSelectedUsers" v-if="selectedUserIds.length > 0">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash3" viewBox="0 0 16 16">
            <path d="M6.5 1h3a.5.5 0 0 1 .5.5v1H6v-1a.5.5 0 0 1 .5-.5M11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3A1.5 1.5 0 0 0 5 1.5v1H1.5a.5.5 0 0 0 0 1h.538l.853 10.66A2 2 0 0 0 4.885 16h6.23a2 2 0 0 0 1.994-1.84l.853-10.66h.538a.5.5 0 0 0 0-1zm1.958 1-.846 10.58a1 1 0 0 1-.997.92h-6.23a1 1 0 0 1-.997-.92L3.042 3.5zm-7.487 1a.5.5 0 0 1 .528.47l.5 8.5a.5.5 0 0 1-.998.06L5 5.03a.5.5 0 0 1 .47-.53Zm5.058 0a.5.5 0 0 1 .47.53l-.5 8.5a.5.5 0 1 1-.998-.06l.5-8.5a.5.5 0 0 1 .528-.47M8 4.5a.5.5 0 0 1 .5.5v8.5a.5.5 0 0 1-1 0V5a.5.5 0 0 1 .5-.5"/>
          </svg>
        </div>
        <div style="display: flex;align-items: center;gap: 10px;">
          <select name="rolefilters" id="rolefilters" class="rolefilters" @change="filterTable" required>
            <option value="" selected>Roles(All)</option>
            <option value="admin">Admin</option>
            <option value="view">View</option>
          </select>
        </div>
        <div class="search" id="usersearch">
          <input type="text" placeholder="Search..." @input="Search" id="searchinput">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
        </div>
      </div>
    </div>
    <div class="overlay-container" v-show="showOverlay" id="adduseroverlay">
      <div class="overlay-content">
        <section style="display: flex; align-items: center; justify-content: space-between;" class="overlay-container-title">
          <h3>Add User</h3>
          <button class="close-overlay" id="closeSignup" @click="closeAddPersonnelForm()" style="display: flex; align-items: center; justify-content: space-between;">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="bi bi-x-lg" viewBox="0 0 16 16">
              <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/>
            </svg>
          </button>
        </section>
        <section>
          <form @submit.prevent="addUser">
            <div class="form-group">
              <label for="username">Name</label>
              <input type="text" v-model="username" name="username" id="username" placeholder="Name" required>
              <span class="error-message" id="nameError">{{ nameError }}</span>
            </div>
            <div class="form-group">
              <label for="useremail">Email</label>
              <input type="email" v-model="useremail" name="useremail" id="useremail" placeholder="Email" required>
              <span class="error-message" id="emailError">{{ emailError }}</span>
            </div>
            <div class="form-group">
              <label for="usertype">User Role</label>
              <select v-model="usertype" name="usertype" id="usertype" required>
                <option value="" disabled selected>Select Role</option>
                <option value="admin">Admin</option>
                <option value="view">View</option>
              </select>
            </div>
            <div class="form-group">
              <label for="password">Password</label>
              <input type="password" v-model="password" name="password" id="password" placeholder="Password" required>
              <span class="error-message" id="passwordError">{{ passwordError }}</span>
            </div>
            <div class="addbutton addformbtn">
              <button type="submit" id="adduser">Add User</button>
            </div>
          </form>
        </section>
      </div>
    </div>
    <div class="userstable">
      <div class="tablelist">
        <div class="table-container" id="userstable">
          <table class="tables">
            <thead>
              <tr>
                <th><input type="checkbox" @change="selectAll" v-model="selectAllCheckbox"></th>
                <th>User Name</th>
                <th>Email</th>
                <th>User Role</th>
                <th>Reset Password</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
                <template v-if="users?.length > 0">
                    <tr v-for="user in users" :key="user.id">
                        <td><input type="checkbox" :id="'deleteusercheckbox_' + user.email" class="deleteusercheckbox" v-model="selectedUserIds" :value="user.email"></td>
                        <td style="color: #007bff;">{{ user.first_name }}</td>
                        <td>{{ user.email }}</td>
                        <td>
                        <select @change="updateUserType($event, user)">
                            <option :value="'admin'" :selected="user.user_type === 'Admin'">Admin</option>
                            <option :value="'view'" :selected="user.user_type === 'View'">View</option>
                        </select>
                        </td>
                        <td>
                        <button @click="resetPassword(user.email)" class="reset-btn">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-counterclockwise" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" d="M8 3a5 5 0 1 1-4.546 2.914.5.5 0 0 0-.908-.417A6 6 0 1 0 8 2z"/>
                            <path d="M8 4.466V.534a.25.25 0 0 0-.41-.192L5.23 2.308a.25.25 0 0 0 0 .384l2.36 1.966A.25.25 0 0 0 8 4.466"/>
                            </svg>Reset Password
                        </button>
                        </td>
                    </tr>
                </template>
                <tr v-else>
                    <td colspan="6">No users found.</td>
                </tr>
            </tbody>
          </table>
        </div>
        <p id="noResults" style="display: none;font-size: 14px;text-align: center;">No results found...!</p>
      </div>
    </div>
  </template>

<script>
import axios from 'axios';
import MessageOverlay from './MessageOverlay.vue';
import LoadingSpinner from './LoadingAnimation.vue';
import config from '@/config';

export default {
    name: 'AdminUsers',
    components: {
        MessageOverlay,
        LoadingSpinner
    },
    data() {
        return {
        showOverlay: false,
        username: '',
        useremail: '',
        userpassword: '',
        usertype: '',
        nameError: '',
        emailError: '',
        passwordError: '',
        generalError: null,
        users: [],
        selectedUserIds: [],
        selectAllCheckbox: false,
        isLoading: false,
        password: '',
        };
    },
    mounted() {
        this.fetchUserDetails();
    },
    methods: {
        showAddPersonnelForm() {
            document.getElementById('adduseroverlay').style.display='flex';
            this.resetForm();
        },
        resetForm(){
            this.username = '';
            this.useremail = '';
            this.userpassword = '';
            this.usertype = '';
            this.nameError = '';
            this.emailError = '';
            this.passwordError = "";
            this.generalError = null;

        },

        closeAddPersonnelForm() {
        this.showOverlay = false;
        document.getElementById('adduseroverlay').style.display='none';
        this.resetForm(); 

        },
        async fetchUserDetails() {
            this.isLoading = true;
            try {
                const response = await axios.get(`${config.apiUrl}/getuserdetails/`, {
                headers: {
                    'X-CSRFToken': this.getCookie('csrftoken'),
                    'Content-Type': 'application/json'
                }
                });
                this.users = response.data.users;
            } catch (error) {
                console.error("Error fetching user details:", error);
                this.showError("Error Fetching Data");
            }
            finally {
                this.isLoading = false;
            }
        },
        getCSRFToken() {
            const token = document.head.querySelector('meta[name="csrf-token"]');
            return token ? token.content : null;
        },

        getCookie(name) {
            const value = `; ${document.cookie}`;
            const parts = value.split(`; ${name}=`);
            if (parts.length === 2) return parts.pop().split(';').shift();
        },

        async addUser() {
            this.nameError = '';
            this.emailError = '';
            this.passwordError = '';
            this.generalError = null;
            this.isLoading = true;
            try {
                const response = await axios.post(`${config.apiUrl}/adduser/`, {
                username: this.username,
                useremail: this.useremail,
                password: this.password,
                usertype: this.usertype
                }, {
                headers: {
                    'X-CSRFToken': this.getCookie('csrftoken'),
                    'Content-Type': 'application/json'
                },
                withCredentials: true


                });
                if (response.data.success) {
                    this.fetchUserDetails();
                    this.showSuccess('User added successfully');
                    this.closeAddPersonnelForm();
                } 
                else if (response.data.error_userexits_message) {
                    this.showError(response.data.error_userexits_message);
                }
                else{
                    this.showError(response.data.error_message || 'An error occurred');
                }

            } catch (error) {
                this.fetchUserDetails();
                if (error.response && error.response.data) {
                    if (error.response.data.error_userexits_message) {
                        this.showError(error.response.data.error_userexits_message);
                    }
                    if (error.response.data.username) {
                        this.nameError = error.response.data.username[0];
                    }
                    if (error.response.data.useremail) {
                        this.emailError = error.response.data.useremail[0];
                    }
                    if (error.response.data.password) {
                        this.passwordError = error.response.data.password[0];
                    }
                    if (error.response.data.usertype) {
                        this.usertypeError = error.response.data.usertype[0];
                    }
                } else {
                    this.generalError = "An unexpected error occurred.";
                }
                this.showError('An error occurred');
            }
            finally {
                this.isLoading = false;
            }
        },
        async resetPassword(user) { 
            this.isLoading = true;
            try {
                const response = await axios.post(`${config.apiUrl}/resetpassword/`, {  
                    userId: user
                }, {
                    headers: {
                        'X-CSRFToken': this.getCookie('csrftoken'),
                        'Content-Type': 'application/json'
                    }
                });
                if (response.status === 200) {
                    this.showSuccess("Password reset successful."); 

                }
            }catch(error){
                console.error("Failed to reset password:", error);
                this.showError("Failed to reset password."); 
            }
            finally {
                this.isLoading = false;
            }
        },
        updateUserType(event, user) {
            user.user_type = event.target.value;
            this.sendUpdateToServer(user);
        },
        async sendUpdateToServer(user){
            this.isLoading = true;
            try {
            const response = await axios.post(`${config.apiUrl}/updateusertype/`, {
                userId: user.email,
                newType: user.user_type
            }, {
                headers: {
                    'X-CSRFToken': this.getCookie('csrftoken'),
                    'Content-Type': 'application/json'
            }
            });
                if (response.status === 200){ 
                    this.showSuccess("User Role Updated");
                    this.fetchUserDetails();
                }
            }catch(error){
                this.fetchUserDetails();
                console.error("Error updating user type:", error);

                if (error.response && error.response.status === 400){  
                    this.showError(error.response.data.error_message || "Invalid Input");

                }else if (error.response && error.response.status === 403){
                    this.showError(error.response.data.error_message || "You are not authorized to do this.");
                }else{
                    this.showError(error.message || "An unexpected error occurred. Please try again.");

                }
            }
            finally {
                this.isLoading = false;
            }
        },

        filterTable() {
            const roleFilter = document.getElementById('rolefilters').value.toLowerCase();
            const tableRows = document.querySelectorAll('#userstable tbody tr');
            const noResultsMessage = document.getElementById('noResults');
            let hasVisibleRow = false;

            tableRows.forEach(row => {
                const userRoleSelect = row.cells[3].querySelector('select'); 
                let selectedRole = '';
                if (userRoleSelect) { 
                    selectedRole = userRoleSelect.value.toLowerCase();
                }
                if (roleFilter === '' || selectedRole === roleFilter) {
                    row.style.display = 'table-row';
                    hasVisibleRow = true;
                } else {
                    row.style.display = 'none';
                }
            });
            if (noResultsMessage) {
                noResultsMessage.style.display = hasVisibleRow ? 'none' : 'block';
            }
        },
        Search() {
            const searchText = document.getElementById('searchinput').value.toLowerCase().replace(/\s+/g, '').trim(); // Get input value
            const tableRows = document.querySelectorAll('#userstable tbody tr');
            const noResultsMessage = document.getElementById('noResults');
            let hasVisibleRow = false;
            if (tableRows && tableRows.length > 0){
                tableRows.forEach(row => {
                    const userName = row.cells[1] ? row.cells[1].textContent.toLowerCase().replace(/\s+/g, '').trim() : ''; 
                    const email = row.cells[2] ? row.cells[2].textContent.toLowerCase().replace(/\s+/g, '').trim() : ''; 
                    if (userName.includes(searchText) || email.includes(searchText)) {
                        row.style.display = 'table-row';
                        hasVisibleRow = true;
                    } else {
                        row.style.display = 'none';
                    }
                });
            }
            if (noResultsMessage){
                noResultsMessage.style.display = hasVisibleRow ? 'none' : 'block';

            }
        },
        selectAll() {
            if(this.users?.length > 0){
                const checkboxes = document.querySelectorAll('.deleteusercheckbox');
                if (this.selectAllCheckbox) {
                    this.selectedUserIds = this.users.map(user => user.email); 
                    checkboxes.forEach(checkbox => {
                        checkbox.checked = true;
                    });
                } else {
                    this.selectedUserIds = [];
                    checkboxes.forEach(checkbox => {
                        checkbox.checked = false;
                    });
                }
            }
        },
        async deleteSelectedUsers() {
            document.getElementById('delete-overlay').style.display = 'flex';
            const confirmDeleteButton = document.getElementById('confirmDelete');
            confirmDeleteButton.onclick = async () => {
                this.isLoading = true;
                try {
                    document.getElementById('delete-overlay').style.display = 'none';
                    const response = await axios.post(`${config.apiUrl}/deleteusers/`, {
                        user_ids: this.selectedUserIds
                    }, {
                        headers: {
                            'X-CSRFToken': this.getCookie('csrftoken'),
                            'Content-Type': 'application/json'
                        }
                    });

                    if (response.status === 200 || response.status === 204) {
                        this.users = this.users.filter(user => !this.selectedUserIds.includes(user.id));
                        this.selectedUserIds = [];
                        this.selectAllCheckbox = false;
                        this.showSuccess("Users deleted successfully");
                        
                        this.fetchUserDetails();
                    }
                } catch (error) {
                    document.getElementById('delete-overlay').style.display = 'none';
                    console.error("Error deleting users:", error);
                    if (error.response.status === 403) {
                        this.showError(error.response.data.error || "Unauthorized to perform this action");
                    } else if (error.response.status === 400) {
                        this.showError(error.response.data.error || "Bad Request. Please check parameters");
                    } else {
                        this.showError("Failed to delete Users. Internal Server Error.");
                        
                    }
                }
                finally {
                    this.isLoading = false;
                }
            };

            document.getElementById('cancelDelete').onclick = () => {
                document.getElementById('delete-overlay').style.display = 'none';
            };
        },
        showError(message) {
            this.$refs.messageOverlay.showMessage(message, 'warning');

        },
        showSuccess(message){
            this.$refs.messageOverlay.showMessage(message, 'success');
        }
    }
};
</script>
<style scoped>

    .subnav>h3{
        color: #333;
        font-size: 20px;
    }
    .subnav-container{
        margin: 0px;
    }
    .addbutton button{
        background-color: white;
        border: none;
        display: flex;
        align-items: center;
        padding: 8px 15px; 
        border-radius: 20px;
        cursor: pointer;
        background-color: rgb(239, 79, 95);
        color: white;
        font-size: 12px;
        font-weight: 600;
        gap: 4px;
    }
    .addbutton button:hover{
        background-color: #e74c3c;
    }
    .overlay-container {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        display: none;
        justify-content: center;
        align-items: center;
        background-color: rgba(0, 0, 0, 0.5); 
        z-index: 1000;
    }
    
    .overlay-content {
        background-color: #fff;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
        max-width: 450px;
        width: 100%;
        max-height: 90vh;
        overflow: scroll;
        margin: 20px 0;
    }
    .overlay-container-title{
        margin-bottom: 40px;
    }
    h3 {
        font-size: 1.4rem;
        margin: 0;
        font-weight: 520;
    }
    
    .close-overlay {
        background: none;
        border: none;
        cursor: pointer;
        padding: 5px;
        font-size: 1.2rem;
    }
    
    .close-overlay svg {
        width: 1em;
        height: 1em;
    }
    
    .form-group {
        margin-bottom: 20px;
        display: flex;
        align-items: center;
    }
    
    .form-group label {
        display: block;
        margin-bottom: 5px;
        min-width: 150px;
        font-weight: 500;
    }
    
    input[type="text"],
    input[type="email"],
    input[type="password"],
    select{
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }
    input[type="text"]:focus,
    input[type="email"]:focus,
    select:focus{
        outline: none;
        border-color: #4285f4; 
        box-shadow: 0px 0px 8px rgba(66, 133, 244, 0.5);
    }
    
    .error-message {
        color: red;
        margin-bottom: 10px;
    }

    .addformbtn{
        display: flex;
        justify-content: center;
    }
    .addformbtn button{
        padding: 10px 20px;
    }
    .addformbtn{
        display: flex;
        justify-content: center;
    }
    .addformbtn button{
        padding: 10px 20px;
    }
    #closeSignup{
        transition: transform 0.2s ease, fill 0.2s ease;

    }
    #closeSignup:hover{
        color: #e74c3c;
        transform: rotate(90deg);
    }
    
    .reset-btn{
        padding: 8px 12px;
        cursor: pointer;
        border: none;
        background-color: #007bff;
        color: #fff;
        border-radius: 4px;
        transition: background-color 0.3s ease;
        display: flex;
        align-items: center;
        gap: 5px;
    }
    .reset-btn:hover {
        background-color: #0056b3;
    }
    .search {
        display: flex;
        align-items: center; 
        border: 1px solid #cbd0dd;
        border-radius: 40px;
        padding-left: 5px;
        padding-right: 5px; 
        background-color: white;
    }
    .search:hover,.search:focus {
        border-color: #4285f4; 
        box-shadow: 0px 0px 8px rgba(66, 133, 244, 0.5); 
        background-color: white;
    }
    .search input[type="text"] {
        border: none;
        padding: 10px; 
        outline: none;
        background: transparent;
        width: 250px;
        background-color: transparent;
        box-shadow: none;
    }

    .search input[type="text"]:focus {
        outline: none;
        box-shadow: none;
        background-color: transparent;
    }

    .search svg {
        margin-left: 3px;
        width: 15px; 
        height: 15px;
        cursor: pointer;
        margin-right: 10px;
    }
    .filters{
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin: 0px 20px;
    }
    .rolefilters{
        border-radius: 10px;
        padding-left: 20px;
        padding-right: 20px;
    }
    .glass-effect {
        background-color: rgba(150, 152, 154, 0.1); 
        padding: 10px 13px 8px 13px;
        border-radius: 50%;
        backdrop-filter: blur(8px); 
        -webkit-backdrop-filter: blur(8px); 
        border: 1px solid rgba(255, 255, 255, 0.3); 
        transition: transform 0.3s ease-in-out, background-color 0.3s ease-in-out;
        cursor: pointer;
        color: #e74c3c;
    }

    .glass-effect:hover {
        background-color: rgba(150, 152, 154, 0.3);
        transform: scale(1.05); 
    }
</style>
