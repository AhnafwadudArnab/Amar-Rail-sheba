// TRAINSAPI.dart — now uses local data service instead of HTTP calls
import 'package:trackers/services/local_data_service.dart';

Future<List<TrainModel>> fetchTrainsByStations(String fromStation, String toStation) async {
  return LocalDataService().getTrains(fromStation, toStation);
}
