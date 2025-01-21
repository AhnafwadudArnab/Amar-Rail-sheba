import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:trackers/All%20Feautures/second%20pagee/Book_page_after_search.dart';

class RouteFinder {
  final List<String> availableRoutes = [
    'Airport-Dhaka',
    'Dhaka-Akhaura',
    'Dhaka-Bhairab-Bazar',
    'Dhaka-Brahman_Baria',
    'Dhaka-Chattogram',
    'Dhaka-Comilla',
    'Dhaka-Feni',
    'Dhaka-Laksham',
    'Dhaka-Narshingdi',
    'Dhaka-Sylhet',
    'Akhaura-Dhaka',
    'Bhairab-Bazar-Dhaka',
    'Brahman_Baria-Dhaka',
    'Chattogram-Dhaka',
    'Comilla-Dhaka',
    'Feni-Dhaka',
    'Laksham-Dhaka',
    'Narshingdi-Dhaka',
    'Sylhet-Dhaka'
  ];

  bool isRouteAvailable(String startStation, String endStation) {
    String route = '$startStation-$endStation';
    return availableRoutes.contains(route);
  }
}

final Logger _logger = Logger('RouteFinderLogger');

void main() {
  setupLogging();
  checkRoutes();
  handleUserInput('Dhaka', 'Sylhet'); // Example user input
}

void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    _logger.info('${record.level.name}: ${record.time}: ${record.message}');
  });
}

void checkRoutes() {
  RouteFinder routeFinder = RouteFinder();

  List<String> availableStations = [
    'Airport',
    'Akhaura',
    'Bhairab-Bazar',
    'Brahman_Baria',
    'Chattogram',
    'Comilla',
    'Dhaka',
    'Feni',
    'Laksham',
    'Narshingdi',
    'Sylhet'
  ];

  List<String> unavailableStations = [
    'Chandpur',
    'Jessore',
    'Kishoreganj',
    'Munshiganj',
    'Mymensingh',
    'Narshingdi',
    'Noakhali',
    'Rajshahi',
    'Rangpur',
    'Dinajpur',
    'Khulna',
    'Bogra'
  ];

  for (String startStation in availableStations) {
    for (String endStation in unavailableStations) {
      bool isAvailable = routeFinder.isRouteAvailable(startStation, endStation);
      if (isAvailable) {
        _logger.info('Route available: $startStation -> $endStation');
      } else {
        _logger.warning('No route available: $startStation -> $endStation');
      }
    }
  }
}

void navigateBasedOnRoute(String startStation, String endStation) {
  RouteFinder routeFinder = RouteFinder();
  bool isAvailable = routeFinder.isRouteAvailable(startStation, endStation);

  if (isAvailable) {
    _logger.info('Navigating to next page: $startStation -> $endStation');

    Get.to(() => TrainSearchPage(
        fromStation: startStation,
        toStation: endStation,
        travelClass: 'AC', // Example value
        journeyDate: DateTime.now().toString(), // Example value
        returnJourneyDate: DateTime.now().toString(), // Example value
        returnFromStation: endStation, // Example value
        returnToStation: startStation, // Example value
        returnJourneyClass: 'S-Chair' // Example value
        ));
  } else {
    _logger
        .severe('Error: No route available from $startStation to $endStation');
    // Code to show error notification
  }
}

void handleUserInput(String startStation, String endStation) {
  navigateBasedOnRoute(startStation, endStation);
}

///call this function to check the routes//
  
  /* setupLogging();
   checkRoutes();
   handleUserInput('Dhaka', 'Sylhet');*/
