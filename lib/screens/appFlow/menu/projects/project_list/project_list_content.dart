import 'package:crm_demo/screens/appFlow/menu/new_project_details/screen/new_project_details_screen.dart';
import 'package:crm_demo/screens/appFlow/menu/projects/project_list/project_list_provider.dart';
import 'package:flutter/material.dart';

class ProjectListContent extends StatelessWidget {
  final CrmProjectListProvider provider;

  const ProjectListContent({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final dataList = provider.projectKYCListModel.data ?? [];

    return dataList.isEmpty
        ? Center(
          child: Text(
            "No Data Available",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        )
        : ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final user = dataList[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => NewProjectDetailsScreen(
                          projectId: int.parse(user.userid ?? ''),
                        ),
                  ),
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    user.name != null ? user.name![0].toUpperCase() : '?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
                title: Text(
                  user.name ?? 'N/A',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        /// Left-aligned content
                        Expanded(
                          flex: 2, // Adjusts width ratio
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(user.mobile ?? 'N/A'),
                              Text(user.email ?? 'N/A'),
                            ],
                          ),
                        ),

                        /// Right-aligned content
                        Expanded(
                          flex: 1, // Makes this column take less space
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.createdDateTime ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
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
        );
  }
}

/*
import 'package:crm_demo/screens/appFlow/menu/projects/project_list/project_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectListContent extends StatelessWidget {
  final CrmProjectListProvider provider;
  const ProjectListContent({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(),
      footer: CustomFooter(
        builder: (context, mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = const Text("Pull up load");
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = const Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = const Text("release to load more");
          } else {
            body = const Text("No more Data");
          }
          return SizedBox(height: 55.0, child: Center(child: body));
        },
      ),
      controller: provider.refreshController,
      onRefresh: provider.loadItems,
      onLoading: provider.loadMoreItems,
      child: ListView.builder(
        itemCount: provider.projectKYCListModel.data?.length ?? 0,
        itemBuilder: (context, index) {
          final user = provider.projectKYCListModel.data?[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[400],
              child: Text(user?.userName?[0].toUpperCase() ?? ''),
            ),
            title: Text(user?.userName ?? 'N/A'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Mobile: ${user?.mobile ?? 'N/A'}"),
                Text("Email: ${user?.emailId ?? 'N/A'}"),
                Text("Company: ${user?.companyName ?? 'N/A'}"),
              ],
            ),
            trailing: Icon(Icons.info_outline),
          );
        },
      ),
      */
/*ListView.builder(
          itemCount: provider.listOfProjects.length,
          itemBuilder: (BuildContext context, int index) {
            final data = provider.listOfProjects[index];
            List<Widget> users = [];
            for (int i = 0; i < data.members!.length; i++) {
              users.add(Positioned(
                left: i * 15,
                top: 0.0,
                bottom: 0.0,
                child: InkWell(
                  onTap: (){
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title:  Text("Name : ${data.members!.elementAt(i).name ?? ""}"),
                        content: Text("Designation : ${data.members!.elementAt(i).designation}\nDepartment : ${data.members!.elementAt(i).department ?? ""}\nPhone : ${data.members!.elementAt(i).phone ?? ""}\nemail : ${data.members!.elementAt(i).email ?? ""}"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    width: 30.0.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                                '${data.members!.elementAt(i).avatar}'))),
                    child: const SizedBox.shrink(),
                  ),
                ),
              ));
            }
            return  ProjectStatusCard(
              ontap: () {
                Project project = Project(
                  id: data.id,
                  name: data.title,
                  status: data.status,
                  color: data.color,

                );
                NavUtil.navigateScreen(context, NewProjectDetailsScreen(projectId: project.id ?? 0,));
              },
              tapBarButton1: CustomTapBarButton(
                buttonColor: const Color(0xffF4EFFD),
                textColor: const Color(0xff5B58FF),
                buttonText: data.status,
                borderColor: const Color(0xffF4EFFD),
              ),
              tapBarButton2: CustomTapBarButton(
                buttonColor: const Color(0xffFDEFEF),
                textColor: const Color(0xffE96161),
                buttonText: data.priority,
                borderColor: const Color(0xffFDEFEF),
              ),
              startData: data.dateRange,
              rightIconArrowColor: const Color(0xff00606F),
              projectName: data.title,
              usersImage: users,
              userCount: data.userCount,
              actualCount: data.actualCount,
              progressBar: ProgressIndeccatorWithPersentage(
                persentageActiveColor:
                const Color(0xff00606F),
                persentageDisebleColor:
                const Color(0xffEAEAEA),
                activeContainerWidth: ((ScreenUtil.defaultSize.width - 80.0) * double.parse('${data.progress}'))/100,
                deActivetContainerWidth: (ScreenUtil.defaultSize.width- 80.0) - ((ScreenUtil.defaultSize.width - 85.0) * double.parse('${data.progress}'))/100,
                persentage: "${data.progress ?? 0}%",
              ),
            );
          })*/ /*

    );
  }
}
*/
