// To parse this JSON data, do
//
//     final notificationListModel = notificationListModelFromJson(jsonString);

import 'dart:convert';

NotificationListModel notificationListModelFromJson(String str) => NotificationListModel.fromJson(json.decode(str));

String notificationListModelToJson(NotificationListModel data) => json.encode(data.toJson());

class NotificationListModel {
  int code;
  Data data;

  NotificationListModel({
    required this.code,
    required this.data,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) => NotificationListModel(
    code: json["code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<NotificationsList> notificationsList;
  bool loadMore;
  int count;

  Data({
    required this.notificationsList,
    required this.loadMore,
    required this.count,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    notificationsList: List<NotificationsList>.from(json["notificationsList"].map((x) => NotificationsList.fromJson(x))),
    loadMore: json["loadMore"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "notificationsList": List<dynamic>.from(notificationsList.map((x) => x.toJson())),
    "loadMore": loadMore,
    "count": count,
  };
}

class NotificationsList {
  String id;
  String? eventsId;
  String? newsId;
  String? trainingId;
  String notificationType;
  String message;
  int readStatus;
  DateTime createdAt;
  String eventDate;
  String trainingDate;
  String publicationDate;

  NotificationsList({
    required this.id,
    required this.eventsId,
    required this.newsId,
    required this.trainingId,
    required this.notificationType,
    required this.message,
    required this.readStatus,
    required this.createdAt,
    required this.eventDate,
    required this.trainingDate,
    required this.publicationDate,
  });

  factory NotificationsList.fromJson(Map<String, dynamic> json) => NotificationsList(
    id: json["id"]??"",
    eventsId: json["eventsId"]??"",
    newsId: json["newsId"]??"",
    trainingId: json["trainingId"]??"",
    notificationType: json["notificationType"]??"",
    message: json["message"]??"",
    readStatus: json["readStatus"],
    createdAt: DateTime.parse(json["createdAt"]),
    eventDate: json["eventDate"]??"",
    trainingDate: json["trainingDate"]??"",
    publicationDate: json["publicationDate"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "eventsId": eventsId,
    "newsId": newsId,
    "trainingId": trainingId,
    "notificationType": notificationType,
    "message": message,
    "readStatus": readStatus,
    "createdAt": createdAt.toIso8601String(),
    "eventDate": eventDate,
    "trainingDate": trainingDate,
    "publicationDate": publicationDate
  };
}
