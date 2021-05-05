import 'package:bankapp/home.dart';
import 'package:bankapp/model.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Login extends StatelessWidget {
  LoginLogic loginClass = LoginLogic();
  final usernameControl = TextEditingController();
  final passwordControl = TextEditingController();
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
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
