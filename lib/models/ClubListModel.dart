// To parse this JSON data, do
//
//     final clubListModel = clubListModelFromJson(jsonString);

import 'dart:convert';

ClubListModel clubListModelFromJson(String str) =>
    ClubListModel.fromJson(json.decode(str));

String clubListModelToJson(ClubListModel data) => json.encode(data.toJson());

class ClubListModel {
  List<Club> clubs;
  bool loadMore;
  int count;

  ClubListModel({
    required this.clubs,
    required this.loadMore,
    required this.count,
  });

  factory ClubListModel.fromJson(Map<String, dynamic> json) => ClubListModel(
        clubs: json["clubs"] != null
            ? List<Club>.from(json["clubs"].map((x) => Club.fromJson(x)))
            : [],
        loadMore: json["loadMore"]??false,
        count: json["count"]??0,
      );

  Map<String, dynamic> toJson() => {
        "clubs": List<dynamic>.from(clubs.map((x) => x.toJson())),
        "loadMore": loadMore,
        "count": count,
      };
}

class Club {
  String id;
  String requestId;
  String clubName;
  String appLogoFilename;

  Club({
    required this.id,
    required this.requestId,
    required this.clubName,
    required this.appLogoFilename,
  });

  factory Club.fromJson(Map<String, dynamic> json) => Club(
        id: json["id"].toString()??"",
        requestId: json["request_id"].toString()??"",
        clubName: json["clubName"].toString()??"",
        appLogoFilename: json["appLogoFilename"].toString()??"",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "request_id": requestId,
        "clubName": clubName,
        "appLogoFilename": appLogoFilename,
      };
}
