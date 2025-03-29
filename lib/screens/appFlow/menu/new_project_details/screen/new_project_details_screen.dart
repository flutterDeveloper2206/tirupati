import 'package:crm_demo/screens/appFlow/menu/new_project_details/provider/discussioin_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/new_project_details/provider/kyc_details_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/new_project_details/provider/project_activity_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/new_project_details/provider/project_email_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/new_project_details/provider/project_file_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/new_project_details/provider/project_member_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/new_project_details/provider/project_milestone_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/new_project_details/provider/project_note_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/new_project_details/provider/project_overview_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/new_project_details/provider/project_task_provider.dart';
import 'package:crm_demo/screens/appFlow/menu/new_project_details/screen/project_file_list_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/new_project_details/screen/project_milestone_list_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/new_project_details/screen/project_overview_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/new_project_details/screen/project_task_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/add_kyc/add_kyc_from.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/model/kyc_user_id_kyc_model.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/model/project_kyc_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewProjectDetailsScreen extends StatelessWidget {
  final int projectId;
  final KYCData? kycData;

  const NewProjectDetailsScreen({
    super.key,
    required this.projectId,
    this.kycData,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KycDetailsProvider(kycData)),
        ChangeNotifierProvider(
          create: (_) => ProjectOverViewProvider(projectId),
        ),
        ChangeNotifierProvider(create: (_) => ProjectTaskProvider(projectId)),
        ChangeNotifierProvider(
          create: (_) => ProjectMilestoneProvider(projectId),
        ),
        ChangeNotifierProvider(create: (_) => ProjectEmailProvider(projectId)),
        ChangeNotifierProvider(create: (_) => ProjectFileProvider(projectId)),
        ChangeNotifierProvider(
          create: (_) => ProjectDiscussionProvider(projectId),
        ),
        ChangeNotifierProvider(create: (_) => ProjectNoteProvider(projectId)),
        ChangeNotifierProvider(create: (_) => ProjectMemberProvider(projectId)),
        ChangeNotifierProvider(
          create: (_) => ProjectActivityProvider(projectId),
        ),
      ],
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("KYC Details"),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddKycFrom(kycData: kycData),
                    ),
                  );
                },
                child: Icon(Icons.edit_calendar, color: Colors.black, size: 28),
              ),
              SizedBox(width: 20),
            ],
            bottom: const PreferredSize(
              preferredSize: Size(double.infinity, 24),
              child: Align(
                alignment: Alignment.topLeft,
                child: TabBar(
                  labelPadding: EdgeInsets.only(left: 0, right: 20),
                  isScrollable: true,
                  tabs: [
                    Text(
                      "Personal information",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Professional information",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text("Bank information", style: TextStyle(fontSize: 16)),
                    Text(
                      "Document information",
                      style: TextStyle(fontSize: 16),
                    ),
                    // Text("Files", style: TextStyle(fontSize: 16)),
                    // Text("Discussion"),
                    // Text("Notes"),
                    // Text("Members"),
                    // Text("Activity"),
                  ],
                ),
              ),
            ),
          ),
          body: Consumer<KycDetailsProvider>(
            builder: (context, provider, _) {
              return TabBarView(
                children: [
                  ProjectOverviewScreen(
                    projectId: projectId,
                    kYCUserIdKYCData:
                        provider.kYCUserIdKYCModel.data != null
                            ? provider.kYCUserIdKYCModel.data!.first
                            : KYCUserIdKYCData(),
                  ),
                  ProjectTaskScreen(
                    projectId: projectId,
                    kYCUserIdKYCData:
                        provider.kYCUserIdKYCModel.data != null
                            ? provider.kYCUserIdKYCModel.data!.first
                            : KYCUserIdKYCData(),
                  ),
                  ProjectMilestoneScreen(
                    projectId: projectId,
                    kYCUserIdKYCData:
                        provider.kYCUserIdKYCModel.data != null
                            ? provider.kYCUserIdKYCModel.data!.first
                            : KYCUserIdKYCData(),
                  ),
                  // ProjectEmailScreen(projectId: projectId),
                  ProjectFileScreen(projectId: projectId),
                  // ProjectDiscussionScreen(projectId: projectId),
                  // ProjectNoteScreen(projectId: projectId),
                  // ProjectMemberListScreen(projectId: projectId),
                  // ProjectActivityScreen(projectId: projectId),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
