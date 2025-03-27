/*

import 'dart:convert';

ResponseLogin responseLoginFromJson(String str) =>
    ResponseLogin.fromJson(json.decode(str));

String responseLoginToJson(ResponseLogin data) => json.encode(data.toJson());

class ResponseLogin {
  ResponseLogin(
      {this.result, this.message, this.data, this.laravelValidationError});

  bool? result;
  String? message;
  Data? data;
  // LaravelValidationError? laravelValidationError;
  dynamic laravelValidationError;

  factory ResponseLogin.fromJson(Map<String, dynamic> json) => ResponseLogin(
      result: json["result"],
      message: json["message"],
      data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      // laravelValidationError: json["error"] != null
      //     ? LaravelValidationError.formjson(json["error"])
      //     : null
      laravelValidationError: json["error"]
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.companyId,
    this.isAdmin,
    this.isHr,
    this.isFaceRegistered,
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.token,
    this.baseUrl,
    this.apiUrl,
  });

  int? id;
  int? companyId;
  bool? isAdmin;
  bool? isHr;
  bool? isFaceRegistered;
  String? name;
  String? email;
  String? phone;
  String? avatar;
  String? token;
  String? baseUrl;
  String? apiUrl;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    companyId: int.parse(json["company_id"].toString()),
    isAdmin: json["is_admin"],
    isHr: json["is_hr"],
    isFaceRegistered: json["is_face_registered"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    avatar: json["avatar"],
    token: json["token"],
    baseUrl: json["base_url"],
    apiUrl: json["api_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    'is_admin': isAdmin,
    'is_hr': isHr,
    'is_face_registered' : isFaceRegistered,
    "name": name,
    "email": email,
    "phone": phone,
    "avatar": avatar,
    "token": token,
    "base_url": baseUrl,
    "api_url": apiUrl,
  };
}

class LaravelValidationError {
  final String? email;
  final String? password;

  LaravelValidationError({this.email, this.password});

  factory LaravelValidationError.formjson(Map<String, dynamic> json) {
    return LaravelValidationError(
        email: json["email"] != null ? json["email"][0] : null,
        password: json["password"] != null ? json["password"][0] : null);
  }
}
*/


import 'dart:convert';

ResponseLogin responseLoginFromJson(String str) =>
    ResponseLogin.fromJson(json.decode(str));

String responseLoginToJson(ResponseLogin data) => json.encode(data.toJson());

class ResponseLogin {
  ResponseLogin({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  List<UserData>? data;
  String? message;

  factory ResponseLogin.fromJson(Map<String, dynamic> json) => ResponseLogin(
    status: json["status"],
    data: json["data"] != null
        ? List<UserData>.from(json["data"].map((x) => UserData.fromJson(x)))
        : [],
    message: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data != null
        ? List<dynamic>.from(data!.map((x) => x.toJson()))
        : [],
    "msg": message,
  };
}

class UserData {
  UserData({
    this.userId,
    this.mobile,
    this.userName,
    this.emailId,
    this.companyId,
    this.userType,
    this.address,
    this.createdDateTime,
    this.companyName,
  });

  String? userId;
  String? mobile;
  String? userName;
  String? emailId;
  String? companyId;
  String? userType;
  String? address;
  String? createdDateTime;
  String? companyName;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    userId: json["userid"],
    mobile: json["mobile"],
    userName: json["user_name"],
    emailId: json["email_id"],
    companyId: json["conpany_id"],
    userType: json["user_type"],
    address: json["address"],
    createdDateTime: json["createdDateTime"],
    companyName: json["conpany_name"],
  );

  Map<String, dynamic> toJson() => {
    "userid": userId,
    "mobile": mobile,
    "user_name": userName,
    "email_id": emailId,
    "conpany_id": companyId,
    "user_type": userType,
    "address": address,
    "createdDateTime": createdDateTime,
    "conpany_name": companyName,
  };
}
