// To parse this JSON data, do
//
//     final eventListModel = eventListModelFromJson(jsonString);

import 'dart:convert';

EventListModel eventListModelFromJson(String str) => EventListModel.fromJson(json.decode(str));

String eventListModelToJson(EventListModel data) => json.encode(data.toJson());

class EventListModel {
  int code;
  Data data;

  EventListModel({
    required this.code,
    required this.data,
  });

  factory EventListModel.fromJson(Map<String, dynamic> json) => EventListModel(
    code: json["code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<EventList> eventList;
  bool loadMore;
  int count;

  Data({
    required this.eventList,
    required this.loadMore,
    required this.count,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    eventList: List<EventList>.from(json["eventList"].map((x) => EventList.fromJson(x))),
    loadMore: json["loadMore"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "eventList": List<dynamic>.from(eventList.map((x) => x.toJson())),
    "loadMore": loadMore,
    "count": count,
  };
}

class EventList {
  String id;
  String title;
  String eventImg;
  int dateType;
  String startDate;
  dynamic endDate;
  String startTime;
  dynamic endTime;
  String repeatingDays;
  dynamic repeatingTime;

  EventList({
    required this.id,
    required this.title,
    required this.eventImg,
    required this.dateType,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.repeatingDays,
    required this.repeatingTime,
  });

  factory EventList.fromJson(Map<String, dynamic> json) => EventList(
    id: json["id"].toString()??"",
    title: json["title"].toString()??"",
    eventImg: json["eventImg"].toString()??"",
    dateType: json["dateType"]??0,
    startDate: json["startDate"]??"",
    endDate: json["endDate"].toString()??"",
    startTime: json["startTime"].toString()??"",
    endTime: json["endTime"].toString()??"",
    repeatingDays: json["repeatingDays"].toString()??"",
    repeatingTime: json["repeatingTime"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "eventImg": eventImg,
    "dateType": dateType,
    "startDate": startDate,
    "endDate": endDate,
    "startTime": startTime,
    "endTime": endTime,
    "repeatingDays": repeatingDays,
    "repeatingTime": repeatingTime,
  };
}
