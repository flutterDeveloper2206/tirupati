import 'dart:async';

import 'package:crm_demo/screens/appFlow/menu/projects/crm_project_repository/crm_project_repository.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/model/project_kyc_list_model.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/model/project_list_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AddKycProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int currentIndex = 0;
  ProjectListModel? crmProjectListResponse;
  Timer? timeHnadle;
  String search = "";
  int page = 1;
  bool isError = false;
  late RefreshController refreshController;
  ProjectKYCListModel projectKYCListModel = ProjectKYCListModel();
  final searchController = TextEditingController();
  final nameController = TextEditingController();
  final nameAsPerAadharController = TextEditingController();
  final fatherNameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final alternatePhoneController = TextEditingController();
  final addressController = TextEditingController();
  final pinController = TextEditingController();
  final stateController = TextEditingController();

  ///step 2
  final mobileAadharController = TextEditingController();
  Gender? selectedGender;
  MaritalStatus? selectedMaritalStatus;

  List<Gender> genderList = [
    Gender(genderId: '1', gender: 'Male'),
    Gender(genderId: '2', gender: 'Female'),
  ];

  List<MaritalStatus> maritalStatusList = [
    MaritalStatus(maritalStatusId: '1', maritalStatus: 'Married'),
    MaritalStatus(maritalStatusId: '2', maritalStatus: 'Single'),
  ];

  AddKycProvider() {
    refreshController = RefreshController(initialRefresh: true);
  }

  void nextPage() {
    if (formKey.currentState!.validate()) {
      if (currentIndex < 1) {
        currentIndex++;
        pageController.animateToPage(
          currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        notifyListeners();
      }
    } else {
      /*submitForm();*/
    }
  }

  void previousPage() {
    if (currentIndex > 0) {
      currentIndex--;
      pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      // Form is valid, submit the data
      print(
        "Submitting: Name: ${nameController.text}, Gender: $selectedGender, Address: ${addressController.text}",
      );
    }
  }

  selectGender(Gender? value) {
    selectedGender = value;
    notifyListeners();
  }

  selectMaritalStatus(MaritalStatus? value) {
    selectedMaritalStatus = value;
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
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Project> item) {
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

class Gender {
  final String genderId;
  final String gender;

  Gender({required this.genderId, required this.gender});
}

class MaritalStatus {
  final String maritalStatusId;
  final String maritalStatus;

  MaritalStatus({required this.maritalStatusId, required this.maritalStatus});
}
