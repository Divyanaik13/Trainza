// To parse this JSON data, do
//
//     final heightListModel = heightListModelFromJson(jsonString);

import 'dart:convert';

HeightListModel heightListModelFromJson(String str) => HeightListModel.fromJson(json.decode(str));

String heightListModelToJson(HeightListModel data) => json.encode(data.toJson());

class HeightListModel {
  List<HeightMeta> heightMeta;

  HeightListModel({
    required this.heightMeta,
  });

  factory HeightListModel.fromJson(Map<String, dynamic> json) => HeightListModel(
    heightMeta: List<HeightMeta>.from(json["heightMeta"].map((x) => HeightMeta.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "heightMeta": List<dynamic>.from(heightMeta.map((x) => x.toJson())),
  };
}

class HeightMeta {
  String id;
  String height;

  HeightMeta({
    required this.id,
    required this.height,
  });

  factory HeightMeta.fromJson(Map<String, dynamic> json) => HeightMeta(
    id: json["id"]??"",
    height: json["height"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "height": height,
  };
}
