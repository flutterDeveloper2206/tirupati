import 'package:crm_demo/screens/appFlow/menu/clients/model/company_list_model.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/project_list/project_list_content.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/project_list/project_list_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/sales/product/content/custom_dropdown.dart';
import 'package:crm_demo/screens/custom_widgets/label_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../api_service/connectivity/no_internet_screen.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NoInternetScreen(
      child: ChangeNotifierProvider(
        create: (context) => CrmProjectListProvider(),
        child: Consumer<CrmProjectListProvider>(
          builder: (context, provider, _) {
            return Scaffold(
              backgroundColor: const Color(0xffF5F6FA),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(56.h),
                child: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.redAccent.shade200,
                  leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  title: Text(
                    "Kyc List",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  actions: [
                    Icon(
                      Icons.edit_calendar_outlined,
                      color: Colors.black,
                      size: 24,
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
                child: Column(
                  children: [
                    /*Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 13.5.w),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r)),
                            child: TextFormField(
                              controller: provider.searchController,
                              onChanged: ((value) {
                                provider.getSearchValue(value);
                              }),
                              maxLines: 1,
                              cursorColor: const Color(0xff5B58FF),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                  ),
                                  hintStyle: TextStyle(
                                      color: const Color(0xffCED1DA),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp),
                                  hintText: "Search...."),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateProjectScreen()),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 13.h, horizontal: 15.w),
                            decoration: BoxDecoration(
                                color: const Color(0xff5B58FF),
                                borderRadius: BorderRadius.circular(8.r)),
                            child: Icon(
                              Icons.add,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        )
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
                    SizedBox(height: 20.h),
                    Expanded(child: ProjectListContent(provider: provider)),
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
