import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:only_pay/models/mongodbmodels.dart';

import 'package:only_pay/mongodbconnect.dart';

import '../constant/constants.dart';

class Registration extends StatelessWidget {
  var collections;
  Future<M.DbCollection> connection() async {
    var db = await MongoDB.connect();
    collections = db.collection(COLLECTION_NAME);
    return collections;
  }

  var userNameController = TextEditingController();
  var loginController = TextEditingController();
  var passwordController = TextEditingController();
  Future<void> insertData(String userName, String login, String password,
      BuildContext context) async {
    if (userNameController.text.isNotEmpty &&
        loginController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      var _id = M.ObjectId();
      final data = MongoDbModel(
        id: _id,
        username: userNameController.text,
        login: loginController.text,
        password: passwordController.text,
        createTime: DateTime.now(),
        v: 0,
      );
      var result = await MongoDB.insert(data, collections);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Insered ID: ${_id.$oid}')));
      _clearAll();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Заполните все поля!')));
    }
  }

  void _clearAll() {
    userNameController.text = '';
    loginController.text = '';
    passwordController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: connection(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: userNameController,
                      decoration:
                          const InputDecoration(labelText: 'Имя пользователя'),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                        controller: loginController,
                        decoration: const InputDecoration(labelText: 'Логин')),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: 'Пароль')),
                    const SizedBox(
                      height: 25,
                    ),
                    MaterialButton(
                      onPressed: (() => insertData(
                          userNameController.text,
                          loginController.text,
                          passwordController.text,
                          context)),
                      child: const Text('Зарегестрироваться'),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          //TODO:- Add error state
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Container(
          child: const Text('ne robit'),
        );
      }),
    );
  }
}
