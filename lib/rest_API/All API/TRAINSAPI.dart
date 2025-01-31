import 'dart:convert';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';

const String baseURL = 'http://localhost:3000';
final Logger logger = Logger('TrainsAPI');

Future<void> fetchAllTrains() async {
  final response = await http.get(Uri.parse('$baseURL/trains'));
  if (response.statusCode == 200) {
    logger.info(jsonDecode(response.body));
  } else {
    logger.severe('Failed to load trains');
  }
}

Future<void> fetchTrainById(int id) async {
  final response = await http.get(Uri.parse('$baseURL/train/$id'));
  if (response.statusCode == 200) {
    logger.info(jsonDecode(response.body));
  } else {
    logger.severe('Failed to load train');
  }
}

Future<void> fetchTrainsByStations(String fromStation, String toStation) async {
  final response = await http.get(Uri.parse('$baseURL/trains/search?from_station=$fromStation&to_station=$toStation'));
  if (response.statusCode == 200) {
    logger.info(jsonDecode(response.body));
  } else {
    logger.severe('Failed to load trains');
  }
}

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  fetchAllTrains();
  fetchTrainById(1); // fetchTrainsByStations('StationA', 'StationB');
}