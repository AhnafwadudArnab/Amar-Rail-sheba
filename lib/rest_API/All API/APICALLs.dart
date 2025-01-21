
import 'package:http/http.dart' as http;
import 'dart:convert';

class FP2API{
  final String baseUrl = 'http://10.15.25.169:3000';

  Future<List<dynamic>> fetchTrains() async {
    final response = await http.get(Uri.parse('$baseUrl/trains'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load trains');
    }
  }

  Future<Map<String, dynamic>> fetchTrainById(int trainId) async {
    final response = await http.get(Uri.parse('$baseUrl/train/$trainId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load train');
    }
  }

  Future<void> addTrain(Map<String, dynamic> trainData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addTrain'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(trainData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add train');
    }
  }

  Future<void> updateTrain(int trainId, Map<String, dynamic> trainData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/updateTrain/$trainId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(trainData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update train');
    }
  }

}