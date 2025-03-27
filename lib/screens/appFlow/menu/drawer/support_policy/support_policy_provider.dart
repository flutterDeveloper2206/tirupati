import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crm_demo/data/model/response_all_contents.dart';
import 'package:crm_demo/data/server/respository/repository.dart';
import 'package:crm_demo/utils/app_const.dart';

class SupportPolicyProvider extends ChangeNotifier{
  ResponseAllContents? contentsData;
  SupportPolicyProvider(){
    supportPolicyApi();
  }

  supportPolicyApi() async {
    var apiResponse = await Repository.allContentsApi(AppConst.supportPolicy);
    if (apiResponse.result == true) {
      contentsData = apiResponse.data;
      notifyListeners();
      if (kDebugMode) {
        print("Support Policy");
      }
    } else {
      Fluttertoast.showToast(
          msg: apiResponse.message ?? "",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
  }
}