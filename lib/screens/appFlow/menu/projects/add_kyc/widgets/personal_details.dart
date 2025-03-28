import 'package:crm_demo/screens/appFlow/menu/projects/add_kyc/add_kyc_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/sales/product/content/custom_dropdown.dart';
import 'package:crm_demo/screens/custom_widgets/add_client_textfield.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalDetails extends StatelessWidget {
  final AddKycProvider provider;

  const PersonalDetails({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 16.h),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Personal Information",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Name".tr(),
          textController: provider.nameController,
        ),
        SizedBox(height: 16.h),
        /* const LavelText(text: "Gender * "),
        SizedBox(height: 10.h),*/
        CustomDropdown<Gender>(
          value: provider.selectedGender,
          labelText: 'Select your gender ',
          items: provider.genderList,
          onChanged: (Gender? newValue) {
            provider.selectGender(newValue!);
          },
          itemLabelBuilder: (Gender value) => value.gender ?? '',
        ),
        SizedBox(height: 16.h),
        /*const LavelText(text: "Marital Status * "),
        SizedBox(height: 10.h),*/
        CustomDropdown<MaritalStatus>(
          value: provider.selectedMaritalStatus,
          labelText: 'Select your Marital Status ',
          items: provider.maritalStatusList,
          onChanged: (MaritalStatus? newValue) {
            provider.selectMaritalStatus(newValue!);
          },
          itemLabelBuilder: (MaritalStatus value) => value.maritalStatus ?? '',
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Father Name/ Husband Name".tr(),
          textController: provider.fatherNameController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Age".tr(),
          textController: provider.ageController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Email Id".tr(),
          validatorFun: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter your email";
            } else if (!RegExp(
              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
            ).hasMatch(value)) {
              return "Enter a valid email (e.g. user@example.com)";
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          textController: provider.emailController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          keyboardType: TextInputType.phone,
          hintText: "Phone No".tr(),
          textController: provider.phoneController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Alternate Number".tr(),
          keyboardType: TextInputType.phone,
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
          keyboardType: TextInputType.phone,
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
