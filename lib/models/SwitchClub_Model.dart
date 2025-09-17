// To parse this JSON data, do
//
//     final switchClubModule = switchClubModuleFromJson(jsonString);

import 'dart:convert';

SwitchClubModule switchClubModuleFromJson(String str) => SwitchClubModule.fromJson(json.decode(str));

String switchClubModuleToJson(SwitchClubModule data) => json.encode(data.toJson());

class SwitchClubModule {
  int code;
  Data data;

  SwitchClubModule({
    required this.code,
    required this.data,
  });

  factory SwitchClubModule.fromJson(Map<String, dynamic> json) => SwitchClubModule(
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
