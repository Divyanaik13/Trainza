// To parse this JSON data, do
//
//     final countryListModel = countryListModelFromJson(jsonString);

import 'dart:convert';

CountryListModel countryListModelFromJson(String str) => CountryListModel.fromJson(json.decode(str));

String countryListModelToJson(CountryListModel data) => json.encode(data.toJson());

class CountryListModel {
  List<CountryMeta> countryMeta;

  CountryListModel({
    required this.countryMeta,
  });

  factory CountryListModel.fromJson(Map<String, dynamic> json) => CountryListModel(
    countryMeta: List<CountryMeta>.from(json["countryMeta"].map((x) => CountryMeta.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "countryMeta": List<dynamic>.from(countryMeta.map((x) => x.toJson())),
  };
}

class CountryMeta {
  String id;
  String name;
  String isoCode;

  CountryMeta({
    required this.id,
    required this.name,
    required this.isoCode,
  });

  factory CountryMeta.fromJson(Map<String, dynamic> json) => CountryMeta(
    id: json["id"]??"",
    name: json["name"]??"",
    isoCode: json["isoCode"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "isoCode": isoCode,
  };
}
