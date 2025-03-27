import 'dart:convert';
import 'dart:io';
import 'package:crm_demo/screens/appFlow/menu/clients/model/company_list_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crm_demo/custom_widgets/custom_dialog.dart';
import 'package:crm_demo/screens/appFlow/navigation_bar/buttom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/nav_utail.dart';
import '../crm_clinet_repository/client_repository.dart';

class AddClientProvider extends ChangeNotifier {
  AddClientProvider() {
    getCompanyList();
  }

  final clientNameController = TextEditingController();
  final clientPhoneNumberController = TextEditingController();
  final clientEmailController = TextEditingController();
  final clientPasswordController = TextEditingController();
  final clientAddressController = TextEditingController();
  final clientDescriptionController = TextEditingController();

  File? imagePath;
  CompanyData? companyData;

  CompanyListModel companyListModel = CompanyListModel();

  Future addClient(BuildContext context) async {
    /*if (imagePath == null) {
      Fluttertoast.showToast(msg: "You must add an Image");
      return;
    }*/

    if (companyData == null) {
      Fluttertoast.showToast(msg: 'Select your Company');
      return;
    }

    /*String fileName = imagePath!.path.split('/').last;*/

    final data = FormData.fromMap({
      "request": "createNewUser",
      "header": "5171a28f0ea95d2b2feb104fef8cc19d",
      "data": jsonEncode({   // ✅ Ensure nested object is JSON encoded
        "conpany_id": int.parse(companyData?.companyId ?? '0'),
        "user_name": clientNameController.text,
        "email_id": clientEmailController.text,
        "mobile": clientPhoneNumberController.text,
        "password": clientPasswordController.text,
        "address": clientAddressController.text,
      }),
      /*"avatar": await MultipartFile.fromFile(imagePath!.path, filename: fileName),*/
    });

    final response = await CrmClientRepository.addClient(data);

    if (response['status'] == true) {
      NavUtil.pushAndRemoveUntil(context, const ButtomNavigationBar());
      notifyListeners();
    }
  }


  selectCompany(CompanyData? value) {
    companyData = value;
    notifyListeners();
  }

  Future getCompanyList() async {
    final response = await CrmClientRepository.getCompanyList();
    if (response['status'] == true) {
      companyListModel = CompanyListModel.fromJson(
        response,
      ); /*companyListModelFromJson(jsonDecode(response))*/
      notifyListeners();
    }
  }

  ///Pick image from Camera and Gallery
  Future<dynamic> pickImage(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogImagePicker(
          onCameraClick: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(
              source: ImageSource.camera,
              maxHeight: 300.h,
              maxWidth: 300.w,
              imageQuality: 90,
            );
            imagePath = File(image!.path);
            notifyListeners();
            if (kDebugMode) {
              print(File(image.path));
            }
          },
          onGalleryClick: () async {
            final ImagePicker pickerGallery = ImagePicker();
            final XFile? imageGallery = await pickerGallery.pickImage(
              source: ImageSource.gallery,
              maxHeight: 300.h,
              maxWidth: 300.w,
              imageQuality: 90,
            );
            imagePath = File(imageGallery!.path);
            if (kDebugMode) {
              print(File(imageGallery.path));
            }
            notifyListeners();
          },
        );
      },
    );
    notifyListeners();
  }
}
