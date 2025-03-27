import 'package:flutter/foundation.dart';
import 'package:crm_demo/data/model/response_meeting_details.dart';
import 'package:crm_demo/data/server/respository/repository.dart';

class MeetingDetailsProvider extends ChangeNotifier{
  int? id;
  ResponseMeetingDetails? meetingDetails;

  MeetingDetailsProvider(int? id){
    getMeetingDetailsApi(id);
  }

  Future getMeetingDetailsApi(meetingId) async{
    if (kDebugMode) {
      print('meeting ID $meetingId' );
    }
    final response = await Repository.getMeetingDetails(meetingId);
    meetingDetails = response.data;
    notifyListeners();
  }
}