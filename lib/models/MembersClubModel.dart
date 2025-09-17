import 'dart:convert';

MembersClubModel membersClubModelFromJson(String str) => MembersClubModel.fromJson(json.decode(str));

String membersClubModelToJson(MembersClubModel data) => json.encode(data.toJson());

class MembersClubModel {
  String code;
  Data data;

  MembersClubModel({
    required this.code,
    required this.data,
  });

  factory MembersClubModel.fromJson(Map<String, dynamic> json) => MembersClubModel(
    code: json["code"].toString()??"",
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<MemberList> memberList;
  String loadMore;
  String count;

  Data({
    required this.memberList,
    required this.loadMore,
    required this.count,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    memberList: List<MemberList>.from(json["memberList"].map((x) => MemberList.fromJson(x))),
    loadMore: json["loadMore"].toString()??"",
    count: json["count"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "memberList": List<dynamic>.from(memberList.map((x) => x.toJson())),
    "loadMore": loadMore,
    "count": count,
  };
}

class MemberList {
  String id;
  String firstName;
  String lastName;
  String profilePicture;

  MemberList({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  factory MemberList.fromJson(Map<String, dynamic> json) => MemberList(
    id: json["id"].toString()??"",
    firstName: json["firstName"].toString()??"",
    lastName: json["lastName"].toString()??"",
    profilePicture: json["profilePicture"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profilePicture": profilePicture,
  };
}
