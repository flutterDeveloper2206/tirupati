import 'dart:convert';

AllAdminListModel allAdminListModelFromJson(String str) =>
    AllAdminListModel.fromJson(json.decode(str));

class AllAdminListModel {
  AllAdminListModel({this.status, this.data, this.msg});

  bool? status;
  List<UserData>? data;
  String? msg;

  factory AllAdminListModel.fromJson(Map<String, dynamic> json) =>
      AllAdminListModel(
        status: json["status"],
        data:
            json["data"] != null
                ? List<UserData>.from(
                  json["data"].map((x) => UserData.fromJson(x)),
                )
                : [],
        msg: json["msg"],
      );
}

class UserData {
  UserData({
    this.userid,
    this.mobile,
    this.userName,
    this.emailId,
    this.companyId,
    this.userType,
    this.address,
    this.createdDateTime,
    this.companyName,
  });

  String? userid;
  String? mobile;
  String? userName;
  String? emailId;
  String? companyId;
  String? userType;
  String? address;
  String? createdDateTime;
  String? companyName;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    userid: json["userid"],
    mobile: json["mobile"],
    userName: json["user_name"],
    emailId: json["email_id"],
    companyId: json["conpany_id"],
    userType: json["user_type"],
    address: json["address"],
    createdDateTime: json["createdDateTime"],
    companyName: json["conpany_name"],
  );
}
