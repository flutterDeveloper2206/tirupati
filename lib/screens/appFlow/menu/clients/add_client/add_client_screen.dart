import 'package:crm_demo/api_service/connectivity/no_internet_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/clients/add_client/add_client_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/clients/model/company_list_model.dart';
import 'package:crm_demo/screens/appFlow/menu/sales/product/content/custom_dropdown.dart';
import 'package:crm_demo/screens/custom_widgets/add_client_textfield.dart';
import 'package:crm_demo/screens/custom_widgets/label_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../projects/model/admin_list_model.dart' show UserData;

class AddClientScreen extends StatefulWidget {
  final UserData? user;

  AddClientScreen({super.key, this.user});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final formKey = GlobalKey<FormState>();
  /*
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Run after the first frame to prevent calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AddClientProvider>(context, listen: false);
      provider.isUpdateFun(widget.user != null);

      // Populate fields if user exists
      if (widget.user != null) {
        provider.clientNameController.text = widget.user?.userName ?? '';
        provider.clientPhoneNumberController.text = widget.user?.mobile ?? '';
        provider.clientEmailController.text = widget.user?.emailId ?? '';
        provider.clientAddressController.text = widget.user?.address ?? '';

        if (provider.companyListModel.data != null) {
          for (var item in provider.companyListModel.data!) {
            if (widget.user!.companyId == item.companyId) {
              provider.selectCompany(item);
            }
          }
        }
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return NoInternetScreen(
      child: ChangeNotifierProvider(
        create: (context) => AddClientProvider(),
        child: Consumer<AddClientProvider>(
          builder: (context, provider, _) {
            if (widget.user != null) {
              provider.clientNameController.text = widget.user?.userName ?? '';
              provider.clientPhoneNumberController.text =
                  widget.user?.mobile ?? '';
              provider.clientEmailController.text = widget.user?.emailId ?? '';
              provider.clientAddressController.text =
                  widget.user?.address ?? '';

              if (provider.companyListModel.data != null) {
                for (var item in provider.companyListModel.data!) {
                  if (widget.user!.companyId == item.companyId) {
                    provider.selectCompany(item);
                  }
                }
              }
            }
            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: const Color(0xffF5F6FA),
              appBar: AppBar(
                elevation: 0,
                title:
                    Text(
                      widget.user != null ? "Update Client" : "add_client",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ).tr(),
              ),
              body: Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: 28.h,
                    horizontal: 16.w,
                  ),
                  children: [
                    const LavelText(text: "Company * "),
                    SizedBox(height: 10.h),
                    CustomDropdown<CompanyData>(
                      value: provider.companyData,
                      labelText: 'Select your attendance shit ',
                      items: provider.companyListModel.data ?? [],
                      onChanged: (CompanyData? newValue) {
                        provider.selectCompany(newValue!);
                      },
                      itemLabelBuilder:
                          (CompanyData value) => value.companyName ?? '',
                    ),
                    SizedBox(height: 10.h),
                    const LavelText(text: "Client's Name * "),
                    SizedBox(height: 10.h),
                    AddClientTextField(
                      hintText: "Enter Client's Name".tr(),
                      textController: provider.clientNameController,
                    ),
                    SizedBox(height: 16.h),
                    const LavelText(text: "Phone Number * "),
                    SizedBox(height: 10.h),
                    AddClientTextField(
                      hintText: "Enter Client's Phone Number".tr(),
                      textController: provider.clientPhoneNumberController,
                    ),
                    SizedBox(height: 16.h),
                    const LavelText(text: "Email * "),
                    SizedBox(height: 10.h),
                    AddClientTextField(
                      hintText: "Enter Client's Email".tr(),
                      textController: provider.clientEmailController,
                    ),
                    SizedBox(height: 16.h),
                    const LavelText(text: "Password * "),
                    SizedBox(height: 10.h),
                    AddClientTextField(
                      hintText: "Enter Client's Password".tr(),
                      textController: provider.clientPasswordController,
                    ),
                    SizedBox(height: 16.h),
                    const LavelText(text: "Address * "),
                    SizedBox(height: 10.h),
                    AddClientTextField(
                      hintText: "Enter Client's Address".tr(),
                      textController: provider.clientAddressController,
                    ),
                    /*SizedBox(
                    height: 16.h,
                  ),
                  const LavelText(
                    text: "Description * ",
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  AddClientTextField(
                    hintText: "Write Client's description here...".tr(),
                    textController: provider.clientDescriptionController,
                    maxLine: 6,
                  ),*/
                    SizedBox(height: 30.h),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await provider.addClient(
                            context,
                            widget.user != null,
                            widget.user?.userid ?? '',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff5B58FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        minimumSize: Size(double.infinity, 60.h),
                      ),
                      child:
                          Text(
                            widget.user != null
                                ? "Update Client"
                                : "Add Clients",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ).tr(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
