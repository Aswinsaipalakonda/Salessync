<template>
    <MessageOverlay ref="messageOverlay" />
    <LoadingSpinner :isVisible="isLoading" />
    <div class="subnav-container">
      <div class="subnav">
        <h3>Sales</h3>
        <div class="addbutton" style="display: flex;align-items: center;gap: 10px;">
            <button id="addreport" @click="showAddReportForm()">
                <span>Add Sales</span>
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24">
                <circle cx="12" cy="12" r="10" fill="none" stroke="currentColor" stroke-width="2"/>
                <path d="M12 7v10M7 12h10" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                </svg>
            </button>
            <button id="importexcel" @click="openFileDialog">
                <span>Import Excel</span>
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-file-earmark-arrow-down-fill" viewBox="0 0 16 16">
                <path d="M9.293 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.707A1 1 0 0 0 13.707 4L10 .293A1 1 0 0 0 9.293 0M9.5 3.5v-2l3 3h-2a1 1 0 0 1-1-1m-1 4v3.793l1.146-1.147a.5.5 0 0 1 .708.708l-2 2a.5.5 0 0 1-.708 0l-2-2a.5.5 0 0 1 .708-.708L7.5 11.293V7.5a.5.5 0 0 1 1 0"/>
                </svg>
            </button>
            <button @click="exportAllOrders">
                <span>Export Excel</span>
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-file-earmark-arrow-up-fill" viewBox="0 0 16 16">
                <path d="M9.293 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.707A1 1 0 0 0 13.707 4L10 .293A1 1 0 0 0 9.293 0M9.5 3.5v-2l3 3h-2a1 1 0 0 1-1-1M6.354 9.854a.5.5 0 0 1-.708-.708l2-2a.5.5 0 0 1 .708 0l2 2a.5.5 0 0 1-.708.708L8.5 8.707V12.5a.5.5 0 0 1-1 0V8.707z"/>
                </svg>
            </button>
            <input type="file" id="excelFile" ref="excelFile" @change="onFileSelected" accept=".xlsx,.xls,.csv" style="display: none;">
        </div>
      </div>
    </div>
    <div class="filters">
      <div>
      </div>
      <div style="display: flex;align-items: center;gap: 10px;">
        <div >
            <button class="generateledger" @click="showgenerateLedger">  
                <span>Generate Ledger</span>
                <img :src="require('@/assets/gemini.svg')" alt="gemini">
            </button>
        </div>
        <div style="display: flex;align-items: center;gap: 10px;">
            <select name="rolefilters" id="rolefilters" class="rolefilters" @change="filterTable" required>
                <option value="" selected>Payment Status(All)</option>
                <option value="paid">Paid</option>
                <option value="partially_paid">Partially Paid</option>
                <option value="unpaid">Pending</option>
            </select>
        </div>
        <div class="search" id="reportsearch">
            <input 
                type="text" 
                placeholder="Search..." 
                v-model="searchText" 
                @keyup.enter="Search"
                id="searchinput" 
                :disabled="isLoading" 
                autocomplete="off"
            >
            <svg 
                xmlns="http://www.w3.org/2000/svg" 
                width="24" 
                height="24" 
                viewBox="0 0 24 24" 
                fill="none" 
                stroke="currentColor" 
                stroke-width="2" 
                stroke-linecap="round" 
                stroke-linejoin="round"
                @click="Search"
                style="cursor: pointer;"
            >
                <circle cx="11" cy="11" r="8"></circle>
                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
        </div>
      </div>
    </div>
    <div class="overlay-container" v-show="showGenrateLedgerOverlay" id="generateledgeroverlay">
      <div class="overlay-content">
        <section style="display: flex; align-items: center; justify-content: space-between;" class="overlay-container-title">
          <h3>Generate Ledger</h3>
          <button class="close-overlay" id="closeGenerateOverlay" @click="closeGenerateOverlay" style="display: flex; align-items: center; justify-content: space-between;">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="bi bi-x-lg" viewBox="0 0 16 16">
              <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/>
            </svg>
          </button>
        </section>
        <section>
            <form @submit.prevent="generateLedger">
                <div class="form-group">
                    <label for="customermobilenumber_ledger">Firm Name</label>
                    <div class="autocomplete-wrapper" ref="autocompleteWrapper">
                        <input
                            type="text"
                            v-model="customermobilenumber_ledger"
                            @input="searchCustomers"
                            name="customermobilenumber_ledger"
                            id="customermobilenumber_ledger"
                            placeholder="Search Firm Name"
                            required
                        />
                        <ul v-if="showAutocomplete && filteredCustomers.length > 0" class="autocomplete-list">
                            <li
                                v-for="customer in filteredCustomers"
                                :key="customer.id"
                                class="autocomplete-item"
                            >
                                <div class="firm-selection">
                                    <input
                                        type="checkbox"
                                        :checked="selectedFirms.some(f => f.id === customer.id)"
                                        @change="toggleFirmSelection(customer)"
                                    />
                                    <span @click="selectCustomer(customer)">{{ customer.name }}({{ customer.area }})</span>
                                </div>
                            </li>
                        </ul>
                    </div>
                    
                    <span class="error-message" v-if="errors.customermobilenumber_ledger">{{ errors.customermobilenumber_ledger }}</span>
                </div>
                <div v-if="selectedFirms.length > 0" class="selected-firms">
                    <h4>Selected Firms:</h4>
                    <ul>
                        <li v-for="firm in selectedFirms" :key="firm.id">
                            {{ firm.name }}
                            <button class="remove-firm" @click="removeFirm(firm)">×</button>
                        </li>
                    </ul>
                </div>
                <div v-if="selectedFirms.length > 1" class="common-firm-input">
                    <div class="form-group">
                        <label for="commonFirmName">Common Firm Name</label>
                        <input
                            type="text"
                            v-model="commonFirmName"
                            id="commonFirmName"
                            placeholder="Enter common firm name"
                            required
                        />
                    </div>
                    
                </div>
                <div class="form-group">
                    <label for="ledger_startdate">From</label>
                    <input type="date" v-model="ledger_startdate" name="customermobilenumber_ledger" id="ledger_startdate" :max="maxDate" required>
                    <span class="error-message" v-if="errors.customermobile">{{ errors.ledger_startdate }}</span>
                </div>

                <div class="form-group">
                    <label for="ledger_enddate">To</label>
                    <input type="date" v-model="ledger_enddate" name="customermobilenumber_ledger" id="ledger_enddate" :max="maxDate" required>
                    <span class="error-message" v-if="errors.ledger_enddate">{{ errors.ledger_enddate }}</span>
                </div>
                <div class="form-group">
                    <label for="ledgerformat">Format</label>
                    <select name="ledgerformat" v-model="ledgerformat" id="ledgerformat" required>
                        <option value="" selected disabled>Ledger Format</option>
                        <option value="excel">Excel</option>
                        <option value="pdf">Pdf</option>
                    </select>
                </div>
                <div class="addbutton addformbtn">
                <button type="submit" id="generateledger">Generate</button>
                </div>
            </form>
        </section>
      </div>
    </div>
    <div class="overlay-container" v-show="showOverlay" id="addreport">
      <div class="overlay-content">
        <section style="display: flex; align-items: center; justify-content: space-between;" class="overlay-container-title">
          <h3>Add Report</h3>
          <button class="close-overlay" id="closeSignup" @click="closeAddReportForm()" style="display: flex; align-items: center; justify-content: space-between;">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="currentColor" class="bi bi-x-lg" viewBox="0 0 16 16">
              <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/>
            </svg>
          </button>
        </section>
        <section>
            <form @submit.prevent="addReport">
                <div class="form-group">
                <label for="customername">Name</label>
                <input type="text" v-model="customername" name="customername" id="customername" placeholder="Name" required>
                <span class="error-message" v-if="errors.customername">{{ errors.customername }}</span>
                </div>

                <div class="form-group">
                <label for="customermobile">Mobile Number</label>
                <input type="tel" v-model="customermobile" name="customermobile" id="customermobile" placeholder="Mobile Number" autocomplete="off" pattern="[0-9]*" inputmode="numeric" maxlength="10" oninput="this.value = this.value.replace(/[^0-9]/g, '');" required>
                <span class="error-message" v-if="errors.customermobile">{{ errors.customermobile }}</span>
                </div>

                <div class="form-group">
                <label for="customerarea">Area</label>
                <input type="text" v-model="customerarea" name="customerarea" id="customerarea" placeholder="Area" required>
                <span class="error-message" v-if="errors.customerarea">{{ errors.customerarea }}</span>
                </div>

                <div class="form-group">
                <label for="product">Product</label>
                <input type="text" v-model="product" name="product" id="product" placeholder="Product" required>
                <span class="error-message" v-if="errors.product">{{ errors.product }}</span>
                </div>

                <div class="form-group">
                <label for="billdate">Bill Date</label>
                <div style="display: flex; align-items: center; gap: 20px;">
                    <span style="display: flex; align-items: center;">
                    <input type="checkbox" v-model="currentdate" name="currentdate" id="currentdate">Today
                    </span>
                    <input type="date" name="dateofinvoice" id="dateofinvoice" :disabled="currentdate" :max="maxDate" v-model="dateofinvoice">
                </div>
                <span class="error-message" v-if="errors.dateofinvoice">{{ errors.dateofinvoice }}</span> </div>

                <div class="form-group">
                <label for="amount">Amount</label>
                <input type="number" v-model="amount" name="amount" id="amount" placeholder="Amount" required>
                <span class="error-message" v-if="errors.amount">{{ errors.amount }}</span>
                </div>

                <div class="form-group">
                <label for="amountpaid">Paid</label>
                <input type="number" v-model="amountpaid" name="amountpaid" id="amountpaid" placeholder="Amount Paid" required>
                <span class="error-message" v-if="errors.amountpaid">{{ errors.amountpaid }}</span>
                </div>
                <div class="form-group">
                <label for="paymentmethod">Payment Method</label>
                <select v-model="paymentmethod" name="paymentmethod" id="paymentmethod" required>
                    <option value="" disabled selected>Payment Method</option>
                    <option value="cash">Cash</option>
                    <option value="card">Card</option>
                    <option value="cheque">Cheque</option>
                    <option value="upi">UPI</option>
                    <option value="bank_transfer">Bank Transfer</option>
                </select>
                </div>
                <div class="form-group">
                <label for="remarks">Remarks</label>
                <input type="text" v-model="remarks" name="remarks" id="remarks" placeholder="Remarks" required>
                <span class="error-message" v-if="errors.remarks">{{ errors.remarks }}</span>
                </div>

                <div class="addbutton addformbtn">
                <button type="submit" id="addreport">Add Report</button>
                </div>
            </form>
        </section>
      </div>
    </div>
    <div class="reportstable">
        <div class="tablelist">
            <div class="table-container" id="reportstable">
                <table class="tables">
                    <thead>
                        <tr>
                            <th>Bill No</th>
                            <th>Customer Name</th>
                            <th>Mobile Number</th>
                            <th>Area</th>
                            <th>Product</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th @click="sortBy('billing_date')" :class="{ 'sortable': true, 'sorted-asc': sortColumn === 'billing_date' && sortDirection === 'asc', 'sorted-desc': sortColumn === 'billing_date' && sortDirection === 'desc' }">
                                Billing Date
                                <span v-if="sortColumn === 'billing_date'">
                                    <svg v-if="sortDirection === 'asc'" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-up" viewBox="0 0 16 16">
                                    <path fill-rule="evenodd" d="M8 15a.5.5 0 0 0 .5-.5V2.707l3.146 3.147a.5.5 0 0 0 .708-.708l-4-4a.5.5 0 0 0-.708 0l-4 4a.5.5 0 0 0 .708.708L7.5 2.707V14.5a.5.5 0 0 0 .5.5"/>
                                    </svg>
                                    <svg v-else xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-down" viewBox="0 0 16 16">
                                    <path fill-rule="evenodd" d="M8 1a.5.5 0 0 1 .5.5v11.793l3.146-3.147a.5.5 0 0 1 .708.708l-4 4a.5.5 0 0 1-.708 0l-4-4a.5.5 0 0 1 .708-.708L7.5 12.293V1.5a.5.5 0 0 1 .5-.5"/>
                                    </svg>
                                </span>
                            </th>
                            <th>Paid</th>
                            <th>Balance</th>
                            <th>Payment Date</th>
                            <th>Paid Amount</th>
                            <th>Payment Method</th>
                            <th>Remarks</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(order, index) in displayedOrders" :key="order.bill_no">
                            <td>{{ order.bill_no }}</td>
                            <td>
                                <input v-if="isEditing[index]" type="text" v-model="editingOrder[index].customer_name" class="edit-input">
                                <span v-else>{{ order.customer_name }}</span>
                            </td>
                            <td>
                                <input v-if="isEditing[index]" type="tel" v-model="editingOrder[index].mobile_number" class="edit-input" pattern="[0-9]*" maxlength="10">
                                <span v-else>{{ order.mobile_number }}</span>
                            </td>
                            <td>
                                <input v-if="isEditing[index]" type="text" v-model="editingOrder[index].area" class="edit-input">
                                <span v-else>{{ order.area }}</span>
                            </td>
                            <td>
                                <input v-if="isEditing[index]" type="text" v-model="editingOrder[index].product" class="edit-input">
                                <span v-else>{{ order.product }}</span>
                            </td>
                            <td>
                                <input v-if="isEditing[index]" type="number" v-model="editingOrder[index].amount" class="edit-input">
                                <span v-else>{{ order.amount }}</span>
                            </td>
                            <td>{{ order.status }}</td>
                            <td>
                                <input v-if="isEditing[index]" type="date" v-model="editingOrder[index].billing_date" class="edit-input" :max="maxDate">
                                <span v-else>{{ order.billing_date }}</span>
                            </td>
                            <td>{{ order.total_paid }}</td>
                            <td>{{ order.balance }}</td>
                            <td>
                                <div v-for="payment in order.payments" :key="payment.id" class="paymentinfo">
                                {{ payment.payment_date }}
                                </div>
                                <div v-if="showAddPayment[index]">
                                    <input type="date" v-model="newPayments[index].payment_date" :max="maxDate" required>
                                </div>
                                <div v-if="order.payments.length === 0 && !showAddPayment[index]">No payments yet.</div>
                            </td>
                            <td>
                                <div v-for="payment in order.payments" :key="payment.id" class="paymentinfo">
                                {{ payment.paid_amount }}
                                </div>
                                <div v-if="showAddPayment[index]">
                                <input type="number" v-model="newPayments[index].paid_amount" required>
                                </div>
                            </td>
                            <td>
                                <div v-for="payment in order.payments" :key="payment.id" class="paymentinfo">
                                {{ payment.payment_method }}
                                </div>
                                <div v-if="showAddPayment[index]">
                                <select v-model="newPayments[index].payment_method" required>
                                    <option value="" disabled selected>Payment Method</option>
                                    <option value="cash">Cash</option>
                                    <option value="card">Card</option>
                                    <option value="cheque">Cheque</option>
                                    <option value="upi">UPI</option>
                                    <option value="bank_transfer">Bank Transfer</option>
                                </select>
                                </div>
                            </td>
                            <td>
                                <div v-for="payment in order.payments" :key="payment.id" class="paymentinfo">
                                {{ payment.remarks }}
                                </div>
                                <div v-if="showAddPayment[index]">
                                <input type="text" v-model="newPayments[index].remarks">
                                </div>
                            </td>
                            <td style="display: flex;justify-content: center;flex-direction: column;align-items: center;gap: 10px;">
                                <div v-if="!showAddPayment[index] && !isEditing[index]">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="#fff" width="20" height="20" viewBox="0 0 24 24"
                                        style="background-color: #007bff; padding: 0px; border-radius: 50%; cursor: pointer;"
                                        @click="showAddPayment[index] = true">
                                        <circle cx="12" cy="12" r="10" fill="none" stroke="#fff" stroke-width="2" />
                                        <path d="M12 7v10M7 12h10" stroke="#fff" stroke-width="2" stroke-linecap="round" />
                                    </svg>
                                </div>
                                <div v-if="isEditing[index]" style="display: flex;align-items: center;justify-content: center;gap: 5px;flex-direction: column;">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#fff" class="bi bi-check-circle" viewBox="0 0 16 16" style="background-color: #409451; padding: 0px; border-radius: 50%; cursor: pointer;"
                                        @click="saveEdit(index)">
                                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16" stroke-width="2"/>
                                        <path d="m10.97 4.97-.02.022-3.473 4.425-2.093-2.094a.5.5 0 0 0-1.06 1.06L6.97 11.03a.5.5 0 0 0 1.079-.02l3.992-4.99a.5.5 0 0 0-1.071-1.05"/>
                                    </svg>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#fff" class="bi bi-x-circle" viewBox="0 0 16 16"
                                        style="background-color: #e74c3c; padding: 0px; border-radius: 50%; cursor: pointer;"
                                        @click="cancelEdit(index)">
                                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16" stroke-width="2"/>
                                        <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708"/>
                                    </svg>
                                </div>
                                <div v-if="showAddPayment[index]" style="display: flex;align-items: center;justify-content: center;gap: 5px;flex-direction: column;">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#fff" class="bi bi-check-circle" viewBox="0 0 16 16" style="background-color: #409451; padding: 0px; border-radius: 50%; cursor: pointer;"
                                        @click="submitPayment(index)">
                                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16" stroke-width="2"/>
                                        <path d="m10.97 4.97-.02.022-3.473 4.425-2.093-2.094a.5.5 0 0 0-1.06 1.06L6.97 11.03a.5.5 0 0 0 1.079-.02l3.992-4.99a.5.5 0 0 0-1.071-1.05"/>
                                    </svg>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#fff" class="bi bi-x-circle" viewBox="0 0 16 16"
                                        style="background-color: #e74c3c; padding: 0px; border-radius: 50%; cursor: pointer;"
                                        @click="cancelPayment(index)">
                                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16" stroke-width="2"/>
                                        <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708"/>
                                    </svg>
                                </div>
                                <div v-if="!showAddPayment[index] && !isEditing[index]">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="#fff" viewBox="0 0 16 16"
                                        style="background-color: #28a745; padding: 3px; border-radius: 50%; cursor: pointer;"
                                        @click="startEdit(index)">
                                        <path d="M12.854.146a.5.5 0 0 0-.707 0L10.5 1.793 14.207 5.5l1.647-1.646a.5.5 0 0 0 0-.708l-3-3zm.646 6.061L9.793 2.5 3.293 9H3.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.207l6.5-6.5zm-7.468 7.468A.5.5 0 0 1 6 13.5V13h-.5a.5.5 0 0 1-.5-.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.5-.5V10h-.5a.499.499 0 0 1-.175-.032l-.179.178a.5.5 0 0 0-.11.168l-2 5a.5.5 0 0 0 .65.65l5-2a.5.5 0 0 0 .168-.11l.178-.179z"/>
                                    </svg>
                                </div>
                            </td>
                        </tr>
                        <tr v-if="displayedOrders.length > 0">
                            <td style="text-align: right;">Total Orders:</td>
                            <td>{{ displayedOrders.length }} / {{ totalOrders }}</td>
                            <td colspan="3"></td>
                            <td colspan="3">
                                <strong>
                                    {{page_total_amount}} / {{total_amount}}
                                </strong>
                            </td>
                            <td>
                                <strong>
                                     {{page_total_paid}} / {{total_paid}}
                                </strong>
                            </td>
                            <td>
                                <strong>
                                      {{page_total_balance}} / {{total_balance}}
                                </strong>
                            </td>
                            <td></td>
                        </tr>
                        <tr v-else>
                            <td colspan="15" style="text-align: center;">No results found...</td>
                        </tr>

                    </tbody>
                </table>
            </div>
        </div>
        
    </div>
    <div class="pagination">
        <button :disabled="currentPage === 1" @click="goToPage(1)">First</button>
        <button :disabled="currentPage === 1" @click="goToPage(currentPage - 1)">Previous</button>
        <span>Page {{ currentPage }} of {{ numPages }}</span>
        <button :disabled="currentPage === numPages" @click="goToPage(currentPage + 1)">Next</button>
        <button :disabled="currentPage === numPages" @click="goToPage(numPages)">Last</button>
    </div>
    
    
</template>
<script>
import axios from 'axios';
import MessageOverlay from './MessageOverlay.vue';
import { getCookie } from '../globalmethods';
import Papa from 'papaparse';
import config from '@/config';
import LoadingSpinner from './LoadingAnimation.vue';

export default {
    components: {
        MessageOverlay,
        LoadingSpinner
    },
    data() {
        return {
            showOverlay: false,
            customername: '',
            customermobile: '',
            customerarea: '',
            product: '',
            currentdate: false,
            dateofinvoice: '',
            amount: '',
            amountpaid: '',
            remarks: '',
            paymentmethod: '',
            errors: {},
            orders: [],
            showAddPayment: [],
            newPayments: [],
            searchText: '',
            selectedStatus: '',
            showGenrateLedgerOverlay: false,
            ledger_startdate: '',
            ledger_enddate: '',
            ledgerformat: '',
            isLoading: false,
            currentPage: 1,
            numPages: 1,
            pageSize: 500,
            totalOrders: 0,
            refreshInterval: null,
            sortColumn: 'billing_date',
            sortDirection: 'desc',
            total_amount: 0,
            total_paid: 0,
            total_balance: 0,
            page_total_amount: 0,
            page_total_paid: 0,
            page_total_balance: 0,
            firmNameSearch: '',
            customers: [],
            filteredCustomers: [],
            selectedCustomer: null,
            isEditing: [],
            editingOrder: [],
            selectedFirms: [],
            commonFirmName: '',
            showCommonFirmInput: false,
            showAutocomplete: false,
        };
    },
    mounted() {
        this.fetchReports();
        this.fetchCustomers();
        document.addEventListener('click', this.handleClickOutside);
    },
    beforeUnmount() {
        document.removeEventListener('click', this.handleClickOutside);
    },
    methods: {
        showAddReportForm() {
            this.showOverlay = true;
            this.resetForm();
        },
        showgenerateLedger() {
            this.showGenrateLedgerOverlay = true;
            this.resetLedgerForm();
        },
        closeGenerateOverlay() {
            this.showGenrateLedgerOverlay = false;
        },
        resetLedgerForm() {
            this.customermobilenumber_ledger = '';
            this.ledger_startdate = '';
            this.ledger_enddate = '';
            this.selectedFirms = [];
            this.commonFirmName = '';
            this.showCommonFirmInput = false;
        },
        resetForm() {
            this.customername = '';
            this.customermobile = '';
            this.customerarea = '';
            this.product = '';
            this.paymentmethod = '';
            this.currentdate = false;
            this.dateofinvoice = '';
            this.amount = '';
            this.amountpaid = '';
            this.remarks = '';
            this.errors = {};
        },
        closeAddReportForm() {
            this.showOverlay = false;
            this.resetForm();
        },
        sortBy(column) {
            if (this.sortColumn === column) {

                this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
            } else {
                this.sortColumn = column;
                this.sortDirection = 'asc';
            }
            this.currentPage = 1;
            this.fetchReports();
        },
        async fetchReports() {
            this.isLoading = true;
            this.orders = []; 
            this.showAddPayment = []; 
            this.newPayments = []; 
            try {
                const params = {
                    page: this.currentPage,
                    page_size: this.pageSize,
                    search: this.searchText,
                    status: this.selectedStatus,
                    sort_by: this.sortColumn,
                    sort_direction: this.sortDirection
                };
                const response = await axios.get(`${config.apiUrl}/getreports/`, { params });
                
                if (response.data && response.data.orders) {
                    this.orders = response.data.orders;
                    this.numPages = response.data.num_pages || 1;
                    this.totalOrders = response.data.total_count || 0;
                    this.total_amount = response.data.total_amount || 0;
                    this.total_paid = response.data.total_paid || 0;
                    this.total_balance = response.data.total_balance || 0;
                    this.page_total_amount = response.data.page_total_amount || 0;
                    this.page_total_paid = response.data.page_total_paid || 0;
                    this.page_total_balance = response.data.page_total_balance || 0;
                    
                    this.showAddPayment = this.orders.map(() => false);
                    this.newPayments = this.orders.map(() => ({
                        payment_date: '',
                        paid_amount: '',
                        payment_method: '',
                        remarks: '',
                    }));
                } else {
                    this.orders = [];
                    this.numPages = 1;
                    this.totalOrders = 0;
                    this.total_amount = 0;
                    this.total_paid = 0;
                    this.total_balance = 0;
                    this.page_total_amount = 0;
                    this.page_total_paid = 0;
                    this.page_total_balance = 0;
                    this.showAddPayment = [];
                    this.newPayments = [];
                    console.warn('No orders data received from API');
                }
            } catch (error) {
                console.error("Error fetching reports:", error);
                this.$refs.messageOverlay.showMessage('Error fetching reports', 'error');
              
                this.orders = [];
                this.numPages = 1;
                this.totalOrders = 0;
                this.total_amount = 0;
                this.total_paid = 0;
                this.total_balance = 0;
                this.page_total_amount = 0;
                this.page_total_paid = 0;
                this.page_total_balance = 0;
                this.showAddPayment = [];
                this.newPayments = [];
            } finally {
                setTimeout(() => {
                    this.isLoading = false; 
                }, 200);
            }
        },
        goToPage(page) {
            if (page >= 1 && page <= this.numPages) {
                this.currentPage = page;
                this.fetchReports();
            }
        },
        addpayment(orderIndex) {
            this.orders[orderIndex].payments.push({ ...this.newPayments[orderIndex], bill_no: this.orders[orderIndex].bill_no });
            this.newPayments[orderIndex] = {
                payment_date: '',
                paid_amount: '',
                payment_method: '',
                remarks: '',
            };
            this.showAddPayment[orderIndex] = false;
        },
        async submitPayment(orderIndex) {
            try {
                const response = await axios.post(`${config.apiUrl}/addpayment/`, {
                    bill_no: this.orders[orderIndex].bill_no,
                    payment_date: this.newPayments[orderIndex].payment_date,
                    paid_amount: this.newPayments[orderIndex].paid_amount,
                    payment_method: this.newPayments[orderIndex].payment_method,
                    remarks: this.newPayments[orderIndex].remarks,
                }, {
                    headers: {
                        'X-CSRFToken': getCookie('csrftoken'),
                        'Content-Type': 'application/json'
                    },
                    withCredentials: true
                });

                if (response.data.success) {

                    const payment = {
                        payment_date: this.newPayments[orderIndex].payment_date,
                        paid_amount: this.newPayments[orderIndex].paid_amount,
                        payment_method: this.newPayments[orderIndex].payment_method,
                        remarks: this.newPayments[orderIndex].remarks,
                        id: Date.now()
                    };

                    this.orders[orderIndex].payments.push(payment);


                    this.orders[orderIndex].total_paid = parseFloat(this.orders[orderIndex].total_paid) + parseFloat(payment.paid_amount);
                    this.orders[orderIndex].balance = parseFloat(this.orders[orderIndex].amount) - parseFloat(this.orders[orderIndex].total_paid);


                    this.showAddPayment[orderIndex] = false;
                    this.newPayments[orderIndex] = {
                        payment_date: '',
                        paid_amount: '',
                        payment_method: '',
                        remarks: '',
                    };

                    this.showSuccess('Payment added successfully');
                } else {
                    this.showError(response.data.error_message || 'An error occurred while submitting payment');
                }
            } catch (error) {
                console.error("Error submitting payment:", error);
                this.showError('An unexpected error occurred while submitting payment.');
            }
        },

        cancelPayment(orderIndex) {
            this.showAddPayment[orderIndex] = false;
            this.newPayments[orderIndex] = {
                payment_date: '',
                paid_amount: '',
                payment_method: '',
                remarks: '',
            };
        },
        async addReport() {
            this.errors = {};
            const isValid = this.validateForm();
            if (!isValid) return;

            this.isLoading = true;

            try {
                const csrftoken = getCookie('csrftoken');
                const response = await axios.post(`${config.apiUrl}/addreport/`, {
                customername: this.customername,
                customermobile: this.customermobile,
                customerarea: this.customerarea,
                product: this.product,
                dateofinvoice: this.currentdate ? new Date().toISOString().slice(0, 10) : this.dateofinvoice,
                amount: this.amount,
                amountpaid: this.amountpaid,
                remarks: this.remarks,
                paymentmethod: this.paymentmethod,
                }, {
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRFToken': csrftoken
                },
                withCredentials: true 
                });
                if (response.data.success) {
                const backendOrder = response.data.order;

                const newOrder = {
                    bill_no: backendOrder.bill_no,
                    customer_name: backendOrder.customer_name,
                    mobile_number: backendOrder.mobile_number,
                    area: backendOrder.area,
                    product: backendOrder.product,
                    amount: backendOrder.amount,
                    status: backendOrder.status,
                    billing_date: backendOrder.billing_date,
                    total_paid: backendOrder.total_paid,
                    balance: backendOrder.balance,
                    payments: backendOrder.payments.map(payment => ({
                    payment_date: payment.payment_date,
                    paid_amount: payment.paid_amount,
                    payment_method: payment.payment_method,
                    remarks: payment.remarks,
                    id: payment.id
                    }))
                };
                this.orders.unshift(newOrder);
                this.closeAddReportForm();
                this.showSuccess('Report added successfully');
                } else {
                this.showError(response.data.error_message || 'An error occurred');
                }
            } catch (error) {
                if (error.response && error.response.data && error.response.data.errors) {
                this.errors = error.response.data.errors;
                } else if (error.response && error.response.status===403) {
                            window.location.href = '/accounts/login/';
                        }
                else if (error.response && error.response.data) {
                this.showError(error.response.data.error_message || 'An error occurred');
                } else {
                this.showError('An unexpected error occurred.');
                }
            } finally {
                this.isLoading = false;
            }
        },
        async fetchCustomers() {
            try {
                const response = await axios.get(`${config.apiUrl}/get_customers/`);

                if (response.status >= 200 && response.status < 300) {
                    this.customers = response.data.customers;
                } else {
                    console.error("Error fetching customers:", response.status, response.statusText);
                    this.showError(`Error fetching customer data: ${response.status} ${response.statusText}`);
                }

            } catch (error) {
                console.error("Error fetching customers:", error);
                this.showError("Error fetching customer data.");
            }
        },
        async generateLedger() {
            try {
                if (this.selectedFirms.length === 0) {
                    this.showError('Please select at least one firm');
                    return;
                }

                if (this.selectedFirms.length > 1 && !this.commonFirmName) {
                    this.showError('Please enter a common firm name');
                    return;
                }

                const postData = {
                    customermobile: this.selectedFirms.length === 1 
                        ? this.selectedFirms[0].name 
                        : this.commonFirmName,
                    from: this.ledger_startdate,
                    to: this.ledger_enddate,
                    format: this.ledgerformat,
                    firm_ids: this.selectedFirms.map(f => f.id)
                };

                let response;
                let filename;
                let date = new Date();
                if (this.ledgerformat === 'pdf') {
                    response = await axios.post(`${config.apiUrl}/generateledger/`, postData, {
                        headers: {
                            'X-CSRFToken': getCookie('csrftoken'),
                            'Content-Type': 'application/json'
                        },
                        responseType: 'blob',
                        withCredentials: true
                    });
                    filename = `${postData.customermobile}_${date}_ledger.pdf`;
                } else if (this.ledgerformat === 'excel') {
                    response = await axios.post(`${config.apiUrl}/generate_excel_ledger/`, postData, {
                        headers: {
                            'X-CSRFToken': getCookie('csrftoken'),
                            'Content-Type': 'application/json'
                        },
                        responseType: 'blob',
                        withCredentials: true
                    });
                    filename = `${postData.customermobile}_${date}_ledger.xls`;
                } else {
                    this.showError("Invalid ledger format selected.");
                    return;
                }

                if (response.status === 200) {
                    const url = window.URL.createObjectURL(new Blob([response.data]));
                    const link = document.createElement('a');
                    link.href = url;
                    link.setAttribute('download', filename);
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                    window.URL.revokeObjectURL(url);
                    this.showSuccess('Ledger Generated');
                    this.closeGenerateOverlay();
                } else {
                    this.showError(response.data?.error_message || 'An error occurred during ledger generation');
                }
            } catch (error) {
                if (error.response && error.response.data && error.response.data.error_message) {
                    this.showError(error.response.data.error_message);
                } else if (error.response && error.response.status === 404) {
                    this.showError('Customer not found.');
                } else {
                    this.showError('An unexpected error occurred: ' + (error.message || 'Unknown error'));
                }
            } finally {
                this.isLoading = false;
            }
        },
        searchCustomers() {
            if (this.customermobilenumber_ledger.length > 0) {
                this.filteredCustomers = this.customers.filter(customer =>
                    customer.name.toLowerCase().includes(this.customermobilenumber_ledger.toLowerCase())
                );
                this.showAutocomplete = true;
            } else {
                this.filteredCustomers = [];
                this.showAutocomplete = false;
            }
        },
        selectCustomer(customer) {
            this.customermobilenumber_ledger = customer.name;
            this.selectedCustomer = customer;
            this.filteredCustomers = [];
            this.showAutocomplete = false;
        },
        getCookie(name) {
            let cookieValue = null;
            if (document.cookie && document.cookie !== '') {
                const cookies = document.cookie.split(';');
                for (let i = 0; i < cookies.length; i++) {
                    const cookie = cookies[i].trim();
                    if (cookie.substring(0, name.length + 1) === (name + '=')) {
                        cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                        break;
                    }
                }
            }
            return cookieValue;
        },
        totalAmount(orders) {
            return orders.reduce((sum, order) => sum + parseFloat(order.amount), 0);
        },

        totalPaid(orders) {
            return orders.reduce((sum, order) => {
                return sum + order.payments.reduce((paymentSum, payment) => paymentSum + parseFloat(payment.paid_amount), 0);
            }, 0);
        },

        totalBalance(orders) {
            return this.totalAmount(orders) - this.totalPaid(orders);
        },

        async Search() {
            const searchInput = document.getElementById('searchinput');
            this.searchText = searchInput.value;
            this.currentPage = 1;
            await this.fetchReports();
            await this.$nextTick();
            searchInput.focus();
        },

        filterTable() {
            this.selectedStatus = document.getElementById('rolefilters').value;
            this.currentPage = 1;
            this.fetchReports();
        },
        validateForm() {
            let isValid = true;
            this.errors = {};

            if (!this.customername.trim()) {
                this.errors.customername = 'Name is required';
                isValid = false;
            }
            if (!this.customermobile.trim() || this.customermobile.length !== 10 || !/^[6-9]\d{9}$/.test(this.customermobile)) {
                this.errors.customermobile = 'Please enter a valid 10-digit Indian mobile number.';
                isValid = false;
            }
            if (!this.customerarea.trim()) {
                this.errors.customerarea = 'Area is required';
                isValid = false;
            }
            if (!this.product.trim()) {
                this.errors.product = 'Product is required';
                isValid = false;
            }
            if (!this.amount) {
                this.errors.amount = 'Amount is required';
                isValid = false;
            }
            if (!this.amountpaid) {
                this.errors.amountpaid = 'Amount paid is required';
                isValid = false;
            }
            if (!this.remarks.trim()) {
                this.errors.remarks = 'Remarks is required';
                isValid = false;
            }
            return isValid;
        },
        showError(message) {
            this.$refs.messageOverlay.showMessage(message, 'warning');
        },
        showSuccess(message) {
            this.$refs.messageOverlay.showMessage(message, 'success');
        },
        openFileDialog() {
            this.$refs.excelFile.click();
        },
        onFileSelected(event) {
            const file = event.target.files[0];
            this.processFile(file);
        },
        async processFile(file) {
            this.isLoading = true;
            this.importStatus = `Processing ${file.name}...`;
            const formData = new FormData();
            formData.append('excelFile', file);
            try {
                const response = await axios.post(`${config.apiUrl}/import_excel_data/`, formData, {
                    headers: {
                        'Content-Type': 'multipart/form-data',
                        'X-CSRFToken': getCookie('csrftoken')
                    },
                    withCredentials: true
                });
                if (response.data.success) {
                    this.showSuccess('Data imported successfully');
                    this.fetchReports();

                }
                else {
                    this.showError(response.data.error_message || 'An error occurred');
                }
            } catch (error) {
                console.error("Error processing file:", error);
                this.showError(error.message)
            }
            finally {
                this.isLoading = false;
            }
        },
        async exportAllOrders() {
            let response;
            this.isLoading=true;
            let date = new Date();
            try {
                response = await axios.get(`${config.apiUrl}/export_all_orders/`,{
                    headers: {
                        'X-CSRFToken': getCookie('csrftoken'),
                        'Content-Type': 'application/json'
                    },
                    responseType: 'blob',
                    withCredentials: true
                });
                if (response.status === 200) {
                    const url = window.URL.createObjectURL(new Blob([response.data]));
                    const link = document.createElement('a');
                    link.href = url;
                    let filename= `All_orders_${date}.xls`;
                    link.setAttribute('download', filename);
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                    window.URL.revokeObjectURL(url);
                    this.showSuccess("All orders exported successfully");
                } else {
                    this.showError("Error exporting orders.");
                }
            } catch (error) {
                console.error("Error exporting orders:", error);
                this.showError("An error occurred during export.");
            }
            finally {
                this.isLoading = false;
            }
        },
        parseCSV(file) {
            return new Promise((resolve, reject) => {
                Papa.parse(file, {
                    complete: (results) => {
                        resolve(results.data);
                    },
                    error: (error) => {
                        reject(error);
                    },
                });
            });
        },
        handleParsedData(data) {
            console.log('Parsed data:', data);
            this.importStatus = "Import successful!";
        },
        startEdit(index) {
            this.isEditing[index] = true;
            this.editingOrder[index] = { ...this.orders[index] };
        },
        async saveEdit(index) {
            try {
                this.isLoading = true;
                const response = await axios.post(`${config.apiUrl}/update_order/`, {
                    bill_no: this.orders[index].bill_no,
                    customer_name: this.editingOrder[index].customer_name,
                    mobile_number: this.editingOrder[index].mobile_number,
                    area: this.editingOrder[index].area,
                    product: this.editingOrder[index].product,
                    amount: this.editingOrder[index].amount,
                    billing_date: this.editingOrder[index].billing_date
                }, {
                    headers: {
                        'X-CSRFToken': getCookie('csrftoken'),
                        'Content-Type': 'application/json'
                    },
                    withCredentials: true
                });

                if (response.data.success) {
                    this.orders[index] = { ...this.editingOrder[index] };
                    this.isEditing[index] = false;
                    this.showAddPayment[index] = false;
                    this.showSuccess('Changes saved successfully');
                    this.fetchReports();
                } else {
                    this.showError(response.data.error_message || 'Failed to save changes');
                }
            } catch (error) {
                console.error("Error saving changes:", error);
                if (error.response && error.response.status === 403) {
                    window.location.href = '/accounts/login/';
                } else {
                    this.showError('An error occurred while saving changes');
                }
            } finally {
                this.isLoading = false;
            }
        },
        cancelEdit(index) {
            this.isEditing[index] = false;
            this.showAddPayment[index] = false;
        },
        toggleFirmSelection(customer) {
            const index = this.selectedFirms.findIndex(f => f.id === customer.id);
            if (index === -1) {
                this.selectedFirms.push(customer);
            } else {
                this.selectedFirms.splice(index, 1);
            }
            this.showCommonFirmInput = this.selectedFirms.length > 1;
        },
        removeFirm(firm) {
            const index = this.selectedFirms.findIndex(f => f.id === firm.id);
            if (index !== -1) {
                this.selectedFirms.splice(index, 1);
            }
            this.showCommonFirmInput = this.selectedFirms.length > 1;
        },
        handleClickOutside(event) {
            const autocompleteWrapper = this.$refs.autocompleteWrapper;
            if (autocompleteWrapper && !autocompleteWrapper.contains(event.target)) {
                this.showAutocomplete = false;
            }
        },
    },
    watch: {
        currentdate(newVal) {
            if (newVal) {
                this.dateofinvoice = "";
            }
        },
        dateofinvoice(newVal) {
            if (newVal) {
                this.currentdate = false;
            }
        }
    },
    computed: {
        displayedOrders() {
            return this.orders;
        },
        maxDate() {
            const today = new Date();
            const dd = String(today.getDate()).padStart(2, '0');
            const mm = String(today.getMonth() + 1).padStart(2, '0');
            const yyyy = today.getFullYear();
            return `${yyyy}-${mm}-${dd}`;
        },
    }

};
</script>
<style scoped>
    .pagination {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: 10px; 
        padding: 10px; 
        background-color: #f8f9fa; 
        border-radius: 5px; 
    }

    .pagination button {
        padding: 8px 12px;
        margin: 0 5px;
        border: 1px solid #ccc;
        border-radius: 4px;
        background-color: white;
        color: #333;
        cursor: pointer;
        transition: background-color 0.3s, color 0.3s;
    }

    .pagination button:hover {
        background-color: #e9ecef; 
    }

    .pagination button:disabled {
        opacity: 0.5; 
        cursor: not-allowed; 
        background-color: #f8f9fa;
        color: #333;
        border-color: #ccc;
    }
    .pagination span{
        padding: 8px 12px;
        margin: 0 5px;
        font-size: 15px;
        font-weight: 500;
    }
    .subnav>h3{
        color: #333;
        font-size: 20px;
    }
    .subnav-container{
        margin: 0px;
    }
    .reportstable[data-v-37db62ad] {
        height: calc(100vh - 270px);
        overflow: auto;
        margin-top: 20px;
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
        display: flex;
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
    input[type="number"],
    input[type="tel"],
    input[type="date"],
    select{
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }
    input[type="text"]:focus,
    input[type="email"]:focus,
    input[type="number"]:focus,
    input[type="tel"]:focus
    input[type="date"]:focus,
    select:focus{
        outline: none;
        border-color: #4285f4; 
        box-shadow: 0px 0px 8px rgba(66, 133, 244, 0.5);
    }
    
    .error-message {
        color: red;
        margin: 3px;
        font-size: 14px;

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
    .close-overlay{
        transition: transform 0.2s ease, fill 0.2s ease;

    }
    .close-overlay:hover{
        color: #e74c3c;
        transform: rotate(90deg);
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
    .paymentinfo{
        margin: 10px 0px;
    }
    .paymentinfo:last-of-type{
        margin: 5px 0px;
    }
    .paymentinfo:first-of-type{
        margin: 5px 0px;
        
    }
    .ledger-container {
        margin-top: 20px;
        border-collapse: collapse;
        width: 100%;
    }

    .ledger-container table {
        width: 100%;
        border-collapse: collapse;
    }

    .ledger-container th,
    .ledger-container td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
    }

    .ledger-container th {
        background-color: #f2f2f2;
    }

    .ledger-container ul {
        list-style: none;
        padding: 0;
    }

    .ledger-container li {
        margin-bottom: 4px;
    }
    .generateledger{
        display: flex;
        align-items: center;
        gap: 5px;
        background-color: #dde3ea;
        padding: 11px;
        border-radius: 10px;
        border: transparent;
        cursor: pointer;
        transition: transform 0.3s ease-in-out;
    }
    .generateledger:hover{
        background-color: #bdbfc1;
    }
    #importexcel{
        background-color: #007bff;
    }
    #importexcel:hover{
        background-color: #4285f4;
    }
    th.sortable {
        cursor: pointer;
        display: flex;
        align-items: center;
        gap:5px;
    }
    .autocomplete-wrapper{
        position: relative;
        width: -webkit-fill-available;
    }
    .autocomplete-list {
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background-color: #fff;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.1);
        list-style: none;
        padding: 0;
        margin-top: 2px;
        z-index: 1000;
        max-height: 200px;
        overflow-y: auto;
    }

    .autocomplete-item {
        padding: 8px 12px;
        cursor: pointer;
        transition: background-color 0.2s ease;
        font-size: 14px;
        color: #333;
        border-bottom: 1px solid #eee; 
    }

    .autocomplete-item:last-child {
        border-bottom: none; 
    }

    .autocomplete-item:hover {
        background-color: #f5f5f5;
        color: #007bff; 
    }

    .edit-input {
        width: 100%;
        padding: 5px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 14px;
    }

    .edit-input:focus {
        outline: none;
        border-color: #4285f4;
        box-shadow: 0 0 0 2px rgba(66, 133, 244, 0.2);
    }

    .firm-selection {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 5px 0;
    }

    .firm-selection input[type="checkbox"] {
        margin: 0;
        cursor: pointer;
    }

    .selected-firms {
        margin-top: 10px;
        padding: 10px;
        background-color: #f8f9fa;
        border-radius: 4px;
    }

    .selected-firms h4 {
        margin: 0 0 10px 0;
        font-size: 14px;
        color: #666;
    }

    .selected-firms ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .selected-firms li {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 5px 10px;
        background-color: white;
        border: 1px solid #ddd;
        border-radius: 4px;
        margin-bottom: 5px;
    }

    .remove-firm {
        background: none;
        border: none;
        color: #dc3545;
        cursor: pointer;
        font-size: 18px;
        padding: 0 5px;
    }

    .remove-firm:hover {
        color: #c82333;
    }

    .common-firm-input {
        margin-top: 15px;
        padding-top: 15px;
    }

    .common-firm-input label {
        display: block;
        margin-bottom: 5px;
    }

    .common-firm-input input {
        width: 100%;
    }
</style>