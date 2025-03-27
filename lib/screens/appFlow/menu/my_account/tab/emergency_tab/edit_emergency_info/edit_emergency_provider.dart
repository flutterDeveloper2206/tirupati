import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crm_demo/api_service/api_body.dart';
import 'package:crm_demo/data/model/response_emergency.dart';
import 'package:crm_demo/data/server/respository/profile_repository/profile_repository.dart';
import 'package:crm_demo/screens/appFlow/menu/my_account/my_account.dart';
import 'package:crm_demo/utils/nav_utail.dart';
import 'package:crm_demo/utils/shared_preferences.dart';

class EditEmergencyProvider extends ChangeNotifier {
  var nameTextController = TextEditingController();
  var mobileTextController = TextEditingController();
  var relationshipTextController = TextEditingController();
  String? emergencyNumberError;

  EditEmergencyProvider(ResponseEmergency? emergencyInfo) {
    setData(emergencyInfo);
  }

  void setData(ResponseEmergency? emergency) {
    nameTextController.text = emergency?.data?.emergencyName ?? "";
    mobileTextController.text = emergency?.data?.emergencyMobileNumber ?? "";
    relationshipTextController.text =
        emergency?.data?.emergencyMobileRelationship ?? "";
  }

  void updateEditEmergencyInfo(context) async {
    int? userId = await SPUtill.getIntValue(SPUtill.keyUserId);
    var bodyEmergencyInfo = BodyEditEmergencyInfo(
        userId: userId,
        emergencyName: nameTextController.text,
        emergencyMobileNumber: mobileTextController.text,
        emergencyMobileRelationship: relationshipTextController.text);
    var apiResponse =
        await ProfileRepository.updateEditEmergencyInfo(bodyEmergencyInfo);
    if (apiResponse.data?.result == true) {
      if (kDebugMode) {
        print(apiResponse.data?.message);
      }
      NavUtil.navigateScreen(
          context,
          const MyAccount(
            tabIndex: 3,
          ));
    } else {
      emergencyNumberError =
          apiResponse.error?.laravelValidationError?.emergencyNumber;
      if (kDebugMode) {
        print(apiResponse.data?.message);
      }
    }
  }
}
