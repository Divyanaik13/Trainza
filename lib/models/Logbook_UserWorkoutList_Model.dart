// To parse this JSON data, do
//
//     final logbookUserworkoutListModel = logbookUserworkoutListModelFromJson(jsonString);

import 'dart:convert';

LogbookUserworkoutListModel logbookUserworkoutListModelFromJson(String str) => LogbookUserworkoutListModel.fromJson(json.decode(str));

String logbookUserworkoutListModelToJson(LogbookUserworkoutListModel data) => json.encode(data.toJson());

class LogbookUserworkoutListModel {
  String code;
  List<UserworkoutList> data;

  LogbookUserworkoutListModel({
    required this.code,
    required this.data,
  });

  factory LogbookUserworkoutListModel.fromJson(Map<String, dynamic> json) => LogbookUserworkoutListModel(
    code: json["code"].toString()??"",
    data: List<UserworkoutList>.from(json["data"].map((x) => UserworkoutList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class UserworkoutList {
  String id;
  String workoutTypeId;
  String workoutType;
  String effortLevel;
  String isDistance;
  String distance;
  DateTime date;
  String time;
  String pace;
  String notes;
  String coachComments;

  UserworkoutList({
    required this.id,
    required this.workoutTypeId,
    required this.workoutType,
    required this.effortLevel,
    required this.isDistance,
    required this.distance,
    required this.date,
    required this.time,
    required this.pace,
    required this.notes,
    required this.coachComments,
  });

  factory UserworkoutList.fromJson(Map<String, dynamic> json) => UserworkoutList(
    id: json["id"].toString()??"",
    workoutTypeId: json["workoutTypeId"].toString()??"",
    workoutType: json["workoutType"].toString()??"",
    effortLevel: json["effortLevel"].toString()??"",
    isDistance: json["isDistance"].toString()??"",
    distance: json["distance"].toString()??"",
    date: DateTime.parse(json["date"]),
    time: json["time"].toString()??"",
    pace: json["pace"].toString()??"",
    notes: json["notes"].toString()??"",
    coachComments: json["coachComments"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "workoutTypeId": workoutTypeId,
    "workoutType": workoutType,
    "effortLevel": effortLevel,
    "isDistance": isDistance,
    "distance": distance,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "time": time,
    "pace": pace,
    "notes": notes,
    "coachComments": coachComments,
  };
}
