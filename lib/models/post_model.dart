// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:only_pay/models/comments_model.dart';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  PostModel({
    required this.id,
    required this.title,
    required this.text,
    required this.imgUrl,
    required this.view,
    required this.author,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  ObjectId id;
  String title;
  String text;
  String imgUrl;
  int view;
  String author;
  List<CommentModel> comments;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["_id"],
        title: json["title"],
        text: json["text"],
        imgUrl: json["imgURL"],
        view: json["view"],
        author: json["author"],
        comments: json["comments"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["_v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "text": text,
        "imgURL": imgUrl,
        "view": view,
        "author": author,
        "comments": comments,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "_v": v,
      };
}
