// To parse this JSON data, do
//
//     final eventPollVoters = eventPollVotersFromJson(jsonString);

import 'dart:convert';

EventPollVoters eventPollVotersFromJson(String str) => EventPollVoters.fromJson(json.decode(str));

String eventPollVotersToJson(EventPollVoters data) => json.encode(data.toJson());

class EventPollVoters {
  int code;
  Data data;

  EventPollVoters({
    required this.code,
    required this.data,
  });

  factory EventPollVoters.fromJson(Map<String, dynamic> json) => EventPollVoters(
    code: json["code"]??0,
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code??500,
    "data": data.toJson(),
  };
}

class Data {
  List<PollVotersList> pollVotersList;
  bool loadMore;
  int count;

  Data({
    required this.pollVotersList,
    required this.loadMore,
    required this.count,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pollVotersList: List<PollVotersList>.from(json["pollVotersList"].map((x) => PollVotersList.fromJson(x))),
    loadMore: json["loadMore"] ?? false,

    count: json["count"]??0,
  );

  Map<String, dynamic> toJson() => {
    "pollVotersList": List<dynamic>.from(pollVotersList.map((x) => x.toJson())),
    "loadMore": loadMore,
    "count": count,
  };
}

class PollVotersList {
  String id;
  String firstName;
  String lastName;
  String profilePicture;

  PollVotersList({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  factory PollVotersList.fromJson(Map<String, dynamic> json) => PollVotersList(
    id: json["id"].toString()??"",
    firstName: json["firstName"].toString()??"",
    lastName: json["lastName"].toString()??"",
    profilePicture: json["profilePicture"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profilePicture": profilePicture,
  };
}
