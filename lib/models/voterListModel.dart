// To parse this JSON data, do
//
//     final voterListModel = voterListModelFromJson(jsonString);

import 'dart:convert';

VoterListModel voterListModelFromJson(String str) => VoterListModel.fromJson(json.decode(str));

String voterListModelToJson(VoterListModel data) => json.encode(data.toJson());

class VoterListModel {
  String code;
  Data data;

  VoterListModel({
    required this.code,
    required this.data,
  });

  factory VoterListModel.fromJson(Map<String, dynamic> json) => VoterListModel(
    code: json["code"].toString()??"",
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<PollVotersList> pollVotersList;
  String loadMore;
  String count;

  Data({
    required this.pollVotersList,
    required this.loadMore,
    required this.count,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pollVotersList: List<PollVotersList>.from(json["pollVotersList"].map((x) => PollVotersList.fromJson(x))),
    loadMore: json["loadMore"].toString()??"",
    count: json["count"].toString()??"",
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
