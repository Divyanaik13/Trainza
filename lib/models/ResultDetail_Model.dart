// To parse this JSON data, do
//
//     final resultDetailModel = resultDetailModelFromJson(jsonString);

import 'dart:convert';

ResultDetailModel resultDetailModelFromJson(String str) => ResultDetailModel.fromJson(json.decode(str));

String resultDetailModelToJson(ResultDetailModel data) => json.encode(data.toJson());

class ResultDetailModel {
  String eventId;
  String memberId;
  String distanceId;
  String result;
  String pace;
  Event event;

  ResultDetailModel({
    required this.eventId,
    required this.memberId,
    required this.distanceId,
    required this.result,
    required this.pace,
    required this.event,
  });

  factory ResultDetailModel.fromJson(Map<String, dynamic> json) => ResultDetailModel(
    eventId: json["eventId"].toString()??"",
    memberId: json["memberId"].toString()??"",
    distanceId: json["distanceId"].toString()??"",
    result: json["result"].toString()??"",
    pace: json["pace"].toString()??"",
    event: Event.fromJson(json["event"]),
  );

  Map<String, dynamic> toJson() => {
    "eventId": eventId,
    "memberId": memberId,
    "distanceId": distanceId,
    "result": result,
    "pace": pace,
    "event": event.toJson(),
  };
}

class Event {
  String eventName;
  String eventDate;
  String endDate;
  String startTime;
  String endTime;
  String repeatingDays;
  String repeatingTime;
  List<Distance> distances;

  Event({
    required this.eventName,
    required this.eventDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.repeatingDays,
    required this.repeatingTime,
    required this.distances,

  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    eventName: json["eventName"].toString()??"",
    eventDate: json["eventDate"].toString()??"",
    endDate: json["endDate"].toString()??"",
    startTime: json["startTime"].toString()??"",
    endTime: json["endTime"].toString()??"",
    repeatingDays: json["repeatingDays"].toString()??"",
    repeatingTime: json["repeatingTime"].toString()??"",
    distances: List<Distance>.from(json["distances"].map((x) => Distance.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "eventName": eventName,
    "eventDate": eventDate,
    "endDate": endDate,
    "startTime": startTime,
    "endTime": endTime,
    "repeatingDays": repeatingDays,
    "repeatingTime": repeatingTime,
    "distances": List<dynamic>.from(distances.map((x) => x.toJson())),
  };
}

class Distance {
  String id;
  double distance;
  int unit;

  Distance({
    required this.id,
    required this.distance,
    required this.unit,
  });

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
    id: json["id"],
    distance: json["distance"]?.toDouble(),
    unit: json["unit"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "distance": distance,
    "unit": unit,
  };
}
