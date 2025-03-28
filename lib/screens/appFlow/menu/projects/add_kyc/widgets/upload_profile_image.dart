import 'package:crm_demo/screens/appFlow/menu/projects/add_kyc/add_kyc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UploadProfileImage extends StatelessWidget {
  final AddKycProvider provider;

  const UploadProfileImage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 16.h),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Upload Profile Image",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16.h),

        provider.selectedImage != null
            ? CircleAvatar(
              radius: 50,
              backgroundImage: FileImage(provider.selectedImage!),
            )
            : CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, size: 50),
            ),

        SizedBox(height: 16.h),

        // 📷 Open Dialog Button
        ElevatedButton.icon(
          onPressed: () => showImagePickerDialog(context, provider),
          icon: Icon(Icons.upload),
          label: Text("Upload Image"),
        ),
        /* AddClientTextField(
          hintText: "Bank Name *".tr(),
          textController: provider.bankNameController,
        ),
        SizedBox(height: 16.h),

        AddClientTextField(
          hintText: "Account Number *".tr(),
          textController: provider.accountNumberController,
        ),

        SizedBox(height: 16.h),
        AddClientTextField(
          hintText: "IFSC Code *".tr(),
          textController: provider.ifscCodeController,
        ),*/
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

  void showImagePickerDialog(BuildContext context, AddKycProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
                onTap: () {
                  provider.pickImage(ImageSource.camera);
                  Navigator.pop(context); // Close the dialog
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Gallery"),
                onTap: () {
                  provider.pickImage(ImageSource.gallery);
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
