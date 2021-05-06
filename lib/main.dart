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
      theme: ThemeData(
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: UserColors.blackbackground)),
      // themeMode: ThemeMode.dark,
      home: Login(),
    );
  }
}
