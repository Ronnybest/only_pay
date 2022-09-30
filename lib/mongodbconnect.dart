import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:only_pay/constant/constants.dart';
import 'package:only_pay/models/mongodbmodels.dart';

class MongoDB {
  static Future<Db> connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    return db;
  }

  static Future<String> insert(
      MongoDbModel data, DbCollection collectionName) async {
    try {
      var result = await collectionName.insertOne(data.toJson());
      return result.isSuccess ? 'Data insert' : 'Something wrong with insert';
    } catch (e) {
      return e.toString();
    }
  }

  static Future<dynamic> getPass(
      DbCollection collectionName, String login) async {
    try {
      dynamic result = await collectionName
          .find(where.eq('login', login).fields(['password']))
          .toList();
      return result;
    } catch (e) {
      return new List.empty();
    }
  }

  static Future<dynamic> getAllPosts(DbCollection collectionName) async {
    try {
      dynamic result = await collectionName.find().toList();
      return result;
    } catch (e) {
      return e.toString();
    }
  }
}
