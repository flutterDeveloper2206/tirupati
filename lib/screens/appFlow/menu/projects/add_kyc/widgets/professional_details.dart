import 'package:crm_demo/screens/appFlow/menu/projects/add_kyc/add_kyc_provider.dart';
import 'package:crm_demo/screens/custom_widgets/add_client_textfield.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfessionalDetails extends StatelessWidget {
  final AddKycProvider provider;

  const ProfessionalDetails({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Name as per Aadhar".tr(),
          textController: provider.nameAsPerAadharController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Mobile number linked to Adhar vard *".tr(),
          textController: provider.mobileAadharController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Age".tr(),
          textController: provider.ageController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Email Id".tr(),
          textController: provider.emailController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Phone No".tr(),
          textController: provider.phoneController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Alternate Number".tr(),
          textController: provider.alternatePhoneController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Address".tr(),
          textController: provider.addressController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Pin code".tr(),
          textController: provider.pinController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "State".tr(),
          textController: provider.stateController,
        ),
      ],
    );
  }

  /// Widget to build each KYC detail section
  Widget buildKYCItem(String title, IconData? icon, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              if (icon != null)
                Icon(icon, color: Colors.blue[900]), // Show icon if available
              if (icon != null)
                SizedBox(width: 8), // Space between icon and text
              Text(
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
