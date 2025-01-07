import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackers/All%20Feautures/second%20pagee/Book_page_after_search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amar Rail Sheba',
      //home: SeatSelectionApp(price: 150, ticketType: 'AC',),
      //home: LiveLocation(),
      //home: ModifySearchBox(),
     //home: SearchInfoCard(from: "Dhaka", to: "Brahman-baria", date: "01.01.2025", journeyClass: "Cabin", returnFrom: "BrahmanBaria", returnTo: "Dhaka", returnDate: "05.01.2025", returnJourneyClass: "AC")
      //home:  MainHomeScreen(),
    home: TrainSearchPage(
      fromStation: 'Dhaka',
      toStation: 'Chittagong',
      travelClass: 'AC',
      journeyDate: DateTime(2025, 1, 1).toString(),
      userId: 'user123',
    ),
      //home: TrainTicketPage(),
      //home: Onboard(),
    );
  }
}