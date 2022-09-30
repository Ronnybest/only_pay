import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:only_pay/constant/constants.dart';
import 'package:only_pay/cubit/auth_cubit.dart';
import 'package:only_pay/cubit/registration_cubit.dart';
import 'package:only_pay/screens/home.dart';
import 'package:only_pay/screens/registration.dart';
import 'package:only_pay/user_repository.dart';

// ignore: must_be_immutable
class Auth extends StatefulWidget {
  Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  var loginController = TextEditingController();

  var passwordController = TextEditingController();

  bool checkRememberMe = false;

  var storage = FlutterSecureStorage();

  void _clearAll() {
    loginController.text = '';
    passwordController.text = '';
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
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
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.result!['username'])));
              _clearAll();
            }
          },
          builder: (context, state) {
            if (state is AuthInitial) {
              return InitialView(
                loginController: loginController,
                passwordController: passwordController,
                storage: storage,
              );
            } else if (state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is AuthLoaded) {
              return MainPage(state.result);
            } else {
              return InitialView(
                loginController: loginController,
                passwordController: passwordController,
                storage: storage,
              );
            }
          },
        ),
      ),
    );
  }
}

class InitialView extends StatefulWidget {
  const InitialView({
    super.key,
    required this.loginController,
    required this.passwordController,
    required this.storage,
  });

  final TextEditingController loginController;
  final TextEditingController passwordController;
  final FlutterSecureStorage storage;

  @override
  State<InitialView> createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: widget.loginController,
          // initialValue:
          //     storage.read(key: 'lgn').toString() ?? loginController.text,
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
          controller: widget.passwordController,
          obscureText: true,
          // initialValue:
          //     storage.read(key: 'pswrd').toString() ?? loginController.text,
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
          child: Text("Вставить данные для авторизации"),
          onPressed: () {
            insertAuthData(
                login: widget.loginController,
                pass: widget.passwordController,
                storage: widget.storage);
          },
        ),
        CupertinoButton(
          child: Text('Авторизоваться'),
          onPressed: () => auth(
              collectionName: COLLECTION_NAME,
              context: context,
              login: widget.loginController.text,
              password: widget.passwordController.text),
        ),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
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
                        ),
                      ),
                    );
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void insertAuthData(
      {required TextEditingController login,
      required TextEditingController pass,
      required FlutterSecureStorage storage}) async {
    (storage.read(key: 'lgn').then((value) => login.text = value ?? ''));
    (storage.read(key: 'pswrd').then((value) => pass.text = value ?? ''));
    setState(() {});
  }

  void auth(
      {required BuildContext context,
      required String password,
      required String login,
      required String collectionName}) {
    final authCubit = context.read<AuthCubit>();
    authCubit.registration(
        login, password, context, collectionName, widget.storage);
  }
}
