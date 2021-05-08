import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:number_display/number_display.dart';

// use preferences to store login details (account number) then use it to fetch data when querying transactions
class UserColors {
  static const blackbackground = Colors.black;
//  static const blackbackground = Color(0xFF1C1C1C)
  static const yellowColor = Color(0xFFF3D657);
}

final displayNumber = createDisplay(length: 50);

class UserWidgets {
  userappbar(IconData icon) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
      {@required String text,
      @required double sizeFont,
      double height,
      double letterSpace,
      bool bold}) {
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
        color: UserColors.yellowColor,
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
    return Container(
      color: Colors.transparent,
      child: AlertDialog(
        backgroundColor: UserColors.blackbackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Center(
            child: Icon(
          Icons.error,
          size: 45,
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

  accountDetails(int accountBalance) {
    return Card(
      color: Colors.transparent,
      margin: EdgeInsets.all(10.0),
      child: Container(
          color: UserColors.blackbackground,
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: UserColors.yellowColor,
                    ),
                    onPressed: () {},
                  ),
                  Text("Savings",
                      style: TextStyle(
                          color: UserColors.yellowColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: UserColors.yellowColor,
                    ),
                    onPressed: () {},
                  )
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("₦ ${displayNumber(accountBalance)}",
                      style: TextStyle(
                          color: UserColors.yellowColor,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 35.0),
            ],
          )),
    );
  }
}

class LoginLogic {
  String username;
  String password;

  login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
  String username;
  String password;

  register() async {
    Map<String, String> registerDetails = {
      'phoneNumber': username,
      'password': password
    };
    Uri link = Uri.parse('https://bank.veegil.com/auth/signup');
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
  String username;
  int amount;

  sendmoney() async {
    Map<String, dynamic> sendmoneyDetails = {
      'phoneNumber': username,
      'amount': amount
    };
    Uri link = Uri.parse('https://bank.veegil.com/accounts/transfer');
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
  String username;
  int amount;
  withdraw() async {
    Map<String, dynamic> withdrawmoneyDetails = {
      'phoneNumber': username,
      'amount': amount
    };
    Uri link = Uri.parse('https://bank.veegil.com/accounts/withdraw');
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
