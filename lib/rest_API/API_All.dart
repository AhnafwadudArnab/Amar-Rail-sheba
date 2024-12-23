import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trackers/rest_API/API_utils.dart';


Future userSignup(
    String name, String email, String password, String phone) async {
  final response = await http.post(
    Uri.parse('${Utils.baseURL}/user/register'),
    headers: {'Accept': 'application/json'},
    body: {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    },
  );

  var decodeData = jsonDecode(response.body);
  return decodeData;
}


Future userLogin(String name, String email, String password) async {
  final response = await http.post(
    Uri.parse('${Utils.baseURL}/user/login'),
    headers: {'Accept': 'application/json'},
    body: {
      'name': name,
      'email': email,
      'password': password,
    },
  );

  var decodeData = jsonDecode(response.body);
  return decodeData;
}
