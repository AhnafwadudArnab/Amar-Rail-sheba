import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackers/All%20Feautures/firstpage/booking.dart';

class TrainDetailsPage extends StatelessWidget {
  final Map<String, List<Station>> trainStations;

  const TrainDetailsPage({super.key, required this.trainStations});

  @override
  Widget build(BuildContext context) {
    if (trainStations.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Train Information'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.offAll(() => const TrainListPage());
            },
          ),
        ),
        body: const Center(
          child: Text('No train information available'),
        ),
      );
    }

    String trainName = trainStations.keys.first;
    List<Station> stations = trainStations[trainName]!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Train Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(() => const TrainListPage());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            const Text(
              "Runs On: Fri Sat Sun Mon Tue Wed Thu",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: stations.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: StationWidget(station: stations[index]),
                  );
                },
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
  final String? arrivalTime;
  final String? departureTime;
  final String haltTime;
  final String duration;

  const Station({
    required this.name,
    this.arrivalTime,
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
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (station.arrivalTime != null)
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

final List<Station> subarnaExpressStations = [
  const Station(
      name: "Dhaka",
      arrivalTime: "07:00 am",
      departureTime: null,
      haltTime: "0m",
      duration: "0h"),
  const Station(
      name: "Biman_Bandar",
      arrivalTime: "07:20 am",
      departureTime: "07:25 am",
      haltTime: "5m",
      duration: "00:20h"),
  const Station(
      name: "Chattogram",
      arrivalTime: "11:30 am",
      departureTime: null,
      haltTime: "0m",
      duration: "01:13h"),
];
final List<Station> mohanagarGodhuliStations = [
  const Station(
      name: "Chattogram",
      arrivalTime: "03:00 pm",
      departureTime: null,
      haltTime: "0m",
      duration: "0h"),
  const Station(
      name: "Feni",
      arrivalTime: "04:10 pm",
      departureTime: "04:12 pm",
      haltTime: "2m",
      duration: "01:10h"),
  const Station(
      name: "Cumilla",
      arrivalTime: "04:45 pm",
      departureTime: "04:47 pm",
      haltTime: "2m",
      duration: "00:35h"),
  const Station(
      name: "Bhairab_Bazar",
      arrivalTime: "05:50 pm",
      departureTime: "05:52 pm",
      haltTime: "2m",
      duration: "01:03h"),
  const Station(
      name: "Biman_Bandar",
      arrivalTime: "06:40 pm",
      departureTime: "06:45 pm",
      haltTime: "5m",
      duration: "00:48h"),
  const Station(
      name: "Dhaka",
      arrivalTime: "07:10 pm",
      departureTime: null,
      haltTime: "0m",
      duration: "00:25h"),
];

final List<Station> mohanagarExpressStations = [
  const Station(
      name: "Dhaka",
      arrivalTime: "08:30 am",
      departureTime: null,
      haltTime: "0m",
      duration: "0h"),
  const Station(
      name: "Biman_Bandar",
      arrivalTime: "08:50 am",
      departureTime: "08:55 am",
      haltTime: "5m",
      duration: "00:20h"),
  const Station(
      name: "Bhairab_Bazar",
      arrivalTime: "10:00 am",
      departureTime: "10:03 am",
      haltTime: "3m",
      duration: "01:05h"),
  const Station(
      name: "Brahmanbaria",
      arrivalTime: "10:25 am",
      departureTime: "10:27 am",
      haltTime: "2m",
      duration: "00:22h"),
  const Station(
      name: "Akhaura",
      arrivalTime: "11:00 am",
      departureTime: "11:05 am",
      haltTime: "5m",
      duration: "00:33h"),
  const Station(
      name: "Cumilla",
      arrivalTime: "11:10 am",
      departureTime: "11:12 am",
      haltTime: "2m",
      duration: "01:07h"),
  const Station(
      name: "Laksham",
      arrivalTime: "11:30 am",
      departureTime: "11:32 am",
      haltTime: "2m",
      duration: "00:18h"),
  const Station(
      name: "Feni",
      arrivalTime: "11:45 am",
      departureTime: "11:47 am",
      haltTime: "2m",
      duration: "00:33h"),
  const Station(
      name: "Chattogram",
      arrivalTime: "01:00 pm",
      departureTime: null,
      haltTime: "0m",
      duration: "01:13h"),
];

final List<Station> turnaNishithaStations = [
  const Station(
    name: "Chattogram",
    arrivalTime: "10:00 pm",
    departureTime: null,
    haltTime: "0m",
    duration: "0h",
  ),
  const Station(
      name: "Feni",
      arrivalTime: "11:30 pm",
      departureTime: "11:32 pm",
      haltTime: "2m",
      duration: "01:30h"),
  const Station(
      name: "Cumilla",
      arrivalTime: "12:05 am",
      departureTime: "12:07 am",
      haltTime: "2m",
      duration: "00:35h"),
  const Station(
      name: "Bhairab_Bazar",
      arrivalTime: "01:30 am",
      departureTime: "01:33 am",
      haltTime: "3m",
      duration: "01:23h"),
  const Station(
      name: "Biman_Bandar",
      arrivalTime: "02:20 am",
      departureTime: "02:25 am",
      haltTime: "5m",
      duration: "00:47h"),
  const Station(
      name: "Dhaka",
      arrivalTime: "02:50 am",
      departureTime: null,
      haltTime: "0m",
      duration: "00:25h"),
];

final List<Station> parabatExpressStations = [
  const Station(
      name: "Dhaka",
      arrivalTime: "06:40 am",
      departureTime: null,
      haltTime: "0m",
      duration: "0h"),
  const Station(
      name: "Biman_Bandar",
      arrivalTime: "07:05 am",
      departureTime: "07:10 am",
      haltTime: "5m",
      duration: "00:25h"),
  const Station(
      name: "Bhairab_Bazar",
      arrivalTime: "08:30 am",
      departureTime: "08:33 am",
      haltTime: "3m",
      duration: "01:20h"),
  const Station(
      name: "Brahmanbaria",
      arrivalTime: "08:55 am",
      departureTime: "08:58 am",
      haltTime: "3m",
      duration: "00:22h"),
  const Station(
      name: "Akhaura",
      arrivalTime: "09:30 am",
      departureTime: "09:35 am",
      haltTime: "5m",
      duration: "00:37h"),
  const Station(
      name: "Sylhet",
      arrivalTime: "12:20 pm",
      departureTime: null,
      haltTime: "0m",
      duration: "02:45h"),
];

final Map<String, List<Station>> trainStations = {
  'Subarna Express': subarnaExpressStations,
  'Mohanagar Godhuli': mohanagarGodhuliStations,
  'Mohanagar Express': mohanagarExpressStations,
  'Turna Nishitha': turnaNishithaStations,
  'Parabat Express': parabatExpressStations,
};

class TrainListPage extends StatelessWidget {
  const TrainListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Train List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Get.off(() => const MainHomeScreen());
            },
          ),
        ],
      ),
      // ...existing code...
      body: ListView.builder(
        itemCount: trainStations.keys.length,
        itemBuilder: (context, index) {
          String trainName = trainStations.keys.elementAt(index);
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Text(trainName),
              // ...existing code...
              onTap: () {
                String trainName = trainStations.keys.elementAt(index);
                if (kDebugMode) {
                  print('Navigating to TrainDetailsPage with train: $trainName');
                }
                if (kDebugMode) {
                  print('Stations: ${trainStations[trainName]}');
                }
                Get.to(() => TrainDetailsPage(trainStations: {
                      trainName: trainStations[trainName] ?? []
                    }));
              },
// ...existing code...
            ),
          );
        },
      ),
// ...existing code...
    );
  }
}
