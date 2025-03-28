import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crm_demo/screens/appFlow/menu/projects/crm_project_repository/crm_project_repository.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/model/project_kyc_list_model.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/model/project_list_model.dart';
import 'package:crm_demo/utils/app_const.dart' show AppConst;
import 'package:crm_demo/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'
    show ImagePicker, ImageSource, XFile;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AddKycProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int currentIndex = 0;
  ProjectListModel? crmProjectListResponse;
  Timer? timeHnadle;
  String search = "";
  int page = 4;
  bool isError = false;
  late RefreshController refreshController;
  ProjectKYCListModel projectKYCListModel = ProjectKYCListModel();
  final searchController = TextEditingController();
  final nameController = TextEditingController();
  final aadharcardController = TextEditingController();
  final fatherNameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final alternatePhoneController = TextEditingController();
  final addressController = TextEditingController();
  final pinController = TextEditingController();
  final stateController = TextEditingController();

  ///step 2
  final nameAsPerAadharController = TextEditingController();
  final mobileAadharController = TextEditingController();
  final companyNameController = TextEditingController();
  final departmentController = TextEditingController();
  final designationController = TextEditingController();
  final aasharNameController = TextEditingController();
  final panNameController = TextEditingController();
  final uanController = TextEditingController();
  final esicNameController = TextEditingController();

  ///Step 3
  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscCodeController = TextEditingController();

  Gender? selectedGender;
  MaritalStatus? selectedMaritalStatus;
  Education? selectedEducation;

  List<Gender> genderList = [
    Gender(genderId: '1', gender: 'Male'),
    Gender(genderId: '2', gender: 'Female'),
  ];

  List<Education> educationList = [
    Education(educationId: 1, educationName: 'Class X'),
    Education(educationId: 2, educationName: 'Class XII'),
    Education(educationId: 3, educationName: 'Graduate'),
    Education(educationId: 4, educationName: 'Post Graduate'),
  ];

  List<MaritalStatus> maritalStatusList = [
    MaritalStatus(maritalStatusId: '1', maritalStatus: 'Married'),
    MaritalStatus(maritalStatusId: '2', maritalStatus: 'Single'),
  ];

  AddKycProvider() {
    refreshController = RefreshController(initialRefresh: true);
  }

  void nextPage() {
    if (formKey.currentState!.validate() || true) {
      if (currentIndex < 3) {
        currentIndex++;
        pageController.animateToPage(
          currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        notifyListeners();
      }
    } else {
      submitForm();
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

  Future submitForm() async {
    var userId = await SPUtill.getIntValue(SPUtill.keyUserId);
    if (formKey.currentState!.validate()) {
      print(
        "Submitting: Name: ${nameController.text}, Gender: $selectedGender, Address: ${addressController.text}",
      );
      List<int> imageBytes = selectedImage!.readAsBytesSync();
      String base64Image = "data:image/png;base64,${base64Encode(imageBytes)}";
      var body = {
        "request": "addKyc",
        "header": AppConst.header,
        "data": {
          "userid": userId,
          "conpany_id": "1",
          "name": nameController.text,
          "dob": "11-01-1991",
          "email": emailController.text,
          "mobile": phoneController.text,
          "address": addressController.text,
          "pincode": pinController.text,
          "state": stateController.text,
          "bank_name": bankNameController.text,
          "account_number": accountNumberController.text,
          "ifsc": ifscCodeController.text,
          "education_id": selectedEducation?.educationId,
          "adhar": aadharcardController.text,
          "pancard": panNameController.text,
          "uan": uanController.text,
          "esicName": esicNameController.text,
          "new_company_name": companyNameController.text,
          "title": "1",
          "father_name": fatherNameController.text,
          "marital_status": selectedMaritalStatus?.maritalStatusId,
          "gender": selectedGender?.genderId,
          "name_as_adhar": nameAsPerAadharController.text,
          "mobile_adhar_linked": mobileAadharController.text,
          "alternate_mobile": alternatePhoneController.text,
          "department": departmentController.text,
          "designation": designationController.text,
          "doj": "04-03-2025",
          "date_of_exit": "",
          "remarks": "remarks",
          "member_photo": base64Image,
        },
      };

      final response = await CrmProjectRepository.addKycForm(body: body);
      if (response['status'] == true) {
        refreshController.loadComplete();
        print("HELLO ");
        notifyListeners();
      } else {
        refreshController.loadNoData();
        notifyListeners();
      }
      notifyListeners();
    }
  }

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  // 📸 Pick Image (Gallery or Camera)
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      print("Error picking image: $e");
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

  selectEducation(Education? value) {
    selectedEducation = value;
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

class Education {
  final int educationId;
  final String educationName;

  Education({required this.educationId, required this.educationName});
}
