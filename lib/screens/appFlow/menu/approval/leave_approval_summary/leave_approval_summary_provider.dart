import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:crm_demo/api_service/api_body.dart';
import 'package:crm_demo/data/model/response_all_leave_request.dart';
import 'package:crm_demo/data/model/response_leave_summary.dart';
import 'package:crm_demo/data/model/response_offical_info.dart';
import 'package:crm_demo/data/server/respository/profile_repository/profile_repository.dart';
import 'package:crm_demo/data/server/respository/repository.dart';
import 'package:crm_demo/data/model/response_user_search.dart';
import 'package:crm_demo/utils/app_const.dart';
import 'package:crm_demo/utils/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../../../../utils/month_picker_dialog/month_picker_dialog.dart';

class LeaveApprovalSummaryProvider extends ChangeNotifier{

  User? userObj;
  ResponseOfficialInfo? officialInfo;
  ResponseLeaveSummary? responseLeaveSummary;
  ResponseAllLeaveRequest? leaveTypeList;
  String? currentMonth;
  bool isLoading = false;
  String? monthYear;
  DateTime? selectedDate;
  int? userID;

  LeaveApprovalSummaryProvider(int? userId){
    userID = userId;
    getOfficialInfo();
    getLeaveSummary();
    allLeaveRequest();
    getDate();
  }

  /// get Leave summary API
  getLeaveSummary() async {
    var userIdKey = await SPUtill.getIntValue(SPUtill.keyUserId);
    var userId = userID ?? userIdKey;
    var bodyUserId = BodyUserId(userId: userId);
    final apiResponse = await Repository.leaveSummary(bodyUserId);
    if (apiResponse.result == true) {
      responseLeaveSummary = apiResponse.data;
      notifyListeners();
    }
    notifyListeners();
  }

  /// Get current date and Format
  getDate() {
    DateTime currentDate = DateTime.now();
    currentMonth = DateFormat('y-MM').format(currentDate);
    monthYear = DateFormat('MMMM,y').format(currentDate);
    notifyListeners();
  }

  /// Select date.....
  Future selectDate(BuildContext context) async {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
      initialDate: DateTime.now(),
      locale: const Locale("en"),
    ).then((date) {
      if (date != null) {
        selectedDate = date;
        currentMonth = DateFormat('y-MM').format(selectedDate!);
        monthYear = DateFormat('MMMM,y').format(selectedDate!);
        allLeaveRequest();
        if (kDebugMode) {
          print(DateFormat('y-MM').format(selectedDate!));
        }
        notifyListeners();
      }
    });
  }

  /// getOfficialInfo API .............
  void getOfficialInfo() async {
    var userIdKey = await SPUtill.getIntValue(SPUtill.keyUserId);
    var bodyUserId = BodyUserId(
      userId: userID ?? userIdKey,
    );

    var apiResponseOfficial = await ProfileRepository.getOfficialInfo(
        bodyUserId, AppConst.officialSlug);
    if (apiResponseOfficial.result == true) {
      officialInfo = apiResponseOfficial.data;
      if (kDebugMode) {
        print(apiResponseOfficial.data);
      }
      notifyListeners();
    } else {
      final errorMessage = apiResponseOfficial.message;
      if (kDebugMode) {
        print(errorMessage);
      }
    }
  }

  ///get all leave request list
  Future allLeaveRequest() async {
    var userIdKey = await SPUtill.getIntValue(SPUtill.keyUserId);
    var userId = userID ?? userIdKey;
    var bodyLeaveRequest = BodyLeaveRequest(userId: userId,month: currentMonth);
    var apiResponse = await Repository.allLeaveRequest(bodyLeaveRequest);
    if (apiResponse.result == true) {
      leaveTypeList = apiResponse.data;
      isLoading = true;
      if (kDebugMode) {
        print(leaveTypeList?.data?.availableLeave);
      }
      notifyListeners();
    } else {

    }
  }
}