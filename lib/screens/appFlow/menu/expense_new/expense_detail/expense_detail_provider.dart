import 'package:flutter/material.dart';
import 'package:crm_demo/data/model/expense_model/response_expense_detail.dart';
import 'package:crm_demo/data/server/respository/expense_repository.dart';

class ExpenseDetailProvider extends ChangeNotifier {
  ResponseExpenseDetail? responseExpenseDetail;

  ExpenseDetailProvider(int? expenseId) {
    expenseDetail(expenseId);
  }

  /// Create expense:-----------------
  Future expenseDetail(int? expenseId) async {
    final response = await ExpenseRepository.expenseDetailApi(expenseId);
    if (response.result == true) {
      responseExpenseDetail = response.data;
      notifyListeners();
    }
  }
}
