
import 'package:flutter/material.dart';
import 'package:crm_demo/data/model/crm_sales/customer_list_model.dart';
import 'package:crm_demo/data/server/respository/crm_sales_repository/crm_sales_repository.dart';

class OrderListProvider extends ChangeNotifier{

  CustomerListModel? orderListResponse;


  OrderListProvider(){
    getCustomerList();
  }



  getCustomerList() async {
    final response = await CRMSalesRepository.getCustomerListData();
    if(response.result == true){
      orderListResponse = response.data;
    }
    notifyListeners();
  }

}