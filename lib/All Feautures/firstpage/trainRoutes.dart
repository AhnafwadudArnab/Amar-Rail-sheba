import 'package:flutter/material.dart';

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

class TrainRoutes extends StatelessWidget {
  final List<Station> stations;

  const TrainRoutes({super.key, required this.stations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train Routes'),
      ),
      body: stations.isNotEmpty ? _buildRouteList() : _buildNoRoutesMessage(),
    );
  }

  Widget _buildRouteList() {
    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        return Card(
          child: ListTile(
            title: Text(station.name),
            subtitle: Text(
              'Arrival: ${station.arrivalTime ?? 'N/A'}, Departure: ${station.departureTime ?? 'N/A'}, Halt: ${station.haltTime}, Duration: ${station.duration}',
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoRoutesMessage() {
    return const Center(
      child: Text(
        'There is no route for this train yet.',
        style: TextStyle(fontSize: 18),
      ),
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
      name: "Bhairab_Bazar",
      arrivalTime: "08:30 am",
      departureTime: "08:33 am",
      haltTime: "3m",
      duration: "01:05h"),
  const Station(
      name: "Cumilla",
      arrivalTime: "09:40 am",
      departureTime: "09:42 am",
      haltTime: "2m",
      duration: "01:07h"),
  const Station(
      name: "Feni",
      arrivalTime: "10:15 am",
      departureTime: "10:17 am",
      haltTime: "2m",
      duration: "00:33h"),
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
      name: "Cumilla",
      arrivalTime: "11:10 am",
      departureTime: "11:12 am",
      haltTime: "2m",
      duration: "01:07h"),
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
      duration: "0h"),
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

class TrainCard extends StatelessWidget {
  final String trainName;
  final List<Station> stations;

  const TrainCard({super.key, required this.trainName, required this.stations});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(trainName),
        subtitle: stations.isNotEmpty
            ? Text('Route: ${stations.first.name} to ${stations.last.name}')
            : const Text('There is no route for this train yet.'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrainRoutes(stations: stations),
            ),
          );
        },
      ),
    );
  }
}

class TrainList extends StatelessWidget {
  final Map<String, List<Station>> trainRoutes = {
    'Subarna Express': subarnaExpressStations,
    'Mohanagar Godhuli': mohanagarGodhuliStations,
    'Mohanagar Express': mohanagarExpressStations,
    'Turna Nishitha': turnaNishithaStations,
    'Parabat Express': parabatExpressStations,
  };

   TrainList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train List'),
      ),
      body: ListView.builder(
        itemCount: trainRoutes.length,
        itemBuilder: (context, index) {
          final trainName = trainRoutes.keys.elementAt(index);
          final stations = trainRoutes[trainName]!;
          return TrainCard(trainName: trainName, stations: stations);
        },
      ),
    );
  }
}
class TrainPrices extends StatelessWidget {
  final String trainName;
  final List<Map<String, dynamic>> prices;

  const TrainPrices({super.key, required this.trainName, required this.prices});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$trainName Ticket Prices'),
      ),
      body: ListView.builder(
        itemCount: prices.length,
        itemBuilder: (context, index) {
          final price = prices[index];
          return Card(
            child: ListTile(
              title: Text('${price['from']} to ${price['to']}'),
              subtitle: Text(
                'S-chair: ${price['S-chair']}, AC: ${price['AC']}, Cabin: ${price['Cabin']}',
              ),
            ),
          );
        },
      ),
    );
  }
}

final List<Map<String, dynamic>> subarnaExpressPrices = [
  {'from': 'Dhaka', 'to': 'Biman_Bandar', 'S-chair': 150, 'AC': 350, 'Cabin': 700},
  {'from': 'Biman_Bandar', 'to': 'Bhairab_Bazar', 'S-chair': 120, 'AC': 280, 'Cabin': 600},
  {'from': 'Bhairab_Bazar', 'to': 'Cumilla', 'S-chair': 100, 'AC': 250, 'Cabin': 550},
  {'from': 'Cumilla', 'to': 'Feni', 'S-chair': 80, 'AC': 210, 'Cabin': 500},
  {'from': 'Feni', 'to': 'Chattogram', 'S-chair': 150, 'AC': 350, 'Cabin': 750},
];

final List<Map<String, dynamic>> mohanagarGodhuliPrices = [
  {'from': 'Chattogram', 'to': 'Feni', 'S-chair': 160, 'AC': 360, 'Cabin': 720},
  {'from': 'Feni', 'to': 'Cumilla', 'S-chair': 130, 'AC': 310, 'Cabin': 640},
  {'from': 'Cumilla', 'to': 'Bhairab_Bazar', 'S-chair': 110, 'AC': 260, 'Cabin': 580},
  {'from': 'Bhairab_Bazar', 'to': 'Biman_Bandar', 'S-chair': 120, 'AC': 280, 'Cabin': 600},
  {'from': 'Biman_Bandar', 'to': 'Dhaka', 'S-chair': 150, 'AC': 350, 'Cabin': 700},
];
final List<Map<String, dynamic>> mohanagarExpressPrices = [
  {'from': 'Dhaka', 'to': 'Biman_Bandar', 'S-chair': 140, 'AC': 330, 'Cabin': 690},
  {'from': 'Biman_Bandar', 'to': 'Bhairab_Bazar', 'S-chair': 110, 'AC': 270, 'Cabin': 590},
  {'from': 'Bhairab_Bazar', 'to': 'Cumilla', 'S-chair': 90, 'AC': 230, 'Cabin': 550},
  {'from': 'Cumilla', 'to': 'Feni', 'S-chair': 80, 'AC': 200, 'Cabin': 500},
  {'from': 'Feni', 'to': 'Chattogram', 'S-chair': 140, 'AC': 340, 'Cabin': 730},
];

final List<Map<String, dynamic>> turnaNishithaPrices = [
  {'from': 'Chattogram', 'to': 'Feni', 'S-chair': 150, 'AC': 350, 'Cabin': 710},
  {'from': 'Feni', 'to': 'Cumilla', 'S-chair': 120, 'AC': 280, 'Cabin': 600},
  {'from': 'Cumilla', 'to': 'Bhairab_Bazar', 'S-chair': 100, 'AC': 250, 'Cabin': 570},
  {'from': 'Bhairab_Bazar', 'to': 'Biman_Bandar', 'S-chair': 110, 'AC': 260, 'Cabin': 590},
  {'from': 'Biman_Bandar', 'to': 'Dhaka', 'S-chair': 140, 'AC': 330, 'Cabin': 700},
];

final List<Map<String, dynamic>> parabatExpressPrices = [
  {'from': 'Dhaka', 'to': 'Biman_Bandar', 'S-chair': 140, 'AC': 330, 'Cabin': 690},
  {'from': 'Biman_Bandar', 'to': 'Bhairab_Bazar', 'S-chair': 110, 'AC': 260, 'Cabin': 600},
  {'from': 'Bhairab_Bazar', 'to': 'Brahmanbaria', 'S-chair': 90, 'AC': 220, 'Cabin': 550},
  {'from': 'Brahmanbaria', 'to': 'Akhaura', 'S-chair': 80, 'AC': 200, 'Cabin': 500},
  {'from': 'Akhaura', 'to': 'Sylhet', 'S-chair': 200, 'AC': 400, 'Cabin': 800},
];
