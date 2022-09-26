import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:only_pay/constant/constants.dart';
import 'package:only_pay/cubit/auth_cubit.dart';
import 'package:only_pay/cubit/registration_cubit.dart';
import 'package:only_pay/screens/registration.dart';
import 'package:only_pay/user_repository.dart';

// ignore: must_be_immutable
class Auth extends StatelessWidget {
  var loginController = TextEditingController();
  var passwordController = TextEditingController();

  Auth({super.key});
  void _clearAll() {
    loginController.text = '';
    passwordController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is AuthLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.result[0]['username'].toString())));
              _clearAll();
            }
          },
          builder: (context, state) {
            if (state is AuthInitial) {
              return InitialView(
                  loginController: loginController,
                  passwordController: passwordController);
            } else if (state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is AuthLoaded) {
              return InitialView(
                  loginController: loginController,
                  passwordController: passwordController);
            } else {
              return InitialView(
                  loginController: loginController,
                  passwordController: passwordController);
            }
          },
        ),
      ),
    );
  }
}

class InitialView extends StatelessWidget {
  const InitialView({
    super.key,
    required this.loginController,
    required this.passwordController,
  });

  final TextEditingController loginController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        CupertinoButton(
          child: Text('Авторизоваться'),
          onPressed: () => auth(
              collectionName: COLLECTION_NAME,
              context: context,
              login: loginController.text,
              password: passwordController.text),
        ),
        RichText(
          text: TextSpan(children: <TextSpan>[
            const TextSpan(
                text: "Нет аккаунта? ",
                style: TextStyle(color: Colors.blueGrey)),
            TextSpan(
                text: "Зарегестрироваться.",
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                  create: (context) =>
                                      RegistrationCubit(ConnectAndRegistr()),
                                  child: Registration(),
                                )));
                  }),
          ]),
        ),
      ],
    );
  }

  void auth(
      {required BuildContext context,
      required String password,
      required String login,
      required String collectionName}) {
    final authCubit = context.read<AuthCubit>();
    authCubit.registration(login, password, context, collectionName);
  }
}
