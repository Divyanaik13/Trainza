// To parse this JSON data, do
//
//     final resultEventsDistanceDataModel = resultEventsDistanceDataModelFromJson(jsonString);

import 'dart:convert';

ResultEventsDistanceDataModel resultEventsDistanceDataModelFromJson(String str) => ResultEventsDistanceDataModel.fromJson(json.decode(str));

String resultEventsDistanceDataModelToJson(ResultEventsDistanceDataModel data) => json.encode(data.toJson());

class ResultEventsDistanceDataModel {
  List<EventsDistanceList> eventsDistanceData;

  ResultEventsDistanceDataModel({
    required this.eventsDistanceData,
  });

  factory ResultEventsDistanceDataModel.fromJson(Map<String, dynamic> json) => ResultEventsDistanceDataModel(
    eventsDistanceData: List<EventsDistanceList>.from(json["eventsDistanceData"].map((x) => EventsDistanceList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "eventsDistanceData": List<dynamic>.from(eventsDistanceData.map((x) => x.toJson())),
  };
}

class EventsDistanceList {
  String id;
  String eventName;
  DateTime eventDate;
  List<Distance> distances;

  EventsDistanceList({
    required this.id,
    required this.eventName,
    required this.eventDate,
    required this.distances,
  });

  factory EventsDistanceList.fromJson(Map<String, dynamic> json) => EventsDistanceList(
    id: json["id"],
    eventName: json["eventName"],
    eventDate: DateTime.parse(json["eventDate"]),
    distances: List<Distance>.from(json["distances"].map((x) => Distance.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "eventName": eventName,
    "eventDate": "${eventDate.year.toString().padLeft(4, '0')}-${eventDate.month.toString().padLeft(2, '0')}-${eventDate.day.toString().padLeft(2, '0')}",
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
