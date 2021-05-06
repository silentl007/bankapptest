import 'package:bankapp/home.dart';
import 'package:bankapp/model.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Login extends StatelessWidget {
  LoginLogic loginClass = LoginLogic();
  UserWidgets userWidgets = UserWidgets();
  final usernameControl = TextEditingController();
  final passwordControl = TextEditingController();
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: UserColors.blackbackground,
          appBar: userWidgets.userappbar('Login'),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      welcomeText(
                          text: "Welcome to",
                          sizeFont: 16,
                          height: 2,
                          bold: false),
                      welcomeText(
                          text: "BANK",
                          sizeFont: 36,
                          height: 1,
                          bold: true,
                          letterSpace: 2),
                      welcomeText(
                          text: "Please login to continue",
                          sizeFont: 16,
                          height: 1,
                          bold: false),
                      Divider(),
                      TextFormField(
                        controller: usernameControl,
                        keyboardType: TextInputType.number,
                        decoration: inputdecor('Account Number'),
                        validator: (text) {},
                        onSaved: (text) {},
                      ),
                      Divider(),
                      TextFormField(
                        controller: passwordControl,
                        keyboardType: TextInputType.text,
                        validator: (text) {},
                        onSaved: (text) {},
                        decoration: inputdecor('Password')
                      ),
                      Divider(),
                      button('Sign-In'),
                      Divider(),
                      button('New User? Register'),
                    ]),
              ),
            ),
          )),
    );
  }

  inputdecor(String text) {
    return InputDecoration(
      hintText: text,
      hintStyle: TextStyle(
        fontSize: 16,
        color: UserColors.blackbackground,
        fontWeight: FontWeight.bold,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      filled: true,
      fillColor: UserColors.yellowColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    );
  }

  welcomeText(
      {@required String text,
      @required double sizeFont,
      double height,
      double letterSpace,
      bool bold}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: sizeFont,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: UserColors.yellowColor,
        letterSpacing: letterSpace ?? 0,
        height: height ?? 0,
      ),
    );
  }

  button(String text) {
    return Container(
      height: 40,
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: UserColors.blackbackground,
          ),
        ),
      ),
    );
  }

  login(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => FutureBuilder(
              future: loginClass.login(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Container(
                    color: Colors.transparent,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      content: LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.purple),
                      ),
                    ),
                  );
                } else if (snapshot.data == 200) {
                  // login
                  loginSuccess(context);
                  return Container();
                } else if (snapshot.data == 404) {
                  // return error
                  loginFailed(context);
                  return Container();
                } else {
                  loginNetwork(context);
                  return Container();
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

  loginFailed(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error - Unable to Login',
        desc: 'Incorrect login details',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      )..show();
    });
  }

  loginNetwork(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error - Unable to Login',
        desc: 'Please check your network connection',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      )..show();
    });
  }
}
