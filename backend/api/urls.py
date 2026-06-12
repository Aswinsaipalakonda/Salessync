from django.contrib import admin
from django.urls import path
import api
import api.urls
from api import views

urlpatterns = [
    path('getuserdetails/',views.getuserdetails,name='getuserdetails'),
    path('', views.index, name='index'),
    path('resetpassword/',views.resetpassword,name='resetpassword'),
    path('adduser/',views.adduser,name='adduser'),
    path('adminlogin/',views.adminlogin,name='adminlogin'),
    path('updateusertype/',views.updateusertype,name='updateusertype'),
    path('deleteusers/',views.deleteusers,name='deleteusers'),
    path('adminlogin/',views.adminlogin,name='adminlogin'),
    path('addreport/',views.addreport,name='addreport'),
    path('getreports/',views.getreports,name='getreports'),
    path('addpayment/',views.addpayment,name='addpayment'),
    path('generateledger/',views.generateledger,name='generateledger'),
    path('generate_excel_ledger/',views.generate_excel_ledger,name='generate_excel_ledger'),
    path('import_excel_data/',views.import_excel_data,name='import_excel_data'),
    path('logout_admin/',views.logout_admin,name='logout_admin'),
    path('export_all_orders/',views.export_all_orders,name='export_all_orders'),
    path('get_customers/', views.get_customers, name='get_customers'),
    path('logout_user/',views.logout_user,name='logout_user'),
    path('userlogin/',views.userlogin,name='userlogin'),
    path('update_order/', views.update_order, name='update_order'),
]
