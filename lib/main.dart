import 'package:bankapp/login.dart';
import 'package:flutter/material.dart';
import 'package:bankapp/model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: Login(),
    );
  }
}

