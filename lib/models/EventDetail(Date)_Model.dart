// // To parse this JSON data, do
// //
// //     final eventDateModel = eventDateModelFromJson(jsonString);
//
// import 'dart:convert';
//
// EventDateModel eventDateModelFromJson(String str) => EventDateModel.fromJson(json.decode(str));
//
// String eventDateModelToJson(EventDateModel data) => json.encode(data.toJson());
//
// class EventDateModel {
//   int code;
//   Data data;
//
//   EventDateModel({
//     required this.code,
//     required this.data,
//   });
//
//   factory EventDateModel.fromJson(Map<String, dynamic> json) => EventDateModel(
//     code: json["code"],
//     data: Data.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "code": code,
//     "data": data.toJson(),
//   };
// }
//
// class Data {
//   List<EventDatum> eventData;
//
//   Data({
//     required this.eventData,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     eventData: List<EventDatum>.from(json["eventData"].map((x) => EventDatum.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "eventData": List<dynamic>.from(eventData.map((x) => x.toJson())),
//   };
// }
//
// class EventDatum {
//   EventInfo eventInfo;
//   EventResults eventResults;
//   List<EventGallery> eventGallery;
//   EventPollClass eventPoll;
//
//   EventDatum({
//     required this.eventInfo,
//     required this.eventResults,
//     required this.eventGallery,
//     required this.eventPoll,
//   });
//
//   factory EventDatum.fromJson(Map<String, dynamic> json) => EventDatum(
//     eventInfo: EventInfo.fromJson(json["eventInfo"]),
//     eventResults: EventResults.fromJson(json["eventResults"]),
//     eventGallery: List<EventGallery>.from(json["eventGallery"].map((x) => EventGallery.fromJson(x))),
//     eventPoll: json["eventPoll"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "eventInfo": eventInfo.toJson(),
//     "eventResults": eventResults.toJson(),
//     "eventGallery": List<dynamic>.from(eventGallery.map((x) => x.toJson())),
//     "eventPoll": eventPoll,
//   };
// }
//
// class EventGallery {
//   String id;
//   String image;
//
//   EventGallery({
//     required this.id,
//     required this.image,
//   });
//
//   factory EventGallery.fromJson(Map<String, dynamic> json) => EventGallery(
//     id: json["id"],
//     image: json["image"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "image": image,
//   };
// }
//
// class EventInfo {
//   String id;
//   String title;
//   int dateType;
//   String isButtonAdded;
//   String buttonLable;
//   String buttonLink;
//   DateTime eventStartDate;
//   String eventEndDate;
//   String startTime;
//   String endTime;
//   String repeatingDays;
//   String repeatingTime;
//   int isEventLocation;
//   String locationName;
//   String googleAddress;
//   double latitude;
//   double longitude;
//   String eventInfo;
//   String? image;
//   int status;
//   List<Distance> distances;
//
//   EventInfo({
//     required this.id,
//     required this.title,
//     required this.dateType,
//     required this.isButtonAdded,
//     required this.buttonLable,
//     required this.buttonLink,
//     required this.eventStartDate,
//     required this.eventEndDate,
//     required this.startTime,
//     required this.endTime,
//     required this.repeatingDays,
//     required this.repeatingTime,
//     required this.isEventLocation,
//     required this.locationName,
//     required this.googleAddress,
//     required this.latitude,
//     required this.longitude,
//     required this.eventInfo,
//     required this.image,
//     required this.status,
//     required this.distances,
//   });
//
//   factory EventInfo.fromJson(Map<String, dynamic> json) => EventInfo(
//     id: json["id"].toString()??"",
//     title: json["title"].toString()??"",
//     dateType: json["dateType"]??0,
//     isButtonAdded: json["isButtonAdded"].toString()??"",
//     buttonLable: json["buttonLable"].toString()??"",
//     buttonLink: json["buttonLink"].toString()??"",
//     eventStartDate: DateTime.parse(json["eventStartDate"]),
//     eventEndDate: json["eventEndDate"].toString()??"",
//     startTime: json["startTime"].toString()??"",
//     endTime: json["endTime"].toString()??"",
//     repeatingDays: json["repeatingDays"].toString()??"",
//     repeatingTime: json["repeatingTime"].toString()??"",
//     isEventLocation: json["isEventLocation"]??0,
//     locationName: json["locationName"].toString()??"",
//     googleAddress: json["googleAddress"].toString()??"",
//     latitude: json["latitude"]?.toDouble(),
//     longitude: json["longitude"]?.toDouble(),
//     eventInfo: json["eventInfo"].toString()??"",
//     image: json["image"].toString()??"",
//     status: json["status"]??0,
//     distances: List<Distance>.from(json["distances"].map((x) => Distance.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "title": title,
//     "dateType": dateType,
//     "isButtonAdded": isButtonAdded,
//     "buttonLable": buttonLable,
//     "buttonLink": buttonLink,
//     "eventStartDate": "${eventStartDate.year.toString().padLeft(4, '0')}-${eventStartDate.month.toString().padLeft(2, '0')}-${eventStartDate.day.toString().padLeft(2, '0')}",
//     "eventEndDate": eventEndDate,
//     "startTime": startTime,
//     "endTime": endTime,
//     "repeatingDays": repeatingDays,
//     "repeatingTime": repeatingTime,
//     "isEventLocation": isEventLocation,
//     "locationName": locationName,
//     "googleAddress": googleAddress,
//     "latitude": latitude,
//     "longitude": longitude,
//     "eventInfo": eventInfo,
//     "image": image,
//     "status": status,
//     "distances": List<dynamic>.from(distances.map((x) => x.toJson())),
//   };
// }
//
// class Distance {
//   String id;
//   double distance;
//   int unit;
//
//   Distance({
//     required this.id,
//     required this.distance,
//     required this.unit,
//   });
//
//   factory Distance.fromJson(Map<String, dynamic> json) => Distance(
//     id: json["id"].toString()??"",
//     distance: json["distance"]?.toDouble(),
//     unit: json["unit"]??0,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "distance": distance,
//     "unit": unit,
//   };
// }
//
// class EventPollClass {
//   String questionId;
//   String question;
//   String myAnswerId;
//   int showParticipantDetails;
//   List<Answer> answers;
//
//   EventPollClass({
//     required this.questionId,
//     required this.question,
//     required this.myAnswerId,
//     required this.showParticipantDetails,
//     required this.answers,
//   });
//
//   factory EventPollClass.fromJson(Map<String, dynamic> json) => EventPollClass(
//     questionId: json["questionId"].toString()??"",
//     question: json["question"].toString()??"",
//     myAnswerId: json["myAnswerId"].toString()??"",
//     showParticipantDetails: json["showParticipantDetails"]??0,
//     answers: List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "questionId": questionId,
//     "question": question,
//     "myAnswerId": myAnswerId,
//     "showParticipantDetails": showParticipantDetails,
//     "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
//   };
// }
//
// class Answer {
//   String answerId;
//   String answer;
//   String voteCount;
//
//   Answer({
//     required this.answerId,
//     required this.answer,
//     required this.voteCount,
//   });
//
//   factory Answer.fromJson(Map<String, dynamic> json) => Answer(
//     answerId: json["answerId"],
//     answer: json["answer"],
//     voteCount: json["voteCount"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "answerId": answerId,
//     "answer": answer,
//     "voteCount": voteCount,
//   };
// }
//
// class EventResults {
//   String? id;
//   String? evDistancesId;
//   String? result;
//   String? pace;
//
//   EventResults({
//     this.id,
//     this.evDistancesId,
//     this.result,
//     this.pace,
//   });
//
//   factory EventResults.fromJson(Map<String, dynamic> json) => EventResults(
//     id: json["id"],
//     evDistancesId: json["evDistancesId"],
//     result: json["result"],
//     pace: json["pace"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "evDistancesId": evDistancesId,
//     "result": result,
//     "pace": pace,
//   };
// }



// To parse this JSON data, do
//
//     final eventDateModel = eventDateModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

EventDateModel eventDateModelFromJson(String str) => EventDateModel.fromJson(json.decode(str));

String eventDateModelToJson(EventDateModel data) => json.encode(data.toJson());

class EventDateModel {
  int code;
  Data data;

  EventDateModel({
    required this.code,
    required this.data,
  });

  factory EventDateModel.fromJson(Map<String, dynamic> json) => EventDateModel(
    code: json["code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<EventDatum> eventData;

  Data({
    required this.eventData,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    eventData: List<EventDatum>.from(json["eventData"].map((x) => EventDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "eventData": List<dynamic>.from(eventData.map((x) => x.toJson())),
  };
}

class EventDatum {
  EventInfo eventInfo;
  EventResults eventResults;
  List<EventGallery> eventGallery;
  List<EventResultList> eventResultList;
  EventPoll eventPoll;

  EventDatum({
    required this.eventInfo,
    required this.eventResults,
    required this.eventGallery,
    required this.eventResultList,
    required this.eventPoll,

  });

  factory EventDatum.fromJson(Map<String, dynamic> json) => EventDatum(
    eventInfo: EventInfo.fromJson(json["eventInfo"]),
    eventResults: EventResults.fromJson(json["eventResults"]),
    eventGallery: List<EventGallery>.from(json["eventGallery"].map((x) => EventGallery.fromJson(x))),
    eventResultList: json["eventResultList"] == null
        ? []
        : List<EventResultList>.from(json["eventResultList"].map((x) => EventResultList.fromJson(x))),
    eventPoll: EventPoll.fromJson(json["eventPoll"]),

  );

  Map<String, dynamic> toJson() => {
    "eventInfo": eventInfo.toJson(),
    "eventResults": eventResults.toJson(),
    "eventGallery": List<dynamic>.from(eventGallery.map((x) => x.toJson())),
    "eventResultList": List<dynamic>.from(eventResultList.map((x) => x.toJson())),
    "eventPoll": eventPoll,
  };
}

class EventGallery {
  String id;
  String image;
  String thumb_image;

  EventGallery({
    required this.id,
    required this.image,
    required this.thumb_image,
  });

  factory EventGallery.fromJson(Map<String, dynamic> json) => EventGallery(
    id: json["id"],
    image: json["image"],
    thumb_image: json["thumb_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "thumb_image": thumb_image,
  };
}

class EventInfo {
  String id;
  String title;
  int dateType;
  String eventStartDate;
  dynamic eventEndDate;
  String startTime;
  dynamic endTime;
  dynamic repeatingDays;
  dynamic repeatingTime;
  int isEventLocation;
  dynamic locationName;
  String googleAddress;
  double latitude;
  double longitude;
  int isButtonAdded;
  dynamic buttonLable;
  dynamic buttonLink;
  String eventInfo;
  String? image;
  String? originalImage;
  int status;
  List<Distance> distances;

  EventInfo({
    required this.id,
    required this.title,
    required this.dateType,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.startTime,
    required this.endTime,
    required this.repeatingDays,
    required this.repeatingTime,
    required this.isEventLocation,
    required this.locationName,
    required this.googleAddress,
    required this.latitude,
    required this.longitude,
    required this.isButtonAdded,
    required this.buttonLable,
    required this.buttonLink,
    required this.eventInfo,
    required this.image,
    required this.originalImage,
    required this.status,
    required this.distances,
  });

  factory EventInfo.fromJson(Map<String, dynamic> json) => EventInfo(
    id: json["id"]??"",
    title: json["title"]??"",
    dateType: json["dateType"]??0,
    eventStartDate: json["eventStartDate"]??"",
    eventEndDate: json["eventEndDate"],
    startTime: json["startTime"]??"",
    endTime: json["endTime"],
    repeatingDays: json["repeatingDays"],
    repeatingTime: json["repeatingTime"],
    isEventLocation: json["isEventLocation"],
    locationName: json["locationName"]??"",
    googleAddress: json["googleAddress"]??"",
    latitude: json["latitude"]?.toDouble()??0.0,
    longitude: json["longitude"]?.toDouble()??0.0,
    isButtonAdded: json["isButtonAdded"],
    buttonLable: json["buttonLable"],
    buttonLink: json["buttonLink"],
    eventInfo: json["eventInfo"],
    image: json["image"],
    originalImage: json["originalImage"],
    status: json["status"],
    distances: List<Distance>.from(json["distances"].map((x) => Distance.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "dateType": dateType,
    "eventStartDate": eventStartDate,/*"${eventStartDate.year.toString().padLeft(4, '0')}-${eventStartDate.month.toString().padLeft(2, '0')}-${eventStartDate.day.toString().padLeft(2, '0')}",*/
    "eventEndDate": eventEndDate,
    "startTime": startTime,
    "endTime": endTime,
    "repeatingDays": repeatingDays,
    "repeatingTime": repeatingTime,
    "isEventLocation": isEventLocation,
    "locationName": locationName,
    "googleAddress": googleAddress,
    "latitude": latitude,
    "longitude": longitude,
    "isButtonAdded": isButtonAdded,
    "buttonLable": buttonLable,
    "buttonLink": buttonLink,
    "eventInfo": eventInfo,
    "image": image,
    "originalImage": originalImage,
    "status": status,
    "distances": List<dynamic>.from(distances.map((x) => x.toJson())),
  };
}

class Distance {
  String id;
  double distance;
  int unit;

  Distance({
    required this.id,
    required this.distance,
    required this.unit,
  });

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
    id: json["id"]??"",
    distance: json["distance"]?.toDouble(),
    unit: json["unit"]??0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "distance": distance,
    "unit": unit,
  };
}

class EventPoll {
  String? questionId;
  String? question;
  String? myAnswerId;
  String? showParticipantDetails;
  List<Answer>? answers;


  EventPoll({
    this.questionId,
    this.question,
    this.myAnswerId,
    this.showParticipantDetails,
    this.answers,

  });

  factory EventPoll.fromJson(Map<String, dynamic> json) => EventPoll(
    questionId: json["questionId"].toString()??"",
    question: json["question"].toString()??"",
    myAnswerId: json["myAnswerId"].toString()??"",
    showParticipantDetails: json["showParticipantDetails"].toString()??"",
    answers: json["answers"] == null ? [] : List<Answer>.from(json["answers"]!.map((x) => Answer.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "question": question,
    "myAnswerId": myAnswerId,
    "showParticipantDetails": showParticipantDetails,
    "answers": answers == null ? [] : List<dynamic>.from(answers!.map((x) => x.toJson())),
  };
}

class Answer {
  String answerId;
  String answer;
  String voteCount;
  bool? viewVoter;
  Answer({
    required this.answerId,
    required this.answer,
    required this.voteCount,
     this.viewVoter,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    answerId: json["answerId"].toString()??"",
    answer: json["answer"].toString()??"",
    voteCount: json["voteCount"].toString()??"",
      viewVoter : false
  );

  Map<String, dynamic> toJson() => {
    "answerId": answerId,
    "answer": answer,
    "voteCount": voteCount,
  };
}

class EventResultList {
  dynamic distance;
  int distanceUnit;
  int genderCategory;
  List<Result> results;

  EventResultList({
    required this.distance,
    required this.distanceUnit,
    required this.genderCategory,
    required this.results,
  });

  factory EventResultList.fromJson(Map<String, dynamic> json) => EventResultList(
    distance: json["distance"]??"",
    distanceUnit: json["distanceUnit"]??0,
    genderCategory: json["genderCategory"]??0,
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "distance": distance,
    "distanceUnit": distanceUnit,
    "genderCategory": genderCategory,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  String id;
  String firstName;
  String lastName;
  String result;
  String pace;
  dynamic gender;
  dynamic age;

  Result({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.result,
    required this.pace,
    required this.gender,
    required this.age,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    firstName: json["firstName"].toString()??"",
    lastName: json["lastName"].toString()??"",
    result: json["result"],
    pace: json["pace"],
    gender: json["gender"],
    age: json["age"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "result": result,
    "pace": pace,
    "gender": gender,
    "age": age,
  };
}

class EventResults {
  String? id;
  String? evDistancesId;
  String? result;
  String? pace;
  String? evDistance;
  String? evDistanceUnit;
  String? editDistanceId;
  String? editEventId;
  String? editDistance;
  RxBool? isEditClicked;

  EventResults({
    this.id,
    this.evDistancesId,
    this.result,
    this.pace,
    this.evDistance,
    this.evDistanceUnit,
    this.editDistanceId,
    this.editEventId,
    this.editDistance,
    this.isEditClicked
  });

  factory EventResults.fromJson(Map<String, dynamic> json) => EventResults(
    id: json["id"]??"",
    evDistancesId: json["evDistancesId"]??"",
    result: json["result"]??"",
    pace: json["pace"]??"",
    evDistance: "",
    evDistanceUnit: "",
    editDistanceId: "",
    editEventId: "",
    editDistance: "",
    isEditClicked : false.obs
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "evDistancesId": evDistancesId,
    "result": result,
    "pace": pace,
  };
}
