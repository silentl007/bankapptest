import 'package:bankapp/home.dart';
import 'package:bankapp/model.dart';
import 'package:bankapp/register.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
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
          appBar: userWidgets.userappbar('Login'),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: f32, vertical: 16),
                child: Form(
                  key: _key,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        userWidgets.welcomeText(
                            text: "Welcome to",
                            sizeFont: f16,
                            height: 2,
                            bold: false),
                        userWidgets.welcomeText(
                            text: "BANK",
                            sizeFont: f32,
                            height: 1,
                            bold: true,
                            letterSpace: 2),
                        userWidgets.welcomeText(
                            text: "Please login to continue",
                            sizeFont: f16,
                            height: 1,
                            bold: false),
                        Divider(),
                        TextFormField(
                          onEditingComplete: () => node.nextFocus(),
                          controller: usernameControl,
                          keyboardType: TextInputType.number,
                          decoration:
                              userWidgets.inputdecor('Account Number', f16),
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
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text.isEmpty) {
                                return 'This field is empty';
                              }
                            },
                            onSaved: (text) {
                              loginClass.password = text;
                            },
                            decoration:
                                userWidgets.inputdecor('Password', f16)),
                        Divider(),
                        button('Sign-In', context, h40, f24),
                        Divider(),
                        button('New User? Register', context, h40, f24),
                        userWidgets.welcomeText(
                            text: "Password forgotten?",
                            sizeFont: f16,
                            height: 2,
                            bold: false),
                      ]),
                ),
              ),
            ),
          )),
    );
  }

  button(
      String text, BuildContext context, double containerH, double sizefont) {
    return InkWell(
      onTap: () {
        if (text == 'Sign-In') {
          var keyState = _key.currentState;
          if (keyState.validate()) {
            keyState.save();
            login(context);
          }
        } else {
          return Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Register()));
        }
      },
      child: Container(
        height: containerH,
        decoration: BoxDecoration(
          color: UserColors.yellowColor,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFF3D657).withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: sizefont,
              fontWeight: FontWeight.bold,
              color: UserColors.blackbackground,
            ),
          ),
        ),
      ),
    );
  }

  login(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => FutureBuilder(
              future: loginClass.login(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return userWidgets.loadingDiag();
                } else if (snapshot.data == 200) {
                  loginSuccess(context);
                  return Container();
                } else if (snapshot.data == 404) {
                  return userWidgets.errorDiag(context, 'Wrong login details');
                } else {
                  return userWidgets.errorDiag(context,
                      'Unable to login, please check internet connection');
                }
              },
            ));
  }

  loginSuccess(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    });
  }
}
