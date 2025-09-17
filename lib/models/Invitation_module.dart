// To parse this JSON data, do
//
//     final invitationListApi = invitationListApiFromJson(jsonString);

import 'dart:convert';

InvitationListApi invitationListApiFromJson(String str) => InvitationListApi.fromJson(json.decode(str));

String invitationListApiToJson(InvitationListApi data) => json.encode(data.toJson());

class InvitationListApi {
  int code;
  Data data;

  InvitationListApi({
    required this.code,
    required this.data,
  });

  factory InvitationListApi.fromJson(Map<String, dynamic> json) => InvitationListApi(
    code: json["code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<InvitationsList> invitationsList;
  bool loadMore;
  int count;

  Data({
    required this.invitationsList,
    required this.loadMore,
    required this.count,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    invitationsList: List<InvitationsList>.from(json["invitationsList"].map((x) => InvitationsList.fromJson(x))),
    loadMore: json["loadMore"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "invitationsList": List<dynamic>.from(invitationsList.map((x) => x.toJson())),
    "loadMore": loadMore,
    "count": count,
  };
}

class InvitationsList {
  String id;
  String clubName;
  String appLogoFilename;

  InvitationsList({
    required this.id,
    required this.clubName,
    required this.appLogoFilename,
  });

  factory InvitationsList.fromJson(Map<String, dynamic> json) => InvitationsList(
    id: json["id"],
    clubName: json["clubName"],
    appLogoFilename: json["appLogoFilename"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "clubName": clubName,
    "appLogoFilename": appLogoFilename,
  };
}
