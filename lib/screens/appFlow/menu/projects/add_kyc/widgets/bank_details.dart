import 'package:crm_demo/screens/appFlow/menu/projects/add_kyc/add_kyc_provider.dart';
import 'package:crm_demo/screens/custom_widgets/add_client_textfield.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BankDetails extends StatelessWidget {
  final AddKycProvider provider;

  const BankDetails({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 16.h),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Bank Information",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Bank Name *".tr(),
          textController: provider.bankNameController,
        ),
        SizedBox(height: 16.h),

        AddClientTextField(
          hintText: "Account Number *".tr(),
          keyboardType: TextInputType.phone,
          textController: provider.accountNumberController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "IFSC Code *".tr(),
          textController: provider.ifscCodeController,
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
