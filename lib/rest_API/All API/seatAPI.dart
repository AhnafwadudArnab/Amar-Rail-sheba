// lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String insertUser;
  final String baseUrl;
  ApiService(this.baseUrl) : insertUser = 'default_value';

  Future<void> insertUserData(List<int> seats, String coachId, String status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/insert-user-data'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'seats': seats,
        'coach_ID': coachId,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      print('User  data inserted successfully');
    } else {
      throw Exception('Failed to insert user data: ${response.body}');
    }
  }
}