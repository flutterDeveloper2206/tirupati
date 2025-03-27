import 'package:crm_demo/screens/appFlow/menu/new_project_details/provider/project_overview_provider.dart';
import 'package:crm_demo/screens/custom_widgets/custom_list_shimer.dart';
import 'package:crm_demo/screens/custom_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectOverviewScreen extends StatelessWidget {
  final int projectId;
  const ProjectOverviewScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectOverViewProvider>(
      builder: (context, provider, _) {
        final projectOverView = provider.projectOverviewDetailsResponse?.data;
        return SingleChildScrollView(
          child:
              provider.isLoading
                  ? const CustomListShimer()
                  : projectOverView != null
                  ? ListView(
                    children: [
                      buildKYCItem("Name", Icons.person, "Mr Grge"),
                      buildKYCItem("Gender", null, "Male"),
                      buildKYCItem("Marital Status", null, "Single"),
                      buildKYCItem("Father Name / Husband Name", null, "Gege"),
                      buildKYCItem("Date of Birth", Icons.cake, "27-03-2025"),
                      buildKYCItem("Age", Icons.cake, "0"),
                      buildKYCItem("Email Id", null, "example@mail.com"),
                    ],
                  )
                  : const NoDataFoundWidget(),
        );
      },
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
