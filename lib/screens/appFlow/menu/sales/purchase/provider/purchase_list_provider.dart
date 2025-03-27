
import 'package:flutter/material.dart';
import 'package:crm_demo/data/model/crm_sales/purchase_list_model.dart';
import 'package:crm_demo/data/server/respository/crm_sales_repository/crm_sales_repository.dart';

class PurchaseListProvider extends ChangeNotifier{

  PurchaseListModel? purchaseListResponse;
  bool isLoading = false;

  PurchaseListProvider(){
    getPurchaseList();
  }


  getPurchaseList() async {
    isLoading = true;
    final response = await CRMSalesRepository.getPurchaseListData();
    if(response.result == true){
      purchaseListResponse = response.data;
      isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

}