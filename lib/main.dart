import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:only_pay/cubit/registration_cubit.dart';
import 'package:only_pay/screens/registration.dart';
import 'package:only_pay/user_repository.dart';

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
      home: BlocProvider(
        create: (context) => RegistrationCubit(ConnectAndRegistr()),
        child: Registration(),
      ),
    );
  }
}
