import 'package:crm_demo/screens/appFlow/home/crm_home_screen.dart';
import 'package:crm_demo/screens/auth/login/login_screen.dart';
import 'package:crm_demo/utils/nav_utail.dart';
import 'package:crm_demo/utils/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../../../main.dart';

class SplashProvider extends ChangeNotifier{
  SplashProvider(context){
    initFunction(context);
  }

  initFunction(context){
    Future.delayed(const Duration(seconds: 2), () async {
      var mobile = await SPUtill.getValue(SPUtill.mobileNo);
      var userId = await SPUtill.getIntValue(SPUtill.keyUserId);
      var baseUrl = await SPUtill.getValue(SPUtill.companyUrl);
      global.set(SPUtill.companyUrl, baseUrl);
      if (kDebugMode) {
        /// development purpose only
        print("mobile: $mobile");
        print("User Id: $userId");
      }
      if (mobile != null && (userId != null /*|| userId != 0*/)) {
        NavUtil.replaceScreen(context, const CrmHomeScreen());
      } else {
        NavUtil.replaceScreen(context, const LoginScreen());
      }
      notifyListeners();
    });
  }
}