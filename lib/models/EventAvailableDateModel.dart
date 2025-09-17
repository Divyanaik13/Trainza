import 'dart:convert';

EventAvailableDateModel eventAvailableDateModelFromJson(String str) => EventAvailableDateModel.fromJson(json.decode(str));

String eventAvailableDateModelToJson(EventAvailableDateModel data) => json.encode(data.toJson());

class EventAvailableDateModel {
  String code;
  Data data;

  EventAvailableDateModel({
    required this.code,
    required this.data,
  });

  factory EventAvailableDateModel.fromJson(Map<String, dynamic> json) => EventAvailableDateModel(
    code: json["code"].toString()??"",
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  String year;
  String month;
  List<String> eventDates;

  Data({
    required this.year,
    required this.month,
    required this.eventDates,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    year: json["year"].toString()??"",
    month: json["month"].toString()??"",
    eventDates: List<String>.from(json["dates"].map((x) => x.toString())),
  );

  Map<String, dynamic> toJson() => {
    "year": year,
    "month": month,
    "dates": List<dynamic>.from(eventDates.map((x) => x.toString())),
  };
}
