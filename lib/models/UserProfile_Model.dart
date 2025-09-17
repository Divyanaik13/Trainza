// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
  Data data;

  UserProfileModel({
    required this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  MemberInfo memberInfo;
  List<PersonalBest> personalBests;
  List<EventResult> eventResults;

  Data({
    required this.memberInfo,
    required this.personalBests,
    required this.eventResults,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    memberInfo: MemberInfo.fromJson(json["memberInfo"]),
    personalBests: List<PersonalBest>.from(json["personalBests"].map((x) => PersonalBest.fromJson(x))),
    eventResults: List<EventResult>.from(json["eventResults"].map((x) => EventResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "memberInfo": memberInfo.toJson(),
    "personalBests": List<dynamic>.from(personalBests.map((x) => x.toJson())),
    "eventResults": List<dynamic>.from(eventResults.map((x) => x.toJson())),
  };
}

class EventResult {
  String id;
  String title;
  String result;
  String pace;
  String distance;
  String distanceUnit;
  String eventDate;

  EventResult({
    required this.id,
    required this.title,
    required this.result,
    required this.pace,
    required this.distance,
    required this.distanceUnit,
    required this.eventDate,
  });

  factory EventResult.fromJson(Map<String, dynamic> json) => EventResult(
    id: json["id"].toString()??"",
    title: json["title"].toString()??"",
    result: json["result"].toString()??"",
    pace: json["pace"].toString()??"",
    distance: json["distance"].toString()??"",
    distanceUnit: json["distanceUnit"].toString()??"",
    eventDate: json["eventDate"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "result": result,
    "pace": pace,
    "distance": distance,
    "distanceUnit": distanceUnit,
    "eventDate":eventDate,
  };
}

class MemberInfo {
  String firstName;
  String lastName;
  String email;
  String isEmailPubliclyShared;
  String phoneDialCode;
  String phoneCountryCode;
  String phoneNumber;
  String isNumberPubliclyShared;
  String dateOfBirth;
  String gender;
  String height;
  String heightDescription;
  String weight;
  String weightDescription;
  String countryMeta;
  String country;
  String stateMeta;
  String state;
  String town;
  String status;
  String profilePicture;
  String bibNumber;

  MemberInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isEmailPubliclyShared,
    required this.phoneDialCode,
    required this.phoneCountryCode,
    required this.phoneNumber,
    required this.isNumberPubliclyShared,
    required this.dateOfBirth,
    required this.gender,
    required this.height,
    required this.heightDescription,
    required this.weight,
    required this.weightDescription,
    required this.countryMeta,
    required this.country,
    required this.stateMeta,
    required this.state,
    required this.town,
    required this.status,
    required this.profilePicture,
    required this.bibNumber,
  });

  factory MemberInfo.fromJson(Map<String, dynamic> json) => MemberInfo(
    firstName: json["firstName"]??"",
    lastName: json["lastName"]??"",
    email: json["email"]??"",
    isEmailPubliclyShared: json["isEmailPubliclyShared"].toString()??"",
    phoneDialCode: json["phoneDialCode"]??"",
    phoneCountryCode: json["phoneCountryCode"]??"",
    phoneNumber: json["phoneNumber"]??"",
    isNumberPubliclyShared: json["isNumberPubliclyShared"].toString()??"",
    dateOfBirth: json["dateOfBirth"]??"",
    gender: json["gender"].toString()??"",
    height: json["height"]??"",
    heightDescription: json["heightDescription"]??"",
    weight: json["weight"]??"",
    weightDescription: json["weightDescription"]??"",
    countryMeta: json["countryMeta"]??"",
    country: json["country"]??"",
    stateMeta: json["stateMeta"]??"",
    state: json["state"]??"",
    town: json["town"]??"",
    status: json["status"].toString()??"",
    profilePicture: json["profilePicture"]??"",
    bibNumber: json["bibNumber"]??"",
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "isEmailPubliclyShared": isEmailPubliclyShared,
    "phoneDialCode": phoneDialCode,
    "phoneCountryCode": phoneCountryCode,
    "phoneNumber": phoneNumber,
    "isNumberPubliclyShared": isNumberPubliclyShared,
    "dateOfBirth": dateOfBirth,
    "gender": gender,
    "height": height,
    "heightDescription": heightDescription,
    "weight": weight,
    "weightDescription": weightDescription,
    "countryMeta": countryMeta,
    "country": country,
    "stateMeta": stateMeta,
    "state": state,
    "town": town,
    "status": status,
    "profilePicture": profilePicture,
    "bibNumber": bibNumber,
  };
}

class PersonalBest {
  String distanceId;
  String distance;
  String unit;
  String bestTime;

  PersonalBest({
    required this.distanceId,
    required this.distance,
    required this.unit,
    required this.bestTime,
  });

  factory PersonalBest.fromJson(Map<String, dynamic> json) => PersonalBest(
    distanceId: json["distanceId"].toString()??"",
    distance: json["distance"].toString()??"",
    unit: json["unit"].toString()??"",
    bestTime: json["bestTime"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "distanceId": distanceId,
    "distance": distance,
    "unit": unit,
    "bestTime": bestTime,
  };
}
