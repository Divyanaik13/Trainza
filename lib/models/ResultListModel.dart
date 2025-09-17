// To parse this JSON data, do
//
//     final resultListModel = resultListModelFromJson(jsonString);

import 'dart:convert';

ResultListModel resultListModelFromJson(String str) => ResultListModel.fromJson(json.decode(str));

String resultListModelToJson(ResultListModel data) => json.encode(data.toJson());

class ResultListModel {
  int code;
  Data data;

  ResultListModel({
    required this.code,
    required this.data,
  });

  factory ResultListModel.fromJson(Map<String, dynamic> json) => ResultListModel(
    code: json["code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<MemberResultList> memberResultList;
  bool loadMore;
  int count;

  Data({
    required this.memberResultList,
    required this.loadMore,
    required this.count,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    memberResultList: List<MemberResultList>.from(json["memberResultList"].map((x) => MemberResultList.fromJson(x))),
    loadMore: json["loadMore"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "memberResultList": List<dynamic>.from(memberResultList.map((x) => x.toJson())),
    "loadMore": loadMore,
    "count": count,
  };
}

class MemberResultList {
  String id;
  String eventId;
  String title;
  String result;
  String pace;
  double distance;
  String distanceUnit;
  String dateType;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  String repeatingDays;
  String repeatingTime;

  MemberResultList({
    required this.id,
    required this.eventId,
    required this.title,
    required this.result,
    required this.pace,
    required this.distance,
    required this.distanceUnit,
    required this.dateType,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.repeatingDays,
    required this.repeatingTime,
  });

  factory MemberResultList.fromJson(Map<String, dynamic> json) => MemberResultList(
    id: json["id"].toString()??"",
    eventId: json["eventId"].toString()??"",
    title: json["title"].toString()??"",
    result: json["result"].toString()??"",
    pace: json["pace"].toString()??"",
    distance: json["distance"]?.toDouble(),
    distanceUnit: json["distanceUnit"].toString()??"",
    dateType: json["dateType"].toString()??"",
    startDate: json["startDate"].toString()??"",
    endDate: json["endDate"].toString()??"",
    startTime: json["startTime"].toString()??"",
    endTime: json["endTime"].toString()??"",
    repeatingDays: json["repeatingDays"].toString()??"",
    repeatingTime: json["repeatingTime"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "eventId": eventId,
    "title": title,
    "result": result,
    "pace": pace,
    "distance": distance,
    "distanceUnit": distanceUnit,
    "dateType": dateType,
    "startDate": startDate,
    "endDate": endDate,
    "startTime": startTime,
    "endTime": endTime,
    "repeatingDays": repeatingDays,
    "repeatingTime": repeatingTime,
  };
}
