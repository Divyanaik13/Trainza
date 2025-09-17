// To parse this JSON data, do
//
//     final acceptinvitation = acceptinvitationFromJson(jsonString);

import 'dart:convert';

Acceptinvitation acceptinvitationFromJson(String str) => Acceptinvitation.fromJson(json.decode(str));

String acceptinvitationToJson(Acceptinvitation data) => json.encode(data.toJson());

class Acceptinvitation {
  int code;
  Data data;

  Acceptinvitation({
    required this.code,
    required this.data,
  });

  factory Acceptinvitation.fromJson(Map<String, dynamic> json) => Acceptinvitation(
    code: json["code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  String name;
  String email;
  int isEmailPubliclyShared;
  int isNumberPubliclyShared;
  String profilePicture;
  CurrentClubData currentClubData;
  String token;

  Data({
    required this.name,
    required this.email,
    required this.isEmailPubliclyShared,
    required this.isNumberPubliclyShared,
    required this.profilePicture,
    required this.currentClubData,
    required this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"],
    email: json["email"],
    isEmailPubliclyShared: json["isEmailPubliclyShared"],
    isNumberPubliclyShared: json["isNumberPubliclyShared"],
    profilePicture: json["profilePicture"],
    currentClubData: CurrentClubData.fromJson(json["currentClubData"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "isEmailPubliclyShared": isEmailPubliclyShared,
    "isNumberPubliclyShared": isNumberPubliclyShared,
    "profilePicture": profilePicture,
    "currentClubData": currentClubData.toJson(),
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

  CurrentClubData({
    required this.clubName,
    required this.canViewOtherMembers,
    required this.btnTxtColor,
    required this.btnBgColor,
    required this.txtColor,
    required this.appLogoFilename,
  });

  factory CurrentClubData.fromJson(Map<String, dynamic> json) => CurrentClubData(
    clubName: json["clubName"],
    canViewOtherMembers: json["canViewOtherMembers"],
    btnTxtColor: json["btnTxtColor"],
    btnBgColor: json["btnBgColor"],
    txtColor: json["txtColor"],
    appLogoFilename: json["appLogoFilename"],
  );

  Map<String, dynamic> toJson() => {
    "clubName": clubName,
    "canViewOtherMembers": canViewOtherMembers,
    "btnTxtColor": btnTxtColor,
    "btnBgColor": btnBgColor,
    "txtColor": txtColor,
    "appLogoFilename": appLogoFilename,
  };
}
