import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class ApiService {
  final String baseUrl = "http://192.168.68.103:3000";
  final Logger logger = Logger();

  Future<void> sendEmergencyAlert({
    required String seatNumber,
    required String emergencyType,
    required String coachNo,
  }) async {
    final url = Uri.parse('$baseUrl/emergencyAlert');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'seatNumber': seatNumber,
        'emergencyType': emergencyType,
        'coachNo': coachNo,
      }),
    );

    if (response.statusCode == 200) {
      logger.i('Emergency alert saved successfully.');
    } else {
      logger.e('Failed to save emergency alert: ${response.body}');
    }
  }
}
