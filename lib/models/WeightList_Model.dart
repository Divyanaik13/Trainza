// To parse this JSON data, do
//
//     final weightListModel = weightListModelFromJson(jsonString);

import 'dart:convert';

WeightListModel weightListModelFromJson(String str) => WeightListModel.fromJson(json.decode(str));

String weightListModelToJson(WeightListModel data) => json.encode(data.toJson());

class WeightListModel {
  List<WeightMeta> weightMeta;

  WeightListModel({
    required this.weightMeta,
  });

  factory WeightListModel.fromJson(Map<String, dynamic> json) => WeightListModel(
    weightMeta: List<WeightMeta>.from(json["weightMeta"].map((x) => WeightMeta.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "weightMeta": List<dynamic>.from(weightMeta.map((x) => x.toJson())),
  };
}

class WeightMeta {
  String id;
  String weight;

  WeightMeta({
    required this.id,
    required this.weight,
  });

  factory WeightMeta.fromJson(Map<String, dynamic> json) => WeightMeta(
    id: json["id"],
    weight: json["weight"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "weight": weight,
  };
}
