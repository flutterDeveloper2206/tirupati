import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crm_demo/main.dart';
import 'package:crm_demo/screens/appFlow/menu/clients/model/company_list_model.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/crm_project_repository/crm_project_repository.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/model/project_kyc_list_model.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/model/project_list_model.dart';
import 'package:crm_demo/utils/app_const.dart' show AppConst;
import 'package:crm_demo/utils/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart' show EasyLoading;
import 'package:fluttertoast/fluttertoast.dart' show Fluttertoast;
import 'package:http/http.dart' as http;
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
  final dateOfBirthController = TextEditingController();
  final dateOfJoiningController = TextEditingController();
  final dateOfExitController = TextEditingController();
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

  String photoImage = '';
  Gender? selectedGender;
  MaritalStatus? selectedMaritalStatus;
  Education? selectedEducation;

  List<Gender> genderList = [
    Gender(genderId: '1', gender: 'Male'),
    Gender(genderId: '2', gender: 'Female'),
  ];

  List<Education> educationList = [
    Education(educationId: '1', educationName: 'Class X'),
    Education(educationId: '2', educationName: 'Class XII'),
    Education(educationId: '3', educationName: 'Graduate'),
    Education(educationId: '4', educationName: 'Post Graduate'),
  ];

  List<MaritalStatus> maritalStatusList = [
    MaritalStatus(maritalStatusId: '1', maritalStatus: 'Married'),
    MaritalStatus(maritalStatusId: '2', maritalStatus: 'Single'),
  ];

  AddKycProvider() {
    getCompanyList();
    refreshController = RefreshController(initialRefresh: true);
  }

  void initializeKycData(KYCData kycData) {
    nameController.text = kycData.name ?? '';
    fatherNameController.text = kycData.fatherName ?? '';
    dateOfBirthController.text = kycData.dateOfExit ?? '';
    emailController.text = kycData.email ?? '';
    phoneController.text = kycData.mobile ?? '';
    alternatePhoneController.text = kycData.alternateMobile ?? '';
    addressController.text = kycData.address ?? '';
    pinController.text = kycData.pincode ?? '';
    stateController.text = kycData.state ?? '';
    nameAsPerAadharController.text = kycData.nameAsAdhar ?? '';
    mobileAadharController.text = kycData.mobileAdharLinked ?? '';
    companyNameController.text = kycData.newCompanyName ?? '';
    departmentController.text = kycData.department ?? '';
    designationController.text = kycData.designation ?? '';
    dateOfJoiningController.text = kycData.doj ?? '';
    dateOfExitController.text = kycData.dateOfExit ?? '';
    aadharcardController.text = kycData.adhar ?? '';
    aasharNameController.text = kycData.nameAsAdhar ?? '';
    panNameController.text = kycData.pancard ?? '';
    uanController.text = kycData.uan ?? '';
    esicNameController.text = kycData.esicName ?? '';
    bankNameController.text = kycData.bankName ?? '';
    accountNumberController.text = kycData.accountNumber ?? '';
    ifscCodeController.text = kycData.ifsc ?? '';
    photoImage = kycData.memberPhoto ?? '';
    if (dateOfBirthController.text.isNotEmpty) {
      ageController.text =
          "${calculateAge(DateFormat("dd-MM-yyyy").parse(dateOfBirthController.text))}";
    }

    if (genderList.isNotEmpty) {
      for (var item in genderList) {
        if (kycData.gender == item.genderId) {
          selectGender(item);
        }
      }
    }
    if (maritalStatusList.isNotEmpty) {
      for (var item in maritalStatusList) {
        if (kycData!.maritalStatus == item.maritalStatusId) {
          selectMaritalStatus(item);
        }
      }
    }
    if (companyList.isNotEmpty) {
      for (var item in companyList) {
        if (kycData!.companyId == item.companyId) {
          selectCompany(item);
        }
      }
    }
    if (educationList.isNotEmpty) {
      for (var item in educationList) {
        print('kycData!.educationId --> ${kycData!.educationId}');
        print('item.educationId --> ${item.educationId}');

        if (kycData!.educationId == item.educationId) {
          print('item.educationId --> true');
          selectEducation(item);
          break;
        }
      }
    }

    notifyListeners();
  }

  void nextPage(bool isUpdate, String kycId) {
    if (formKey.currentState!.validate()) {
      if (currentIndex < 3) {
        currentIndex++;
        pageController.animateToPage(
          currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        notifyListeners();
      } else if (currentIndex == 3) {
        submitForm(isUpdate, kycId);
      } else {
        ///
      }
    } else {
      ///
    }
  }

  Future<String> convertImageUrlToBase64(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Convert image bytes to Base64
        String base64String = base64Encode(response.bodyBytes);
        return base64String;
      } else {
        print("Failed to load image: ${response.statusCode}");
        return "";
      }
    } catch (e) {
      print("Error: $e");
      return "";
    }
  }

  List<CompanyData> companyList = [];

  CompanyData? companyData;

  selectCompany(CompanyData? value) {
    companyData = value;
    notifyListeners();
    getCrmProjectKYCListData(companyId: value?.companyId ?? 'all');
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

  Future submitForm(bool isUpdate, String kycId) async {
    var userId = await SPUtill.getIntValue(SPUtill.keyUserId);
    if (formKey.currentState!.validate()) {
      EasyLoading.show(status: 'loading...');
      String base64Image = '';
      if (selectedImage != null) {
        List<int> imageBytes = selectedImage!.readAsBytesSync();
        base64Image = "data:image/png;base64,${base64Encode(imageBytes)}";
      } else {
        base64Image = await convertImageUrlToBase64(photoImage);
      }
      print("isUpdate --> $isUpdate");
      var body = {
        "request": isUpdate ? "updateKyc" : "addKyc",
        "header": AppConst.header,
        "data":
            isUpdate
                ? {
                  "kycid": int.parse(kycId),
                  "userid": userId,
                  "conpany_id": companyData?.companyId ?? '',
                  "name": nameController.text,
                  "dob": dateOfBirthController.text,
                  "email": emailController.text,
                  "mobile": phoneController.text,
                  "address": addressController.text,
                  "pincode": pinController.text,
                  "state": stateController.text,
                  "bank_name": bankNameController.text,
                  "account_number": accountNumberController.text,
                  "ifsc": ifscCodeController.text,
                  "education_id": int.parse(
                    selectedEducation?.educationId ?? '',
                  ),
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
                  "doj": dateOfJoiningController.text,
                  "date_of_exit": dateOfExitController.text,
                  "remarks": "remarks",
                  "member_photo": base64Image,
                }
                : {
                  "userid": userId,
                  "conpany_id": companyData?.companyId ?? '',
                  "name": nameController.text,
                  "dob": dateOfBirthController.text,
                  "email": emailController.text,
                  "mobile": phoneController.text,
                  "address": addressController.text,
                  "pincode": pinController.text,
                  "state": stateController.text,
                  "bank_name": bankNameController.text,
                  "account_number": accountNumberController.text,
                  "ifsc": ifscCodeController.text,
                  "education_id": int.parse(
                    selectedEducation?.educationId ?? '',
                  ),
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
                  "doj": dateOfJoiningController.text,
                  "date_of_exit": dateOfExitController.text,
                  "remarks": "remarks",
                  "member_photo": base64Image,
                },
      };

      final response = await CrmProjectRepository.addKycForm(
        body: body,
        endPoints: isUpdate ? "/Welcome/updateKyc" : "/Welcome/addKyc",
      );
      EasyLoading.dismiss();
      if (response['status'] == true) {
        refreshController.loadComplete();
        Navigator.pop(navigatorKey.currentContext!);
        if (isUpdate) {
          Navigator.pop(navigatorKey.currentContext!);
        }
        Fluttertoast.showToast(msg: response['msg']);
        notifyListeners();
      } else if (response['status'] == false) {
        Fluttertoast.showToast(msg: response['msg']);
        notifyListeners();
      } else {
        EasyLoading.dismiss();
        refreshController.loadNoData();
        notifyListeners();
      }
      notifyListeners();
      EasyLoading.dismiss();
    }
  }

  DateTime joiningDate = DateTime.now();

  DateTime birthDate = DateTime.now();

  DateTime exitDate = DateTime.now();

  void updateBirthDate(DateTime newDate) {
    birthDate = newDate;
    dateOfBirthController.text = DateFormat('dd-MM-yyyy').format(birthDate);
    ageController.text = "${calculateAge(birthDate)}";
    notifyListeners();
  }

  void updateJoiningDate(DateTime newDate) {
    joiningDate = newDate;
    dateOfJoiningController.text = DateFormat('dd-MM-yyyy').format(joiningDate);
    notifyListeners();
  }

  void updateExitDate(DateTime newDate) {
    exitDate = newDate;
    dateOfExitController.text = DateFormat('dd-MM-yyyy').format(exitDate);
    notifyListeners();
  }

  int calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int age = today.year - dob.year;

    // Adjust if the birthday hasn't occurred yet this year
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }

    return age;
  }

  File? selectedImage;
  String? selectedImageUrl;
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

  Future<DateTime?> selectDate(
    BuildContext context,
    DateTime initialDate,
  ) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
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
  final String educationId;
  final String educationName;

  Education({required this.educationId, required this.educationName});
}
