class KYCUserIdKYCModel {
  bool? status;
  List<KYCUserIdKYCData>? data;
  String? msg;

  KYCUserIdKYCModel({this.status, this.data, this.msg});

  factory KYCUserIdKYCModel.fromJson(Map<String, dynamic> json) {
    return KYCUserIdKYCModel(
      status: json['status'],
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map((i) => KYCUserIdKYCData.fromJson(i))
                  .toList()
              : null,
      msg: json['msg'],
    );
  }
}

class KYCUserIdKYCData {
  String? kycid;
  String? userid;
  String? name;
  String? dob;
  String? email;
  String? mobile;
  String? address;
  String? pincode;
  String? adhar;
  String? pancard;
  String? uan;
  String? esicName;
  String? bankName;
  String? accountNumber;
  String? ifsc;
  String? state;
  String? companyId;
  String? newCompanyName;
  String? title;
  String? fatherName;
  String? maritalStatus;
  String? gender;
  String? nameAsAdhar;
  String? mobileAdharLinked;
  String? alternateMobile;
  String? department;
  String? designation;
  String? doj;
  String? dateOfExit;
  String? remarks;
  String? memberPhoto;
  String? companyName;
  String? educationId;
  String? educationName;
  String? status;
  String? createdDateTime;
  String? updatedDateTime;

  KYCUserIdKYCData({
    this.kycid,
    this.userid,
    this.name,
    this.dob,
    this.email,
    this.mobile,
    this.address,
    this.pincode,
    this.adhar,
    this.pancard,
    this.uan,
    this.esicName,
    this.bankName,
    this.accountNumber,
    this.ifsc,
    this.state,
    this.companyId,
    this.newCompanyName,
    this.title,
    this.fatherName,
    this.maritalStatus,
    this.gender,
    this.nameAsAdhar,
    this.mobileAdharLinked,
    this.alternateMobile,
    this.department,
    this.designation,
    this.doj,
    this.dateOfExit,
    this.remarks,
    this.memberPhoto,
    this.companyName,
    this.educationId,
    this.educationName,
    this.status,
    this.createdDateTime,
    this.updatedDateTime,
  });

  factory KYCUserIdKYCData.fromJson(Map<String, dynamic> json) {
    return KYCUserIdKYCData(
      kycid: json['kycid'],
      userid: json['userid'],
      name: json['name'],
      dob: json['dob'],
      email: json['email'],
      mobile: json['mobile'],
      address: json['address'],
      pincode: json['pincode'],
      adhar: json['adhar'],
      pancard: json['pancard'],
      uan: json['uan'],
      esicName: json['esicName'],
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
      ifsc: json['ifsc'],
      state: json['state'],
      companyId: json['conpany_id'],
      newCompanyName: json['new_company_name'],
      title: json['title'],
      fatherName: json['father_name'],
      maritalStatus: json['marital_status'],
      gender: json['gender'],
      nameAsAdhar: json['name_as_adhar'],
      mobileAdharLinked: json['mobile_adhar_linked'],
      alternateMobile: json['alternate_mobile'],
      department: json['department'],
      designation: json['designation'],
      doj: json['doj'],
      dateOfExit: json['date_of_exit'],
      remarks: json['remarks'],
      memberPhoto: json['member_photo'],
      companyName: json['conpany_name'],
      educationId: json['education_id'],
      educationName: json['education_name'],
      status: json['status'],
      createdDateTime: json['createdDateTime'],
      updatedDateTime: json['updatedDateTime'],
    );
  }
}
