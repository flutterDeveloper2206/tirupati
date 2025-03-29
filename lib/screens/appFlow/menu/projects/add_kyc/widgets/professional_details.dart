import 'package:crm_demo/screens/appFlow/menu/clients/model/company_list_model.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/add_kyc/add_kyc_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/sales/product/content/custom_dropdown.dart';
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
        Align(
          alignment: Alignment.center,
          child: Text(
            "Professional Information",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Name as per Aadhar".tr(),
          textController: provider.nameAsPerAadharController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Mobile number linked to Adhar vard *".tr(),
          keyboardType: TextInputType.phone,
          textController: provider.mobileAadharController,
        ),

        SizedBox(height: 16.h),
        /* const LavelText(text: "Education * "),
        SizedBox(height: 10.h),*/
        CustomDropdown<Education>(
          value: provider.selectedEducation,
          labelText: 'Select your Education ',
          items: provider.educationList,
          onChanged: (Education? newValue) {
            provider.selectEducation(newValue!);
          },
          itemLabelBuilder: (Education value) => value.educationName ?? '',
        ),

        SizedBox(height: 10.h),
        CustomDropdown<CompanyData>(
          value: provider.companyData,
          labelText: 'Select Company ',
          items: provider.companyList ?? [],
          onChanged: (CompanyData? newValue) {
            provider.selectCompany(newValue!);
          },
          itemLabelBuilder: (CompanyData value) => value.companyName ?? '',
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "New Company Name".tr(),
          textController: provider.companyNameController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Department".tr(),
          textController: provider.departmentController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Designation".tr(),
          textController: provider.designationController,
        ),

        SizedBox(height: 16.h),
        InkWell(
          onTap: () async {
            DateTime? pickedDate = await provider.selectDate(
              context,
              provider.joiningDate,
            );
            if (pickedDate != null) {
              provider.updateJoiningDate(pickedDate);
            }
          },
          child: AddClientTextField(
            hintText: "Date of Joining".tr(),
            enabled: false,
            textController: provider.dateOfJoiningController,
          ),
        ),

        SizedBox(height: 16.h),
        InkWell(
          onTap: () async {
            DateTime? pickedDate = await provider.selectDate(
              context,
              provider.exitDate,
            );
            if (pickedDate != null) {
              provider.updateExitDate(pickedDate);
            }
          },
          child: AddClientTextField(
            hintText: "Date of Exit".tr(),
            enabled: false,
            textController: provider.dateOfExitController,
          ),
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Aadhar card Number".tr(),
          keyboardType: TextInputType.phone,
          validatorFun: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter Aadhar Card Number";
            }
            if (!RegExp(r"^[2-9]{1}[0-9]{11}$").hasMatch(value)) {
              return "Enter a valid 12-digit Aadhar Number";
            }
            return null;
          },
          textController: provider.aadharcardController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Aadhar card name".tr(),
          textController: provider.aasharNameController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Pan card Number".tr(),
          validatorFun: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter PAN Card Number";
            }
            if (!RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]$").hasMatch(value)) {
              return "Enter a valid PAN Number (e.g., ABCDE1234F)";
            }
            return null;
          },
          textController: provider.panNameController,
        ),

        /*

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "Pan card name".tr(),
          textController: provider.panNameController,
        ),*/
        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "UAN Name".tr(),
          textController: provider.uanController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "ESIC Name".tr(),
          textController: provider.esicNameController,
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
