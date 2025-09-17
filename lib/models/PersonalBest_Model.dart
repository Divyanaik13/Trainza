import 'dart:convert';

PersonalBestModel personalBestModelFromJson(String str) => PersonalBestModel.fromJson(json.decode(str));

String personalBestModelToJson(PersonalBestModel data) => json.encode(data.toJson());

class PersonalBestModel {
  int code;
  Data data;

  PersonalBestModel({
    required this.code,
    required this.data,
  });

  factory PersonalBestModel.fromJson(Map<String, dynamic> json) => PersonalBestModel(
    code: json["code"]??500,
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<PersonalBestList> personalBestList;

  Data({
    required this.personalBestList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    personalBestList: List<PersonalBestList>.from(json["personalBestList"].map((x) => PersonalBestList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "personalBestList": List<dynamic>.from(personalBestList.map((x) => x.toJson())),
  };
}

class PersonalBestList {
  String id;
  String distanceId;
  String distance;
  String unit;
  String bestTime;

  PersonalBestList({
    required this.id,
    required this.distanceId,
    required this.distance,
    required this.unit,
    required this.bestTime,
  });

  factory PersonalBestList.fromJson(Map<String, dynamic> json) => PersonalBestList(
    id: json["id"].toString()??"",
    distanceId: json["distanceId"].toString()??"",
    distance: json["distance"].toString()??"",
    unit: json["unit"].toString()??"",
    bestTime: json["bestTime"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "distanceId": distanceId,
    "distance": distance,
    "unit": unit,
    "bestTime": bestTime,
  };
}
