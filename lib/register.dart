import 'package:bankapp/model.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  final LoginLogic loginClass = LoginLogic();
  final UserWidgets userWidgets = UserWidgets();
  final usernameControl = TextEditingController();
  final passwordControl = TextEditingController();
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    Size size = MediaQuery.of(context).size;
    double h40 = size.height * .05;
    double f24 = size.height * .03;
    double f16 = size.height * .02;
    double f32 = size.height * .04;
    return SafeArea(
      child: Scaffold(
        backgroundColor: UserColors.blackbackground,
        appBar: userWidgets.userappbar('Register'),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: f32, vertical: 16),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      onEditingComplete: () => node.nextFocus(),
                      controller: usernameControl,
                      keyboardType: TextInputType.number,
                      decoration: userWidgets.inputdecor('Account Number', f16),
                      validator: (text) {
                        if (text.isEmpty) {
                          return 'This field is empty';
                        }
                      },
                      onSaved: (text) {
                        loginClass.username = text;
                      },
                    ),
                    Divider(),
                    TextFormField(
                        controller: passwordControl,
                        keyboardType: TextInputType.text,
                        validator: (text) {
                          if (text.isEmpty) {
                            return 'This field is empty';
                          }
                        },
                        onSaved: (text) {
                          loginClass.password = text;
                        },
                        decoration: userWidgets.inputdecor('Password', f16)),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  
}
