import 'dart:convert';

class LoginLogic {
  String username;
  String password;

  login() async {
    Map<String, String> loginDetails = {
      'phoneNumber': username,
      'password': password
    };
    String link = '';
    try {
      var encodeData = jsonEncode(loginDetails);
    } catch (e) {
    }
  }
}
