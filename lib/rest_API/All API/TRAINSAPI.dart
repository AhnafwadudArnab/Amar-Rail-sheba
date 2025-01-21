import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trackers/All%20Feautures/second%20pagee/trainSelection.dart';
class TrainDetailsAPi {
  final String baseUrl = Utils.baseURL;

  /// Fetches the train details by from_station and to_station
  Future<List<dynamic>> getTrains(String fromStation, String toStation) async {
    final url = Uri.parse(
        '$baseUrl/trains?from_station=$fromStation&to_station=$toStation');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load train details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching train details: $e');
    }
  }
}

void main() async {
  TrainDetailsAPi api = TrainDetailsAPi();
  try {
    List<dynamic> trains = await api.getTrains('NYC', 'LA');
    print(trains);
  } catch (e) {
    print(e);
  }
}