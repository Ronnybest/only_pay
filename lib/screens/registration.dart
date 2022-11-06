import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:only_pay/cubit/auth_cubit.dart';
import 'package:only_pay/cubit/registration_cubit.dart';
import 'package:only_pay/screens/home.dart';
import 'package:only_pay/user_repository.dart';
import '../constant/constants.dart';
import '../cubit/posts_cubit.dart';
import '../screens/auth.dart';
import '../user_main_page_functions.dart';

// ignore: must_be_immutable
class Registration extends StatelessWidget {
  var userNameController = TextEditingController();
  var loginController = TextEditingController();
  var passwordController = TextEditingController();
  var storage = FlutterSecureStorage();
  Registration({super.key});

  void _clearAll() {
    userNameController.text = '';
    loginController.text = '';
    passwordController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegistrationCubit, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is RegistrationLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.mongoDbModel['id'].toString())));
            _clearAll();
          }
        },
        builder: (context, state) {
          if (state is RegistrationInitial) {
            return InitialWidget(
              userNameController: userNameController,
              loginController: loginController,
              passwordController: passwordController,
            );
          } else if (state is RegistrationLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is RegistrationLoaded) {
            return BlocProvider(
              create: (context) => PostsCubit(ActionsWithPosts()),
              child: MainPage(state.mongoDbModel),
            );
          } else {
            return InitialWidget(
              userNameController: userNameController,
              loginController: loginController,
              passwordController: passwordController,
            );
          }
        },
      ),
    );
  }
}

class InitialWidget extends StatelessWidget {
  const InitialWidget({
    super.key,
    required this.userNameController,
    required this.loginController,
    required this.passwordController,
  });

  final TextEditingController userNameController;
  final TextEditingController loginController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          onPressed: (() => registr(
                userName: userNameController.text,
                login: loginController.text,
                password: passwordController.text,
                collectionName: COLLECTION_NAME,
                context: context,
              )),
          child: const Text(
            'Зарегестрироваться',
            style: TextStyle(fontFamily: 'Arial'),
          ),
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
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                  create: (context) =>
                                      AuthCubit(ConnectAndRegistr()),
                                  child: Auth(),
                                )));
                  }),
          ]),
        ),
      ],
    );
  }

  void registr({
    required BuildContext context,
    required String userName,
    required String login,
    required String password,
    required String collectionName,
  }) {
    final registrationCubit = context.read<RegistrationCubit>();
    registrationCubit.connection(
        userName, login, password, collectionName, context);
  }
}
