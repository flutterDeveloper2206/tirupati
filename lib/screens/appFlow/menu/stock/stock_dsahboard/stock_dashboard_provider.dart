import 'package:flutter/material.dart';
import 'package:crm_demo/data/model/crm_stocks/crm_stocks_model.dart';
import 'package:crm_demo/data/server/respository/crm_stocks_repository/stock_repository.dart';

class StockDashboardProvider extends ChangeNotifier{
  StockModel? stockModel;

  StockDashboardProvider(){
    getSalesData();
  }

  ///get crm home screen data
  getSalesData() async {
    final response = await CRMStockRepository.getCrmStockData();
    if (response.httpCode == 200) {
      stockModel = response.data;
    }
    notifyListeners();
  }
}