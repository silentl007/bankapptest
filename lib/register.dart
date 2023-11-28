import 'package:bankapp/login.dart';
import 'package:bankapp/model.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final RegisterLogic registerClass = RegisterLogic();
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
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
          return true;
        },
        child: Scaffold(
          backgroundColor: UserColors.blackbackground,
          appBar: userWidgets.userappbar(Icons.how_to_reg, 18, 'Register'),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: f32, vertical: f16),
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
                          text: "BANK VEEGIL",
                          sizeFont: f32,
                          height: 1,
                          bold: true,
                          letterSpace: 2),
                      userWidgets.welcomeText(
                          text: "Please register to continue",
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
                          if (text!.isEmpty) {
                            return 'This field is empty';
                          }
                          return null;
                        },
                        onSaved: (text) {
                          registerClass.username = text!;
                        },
                      ),
                      Divider(),
                      TextFormField(
                          controller: passwordControl,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return 'This field is empty';
                            }
                            return null;
                          },
                          onSaved: (text) {
                            registerClass.password = text!;
                          },
                          decoration: userWidgets.inputdecor('Password', f16)),
                      Divider(),
                      button('Register', context, h40, f24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  button(
      String text, BuildContext context, double containerH, double sizefont) {
    return InkWell(
      onTap: () {
        var keyState = _key.currentState;
        if (keyState!.validate()) {
          keyState.save();
          register(context);
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

  register(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => FutureBuilder(
              future: registerClass.register(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return userWidgets.loadingDiag();
                } else if (snapshot.data == 200) {
                  resetField();
                  return userWidgets.noticeDiag(
                      context, 'Account registered successfully!');
                } else if (snapshot.data == 404) {
                  return userWidgets.noticeDiag(context, 'Unable to register');
                } else if (snapshot.data == 409) {
                  return userWidgets.noticeDiag(
                      context, 'Unable to register, account is registered');
                } else {
                  return userWidgets.noticeDiag(context,
                      'Unable to register, please check internet connection');
                }
              },
            ));
  }

  resetField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var keyState = _key.currentState;
      setState(() {
        keyState!.reset();
        usernameControl.clear();
        passwordControl.clear();
      });
    });
  }
}
