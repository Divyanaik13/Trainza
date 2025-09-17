// To parse this JSON data, do
//
//     final joinClubModule = joinClubModuleFromJson(jsonString);

import 'dart:convert';

JoinClubModule joinClubModuleFromJson(String str) => JoinClubModule.fromJson(json.decode(str));

String joinClubModuleToJson(JoinClubModule data) => json.encode(data.toJson());

class JoinClubModule {
  int code;
  Data data;

  JoinClubModule({
    required this.code,
    required this.data,
  });

  factory JoinClubModule.fromJson(Map<String, dynamic> json) => JoinClubModule(
    code: json["code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<JoinedClub> joinedClubs;
  bool loadMore;
  int count;

  Data({
    required this.joinedClubs,
    required this.loadMore,
    required this.count,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    joinedClubs: List<JoinedClub>.from(json["joinedClubs"].map((x) => JoinedClub.fromJson(x))),
    loadMore: json["loadMore"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "joinedClubs": List<dynamic>.from(joinedClubs.map((x) => x.toJson())),
    "loadMore": loadMore,
    "count": count,
  };
}

class JoinedClub {
  String id;
  String clubName;
  int canViewOtherMembers;
  DateTime membershipValidUntil;
  String appLogoFilename;

  JoinedClub({
    required this.id,
    required this.clubName,
    required this.canViewOtherMembers,
    required this.membershipValidUntil,
    required this.appLogoFilename,
  });

  factory JoinedClub.fromJson(Map<String, dynamic> json) => JoinedClub(
    id: json["id"],
    clubName: json["clubName"],
    canViewOtherMembers: json["canViewOtherMembers"],
    membershipValidUntil: DateTime.parse(json["membershipValidUntil"]),
    appLogoFilename: json["appLogoFilename"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "clubName": clubName,
    "canViewOtherMembers": canViewOtherMembers,
    "membershipValidUntil": "${membershipValidUntil.year.toString().padLeft(4, '0')}-${membershipValidUntil.month.toString().padLeft(2, '0')}-${membershipValidUntil.day.toString().padLeft(2, '0')}",
    "appLogoFilename": appLogoFilename,
  };
}
