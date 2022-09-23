// To parse this JSON data, do
//
//     final mongoDbModel = mongoDbModelFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbModel mongoDbModelFromJson(String str) =>
    MongoDbModel.fromJson(json.decode(str));

String mongoDbModelToJson(MongoDbModel data) => json.encode(data.toJson());

class MongoDbModel {
  MongoDbModel({
    required this.id,
    required this.username,
    required this.login,
    required this.password,
    required this.createTime,
    required this.v,
  });

  ObjectId id;
  String username;
  String login;
  String password;
  DateTime createTime;
  //DateTime updatedTime;
  int v;

  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
        id: json["_id"],
        username: json["username"],
        login: json["login"],
        password: json["password"],
        createTime: json["createTime"],
        v: json["v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "login": login,
        "password": password,
        "createTime": createTime,
        "v": v,
      };
}
