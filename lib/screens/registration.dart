import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:only_pay/models/mongodbmodels.dart';
import 'package:only_pay/mongodbconnect.dart';
import 'package:dbcrypt/dbcrypt.dart';
import '../constant/constants.dart';
import '../screens/auth.dart';

class Registration extends StatelessWidget {
  var collections;
  Future<m.DbCollection> connection() async {
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
      var _id = m.ObjectId();
      final data = MongoDbModel(
        id: _id,
        username: userNameController.text,
        login: loginController.text,
        password:
            DBCrypt().hashpw(passwordController.text, DBCrypt().gensalt()),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 0,
      );
      var result = await MongoDB.insert(data, collections);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Insered ID: ${_id.$oid}')));
      _clearAll();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Заполните все поля!')));
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
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      labelText: 'Имя пользователя',
                      fillColor: Colors.blueGrey,
                      labelStyle: TextStyle(color: Colors.blueGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      filled: false,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextField(
                    controller: loginController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.login),
                      labelText: 'Логин',
                      fillColor: Colors.blueGrey,
                      labelStyle: TextStyle(color: Colors.blueGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      filled: false,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      labelText: 'Пароль',
                      fillColor: Colors.blueGrey,
                      labelStyle: TextStyle(color: Colors.blueGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      filled: false,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CupertinoButton(
                    onPressed: (() => insertData(
                        userNameController.text,
                        loginController.text,
                        passwordController.text,
                        context)),
                    child: const Text('Зарегестрироваться'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(children: <TextSpan>[
                      const TextSpan(
                          text: "Есть аккаунт? ",
                          style: TextStyle(color: Colors.blueGrey)),
                      TextSpan(
                          text: "Авторизоваться.",
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Auth()));
                            }),
                    ]),
                  ),
                ],
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
