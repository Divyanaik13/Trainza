// To parse this JSON data, do
//
//     final eventDetailListModel = eventDetailListModelFromJson(jsonString);

import 'dart:convert';

EventDetailListModel eventDetailListModelFromJson(String str) => EventDetailListModel.fromJson(json.decode(str));

String eventDetailListModelToJson(EventDetailListModel data) => json.encode(data.toJson());

class EventDetailListModel {
  int code;
  Data data;

  EventDetailListModel({
    required this.code,
    required this.data,
  });

  factory EventDetailListModel.fromJson(Map<String, dynamic> json) => EventDetailListModel(
    code: json["code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<EventResultList> eventResultList;
  bool loadMore;
  int count;

  Data({
    required this.eventResultList,
    required this.loadMore,
    required this.count,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    eventResultList: List<EventResultList>.from(json["eventResultList"].map((x) => EventResultList.fromJson(x))),
    loadMore: json["loadMore"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "eventResultList": List<dynamic>.from(eventResultList.map((x) => x.toJson())),
    "loadMore": loadMore,
    "count": count,
  };
}

class EventResultList {
  double distance;
  int distanceUnit;
  List<Member> members;

  EventResultList({
    required this.distance,
    required this.distanceUnit,
    required this.members,
  });

  factory EventResultList.fromJson(Map<String, dynamic> json) => EventResultList(
    distance: json["distance"]?.toDouble(),
    distanceUnit: json["distanceUnit"],
    members: List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "distance": distance,
    "distanceUnit": distanceUnit,
    "members": List<dynamic>.from(members.map((x) => x.toJson())),
  };
}

class Member {
  String id;
  String firstName;
  String lastName;
  String result;
  String pace;
  int gender;
  int age;

  Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.result,
    required this.pace,
    required this.gender,
    required this.age,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    result: json["result"],
    pace: json["pace"],
    gender: json["gender"],
    age: json["age"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "result": result,
    "pace": pace,
    "gender": gender,
    "age": age,
  };
}
