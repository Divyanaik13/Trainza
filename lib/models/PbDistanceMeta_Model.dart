// To parse this JSON data, do
//
//     final pbDistanceMetaModel = pbDistanceMetaModelFromJson(jsonString);

import 'dart:convert';

PbDistanceMetaModel pbDistanceMetaModelFromJson(String str) => PbDistanceMetaModel.fromJson(json.decode(str));

String pbDistanceMetaModelToJson(PbDistanceMetaModel data) => json.encode(data.toJson());

class PbDistanceMetaModel {
  int code;
  Data data;

  PbDistanceMetaModel({
    required this.code,
    required this.data,
  });

  factory PbDistanceMetaModel.fromJson(Map<String, dynamic> json) => PbDistanceMetaModel(
    code: json["code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<PersonalBestDistanceMeta> personalBestDistanceMeta;

  Data({
    required this.personalBestDistanceMeta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    personalBestDistanceMeta: List<PersonalBestDistanceMeta>.from(json["personalBestDistanceMeta"].map((x) => PersonalBestDistanceMeta.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "personalBestDistanceMeta": List<dynamic>.from(personalBestDistanceMeta.map((x) => x.toJson())),
  };
}

class PersonalBestDistanceMeta {
  String id;
  String distance;
  String distanceUnit;

  PersonalBestDistanceMeta({
    required this.id,
    required this.distance,
    required this.distanceUnit,
  });

  factory PersonalBestDistanceMeta.fromJson(Map<String, dynamic> json) => PersonalBestDistanceMeta(
    id: json["id"],
    distance: json["distance"].toString()??"",
    distanceUnit: json["distance_unit"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "distance": distance,
    "distance_unit": distanceUnit,
  };
}
