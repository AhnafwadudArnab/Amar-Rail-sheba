
import 'package:flutter/material.dart';
import 'package:trackers/All%20Feautures/firstpage/booking.dart';

import '../All Feautures/Emergencies/emergencies.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Flutter Demo',

      theme: ThemeData(

        primarySwatch: Colors.blue,

      ),

      initialRoute: '/',

      routes: {

        '/': (context) => const MainHomeScreen(),

        '/EmergencyScreen': (context) => EmergencyScreen(user: User('attendant')),

      },

    );

  }

}
