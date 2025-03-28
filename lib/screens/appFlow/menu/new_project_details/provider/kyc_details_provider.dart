import 'dart:io';

import 'package:crm_demo/custom_widgets/custom_dialog.dart';
import 'package:crm_demo/screens/appFlow/menu/clients/model/company_list_model.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/model/kyc_user_id_kyc_model.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/model/project_kyc_list_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../projects/crm_project_repository/crm_project_repository.dart'
    show CrmProjectRepository;

class KycDetailsProvider extends ChangeNotifier {
  KYCData? kycData2;

  KycDetailsProvider(KYCData? kycData) {
    print('{kycData ${kycData?.kycid}');
    kycData2 = kycData;
    print('{kycData2 ${kycData2?.kycid}');
    notifyListeners();
    getKycByKycIdList();
  }

  KYCUserIdKYCModel kYCUserIdKYCModel = KYCUserIdKYCModel();

  final clientNameController = TextEditingController();
  final clientPhoneNumberController = TextEditingController();
  final clientEmailController = TextEditingController();
  final clientPasswordController = TextEditingController();
  final clientAddressController = TextEditingController();
  final clientDescriptionController = TextEditingController();

  File? imagePath;
  CompanyData? companyData;

  Future getKycByKycIdList() async {
    final response = await CrmProjectRepository.getKycByKycIdList(
      kYCId: kycData2?.kycid ?? '',
    );

    if (response['status'] == true) {
      kYCUserIdKYCModel = KYCUserIdKYCModel.fromJson(response);
      notifyListeners();
    }
  }

  selectCompany(CompanyData? value) {
    companyData = value;
    notifyListeners();
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
