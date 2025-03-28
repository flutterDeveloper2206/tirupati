import 'package:crm_demo/api_service/api_body.dart';
import 'package:crm_demo/data/model/event_holiday_model/event_holiday_model.dart'
    as holiday;
import 'package:crm_demo/data/model/response_base_settings.dart';
import 'package:crm_demo/data/model/response_meeting_list.dart';
import 'package:crm_demo/data/server/respository/appointment/appointment_repository.dart';
import 'package:crm_demo/data/server/respository/home/home_repository.dart';
import 'package:crm_demo/data/server/respository/repository.dart';
import 'package:crm_demo/screens/appFlow/home/break_time/break_time_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/appointment/appointment_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/meeting/meeting_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/support/support_ticket/support_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/visit/visit_screen.dart';
import 'package:crm_demo/utils/app_const.dart';
import 'package:crm_demo/utils/nav_utail.dart';
import 'package:crm_demo/utils/shared_preferences.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../data/model/home/crm_home_model.dart';
import '../../../data/model/home/statics_model.dart';
import 'attendeance/attendance.dart';

class HomeProvider extends ChangeNotifier {
  String? userName;
  String? userType;
  int current = 0;
  bool? isCheckIn;
  String? checkStatus;
  bool? checkIn;
  bool? checkOut;
  bool? isBreak;
  bool? isFaceRegistered;
  TimeWish? timeWish;
  String? diffTime;
  int? hour;
  int? minutes;
  int? seconds;
  String? currentDateData;
  String? attendanceMethod;
  String? fcmTopic;

  String? profileImage;

  ///statics
  List<Today>? todayData;
  List<CurrentMonth>? currentMothList;

  ///For upcoming events & Holidays
  holiday.EventHolidayModel? upcomingModel;
  List<holiday.Item>? upcomingItems;

  ///For Appointments
  ResponseMeetingList? appointmentsModel;
  List<Item>? appointmentsItems;

  ///crmHomeData
  CrmHomeModel? crmResponseData;

  HomeProvider(BuildContext context) {
    currentDate();
    getUserData();
    checkInCheckOutStatus(context);
    getCrmHomeData();
    getUserData();
  }

  currentDate() async {
    DateTime now = DateTime.now();
    currentDateData = DateFormat('y-MM-d').format(now);
    profileImage = await SPUtill.getValue(SPUtill.keyProfileImage);
  }

  getRoutSlag(context, String? name) {
    switch (name) {
      case 'appointment':
        return NavUtil.navigateScreen(context, const AppointmentScreen());
      case 'meeting':
        return NavUtil.navigateScreen(context, const MeetingScreen());
      case 'visit':
        return NavUtil.navigateScreen(context, const VisitScreen());
      case 'birthday':
        return Fluttertoast.showToast(
          msg: 'Under Development',
          toastLength: Toast.LENGTH_SHORT,
        );
      case 'task':
        return Fluttertoast.showToast(
          msg: 'Under Development',
          toastLength: Toast.LENGTH_SHORT,
        );
      case 'support_ticket':
        return NavUtil.navigateScreen(context, const SupportScreen());
      default:
        return debugPrint('default');
    }
  }

  getSettingBase(CustomTimerController customTimerController, context) async {
    var apiResponse = await Repository.baseSettingApi();
    if (apiResponse.result == true) {
      ///check user register their face or not
      ///if not then go to face register page
      attendanceMethod = apiResponse.data?.data?.attendanceMethod;
      isFaceRegistered = apiResponse.data?.data?.isFaceRegistered;
      timeWish = apiResponse.data?.data?.timeWish;
      String? endPointKey = apiResponse.data?.data?.barikoiAPI?.endPoint;
      String? barikoiApiKey = apiResponse.data?.data?.barikoiAPI?.key;
      AppConst.endPoint = endPointKey;
      AppConst.bariKoiApiKey = barikoiApiKey;

      fcmTopic = apiResponse.data?.data?.fcmTopic;

      /// initial Firebase for topic notification
      await FirebaseMessaging.instance.subscribeToTopic('$fcmTopic');

      if (apiResponse.data?.data?.breakStatus?.diffTime != null) {
        diffTime = apiResponse.data!.data!.breakStatus!.diffTime!;
      }
      if (diffTime!.isNotEmpty) {
        var str = diffTime;
        var parts = str?.split(':');
        hour = int.parse(parts![0].trim());
        minutes = int.parse(parts[1].trim());
        seconds = int.parse(parts[2].trim());
        NavUtil.navigateScreen(
          context,
          BreakTime(
            diffTimeHome: diffTime,
            hourHome: hour,
            minutesHome: minutes,
            secondsHome: seconds,
          ),
        );
      }
      notifyListeners();
    }
  }

  void getAttendanceMethod(context) {
    switch (attendanceMethod) {
      case 'FR':
        break;
      case 'QR':
        Fluttertoast.showToast(msg: 'QR attendance under premium policy');
        break;
      case 'N':
        NavUtil.navigateScreen(
          context,
          const Attendance(navigationMenu: false),
        );
        break;
      default:
        NavUtil.navigateScreen(
          context,
          const Attendance(navigationMenu: false),
        );
        break;
    }
  }

  getSlider(index) {
    current = index;
    notifyListeners();
  }

  void getUserData() async {
    userName = await SPUtill.getValue(SPUtill.userName);
    userType = await SPUtill.getValue(SPUtill.userType);
    print('userName --> $userName');
    print('userType --> $userType');
    notifyListeners();
  }

  checkInCheckOutStatus(context) async {
    var userId = await SPUtill.getIntValue(SPUtill.keyUserId);
    var bodyUserId = BodyUserId(userId: userId);
    var apiResponse = await Repository.attendanceStatus(bodyUserId);
    if (apiResponse.result == true) {
      checkIn = apiResponse.data?.data?.checkin;
      checkOut = apiResponse.data?.data?.checkout;
      if (checkIn == false && checkOut == false) {
        checkStatus = "Check In";
        notifyListeners();
      } else if (checkIn == true && checkOut == true) {
        checkStatus = "Check In";
        notifyListeners();
      } else if (checkIn == true && checkOut == false) {
        checkStatus = "Check Out";
        notifyListeners();
      }
      checkInOutVisibility(context);
    }
  }

  Future checkInOutVisibility(context) async {
    if (checkIn == true && checkOut == true) {
      isCheckIn = false;
    } else {
      isCheckIn = true;
    }

    if (checkIn == true && checkOut == false) {
      isBreak = true;
    } else {
      isBreak = false;
    }

    notifyListeners();
  }

  ///get crm home screen data
  getCrmHomeData() async {
    final response = await HomeRepository.getCrmHomeData();
    if (response.httpCode == 200) {
      crmResponseData = response.data;
      notifyListeners();
    }
    notifyListeners();
  }

  /// Get all statics data from here
  getStaticsList() async {
    final response = await HomeRepository.getAllStatics();
    if (response.httpCode == 200) {
      todayData = response.data?.data?.today;
      currentMothList = response.data?.data?.currentMonth;
      notifyListeners();
    }
    notifyListeners();
  }

  ///Get all upcoming events and HOLIDAY data list from here
  getUpcomingEvents() async {
    final response = await HomeRepository.getUpcomingEvents();
    upcomingModel = response.data;
    upcomingItems = upcomingModel?.data?.items;
    notifyListeners();
  }

  ///Get all APPOINTMENT data list from here
  getAppointments() async {
    final response = await AppointmentRepository.postAppointmentList('');
    appointmentsModel = response.data;
    appointmentsItems = appointmentsModel?.data?.items;
    notifyListeners();
  }
}
