import 'package:only_pay/mongodbconnect.dart';

abstract class MainPageFunctions {
  Future<List<dynamic>> displayAllPosts(String collectionName);
}

class ActionsWithPosts extends MainPageFunctions {
  @override
  Future<List> displayAllPosts(String collectionName) async {
    try {
      var db = await MongoDB.connect();
      var collection = db.collection(collectionName);
      List<dynamic> allPosts = await MongoDB.getAllPosts(collection);
      return allPosts;
    } catch (e) {
      throw PostException();
    }
  }
}

class PostException implements Exception {}
