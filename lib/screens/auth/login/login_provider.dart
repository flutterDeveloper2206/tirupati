import 'dart:io';

import 'package:crm_demo/api_service/api_body.dart';
import 'package:crm_demo/data/model/auth_response/response_login.dart';
import 'package:crm_demo/data/server/respository/auth_repository/auth_repository.dart';
import 'package:crm_demo/data/server/respository/repository.dart';
import 'package:crm_demo/screens/appFlow/home/crm_home_screen.dart'
    show CrmHomeScreen;
import 'package:crm_demo/screens/appFlow/permission/app_permission_page.dart';
import 'package:crm_demo/utils/app_const.dart' show AppConst;
import 'package:crm_demo/utils/nav_utail.dart';
import 'package:crm_demo/utils/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart' as loc;

class LoginProvider extends ChangeNotifier {
  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();
  String? email;
  String? password;
  String? error;
  bool isError = false;
  bool passwordVisible = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  loc.Location location = loc.Location();
  String? deviceInfoModel;

  LoginProvider() {
    passwordVisible = false;
    getDeviceId();
  }

  Future checkGps(context) async {
    ///location permission
    await location.requestPermission();

    ///check permission
    location.hasPermission().then((permissionGrantedResult) {
      if (permissionGrantedResult != loc.PermissionStatus.granted &&
          Platform.isAndroid) {
        _neverSatisfied(context);
      }
    });
    notifyListeners();
  }

  Future<void> _neverSatisfied(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location permission'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'You have to grant background location permission.',
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  prominentDisclosure,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 36.0),
                Text(denyMessage),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () async {
                locationPermission(context);
              },
              child: const Text('Continue'),
            ),
            MaterialButton(
              child: const Text('Deny'),
              onPressed: () {
                // Get.back();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String denyMessage =
      'If the permission is rejected, then you have to manually go to the settings to enable it';
  String prominentDisclosure =
      'Onest HRM collects location data to enable user employee attendance and visit feature, also find distance between employee and office position for accurate daily attendance ';

  passwordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void resetTextField() {
    emailTextController.text = "";
    passwordTextController.text = "";
    email = "";
    password = "";
    error = "";
    notifyListeners();
  }

  Future<void> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceInfoModel =
          '${iosDeviceInfo.name}-${iosDeviceInfo.model}-${iosDeviceInfo.systemVersion}';
      final result =
          '${iosDeviceInfo.name}-${iosDeviceInfo.model}-${iosDeviceInfo.identifierForVendor}';
      SPUtill.setValue(SPUtill.keyIosDeviceToken, result);
    } else {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      deviceInfoModel =
          '${androidDeviceInfo.device},${androidDeviceInfo.model},${androidDeviceInfo.brand}';
      final result =
          '${androidDeviceInfo.brand}-${androidDeviceInfo.device}-${androidDeviceInfo.id}';
      SPUtill.setValue(SPUtill.keyAndroidDeviceToken, result);
    }
  }

  Future setDataSharePreferences(ResponseLogin? responseLogin) async {
    if (responseLogin?.data != null) {
      // SPUtill.setValue(SPUtill.keyAuthToken, responseLogin?.data?.token);
      SPUtill.setIntValue(
        SPUtill.keyUserId,
        int.parse(responseLogin?.data?.first.userId ?? ''),
      );
      SPUtill.setValue(
        SPUtill.address,
        responseLogin?.data?.first.address ?? '',
      );
      SPUtill.setValue(
        SPUtill.emailId,
        responseLogin?.data?.first.emailId ?? '',
      );
      SPUtill.setValue(
        SPUtill.userName,
        (responseLogin?.data?.first.userName ?? ''),
      );
      SPUtill.setValue(
        SPUtill.userType,
        (responseLogin?.data?.first.userType ?? ''),
      );
      SPUtill.setValue(
        SPUtill.mobileNo,
        (responseLogin?.data?.first.mobile ?? ''),
      );
      SPUtill.setValue(
        SPUtill.companyName,
        (responseLogin?.data?.first.companyName ?? ''),
      );
    }
    getBaseSetting();
  }

  void getUserInfo(context) async {
    var deviceName = await SPUtill.getValue(SPUtill.keyAndroidDeviceToken);
    var iosDeviceName = await SPUtill.getValue(SPUtill.keyIosDeviceToken);
    var bodyLogin = BodyLogin(
      mobile: emailTextController.text,
      password: passwordTextController.text,
      request: 'userLogin',
      header: AppConst.header,
      /*mobile: emailTextController.text,
        // email: emailTextController.text,
        password: passwordTextController.text,
        deviceId: Platform.isAndroid ? deviceName : iosDeviceName,
        deviceInfo: deviceInfoModel*/
    );
    var apiResponse = await AuthRepository.getLogin(bodyLogin);
    if (apiResponse.result == true) {
      setDataSharePreferences(apiResponse.data);

      Fluttertoast.showToast(
        msg: apiResponse.message ?? "",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      resetTextField();
      if (Platform.isAndroid) {
        checkGps(context);
        NavUtil.replaceScreen(context, const CrmHomeScreen());
      } else {
        NavUtil.replaceScreen(context, const AppPermissionPage());
      }
    } else {
      if (apiResponse.httpCode == 422) {
        // email = apiResponse.error?.laravelValidationError?.email;
        // password = apiResponse.error?.laravelValidationError?.password;
        error = apiResponse.message;
        notifyListeners();
      } else if (apiResponse.httpCode ==
          400 /*&&apiResponse.error?.laravelValidationError.toString() != '404'*/ ) {
        // email = apiResponse.error?.laravelValidationError?.email;
        // password = apiResponse.error?.laravelValidationError?.password;
        error = apiResponse.message;
        notifyListeners();
      } else {
        Fluttertoast.showToast(msg: "Something Went Wrong");
      }
    }
  }

  getBaseSetting() async {
    var apiResponse = await Repository.baseSettingApi();
    if (apiResponse.result == true) {
      notifyListeners();
    }
  }

  locationPermission(context) async {
    ///request  permission
    await location.requestPermission();

    ///instantiate locationService
    if (!await location.serviceEnabled()) {
      location.requestService();
    }
    Navigator.pop(context);
  }
}
