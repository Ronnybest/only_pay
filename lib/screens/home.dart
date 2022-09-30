import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage(this.model, {super.key});
  final Map<String, dynamic>? model;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(widget.model!['username'].toString())),
    );
  }
}
