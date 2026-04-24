// TRAINSAPI.dart — now uses local data service instead of HTTP calls
import 'package:amarRailSheba/services/local_data_service.dart';

Future<List<TrainModel>> fetchTrainsByStations(String fromStation, String toStation) async {
  return LocalDataService().getTrains(fromStation, toStation);
}
