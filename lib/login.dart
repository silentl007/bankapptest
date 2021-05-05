import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final usernameControl = TextEditingController();
  final passwordControl = TextEditingController();
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Form(
        key: _key,
        child: Column(children: [
          TextFormField(
            controller: usernameControl,
            keyboardType: TextInputType.number,
            validator: (text) {},
            onSaved: (text) {},
          ),
          TextFormField(
            controller: passwordControl,
            keyboardType: TextInputType.text,
            validator: (text) {},
            onSaved: (text) {},
          ),
          ElevatedButton(
            child: Text('Login'),
            onPressed: () {},
          ),
          ElevatedButton(
            child: Text('New User? Register'),
            onPressed: () {},
          )
        ]),
      )),
    );
  }
}
