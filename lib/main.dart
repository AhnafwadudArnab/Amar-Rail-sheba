import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackers/Login&Signup/Login.dart';
import 'package:trackers/Login&Signup/sign_up.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bangladesh Railway',
      // home: MainTicketPage(
      //   name: 'John Doe',
      //   from: 'Dhaka',
      //   to: 'Chittagong',
      //   travelClass: 'First Class',
      //   date: DateTime.now().toString(),
      //   departTime: '10:00 AM',
      //   seat: 'A1',
      // ),
      //home: booking.MainHomeScreen(),
      home: SignUp(),
      // home: TrainSearchPage(
      //   fromStation: 'Dhaka',
      //   toStation: 'Chittagong',
      //   travelClass: 'First Class',
      //   journeyDate: DateTime.now().toString(),),
      //home: TrainTicketPage(),
    );
  }
}
