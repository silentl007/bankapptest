import 'dart:convert';
import 'package:http/http.dart' as http;

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
