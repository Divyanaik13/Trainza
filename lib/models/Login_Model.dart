// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  int code;
  Data data;

  LoginModel({
    required this.code,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        code: json["code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
      };
}

class Data {
  String firstName;
  String lastName;
  String email;
  int isEmailPubliclyShared;
  int isNumberPubliclyShared;
  String profilePicture;
  String phoneDialCode;
  String phoneCountryCode;
  String phoneNumber;
  String signupType;
  String notification_enable;
  String havePassword;
  CurrentClubData currentClubData;
  int isOnboardingStep;
  String token;

  Data({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isEmailPubliclyShared,
    required this.isNumberPubliclyShared,
    required this.profilePicture,
    required this.phoneDialCode,
    required this.phoneCountryCode,
    required this.phoneNumber,
    required this.signupType,
    required this.notification_enable,
    required this.havePassword,
    required this.currentClubData,
    required this.isOnboardingStep,
    required this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        firstName: json["firstName"].toString() ?? "",
        lastName: json["lastName"].toString() ?? "",
        email: json["email"].toString() ?? "",
        isEmailPubliclyShared: json["isEmailPubliclyShared"] ?? 0,
        isNumberPubliclyShared: json["isNumberPubliclyShared"] ?? 0,
        profilePicture: json["profilePicture"].toString() ?? "",
        phoneDialCode: json["phoneDialCode"]?.toString() ?? "",
        phoneCountryCode: json["phoneCountryCode"]?.toString() ?? "",
        phoneNumber: json["phoneNumber"]?.toString() ?? "",
        signupType: json["signupType"]?.toString() ?? "",
        notification_enable: json["notification_enable"]?.toString() ?? "",
        havePassword: json["havePassword"]?.toString() ?? "",
        currentClubData:
            CurrentClubData.fromJson(json["currentClubData"] ?? {}),
        isOnboardingStep: json["isOnboardingStep"] ?? 0,
        token: json["token"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "isEmailPubliclyShared": isEmailPubliclyShared,
        "isNumberPubliclyShared": isNumberPubliclyShared,
        "profilePicture": profilePicture,
        "phoneDialCode": phoneDialCode,
        "phoneCountryCode": phoneCountryCode,
        "phoneNumber": phoneNumber,
        "signupType": signupType,
        "notification_enable": notification_enable,
        "havePassword": havePassword,
        "currentClubData": currentClubData.toJson(),
        "isOnboardingStep": isOnboardingStep,
        "token": token,
      };
}

class CurrentClubData {
  String clubName;
  int canViewOtherMembers;
  String btnTxtColor;
  String btnBgColor;
  String txtColor;
  String appLogoFilename;
  String isMembershipExpire;
  String isMembershipActive;
  String isMembershipFinal;
  String notificationUnreadCount;

  CurrentClubData(
      {required this.clubName,
      required this.canViewOtherMembers,
      required this.btnTxtColor,
      required this.btnBgColor,
      required this.txtColor,
      required this.appLogoFilename,
      required this.isMembershipExpire,
      required this.isMembershipActive,
      required this.isMembershipFinal,
      required this.notificationUnreadCount});

  factory CurrentClubData.fromJson(Map<String, dynamic> json) =>
      CurrentClubData(
        clubName: json["clubName"] ?? "",
        canViewOtherMembers: json["canViewOtherMembers"] ?? 0,
        btnTxtColor: json["btnTxtColor"] ?? "",
        btnBgColor: json["btnBgColor"] ?? "",
        txtColor: json["txtColor"] ?? "",
        appLogoFilename: json["appLogoFilename"] ?? "",
        isMembershipExpire: json["isMembershipExpire"].toString() ?? "",
        isMembershipActive: json["isMembershipActive"].toString() ?? "",
        notificationUnreadCount:
            json["notificationUnreadCount"].toString() ?? "",
        isMembershipFinal: "",
      );

  Map<String, dynamic> toJson() => {
        "clubName": clubName,
        "canViewOtherMembers": canViewOtherMembers,
        "btnTxtColor": btnTxtColor,
        "btnBgColor": btnBgColor,
        "txtColor": txtColor,
        "appLogoFilename": appLogoFilename,
        "isMembershipExpire": isMembershipExpire,
        "isMembershipActive": isMembershipActive,
        "notificationUnreadCount": notificationUnreadCount,
      };
}
