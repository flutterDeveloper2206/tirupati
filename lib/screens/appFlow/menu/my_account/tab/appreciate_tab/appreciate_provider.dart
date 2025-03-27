import 'package:flutter/foundation.dart';
import 'package:crm_demo/api_service/api_body.dart';
import 'package:crm_demo/data/model/response_appreciate_list.dart';
import 'package:crm_demo/data/server/respository/repository.dart';
import 'package:crm_demo/utils/shared_preferences.dart';

class AppreciateProvider extends ChangeNotifier{
  ResponseAppreciateList? appreciateList;
  bool isLoading = false;
  AppreciateProvider(){
    getAppreciateApi();
  }
  /// getAppreciate API .............
  void getAppreciateApi() async {
    var userId = await SPUtill.getIntValue(SPUtill.keyUserId);
    var bodyUserId = BodyUserId(userId: userId);
    var apiResponse =
    await Repository.gerAppreciateList(bodyUserId);
    if (apiResponse.result == true) {
      appreciateList = apiResponse.data;
      isLoading = true;
      if (kDebugMode) {
        print(apiResponse.data);
      }
      notifyListeners();
    } else {
      final errorMessage = apiResponse.message;
      if (kDebugMode) {
        print(errorMessage);
      }
    }
  }
}