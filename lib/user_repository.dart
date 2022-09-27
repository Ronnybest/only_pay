import 'package:bcrypt/bcrypt.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:flutter/material.dart';
import 'models/mongodbmodels.dart';
import 'mongodbconnect.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class UserRepository {
  Future<MongoDbModel> connect(String userName, String login, String password,
      BuildContext context, String collectionName);
  Future<List<Map<String, dynamic>>> auth(String login, String password,
      BuildContext context, String collectionName, storage);
}

class ConnectAndRegistr implements UserRepository {
  @override
  Future<List<Map<String, dynamic>>> auth(String login, String password,
      BuildContext context, String collectionName, var storage) async {
    if (login.isNotEmpty && password.isNotEmpty) {
      var db = await MongoDB.connect();
      var collections = db.collection(collectionName);
      dynamic userPass = await MongoDB.getPass(collections, login);
      //String hashedPassInput = BCrypt.hashpw(password, BCrypt.gensalt());
      //print(hashedPassInput);
      //print(userPass[0]['password']);
      bool isCorrect = false;
      if (userPass.isNotEmpty) {
        isCorrect = BCrypt.checkpw(password, userPass[0]["password"]);
      }
      // ignore: dead_code
      if (isCorrect) {
        var data = collections.find(m.where.eq('login', login)).toList();
        var passwrd = await storage.write(key: 'pswrd', value: password);
        var lgn = await storage.write(key: 'lgn', value: login);
        return data;
      } else {
        throw RegException();
      }
    } else {
      throw RegException();
    }
  }

  @override
  Future<MongoDbModel> connect(String userName, String login, String password,
      BuildContext context, String collectionName) async {
    if (userName.isNotEmpty && login.isNotEmpty && password.isNotEmpty) {
      var db = await MongoDB.connect();
      var collections = db.collection(collectionName);
      var onlyOne = await collections.findOne(m.where.eq('login', login));
      var onlyOne2 =
          await collections.findOne(m.where.eq('username', userName));
      if (onlyOne == null && onlyOne2 == null) {
        var id = m.ObjectId();
        final data = MongoDbModel(
          id: id,
          username: userName,
          login: login,
          password: BCrypt.hashpw(password, BCrypt.gensalt()),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          v: 0,
        );
        await MongoDB.insert(data, collections);

        return data;
      } else {
        print('Login or UserName is busy');
        throw RegException();
      }
    } else {
      throw RegException();
    }
  }
}

class RegException implements Exception {}
