
import 'dart:convert';

import 'package:http/http.dart' as http;
class ApiService {
  //final String baseUrl = "http://192.168.68.103:3000";
  final String baseUrl = "http://192.168.68.103:3000"; //university wifi ip//

  Future<bool> addBooking({
    required String userFrom,
    required String userTo,
    required String userClass,
    required String journeyDate,
  }) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
    };
    Map<String, String> requestBody = {
      "user_from": userFrom,
      "user_to": userTo,
      "user_class": userClass,
      "journey_date": journeyDate,
    };
    var response = await http.post(Uri.parse("$baseUrl/firstPage"),
        headers: requestHeaders, body: jsonEncode(requestBody));

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<dynamic>> getAllBookings() async {
    var response = await http.get(Uri.parse("$baseUrl/firstPage"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<Map<String, dynamic>> getBookingById(int bookingId) async {
    var response = await http.get(Uri.parse("$baseUrl/firstPage/$bookingId"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load booking');
    }
  }
}
