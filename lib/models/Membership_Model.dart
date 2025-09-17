// To parse this JSON data, do
//
//     final membershipInfoModel = membershipInfoModelFromJson(jsonString);

import 'dart:convert';

MembershipInfoModel membershipInfoModelFromJson(String str) => MembershipInfoModel.fromJson(json.decode(str));

String membershipInfoModelToJson(MembershipInfoModel data) => json.encode(data.toJson());

class MembershipInfoModel {
  int code;
  Data data;

  MembershipInfoModel({
    required this.code,
    required this.data,
  });

  factory MembershipInfoModel.fromJson(Map<String, dynamic> json) => MembershipInfoModel(
    code: json["code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  MembershipInfo membershipInfo;
  String membershipButtonStatus;

  Data({
    required this.membershipInfo,
    required this.membershipButtonStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    membershipInfo: MembershipInfo.fromJson(json["membershipInfo"]),
    membershipButtonStatus: json["membershipButtonStatus"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "membershipInfo": membershipInfo.toJson(),
    "membershipButtonStatus": membershipButtonStatus,
  };
}

class MembershipInfo {
  String details;
  String phoneDialCode;
  String phoneNumber;
  String contactEmail;
  String webAddress;
  String address;
  String googleAddress;
  String membershipPageImg;
  String membershipStatus;
  String title;
  double latitude;
  double longitude;
  String whatsappDialCode;
  String whatsappNumber;
  String isBtnAdded;
  String btnLbl;
  String btnLink;
  String trainzaUrl;

  MembershipInfo({
    required this.details,
    required this.phoneDialCode,
    required this.phoneNumber,
    required this.contactEmail,
    required this.webAddress,
    required this.address,
    required this.googleAddress,
    required this.membershipPageImg,
    required this.membershipStatus,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.whatsappDialCode,
    required this.whatsappNumber,
    required this.isBtnAdded,
    required this.btnLbl,
    required this.btnLink,
    required this.trainzaUrl,
  });

  factory MembershipInfo.fromJson(Map<String, dynamic> json) => MembershipInfo(
    details: json["details"]??"",
    phoneDialCode: json["phoneDialCode"]??"",
    phoneNumber: json["phoneNumber"]??"",
    contactEmail: json["contactEmail"]??"",
    webAddress: json["webAddress"]??"",
    address: json["address"]??"",
    googleAddress: json["googleAddress"]??"",
    membershipPageImg: json["membershipPageImg"]??"",
    membershipStatus: json["membershipStatus"]??"",
    title: json["title"]??"",
    latitude: json["latitude"]??0.0,
    longitude: json["longitude"]??0.0,
    whatsappDialCode: json["whatsappDialCode"]??"",
    whatsappNumber: json["whatsappNumber"]??"",
    isBtnAdded: json["isBtnAdded"].toString()??"",
    btnLbl: json["btnLbl"].toString()??"",
    btnLink: json["btnLink"].toString()??"",
    trainzaUrl: json["trainzaUrl"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "details": details,
    "phoneDialCode": phoneDialCode,
    "phoneNumber": phoneNumber,
    "contactEmail": contactEmail,
    "webAddress": webAddress,
    "address": address,
    "googleAddress": googleAddress,
    "membershipPageImg": membershipPageImg,
    "membershipStatus": membershipStatus,
    "title": title,
    "latitude": latitude,
    "longitude": longitude,
    "whatsappDialCode": whatsappDialCode,
    "whatsappNumber": whatsappNumber,
    "isBtnAdded": isBtnAdded,
    "btnLbl": btnLbl,
    "btnLink": btnLink,
    "trainzaUrl": trainzaUrl,
  };
}
