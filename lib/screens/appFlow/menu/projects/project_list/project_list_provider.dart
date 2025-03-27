import 'dart:async';

import 'package:crm_demo/screens/appFlow/menu/clients/model/company_list_model.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/crm_project_repository/crm_project_repository.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/model/project_kyc_list_model.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/model/project_list_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CrmProjectListProvider extends ChangeNotifier {
  ProjectListModel? crmProjectListResponse;
  Timer? timeHnadle;
  String search = "";
  int page = 1;
  bool isError = false;
  late RefreshController refreshController;
  ProjectKYCListModel projectKYCListModel = ProjectKYCListModel();
  List<CompanyData> companyList = [];
  final searchController = TextEditingController();
  CompanyData? companyData;
  List<Project> listOfProjects = <Project>[];

  CrmProjectListProvider() {
    companyList.insert(0, CompanyData(companyId: 'all', companyName: 'All'));
    selectCompany(companyList.first);
    getCompanyList();
    refreshController = RefreshController(initialRefresh: true);
  }

  selectCompany(CompanyData? value) {
    companyData = value;
    notifyListeners();
    getCrmProjectKYCListData(companyId: value?.companyId ?? 'all');
    notifyListeners();
  }

  loadItems() {
    refreshController.requestRefresh();
    searchController.clear();
    search = '';
    page = 1;
    // getCrmProjectListData();
    notifyListeners();
  }

  loadMoreItems() {
    page = page + 1;

    notifyListeners();
  }

  void setItems(List<Project> item) {
    listOfProjects.clear();
    listOfProjects = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Project> item) {
    listOfProjects.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  void getSearchValue(String searchCode) {
    search = searchCode;
    if (timeHnadle != null) {
      timeHnadle!.cancel();
    }
    timeHnadle = Timer(const Duration(seconds: 1), () {
      // getCrmProjectListData();
    });
  }

  getCrmProjectKYCListData({required String companyId}) async {
    final response = await CrmProjectRepository.getKYCList(
      companyId: companyId ?? 'all',
    );
    if (response['status'] == true) {
      projectKYCListModel = ProjectKYCListModel.fromJson(response);
      refreshController.loadComplete();
      print("HELLO ");
      notifyListeners();
    } else {
      refreshController.loadNoData();
      notifyListeners();
    }
    notifyListeners();
  }

  Future getCompanyList() async {
    final response = await CrmProjectRepository.getCompanyList();
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

  ///get projectList Data
  getCrmProjectListData() async {
    final response = await CrmProjectRepository.getCrmProjectListData(
      search,
      page,
    );

    if (response.httpCode == 200) {
      if (response.data?.data?.data?.projects?.isNotEmpty == true) {
        if (page == 1) {
          setItems(response.data!.data!.data!.projects!);
          refreshController.loadComplete();
          notifyListeners();
        } else {
          setMoreItems(response.data!.data!.data!.projects!);
          notifyListeners();
        }
      } else {
        refreshController.loadNoData();
        notifyListeners();
      }
    } else {
      setFetchError();
    }
    notifyListeners();
  }

  setFetchError() {
    if (page == 0) {
      isError = true;
      refreshController.refreshFailed();
      notifyListeners();
    } else {
      refreshController.loadFailed();
      notifyListeners();
    }
  }
}
