import 'dart:convert';

TrainingListModel trainingListModelFromJson(String str) =>
    TrainingListModel.fromJson(json.decode(str));

String trainingListModelToJson(TrainingListModel data) =>
    json.encode(data.toJson());

class TrainingListModel {
  int code;
  Data data;

  TrainingListModel({
    required this.code,
    required this.data,
  });

  factory TrainingListModel.fromJson(Map<String, dynamic> json) =>
      TrainingListModel(
        code: json["code"],
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
      };
}

class Data {
  List<TrainingList> trainingList;
  int count;
  List<DateTime> calendarData;
  List<BirthDayDatum> birthDayData;

  Data({
    required this.trainingList,
    required this.count,
    required this.calendarData,
    required this.birthDayData,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        trainingList: json["trainingList"] != null
            ? List<TrainingList>.from(
                json["trainingList"].map((x) => TrainingList.fromJson(x)))
            : [],
        count: json["count"] ?? 0,
        calendarData: json["calendarData"] != null
            ? List<DateTime>.from(
                json["calendarData"].map((x) => DateTime.parse(x)))
            : [],
        birthDayData: List<BirthDayDatum>.from(
            json["birthDayData"].map((x) => BirthDayDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "trainingList": List<dynamic>.from(trainingList.map((x) => x.toJson())),
        "count": count,
        "calendarData": List<dynamic>.from(calendarData.map((x) =>
            "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "birthDayData": List<dynamic>.from(birthDayData.map((x) => x.toJson())),
      };
}

class BirthDayDatum {
  String id;
  String firstName;
  String lastName;
  String profilePicture;

  BirthDayDatum({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  factory BirthDayDatum.fromJson(Map<String, dynamic> json) => BirthDayDatum(
        id: json["id"]??"",
        firstName: json["firstName"]??"",
        lastName: json["lastName"]??"",
        profilePicture: json["profilePicture"]??"",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "profilePicture": profilePicture,
      };
}

class TrainingList {
  String id;
  int isAnytime;
  String trainingTime;
  Workout workout;
  List<Group> groups;
  RouteInfo routeInfo;

  TrainingList({
    required this.id,
    required this.isAnytime,
    required this.trainingTime,
    required this.workout,
    required this.groups,
    required this.routeInfo,
  });

  factory TrainingList.fromJson(Map<String, dynamic> json) => TrainingList(
        id: json["id"]?.toString() ?? "",
        isAnytime: json["isAnytime"] ?? 0,
        trainingTime: json["trainingTime"] ?? "",
        workout: Workout.fromJson(json["workout"] ?? {}),
        groups: json["groups"] != null
            ? List<Group>.from(json["groups"].map((x) => Group.fromJson(x)))
            : [],
        routeInfo: RouteInfo.fromJson(json["routeInfo"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isAnytime": isAnytime,
        "trainingTime": trainingTime,
        "workout": workout.toJson(),
        "groups": List<dynamic>.from(groups.map((x) => x.toJson())),
        "routeInfo": routeInfo.toJson(),
      };
}

class Group {
  String name;
  String subtitle;

  Group({
    required this.name,
    required this.subtitle,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        name: json["name"]?.toString() ?? "",
        subtitle: json["subtitle"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "subtitle": subtitle,
      };
}

class RouteInfo {
  String id;
  String routeName;
  String routeDetail;
  String distance;
  int distanceUnit;
  String routeLink;
  String routeImage;

  RouteInfo({
    required this.id,
    required this.routeName,
    required this.routeDetail,
    required this.distance,
    required this.distanceUnit,
    required this.routeLink,
    required this.routeImage,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) => RouteInfo(
        id: json["id"]?.toString() ?? "",
        routeName: json["routeName"]?.toString() ?? "",
        routeDetail: json["routeDetail"]?.toString() ?? "",
        distance: json["distance"].toString() ?? "",
        distanceUnit: json["distanceUnit"] ?? 0,
        routeLink: json["routeLink"]?.toString() ?? "",
        routeImage: json["routeImage"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "routeName": routeName,
        "routeDetail": routeDetail,
        "distance": distance,
        "distanceUnit": distanceUnit,
        "routeLink": routeLink,
        "routeImage": routeImage,
      };
}

class Workout {
  String workoutTypeId;
  String details;
  String workoutType;
  String videoLink;
  List<String> images;

  Workout({
    required this.workoutTypeId,
    required this.details,
    required this.workoutType,
    required this.videoLink,
    required this.images,
  });

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        workoutTypeId: json["workoutTypeId"]?.toString() ?? "",
        details: json["details"]?.toString() ?? "",
        workoutType: json["workoutType"]?.toString() ?? "",
        videoLink: json["videoLink"]?.toString() ?? "",
        images: json["images"] != null
            ? List<String>.from(json["images"].map((x) => x.toString()))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "workoutTypeId": workoutTypeId,
        "details": details,
        "workoutType": workoutType,
        "videoLink": videoLink,
        "images": List<String>.from(images.map((x) => x)),
      };
}
