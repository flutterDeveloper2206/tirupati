import 'package:crm_demo/api_service/connectivity/no_internet_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/add_kyc/add_kyc_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/add_kyc/widgets/bank_details.dart'
    show BankDetails;
import 'package:crm_demo/screens/appFlow/menu/projects/add_kyc/widgets/personal_details.dart'
    show PersonalDetails;
import 'package:crm_demo/screens/appFlow/menu/projects/add_kyc/widgets/professional_details.dart'
    show ProfessionalDetails;
import 'package:crm_demo/screens/appFlow/menu/projects/add_kyc/widgets/upload_profile_image.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/model/project_kyc_list_model.dart';
import 'package:crm_demo/screens/custom_widgets/custom_title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddKycFrom extends StatelessWidget {
  final KYCData? kycData;

  const AddKycFrom({super.key, this.kycData});

  @override
  Widget build(BuildContext context) {
    return NoInternetScreen(
      child: ChangeNotifierProvider(
        create: (context) {
          final provider = AddKycProvider();
          if (kycData != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.initializeKycData(kycData!);
            });
          }
          return provider;
        },
        child: Consumer<AddKycProvider>(
          builder: (context, provider, _) {
            return Scaffold(
              backgroundColor: const Color(0xffF5F6FA),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(56.h),
                child: CustomTitleAppBar(
                  title: kycData != null ? "Update KYC" : "Add KYC",
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: provider.formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: provider.pageController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            PersonalDetails(provider: provider),
                            ProfessionalDetails(provider: provider),
                            BankDetails(provider: provider),
                            UploadProfileImage(provider: provider),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (provider.currentIndex > 0)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: provider.previousPage,
                                  child: Text("Back"),
                                ),
                              ),
                            if (provider.currentIndex > 0) SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  provider.nextPage(
                                    kycData != null,
                                    kycData?.kycid ?? "",
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  provider.currentIndex == 3
                                      ? kycData != null
                                          ? "Update"
                                          : "Submit"
                                      : "Next",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
