// To parse this JSON data, do
//
//     final logbookWorkoutTypeModel = logbookWorkoutTypeModelFromJson(jsonString);

import 'dart:convert';

LogbookWorkoutTypeModel logbookWorkoutTypeModelFromJson(String str) => LogbookWorkoutTypeModel.fromJson(json.decode(str));

String logbookWorkoutTypeModelToJson(LogbookWorkoutTypeModel data) => json.encode(data.toJson());

class LogbookWorkoutTypeModel {
  int code;
  List<WorkoutType> data;

  LogbookWorkoutTypeModel({
    required this.code,
    required this.data,
  });

  factory LogbookWorkoutTypeModel.fromJson(Map<String, dynamic> json) => LogbookWorkoutTypeModel(
    code: json["code"],
    data: List<WorkoutType>.from(json["data"].map((x) => WorkoutType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class WorkoutType {
  String id;
  String name;

  WorkoutType({
    required this.id,
    required this.name,
  });

  factory WorkoutType.fromJson(Map<String, dynamic> json) => WorkoutType(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
