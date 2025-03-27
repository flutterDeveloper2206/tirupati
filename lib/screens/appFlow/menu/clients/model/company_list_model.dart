import 'dart:convert';

CompanyListModel companyListModelFromJson(String str) =>
    CompanyListModel.fromJson(json.decode(str));

String companyListModelToJson(CompanyListModel data) =>
    json.encode(data.toJson());

class CompanyListModel {
  CompanyListModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  List<CompanyData>? data;
  String? message;

  factory CompanyListModel.fromJson(Map<String, dynamic> json) =>
      CompanyListModel(
        status: json["status"],
        data: json["data"] != null
            ? List<CompanyData>.from(
            json["data"].map((x) => CompanyData.fromJson(x)))
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

class CompanyData {
  CompanyData({
    this.companyId,
    this.companyName,
  });

  String? companyId;
  String? companyName;

  factory CompanyData.fromJson(Map<String, dynamic> json) => CompanyData(
    companyId: json["conpany_id"],
    companyName: json["c_name"],
  );

  Map<String, dynamic> toJson() => {
    "conpany_id": companyId,
    "c_name": companyName,
  };
}
