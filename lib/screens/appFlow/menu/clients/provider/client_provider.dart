import 'dart:async';

import 'package:crm_demo/data/server/respository/repository.dart';
import 'package:crm_demo/screens/appFlow/menu/clients/model/client_dashboard_model.dart';
import 'package:crm_demo/screens/appFlow/menu/clients/model/client_list_model.dart';
import 'package:crm_demo/screens/appFlow/menu/clients/model/company_list_model.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/model/admin_list_model.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' show RefreshController;

import '../crm_clinet_repository/client_repository.dart';

class CrmClientProvider extends ChangeNotifier {
  ClientDashboardModel? crmClientDashboardResponse;
  ClientListModel? crmClientListREsponse;
  List<CompanyData> companyList = [];
  AllAdminListModel allAdminListModel = AllAdminListModel();
  CompanyData? companyData;
  late RefreshController refreshController;
  Timer? timeHandle;
  String search = "";
  bool? isAdmian;

  CrmClientProvider(BuildContext context) {
    companyList.insert(0, CompanyData(companyId: 'all', companyName: 'All'));
    selectCompany(companyList.first);
    getCompanyList();
    getCrmClientDashboardData();
    getCrmClientListData(search);
    getSettingBase();
    refreshController = RefreshController(initialRefresh: true);
  }

  selectCompany(CompanyData? value) {
    companyData = value;
    notifyListeners();
    getCrmProjectAdminListData(companyId: value?.companyId ?? 'all');
    notifyListeners();
  }

  Future getCompanyList() async {
    final response = await CrmClientRepository.getCompanyList();
    if (response['status'] == true) {
      CompanyListModel companyListModel = CompanyListModel.fromJson(response);
      if (companyListModel.data != null) {
        for (var item in companyListModel.data!) {
          companyList.add(
            CompanyData(
              companyName: item.companyName,
              companyId: item.companyId,
            ),
          );
        }
      }
      notifyListeners();
    }
  }

  getCrmProjectAdminListData({required String companyId}) async {
    final response = await CrmClientRepository.getAllAdminList(
      companyId: companyId ?? 'all',
    );
    if (response['status'] == true) {
      allAdminListModel = AllAdminListModel.fromJson(response);
      refreshController.loadComplete();
      print("HELLO ");
      notifyListeners();
    } else {
      refreshController.loadNoData();
      notifyListeners();
    }
    notifyListeners();
  }

  getSettingBase() async {
    var apiResponse = await Repository.baseSettingApi();
    if (apiResponse.result == true) {
      isAdmian = apiResponse.data?.data?.isAdmin;

      notifyListeners();
    }
  }

  ///get client dashboard data
  getCrmClientDashboardData() async {
    final response = await CrmClientRepository.getCrmClientHomeData();
    if (response.httpCode == 200) {
      crmClientDashboardResponse = response.data;
      notifyListeners();
    }
    notifyListeners();
  }

  void getSearchValue(String searchCode) {
    search = searchCode;
    if (timeHandle != null) {
      timeHandle!.cancel();
    }

    timeHandle = Timer(const Duration(seconds: 1), () {
      getCrmClientListData(search);
      notifyListeners();
    });
  }

  getCrmClientListData(String? search) async {
    final response = await CrmClientRepository.getCrmClientList(
      reposearch: search,
    );
    if (response.httpCode == 200) {
      crmClientListREsponse = response.data;
      notifyListeners();
    }
    notifyListeners();
  }
}
