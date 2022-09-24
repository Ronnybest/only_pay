import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Auth extends StatelessWidget {
  var loginController = TextEditingController();
  var passwordController = TextEditingController();

  Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
        ]),
      ),
    );
  }
}
