import 'package:flutter/cupertino.dart';
import 'package:crm_demo/data/model/crm_leads/lead_activity_list_model.dart';
import 'package:crm_demo/data/server/respository/crm_leads_repositoy/crm_leads_repository.dart';

class LeadActivityProvider extends ChangeNotifier {

  LeadActivityListModel? leadActivityListResponse;

  LeadActivityProvider(int leadId){
    getLeadActivityList(leadId);
  }

  getLeadActivityList(int leadId) async {
    final response = await CrmLeadsRepository.getLeadsActivityList(leadId);
    if(response.result == true){
      leadActivityListResponse = response.data;
      notifyListeners();
    }
    notifyListeners();
  }

}