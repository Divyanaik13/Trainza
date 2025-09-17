import 'dart:convert';

NewsAvailableDateModel newsAvailableDateModelFromJson(String str) => NewsAvailableDateModel.fromJson(json.decode(str));

String newsAvailableDateModelToJson(NewsAvailableDateModel data) => json.encode(data.toJson());

class NewsAvailableDateModel {
  String code;
  Data data;

  NewsAvailableDateModel({
    required this.code,
    required this.data,
  });

  factory NewsAvailableDateModel.fromJson(Map<String, dynamic> json) => NewsAvailableDateModel(
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
  List<String> newsDates;

  Data({
    required this.year,
    required this.month,
    required this.newsDates,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    year: json["year"].toString()??"",
    month: json["month"].toString()??"",
    newsDates: List<String>.from(json["dates"].map((x) => x.toString())),
  );

  Map<String, dynamic> toJson() => {
    "year": year,
    "month": month,
    "newsDates": List<dynamic>.from(newsDates.map((x) => x.toString())),
  };
}
