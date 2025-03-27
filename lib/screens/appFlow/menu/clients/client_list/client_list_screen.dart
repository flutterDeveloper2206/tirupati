import 'package:crm_demo/screens/appFlow/menu/clients/model/company_list_model.dart';
import 'package:crm_demo/screens/appFlow/menu/clients/provider/client_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/new_clients_details/content/client_profile_details_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/sales/product/content/custom_dropdown.dart';
import 'package:crm_demo/screens/custom_widgets/label_text.dart' show LavelText;
import 'package:crm_demo/utils/nav_utail.dart' show NavUtil;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../api_service/connectivity/no_internet_screen.dart';

class ClientListScreen extends StatelessWidget {
  const ClientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NoInternetScreen(
      child: ChangeNotifierProvider(
        create: (context) => CrmClientProvider(context),
        child: Consumer<CrmClientProvider>(
          builder: (context, provider, _) {
            return Scaffold(
              backgroundColor: const Color(0xffF5F6FA),
              appBar: AppBar(
                elevation: 0,
                title: Text(
                  "Admin's List".tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),

                    /* Search Bar */
                    /*Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xffEBEBEB),
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: TextFormField(
                              onChanged: ((value) {
                                provider.getSearchValue(value);
                              }),
                              maxLines: 1,
                              cursorColor: const Color(0xff5B58FF),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(8.sp),
                                    height: 29.h,
                                    width: 29.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff5B58FF),
                                    ),
                                    child: Image.asset(
                                      "assets/task/search_bar.png",
                                      height: 11.h,
                                      width: 11.w,
                                    ),
                                  ),
                                ),
                                hintStyle: TextStyle(
                                  color: const Color(0xffCED1DA),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                                hintText: "Search".tr(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),*/
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const LavelText(text: "Company * "),
                    ),
                    SizedBox(height: 10.h),

                    CustomDropdown<CompanyData>(
                      value: provider.companyData,
                      labelText: 'Select Company ',
                      items: provider.companyList ?? [],
                      onChanged: (CompanyData? newValue) {
                        provider.selectCompany(newValue!);
                      },
                      itemLabelBuilder:
                          (CompanyData value) => value.companyName ?? '',
                    ),
                    SizedBox(height: 10.h),

                    /* Client List */
                    /*provider.crmClientListREsponse?.data?.clients != null
                        ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              provider
                                  .crmClientListREsponse
                                  ?.data
                                  ?.clients
                                  ?.length,
                          itemBuilder: (BuildContext context, int index) {
                            final data =
                                provider
                                    .crmClientListREsponse
                                    ?.data
                                    ?.clients?[index];
                            return ClientListCard(
                              ontap: () {
                                if (kDebugMode) {
                                  print("chekc client list card");
                                }
                                NavUtil.navigateScreen(
                                  context,
                                  NewClientDetailsScreen(clientId: data!.id!),
                                );
                              },
                              name: data?.name,
                              email: data?.email,
                              profileImage: data?.avater,
                              number: data?.phone,
                            );
                          },
                        )
                        : const CustomListShimer(),*/
                    Expanded(
                      child:
                          provider.allAdminListModel.data == null
                              ? Center(
                                child: Text(
                                  "No Data Available",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                              : ListView.builder(
                                itemCount:
                                    provider.allAdminListModel.data?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  final user =
                                      provider.allAdminListModel.data![index];

                                  return InkWell(
                                    onTap: () {
                                      NavUtil.navigateScreen(
                                        context,
                                        ClientProfileDetailsScreen(
                                          clientId: int.parse(
                                            user.userid ?? '',
                                          ),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.grey[300],
                                        child: Text(
                                          user.userName != null
                                              ? user.userName![0].toUpperCase()
                                              : '?',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        user.userName ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              /// Left-aligned content
                                              Expanded(
                                                flex: 2, // Adjusts width ratio
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    /*Text(user.mobile ?? 'N/A'),*/
                                                    Text(user.emailId ?? 'N/A'),
                                                  ],
                                                ),
                                              ),

                                              /// Right-aligned content
                                              Expanded(
                                                flex:
                                                    1, // Makes this column take less space
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      user.createdDateTime ??
                                                          'N/A',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Icon(Icons.info_outline),
                                    ),
                                  );
                                },
                              ),
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
