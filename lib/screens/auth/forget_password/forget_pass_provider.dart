import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crm_demo/api_service/api_body.dart';
import 'package:crm_demo/data/server/respository/auth_repository/auth_repository.dart';
import 'package:crm_demo/screens/auth/change_password/change_password.dart';
import 'package:crm_demo/utils/nav_utail.dart';

class ForgetPassProvider extends ChangeNotifier {
  var emailTextController = TextEditingController();
  String? emailError;
  String? error;

  void resetTextField() {
    emailTextController.text = "";
    emailError = "";
    error = "";
    notifyListeners();
  }

  void getVerificationCode(context) async {
    var bodyVerificationCode =
        BodyVerificationCode(email: emailTextController.text);
    var apiResponse =
        await AuthRepository.getVerificationCode(bodyVerificationCode);
    if (apiResponse.result == true) {
      Fluttertoast.showToast(
          msg: apiResponse.message ?? "",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
      NavUtil.replaceScreen(
          context, ChangePassword(email: emailTextController.text));
      resetTextField();
    } else {
      if(apiResponse.httpCode == 422){
        emailError = apiResponse.error?.laravelValidationError?.email;
        error = apiResponse.message;
        notifyListeners();
      } else if(apiResponse.httpCode == 400){
        emailError = apiResponse.error?.laravelValidationError?.email;
        error = apiResponse.message;
        notifyListeners();
      } else {
        Fluttertoast.showToast(msg: "Something Went Wrong");
      }
    }
  }
}
