import 'package:bankapp/home.dart';
import 'package:bankapp/model.dart';
import 'package:flutter/material.dart';

class SendMoney extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        },
        child: Scaffold(
          backgroundColor: UserColors.blackbackground,
          appBar: UserWidgets().userappbar(Icons.send),
          body: Column(),
        ),
      ),
    );
  }
}
