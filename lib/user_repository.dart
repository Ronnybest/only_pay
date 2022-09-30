import 'package:bcrypt/bcrypt.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:flutter/material.dart';
import 'models/mongodbmodels.dart';
import 'mongodbconnect.dart';
import 'dart:convert';

abstract class UserRepository {
  Future<Map<String, dynamic>> connect(String userName, String login,
      String password, BuildContext context, String collectionName);
  Future<Map<String, dynamic>> auth(String login, String password,
      BuildContext context, String collectionName, storage);
}

class ConnectAndRegistr implements UserRepository {
  @override
  Future<Map<String, dynamic>> auth(String login, String password,
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
        var data = await collections.findOne(m.where.eq('login', login));
        await storage.write(key: 'pswrd', value: password);
        await storage.write(key: 'lgn', value: login);
        return data as Map<String, dynamic>;
      } else {
        throw RegException();
      }
    } else {
      throw RegException();
    }
  }

  @override
  Future<Map<String, dynamic>> connect(String userName, String login,
      String password, BuildContext context, String collectionName) async {
    if (userName.isNotEmpty && login.isNotEmpty && password.isNotEmpty) {
      var db = await MongoDB.connect();
      var collections = db.collection(collectionName);
      var onlyOne = await collections.findOne(m.where.eq('login', login));
      var onlyOne2 =
          await collections.findOne(m.where.eq('username', userName));
      if (onlyOne == null && onlyOne2 == null) {
        var id = m.ObjectId();
        final data = await MongoDbModel(
          id: id,
          username: userName,
          login: login,
          password: BCrypt.hashpw(password, BCrypt.gensalt()),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          v: 0,
        );
        await MongoDB.insert(data, collections);
        Map<String, dynamic> res = {
          'id': data.id,
          'username': data.username,
          'createdAt': data.createdAt,
          'updatedAt': data.updatedAt,
          'login': data.login,
          'password': data.password,
          'v': data.v,
        };
        return res;
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
