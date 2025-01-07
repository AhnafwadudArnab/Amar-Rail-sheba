
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> loginUser(String name, String email, String password) async {
  final url = Uri.parse('http://localhost:3000/user/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    print('Login successful');
  } else {
    print('Failed to login: ${response.body}');
  }
}