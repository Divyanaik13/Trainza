// To parse this JSON data, do
//
//     final stateListModel = stateListModelFromJson(jsonString);

import 'dart:convert';

StateListModel stateListModelFromJson(String str) => StateListModel.fromJson(json.decode(str));

String stateListModelToJson(StateListModel data) => json.encode(data.toJson());

class StateListModel {
  List<StateMeta> stateMeta;

  StateListModel({
    required this.stateMeta,
  });

  factory StateListModel.fromJson(Map<String, dynamic> json) => StateListModel(
    stateMeta: List<StateMeta>.from(json["stateMeta"].map((x) => StateMeta.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "stateMeta": List<dynamic>.from(stateMeta.map((x) => x.toJson())),
  };
}

class StateMeta {
  String id;
  String name;
  String isoCode;

  StateMeta({
    required this.id,
    required this.name,
    required this.isoCode,
  });

  factory StateMeta.fromJson(Map<String, dynamic> json) => StateMeta(
    id: json["id"],
    name: json["name"],
    isoCode: json["isoCode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "isoCode": isoCode,
  };
}
