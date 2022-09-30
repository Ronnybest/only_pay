// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

CommentModel postModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String postModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  CommentModel({
    required this.id,
    required this.author,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String author;
  String text;
  String createdAt;
  String updatedAt;
  String v;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["_id"],
        author: json["author"],
        text: json["text"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["_v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "author": author,
        "text": text,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "_v": v,
      };
}
