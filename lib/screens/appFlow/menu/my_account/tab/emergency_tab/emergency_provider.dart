import 'package:flutter/material.dart';
import 'package:crm_demo/utils/shared_preferences.dart';

class EmergencyProvider extends ChangeNotifier {
  String? profileImage;
  EmergencyProvider() {
    getProfileData();
  }

  void getProfileData() async {
    profileImage = await SPUtill.getValue(SPUtill.keyProfileImage);
    notifyListeners();
  }
}
