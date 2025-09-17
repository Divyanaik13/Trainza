// To parse this JSON data, do
//
//     final notificationPayloadModel = notificationPayloadModelFromJson(jsonString);

import 'dart:convert';

NotificationPayloadModel notificationPayloadModelFromJson(String str) => NotificationPayloadModel.fromJson(json.decode(str));

String notificationPayloadModelToJson(NotificationPayloadModel data) => json.encode(data.toJson());

class NotificationPayloadModel {
  String notificationType;
  String date;
  String referenceId;
  String notificationId;

  NotificationPayloadModel({
    required this.notificationType,
    required this.date,
    required this.referenceId,
    required this.notificationId,
  });

  factory NotificationPayloadModel.fromJson(Map<String, dynamic> json) => NotificationPayloadModel(
    notificationType: json["notification_type"].toString() ?? "",
    date: json["date"].toString() ?? "",
    referenceId: json["reference_id"].toString() ?? "",
    notificationId: json["notification_id"].toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "notification_type": notificationType,
    "date": date,
    "reference_id": referenceId,
    "notification_id": notificationId,
  };
}
