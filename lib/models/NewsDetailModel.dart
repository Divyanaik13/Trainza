import 'dart:convert';

NewsDetailModel newsDetailModelFromJson(String str) => NewsDetailModel.fromJson(json.decode(str));

String newsDetailModelToJson(NewsDetailModel data) => json.encode(data.toJson());

class NewsDetailModel {
  String code;
  Data data;

  NewsDetailModel({
    required this.code,
    required this.data,
  });

  factory NewsDetailModel.fromJson(Map<String, dynamic> json) => NewsDetailModel(
    code: json["code"].toString()??"",
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<NewsDatum> newsData;

  Data({
    required this.newsData,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    newsData: List<NewsDatum>.from(json["newsData"].map((x) => NewsDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "newsData": List<dynamic>.from(newsData.map((x) => x.toJson())),
  };
}

class NewsDatum {
  String id;
  String title;
  String publicationDate;
  String publicationTime;
  String content;
  String isButtonAdded;
  String buttonLable;
  String buttonLink;
  String? featureImage;
  String? featureOriginalImage;
  List<NewsGallery> newsGallery;
  NewsPoll newsPoll;

  NewsDatum({
    required this.id,
    required this.title,
    required this.publicationDate,
    required this.publicationTime,
    required this.content,
    required this.isButtonAdded,
    required this.buttonLable,
    required this.buttonLink,
    required this.featureImage,
    required this.featureOriginalImage,
    required this.newsGallery,
    required this.newsPoll,
  });

  factory NewsDatum.fromJson(Map<String, dynamic> json) => NewsDatum(
    id: json["id"].toString()??"",
    title: json["title"].toString()??"",
    publicationDate:json["publicationDate"].toString()??"",
    publicationTime: json["publicationTime"].toString()??"",
    content: json["content"].toString()??"",
    isButtonAdded: json["isButtonAdded"].toString()??"",
    buttonLable: json["buttonLable"].toString()??"",
    buttonLink: json["buttonLink"].toString()??"",
    featureImage: json["featureImage"].toString()??"",
    featureOriginalImage: json["featureOriginalImage"].toString()??"",
    newsGallery: List<NewsGallery>.from(json["newsGallery"].map((x) => NewsGallery.fromJson(x))),
    newsPoll: NewsPoll.fromJson(json["newsPoll"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "publicationDate":publicationDate,
    "publicationTime": publicationTime,
    "content": content,
    "featureImage": featureImage,
    "featureOriginalImage": featureOriginalImage,
    "newsGallery": List<dynamic>.from(newsGallery.map((x) => x.toJson())),
    "newsPoll": newsPoll.toJson(),
  };
}

class NewsGallery {
  String id;
  String image;
  String thumb_image;

  NewsGallery({
    required this.id,
    required this.image,
    required this.thumb_image,
  });

  factory NewsGallery.fromJson(Map<String, dynamic> json) => NewsGallery(
    id: json["id"].toString()??"",
    image: json["image"].toString()??"",
    thumb_image: json["thumb_image"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "thumb_image": thumb_image,
  };
}

class NewsPoll {
  String? showParticipantDetails;
  String? questionId;
  String? question;
  String? myAnswerId;
  List<Answer>? answers;

  NewsPoll({
    this.showParticipantDetails,
    this.questionId,
    this.question,
    this.myAnswerId,
    this.answers,
  });

  factory NewsPoll.fromJson(Map<String, dynamic> json) => NewsPoll(
    showParticipantDetails: json["showParticipantDetails"].toString()??"",
    questionId: json["questionId"].toString()??"",
    question: json["question"].toString()??"",
    myAnswerId: json["myAnswerId"].toString()??"",
    answers: json["answers"] == null ? [] : List<Answer>.from(json["answers"]!.map((x) => Answer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "showParticipantDetails": showParticipantDetails,
    "questionId": questionId,
    "question": question,
    "myAnswerId": myAnswerId,
    "answers": answers == null ? [] : List<dynamic>.from(answers!.map((x) => x.toJson())),
  };
}

class Answer {
  String answerId;
  String answer;
  String votes;
  bool? viewVoter;

  Answer({
    required this.answerId,
    required this.answer,
    required this.votes,
    required this.viewVoter,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    answerId: json["answerId"].toString()??"",
    answer: json["answer"].toString()??"",
    votes: json["votes"].toString()??"",
    viewVoter: false
  );

  Map<String, dynamic> toJson() => {
    "answerId": answerId,
    "answer": answer,
    "votes": votes,
  };
}
