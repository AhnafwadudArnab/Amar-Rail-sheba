import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:amarRailSheba/All%20Feautures/second%20pagee/Book_page_after_search.dart';

final _logger = Logger();

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

void main() {
  checkRoutes();
  handleUserInput('Dhaka', 'Sylhet');
}

void setupLogging() {}

void checkRoutes() {
  RouteFinder routeFinder = RouteFinder();
  final stations = ['Dhaka', 'Chattogram', 'Sylhet'];
  for (String s in stations) {
    _logger.i('Checking routes from $s');
    routeFinder.isRouteAvailable(s, 'Dhaka');
  }
}

void navigateBasedOnRoute(String startStation, String endStation) {
  RouteFinder routeFinder = RouteFinder();
  bool isAvailable = routeFinder.isRouteAvailable(startStation, endStation);

  if (isAvailable) {
    _logger.i('Navigating: $startStation -> $endStation');
    Get.to(() => TrainSearchPage(
        fromStation: startStation,
        toStation: endStation,
        travelClass: 'AC',
        journeyDate: DateTime.now().toString(),
        returnJourneyDate: '',
        returnFromStation: '',
        returnToStation: '',
        returnJourneyClass: ''));
  } else {
    _logger.e('No route available from $startStation to $endStation');
  }
}

void handleUserInput(String startStation, String endStation) {
  navigateBasedOnRoute(startStation, endStation);
}

///call this function to check the routes//
  
  /* setupLogging();
   checkRoutes();
   handleUserInput('Dhaka', 'Sylhet');*/
