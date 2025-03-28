import 'package:crm_demo/screens/appFlow/menu/menu_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/my_account/my_account.dart';
import 'package:crm_demo/utils/nav_utail.dart';
import 'package:crm_demo/utils/res.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../home/home_provider.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key, this.provider});

  final MenuProvider? provider;

  @override
  Widget build(BuildContext context) {
    List<MenuDrawerModel> btnNames = [
      MenuDrawerModel(
        title: 'Home'.tr(),
        iconData: Icons.home,
        onTap: () {
          Navigator.pop(context);
        } /*NavUtil.navigateScreen(context, const LeaveSummary())*/,
      ),
      MenuDrawerModel(
        title: 'Profile'.tr(),
        iconData: Icons.account_circle,
        onTap: () => NavUtil.navigateScreen(context, MyAccount()),
      ),
      MenuDrawerModel(
        title: tr("Logout"),
        iconData: Icons.logout,
        onTap:
            () => showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    content: Text(tr("are_you_sure_you_want_to_logout")),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(tr("no")),
                      ),
                      TextButton(
                        onPressed: () async {
                          provider?.logOutFunctionality(context);
                        },
                        child: Text(tr("yes")),
                      ),
                    ],
                  ),
            ),
      ),
    ];

    return Consumer<HomeProvider>(
      builder: (BuildContext context, provider, _) {
        return Drawer(
          backgroundColor: AppColors.white,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                color: AppColors.white,
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        "assets/images/t_logo.png",
                        height: 110,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "TIRUPATI INDUSTRIAL",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "SERVICES PVT. LTD.",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Text(
                      //   'account',
                      //   style: TextStyle(color: Colors.grey),
                      // ).tr(),
                      // const Divider(),
                      Column(
                        children:
                            btnNames
                                .map(
                                  (e) => buildDrawerListTile(
                                    title: e.title,
                                    iconData: e.iconData,
                                    onTap: e.onTap,
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "@2025 Tirupati Group.All rights reserved\nV 1.0.0",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 120.h),
            ],
          ),
        );
      },
    );
  }

  ListTile buildDrawerListTile({
    String? title,
    Function()? onTap,
    IconData? iconData,
  }) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      leading: Padding(
        padding: EdgeInsets.only(right: 14),
        child: Icon(iconData),
      ),
      title: Text(title ?? ''),
    );
  }
}

class MenuDrawerModel {
  String? title;
  IconData? iconData;
  Function()? onTap;

  MenuDrawerModel({this.title, this.iconData, this.onTap});
}
