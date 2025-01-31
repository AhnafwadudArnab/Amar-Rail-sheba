import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackers/All%20Feautures/firstpage/booking.dart';
import 'package:trackers/OnBoards/FrontPage.dart';
//import 'package:get/get_connect/http/src/utils/utils.dart';
//import 'package:trackers/All%20Feautures/second%20pagee/Book_page_after_search.dart';
//import 'package:trackers/OnBoards/FrontPage.dart';
//import 'All Feautures/Seat management/Train_Seat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amar Rail Sheba',
      home: Onboard(),
//       home: TrainSearchPage(
//   fromStation: 'Dhaka',
//   toStation: 'Chittagong',
//   travelClass: 'S-Chair',
//   journeyDate: DateTime(2025, 1, 16).toIso8601String(),
//   returnFromStation: 'Chittagong',
//   returnToStation: 'Dhaka',
//   returnJourneyClass: 'S-Chair',
//   returnJourneyDate: DateTime(2025, 1, 20).toIso8601String(),
// ),
      // home: SeatSelectionPage(
      //   price: 150,
      //   ticketType: 'SNIGDHA',
      //   fromStation: 'Dhaka',
      //   toStation: 'Chittagong',
      //   travelClass: 'S-Chair',
      //   journeyDate: "2025-01-29",
      //   departureTime: '10:00 AM',
      // ),
    );
  }
}
//home: SignUp(),

// final response = await ApiService()
//home: SeatSelectionApp(price: 150, ticketType: 'AC',),
//home: LiveLocation(),
//home: ModifySearchBox(),
//home: SearchInfoCard(from: "Dhaka", to: "Brahman-baria", date: "01.01.2025", journeyClass: "Cabin", returnFrom: "BrahmanBaria", returnTo: "Dhaka", returnDate: "05.01.2025", returnJourneyClass: "AC")
//home:  MainHomeScreen(),
// home: TrainSearchPage(
//   fromStation: 'Dhaka',
//   toStation: 'Chittagong',
//   travelClass: 'S-Chair',
//   journeyDate: DateTime(2025, 1, 16).toIso8601String(),
//   returnFromStation: 'Chittagong',
//   returnToStation: 'Dhaka',
//   returnJourneyClass: 'S-Chair',
//   returnJourneyDate: DateTime(2025, 1, 20).toIso8601String(),
// ),
//home: RailwayRouteFinder(),
//home: TrainTicketPage(),
// home: TrainDetailsPage(trainStations: {
// },),
//home: ModifySearchBox(),
