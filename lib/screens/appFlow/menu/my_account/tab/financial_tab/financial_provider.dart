import 'package:flutter/material.dart';
import 'package:crm_demo/utils/shared_preferences.dart';

class FinancialProvider extends ChangeNotifier {
  String? profileImage;

  FinancialProvider() {
    getProfileData();
  }

  void getProfileData() async {
    profileImage = await SPUtill.getValue(SPUtill.keyProfileImage);
    notifyListeners();
  }
}
