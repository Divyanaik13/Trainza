import 'dart:convert';

NewsListModel newsListModelFromJson(String str) => NewsListModel.fromJson(json.decode(str));

String newsListModelToJson(NewsListModel data) => json.encode(data.toJson());

class NewsListModel {
  String code;
  Data data;

  NewsListModel({
    required this.code,
    required this.data,
  });

  factory NewsListModel.fromJson(Map<String, dynamic> json) => NewsListModel(
    code: json["code"].toString()??"",
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  List<NewsList> newsList;
  String loadMore;
  String count;

  Data({
    required this.newsList,
    required this.loadMore,
    required this.count,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    newsList: List<NewsList>.from(json["newsList"].map((x) => NewsList.fromJson(x))),
    loadMore: json["loadMore"].toString()??"",
    count: json["count"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "newsList": List<dynamic>.from(newsList.map((x) => x.toJson())),
    "loadMore": loadMore,
    "count": count,
  };
}

class NewsList {
  String id;
  String title;
  DateTime publicationDate;
  String publicationTime;
  String status;
  String featureImage;

  NewsList({
    required this.id,
    required this.title,
    required this.publicationDate,
    required this.publicationTime,
    required this.status,
    required this.featureImage,
  });

  factory NewsList.fromJson(Map<String, dynamic> json) => NewsList(
    id: json["id"].toString()??"",
    title: json["title"].toString()??"",
    publicationDate: DateTime.parse(json["publicationDate"]),
    publicationTime: json["publicationTime"].toString()??"",
    status: json["status"].toString()??"",
    featureImage: json["featureImage"].toString()??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "publicationDate": publicationDate,
    "publicationTime": publicationTime,
    "status": status,
    "featureImage": featureImage,
  };
}
