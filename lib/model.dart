import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:number_display/number_display.dart';

String baseUrl = 'https://bankapi.veegil.com';

// use preferences to store login details (account number) then use it to fetch data when querying transactions
class UserColors {
  static const blackbackground = Colors.black;
//  static const blackbackground = Color(0xFF1C1C1C)
  static const yellowColor = Color(0xFFF3D657);
}

final displayNumber = createDisplay(length: 50);

class UserWidgets {
  buttonDecor() {
    return ElevatedButton.styleFrom(
        backgroundColor: UserColors.blackbackground,
        side: BorderSide(
          color: UserColors.yellowColor,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))));
  }

  userappbar(IconData icon, double pad18, String title) {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.all(pad18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(title,
                style: TextStyle(
                    color: UserColors.yellowColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            Icon(
              icon,
              color: UserColors.yellowColor,
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

  welcomeText(
      {required String text,
      required double sizeFont,
      double? height,
      double? letterSpace,
      bool bold = false}) {
    return Text(
      text,
      textAlign: TextAlign.end,
      style: TextStyle(
        fontSize: sizeFont,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: UserColors.yellowColor,
        letterSpacing: letterSpace ?? 0,
        height: height ?? 0,
      ),
    );
  }

  loadingIndicator() {
    return Center(
      child: LoadingIndicator(
        indicatorType: Indicator.ballClipRotateMultiple,
        colors: [UserColors.yellowColor],
      ),
    );
  }

  defaultloadingindicator() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: UserColors.yellowColor,
      ),
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

  noticeDiag(BuildContext context, String errorDetails) {
    Size size = MediaQuery.of(context).size;
    double f45 = size.height * .05632;
    return Container(
      color: Colors.transparent,
      child: AlertDialog(
        backgroundColor: UserColors.blackbackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Center(
            child: Icon(
          Icons.error,
          size: f45,
          color: UserColors.yellowColor,
        )),
        content: Text(
          errorDetails,
          style: TextStyle(color: UserColors.yellowColor),
          textAlign: TextAlign.start,
        ),
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

  accountDetails(int accountBalance, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double f10 = size.height * .0125;
    double f5 = size.height * .00625;
    double f20 = size.height * .025;
    double f24 = size.height * .03;
    double f35 = size.height * .0438;
    return Card(
      color: Colors.transparent,
      margin: EdgeInsets.all(f10),
      child: Container(
          color: UserColors.blackbackground,
          padding: EdgeInsets.all(f5),
          child: Column(
            children: <Widget>[
              Center(
                child: Text("Savings",
                    style: TextStyle(
                        color: UserColors.yellowColor,
                        fontSize: f20,
                        fontWeight: FontWeight.bold)),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(f5),
                  child: Text("₦ ${displayNumber(accountBalance)}",
                      style: TextStyle(
                          color: UserColors.yellowColor,
                          fontSize: f24,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: f35),
            ],
          )),
    );
  }
}

class LoginLogic {
  String username = '';
  String password = '';

  login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> loginDetails = {
      'phoneNumber': username,
      'password': password
    };
    Uri link = Uri.parse('$baseUrl/auth/login');
    try {
      var encodeData = jsonEncode(loginDetails);
      var send = await http.post(link,
          body: encodeData,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      print('=======> body: ${send.body}');
      print('=======> status: ${send.statusCode}');
      if (send.statusCode == 200) {
        prefs.setString('account', username);
        return send.statusCode;
      } else {
        return send.statusCode;
      }
    } catch (e) {
      print('=======> error: $e');
      return null;
    }
  }
}

class RegisterLogic {
  String username = '';
  String password = '';

  register() async {
    Map<String, String> registerDetails = {
      'phoneNumber': username,
      'password': password
    };
    Uri link = Uri.parse('$baseUrl/auth/signup');
    try {
      var encodeData = jsonEncode(registerDetails);
      var send = await http.post(link,
          body: encodeData,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      print('=======> body: ${send.body}');
      print('=======> status: ${send.statusCode}');
      print('=======> register details: $registerDetails');
      return send.statusCode;
    } catch (e) {
      print('=======> error: $e');
      return null;
    }
  }
}

class SendMoneyLogic {
  String username = '';
  int amount = 0;

  sendmoney() async {
    Map<String, dynamic> sendmoneyDetails = {
      'phoneNumber': username,
      'amount': amount
    };
    Uri link = Uri.parse('$baseUrl/accounts/transfer');
    try {
      var encodeData = jsonEncode(sendmoneyDetails);
      var send = await http.post(link,
          body: encodeData,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      print('=======> body: ${send.body}');
      print('=======> status: ${send.statusCode}');
      print('=======> send money details: $sendmoneyDetails');
      return send.statusCode;
    } catch (e) {
      print('=======> error: $e');
      return null;
    }
  }
}

class WithdrawMoneyLogic {
  String username = '';
  int amount = 0;
  withdraw() async {
    Map<String, dynamic> withdrawmoneyDetails = {
      'phoneNumber': username,
      'amount': amount
    };
    Uri link = Uri.parse('$baseUrl/accounts/withdraw');
    try {
      var encodeData = jsonEncode(withdrawmoneyDetails);
      var send = await http.post(link,
          body: encodeData,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      print('=======> body: ${send.body}');
      print('=======> status: ${send.statusCode}');
      print('=======> send money details: $withdrawmoneyDetails');
      return send.statusCode;
    } catch (e) {
      print('=======> error: $e');
      return null;
    }
  }
}
