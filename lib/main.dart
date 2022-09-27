import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:only_pay/cubit/auth_cubit.dart';
import 'package:only_pay/screens/auth.dart';
import 'package:only_pay/user_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit(ConnectAndRegistr())),
        ],
        child: Auth(),
      ),
    );
  }
}
