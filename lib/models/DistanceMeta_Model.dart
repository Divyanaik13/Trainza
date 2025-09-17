import 'dart:convert';

DistanceMetaModel distanceMetaModelFromJson(String str) => DistanceMetaModel.fromJson(json.decode(str));

String distanceMetaModelToJson(DistanceMetaModel data) => json.encode(data.toJson());

class DistanceMetaModel {
  int code;
  Data data;

  DistanceMetaModel({
    required this.code,
    required this.data,
  });

  factory DistanceMetaModel.fromJson(Map<String, dynamic> json) => DistanceMetaModel(
    code: json["code"]??500,
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<DistanceMeta> distanceMeta;

  Data({
    required this.distanceMeta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    distanceMeta: List<DistanceMeta>.from(json["distanceMeta"].map((x) => DistanceMeta.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "distanceMeta": List<dynamic>.from(distanceMeta.map((x) => x.toJson())),
  };
}

class DistanceMeta {
  String id;
  String distance;
  String distanceUnit;

  DistanceMeta({
    required this.id,
    required this.distance,
    required this.distanceUnit,
  });

  factory DistanceMeta.fromJson(Map<String, dynamic> json) => DistanceMeta(
      id: json["id"].toString()??"",
      distance: json["distance"].toString()??"",
      distanceUnit: json["distance_unit"].toString()??""
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "distance": distance,
    "distance_unit": distanceUnit,
  };
}
