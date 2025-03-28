import 'package:crm_demo/api_service/connectivity/no_internet_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/clients/add_client/add_client_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/clients/client_deal_list/client_deal_list_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/clients/client_details/client_details_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/clients/edit_client/edit_client_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/clients/widgets/client_deal_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/nav_utail.dart';
import '../../../../../utils/res.dart';
import '../../projects/model/admin_list_model.dart' show UserData;
import 'contents/client_profile_details_card.dart';

class ClientDetailsScreen extends StatelessWidget {
  final int clientId;

  const ClientDetailsScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return NoInternetScreen(
      child: ChangeNotifierProvider(
        create: ((context) => CrmClientDetailsProvider(clientId)),
        child: Consumer<CrmClientDetailsProvider>(
          builder: (context, provider, _) {
            final data = provider.crmClientDetailsResponse?.data?.client;
            return Scaffold(
              backgroundColor: const Color(0xffF5F6FA),
              appBar: AppBar(
                elevation: 0,
                actions: [
                  Visibility(
                    visible: provider.isAdmin ?? false,
                    child: InkWell(
                      onTap: () {
                        NavUtil.navigateScreen(
                          context,
                          EditClientScreen(
                            clientDetails: provider.crmClientDetailsResponse,
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.colorPrimary,
                        ),
                        child: Icon(
                          size: 14.0.r,
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: provider.isAdmin ?? false,
                    child: InkWell(
                      onTap: () {
                        if (kDebugMode) {
                          print(clientId);
                        }
                        provider.crmClientDelete(clientId, context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.colorPrimary,
                        ),
                        child: Icon(
                          size: 14.0.r,
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
                title:
                    Text(
                      "client_details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ).tr(),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0.w,
                    vertical: 21.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClientProfileDetailsCard(client: data),
                      SizedBox(height: 24.h),
                      if (data != null)
                        data.projects!.isNotEmpty
                            ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Deals",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                    ),
                                  ).tr(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ClientDealListScreen(
                                                clientId: data.id ?? 0,
                                              ),
                                        ),
                                      );
                                    },
                                    child:
                                        Text(
                                          "see_all",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.sp,
                                          ),
                                        ).tr(),
                                  ),
                                ],
                              ),
                            )
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Deals",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                      ),
                                    ).tr(),
                                    Text(
                                      "see_all",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                      ),
                                    ).tr(),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                const Text("project_hadn't_added_yet").tr(),
                              ],
                            ),
                      SizedBox(height: 16.h),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data?.projects?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          final projectData = data?.projects?[index];
                          return ClientDealsCard(project: projectData);
                        },
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

class ProfileDetailsScreen extends StatelessWidget {
  final UserData user;

  const ProfileDetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile Details", style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddClientScreen(user: user),
                ),
              );
            },
            child: Icon(Icons.edit_calendar),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileField(
              icon: Icons.apartment,
              label: "Company Name",
              value: user.companyName ?? 'N/A',
            ),
            ProfileField(
              icon: Icons.badge,
              label: "User Type",
              value: user.userType ?? 'N/A',
            ),
            ProfileField(
              icon: Icons.person,
              label: "Name",
              value: user.userName ?? 'N/A',
            ),
            ProfileField(
              icon: Icons.email,
              label: "Email Id",
              value: user.emailId ?? 'N/A',
            ),
            ProfileField(
              icon: Icons.phone,
              label: "Phone Number",
              value: user.mobile ?? 'N/A',
            ),
            ProfileField(
              icon: Icons.home,
              label: "Address",
              value: user.address ?? 'N/A',
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  ProfileField({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(value, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
