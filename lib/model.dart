import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserColors {
  static const blackbackground = Color(0xFF1C1C1C);
  static const yellowColor = Color(0xFFF3D657);
}

class UserWidgets {
  userappbar(String text) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(
                  color: UserColors.yellowColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ],
        ),
      ),
      backgroundColor: UserColors.blackbackground,
    );
  }

  inputdecor(String text, double sizeFont) {
    return InputDecoration(
      hoverColor: Colors.red,
      hintText: text,
      hintStyle: TextStyle(
        fontSize: sizeFont,
        color: UserColors.blackbackground.withOpacity(0.5),
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

  loadingDiag() {
    return Container(
      color: Colors.transparent,
      child: AlertDialog(
        backgroundColor: UserColors.blackbackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        content: LinearProgressIndicator(
          backgroundColor: UserColors.blackbackground,
          valueColor: new AlwaysStoppedAnimation<Color>(UserColors.yellowColor),
        ),
      ),
    );
  }

  errorDiag(BuildContext context, String errorDetails) {
    return Container(
      color: Colors.transparent,
      child: AlertDialog(
        backgroundColor: UserColors.blackbackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Center(
            child: Container(
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                size: 45,
                color: UserColors.yellowColor,
              ),
              Text(
                'Error',
              )
            ],
          ),
        )),
        content: Text(errorDetails),
        actions: [
          ElevatedButton.icon(
            icon: Icon(
              Icons.close,
              color: UserColors.blackbackground,
            ),
            label: Text(
              'Close',
              style: TextStyle(color: UserColors.blackbackground),
            ),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(UserColors.yellowColor),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))))),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

class LoginLogic {
  String username;
  String password;

  login() async {
    Map<String, String> loginDetails = {
      'phoneNumber': username,
      'password': password
    };
    Uri link = Uri.parse('https://bank.veegil.com/auth/login');
    try {
      var encodeData = jsonEncode(loginDetails);
      var send = await http.post(link,
          body: encodeData,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      print('=======> body: ${send.body}');
      print('=======> status: ${send.statusCode}');
      return send.statusCode;
    } catch (e) {
      print('=======> error: $e');
      return null;
    }
  }
}

class RegisterLogic {
  String username;
  String password;

  register() async {
    Map<String, String> registerDetails = {
      'phoneNumber': username,
      'password': password
    };
    Uri link = Uri.parse('https://bank.veegil.com/auth/login');
    try {
      var encodeData = jsonEncode(registerDetails);
      var send = await http.post(link,
          body: encodeData,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      print('=======> body: ${send.body}');
      print('=======> status: ${send.statusCode}');
      return null;
    } catch (e) {
      print('=======> error: $e');
      return null;
    }
  }
}
