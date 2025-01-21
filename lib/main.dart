import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'All Feautures/Seat management/Train_Seat.dart';

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
        home: SeatSelectionPage(price: 150, ticketType: 'S-Chair'),
      //home: MainHomeScreen(),
    );
  }
}


//home: SignUp(),
//home: SeatSelectionPage(price: 150, ticketType: 'SNIGDHA'),
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