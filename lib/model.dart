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
      title: Text(
        text,
        style: TextStyle(
            color: UserColors.yellowColor,
            fontWeight: FontWeight.bold,
            fontSize: 30),
      ),
      centerTitle: true,
      backgroundColor: UserColors.blackbackground,
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
    Uri link = Uri.parse('');
    try {
      var encodeData = jsonEncode(loginDetails);
      var send = await http.post(link,
          body: encodeData,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      print('=======> body: ${send.body}');
      print('=======> status: ${send.statusCode}');
    } catch (e) {
      print('=======> error: $e');
      return null;
    }
  }
}
