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
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  ObjectId id;
  String username;
  String login;
  String password;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
        id: json["_id"],
        username: json["username"],
        login: json["login"],
        password: json["password"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "login": login,
        "password": password,
        "createAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}
