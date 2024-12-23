import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../booking.dart';

class TrainDetailsPage extends StatelessWidget {
  final List<Station> stations = [
    Station(name: "Dhaka", arrivalTime: "07:45 am", departureTime: null, haltTime: "0m", duration: "0h"),
    Station(name: "Biman_Bandar", arrivalTime: "08:07 am", departureTime: "08:12 am", haltTime: "5m", duration: "00:22h"),
    Station(name: "Bhairab_Bazar", arrivalTime: "09:16 am", departureTime: "09:19 am", haltTime: "3m", duration: "01:04h"),
    Station(name: "Brahmanbaria", arrivalTime: "09:39 am", departureTime: "09:43 am", haltTime: "4m", duration: "00:20h"),
    Station(name: "Akhaura", arrivalTime: "10:05 am", departureTime: "10:08 am", haltTime: "3m", duration: "00:22h"),
    Station(name: "Cumilla", arrivalTime: "10:51 am", departureTime: "10:53 am", haltTime: "2m", duration: "00:43h"),
    Station(name: "Laksam", arrivalTime: "11:15 am", departureTime: "11:17 am", haltTime: "2m", duration: "00:22h"),
    Station(name: "Gunabati", arrivalTime: "11:43 am", departureTime: "11:45 am", haltTime: "2m", duration: "00:26h"),
    Station(name: "Feni", arrivalTime: "12:00 pm", departureTime: "12:02 pm", haltTime: "2m", duration: "00:15h"),
    Station(name: "Chattogram", arrivalTime: "01:35 pm", departureTime: null, haltTime: "0m", duration: "01:33h"),
  ];

   TrainDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      title: const Text('Train Information'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
        Get.offAll(()=>const MainHomeScreen());
        },
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "TrainName",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 4),
            const Text(
              "Runs On: Fri Sat Sun Mon Tue Wed Thu",
              style: TextStyle(color: Colors.grey),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: stations.length,
                itemBuilder: (context, index) {
                  return StationWidget(station: stations[index]);
                },
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Total Duration: 05:50h",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Station {
  final String name;
  final String arrivalTime;
  final String? departureTime;
  final String haltTime;
  final String duration;

  Station({
    required this.name,
    required this.arrivalTime,
    this.departureTime,
    required this.haltTime,
    required this.duration,
  });
}

class StationWidget extends StatelessWidget {
  final Station station;

  const StationWidget({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.place, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("Arrival: ${station.arrivalTime} BST"),
                  if (station.departureTime != null)
                    Text("Depart: ${station.departureTime} BST"),
                  const SizedBox(height: 4),
                  Text("Halt: ${station.haltTime}"),
                  Text("Duration: ${station.duration}"),
                ],
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
