import 'package:dbcrypt/dbcrypt.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:flutter/material.dart';
import 'models/mongodbmodels.dart';
import 'mongodbconnect.dart';

abstract class UserRepository {
  Future<MongoDbModel> connect(String userName, String login, String password,
      BuildContext context, String collectionName);
}

class ConnectAndRegistr implements UserRepository {
  @override
  Future<MongoDbModel> connect(String userName, String login, String password,
      BuildContext context, String collectionName) async {
    if (userName.isNotEmpty && login.isNotEmpty && password.isNotEmpty) {
      var db = await MongoDB.connect();
      var collections = db.collection(collectionName);
      var id = m.ObjectId();
      final data = MongoDbModel(
        id: id,
        username: userName,
        login: login,
        password: DBCrypt().hashpw(password, DBCrypt().gensalt()),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 0,
      );
      await MongoDB.insert(data, collections);
      return data;
    } else {
      throw RegException();
    }
  }
}

class RegException implements Exception {}
