import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amarRailSheba/utils/responsive.dart';
import '../All Feautures/firstpage/booking.dart';

class TrainDetailsPage extends StatelessWidget {
  final Map<String, List<Station>> trainStations;
  const TrainDetailsPage({super.key, required this.trainStations});

  @override
  Widget build(BuildContext context) {
    if (trainStations.isEmpty) {
      return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Train Information'),
          leading: IconButton(icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.offAll(() => const TrainListPage()))),
        body: const Center(child: Text('No train information available')),
      );
    }
    final trainName = trainStations.keys.first;
    final stations = trainStations[trainName]!;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Train Information'),
        leading: IconButton(icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.offAll(() => const TrainListPage()))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Builder(builder: (ctx) {
            final r = R.of(ctx);
            return Padding(
              padding: EdgeInsets.all(r.sp16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Runs On: Fri Sat Sun Mon Tue Wed Thu",
                    style: TextStyle(color: Colors.grey, fontSize: r.fs12)),
                SizedBox(height: r.sp16),
                Expanded(
                  child: ListView.builder(
                    itemCount: stations.length,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(vertical: r.sp8),
                      padding: EdgeInsets.all(r.sp12),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.3),
                            spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))],
                      ),
                      child: StationWidget(station: stations[index]),
                    ),
                  ),
                ),
              ]),
            );
          }),
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
  const Station({required this.name, this.arrivalTime, this.departureTime,
      required this.haltTime, required this.duration});
}

class StationWidget extends StatelessWidget {
  final Station station;
  const StationWidget({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.place, color: Colors.green, size: r.fs20),
        SizedBox(width: r.sp8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(station.name, style: TextStyle(fontSize: r.fs15, fontWeight: FontWeight.bold)),
          if (station.arrivalTime != null)
            Text("Arrival: ${station.arrivalTime} BST", style: TextStyle(fontSize: r.fs13)),
          if (station.departureTime != null)
            Text("Depart: ${station.departureTime} BST", style: TextStyle(fontSize: r.fs13)),
          SizedBox(height: r.sp4),
          Text("Halt: ${station.haltTime}", style: TextStyle(fontSize: r.fs12)),
          Text("Duration: ${station.duration}", style: TextStyle(fontSize: r.fs12)),
        ])),
      ]),
      const Divider(),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DHA–CTG  (ঢাকা → চট্টগ্রাম)
// ─────────────────────────────────────────────────────────────────────────────
const _dhaCtg = [
  Station(name: 'Dhaka (Kamalapur)', departureTime: null, haltTime: '0m',  duration: '0h 0m'),
  Station(name: 'Airport',           arrivalTime: '07:20 am', departureTime: '07:25 am', haltTime: '5m',  duration: '0h 20m'),
  Station(name: 'Bhairab Bazar',     arrivalTime: '09:10 am', departureTime: '09:13 am', haltTime: '3m',  duration: '2h 10m'),
  Station(name: 'Brahman Baria',     arrivalTime: '09:45 am', departureTime: '09:47 am', haltTime: '2m',  duration: '2h 45m'),
  Station(name: 'Akhaura',           arrivalTime: '10:20 am', departureTime: '10:25 am', haltTime: '5m',  duration: '3h 20m'),
  Station(name: 'Comilla',           arrivalTime: '11:05 am', departureTime: '11:07 am', haltTime: '2m',  duration: '4h 5m'),
  Station(name: 'Laksham',           arrivalTime: '11:30 am', departureTime: '11:32 am', haltTime: '2m',  duration: '4h 30m'),
  Station(name: 'Feni',              arrivalTime: '12:00 pm', departureTime: '12:02 pm', haltTime: '2m',  duration: '5h 0m'),
  Station(name: 'Chattogram',        arrivalTime: '01:30 pm', departureTime: null,        haltTime: '0m',  duration: '6h 30m'),
];

// ─────────────────────────────────────────────────────────────────────────────
// DHA–SYL  (ঢাকা → সিলেট)
// ─────────────────────────────────────────────────────────────────────────────
const _dhaSyl = [
  Station(name: 'Dhaka (Kamalapur)', departureTime: null, haltTime: '0m',  duration: '0h 0m'),
  Station(name: 'Airport',           arrivalTime: '07:05 am', departureTime: '07:10 am', haltTime: '5m',  duration: '0h 25m'),
  Station(name: 'Bhairab Bazar',     arrivalTime: '08:30 am', departureTime: '08:33 am', haltTime: '3m',  duration: '1h 50m'),
  Station(name: 'Brahman Baria',     arrivalTime: '08:55 am', departureTime: '08:58 am', haltTime: '3m',  duration: '2h 15m'),
  Station(name: 'Akhaura',           arrivalTime: '09:30 am', departureTime: '09:35 am', haltTime: '5m',  duration: '2h 50m'),
  Station(name: 'Sreemangal',        arrivalTime: '11:10 am', departureTime: '11:13 am', haltTime: '3m',  duration: '4h 30m'),
  Station(name: 'Kulaura',           arrivalTime: '11:55 am', departureTime: '11:57 am', haltTime: '2m',  duration: '5h 15m'),
  Station(name: 'Moulvibazar',       arrivalTime: '12:20 pm', departureTime: '12:22 pm', haltTime: '2m',  duration: '5h 40m'),
  Station(name: 'Sylhet',            arrivalTime: '01:40 pm', departureTime: null,        haltTime: '0m',  duration: '7h 0m'),
];

// ─────────────────────────────────────────────────────────────────────────────
// CTG–SYL  (চট্টগ্রাম → সিলেট)
// ─────────────────────────────────────────────────────────────────────────────
const _ctgSyl = [
  Station(name: 'Chattogram', departureTime: null, haltTime: '0m',  duration: '0h 0m'),
  Station(name: 'Feni',       arrivalTime: '08:30 am', departureTime: '08:32 am', haltTime: '2m',  duration: '1h 30m'),
  Station(name: 'Laksham',    arrivalTime: '09:00 am', departureTime: '09:02 am', haltTime: '2m',  duration: '2h 0m'),
  Station(name: 'Akhaura',    arrivalTime: '10:30 am', departureTime: '10:35 am', haltTime: '5m',  duration: '3h 30m'),
  Station(name: 'Sreemangal', arrivalTime: '12:00 pm', departureTime: '12:03 pm', haltTime: '3m',  duration: '5h 0m'),
  Station(name: 'Kulaura',    arrivalTime: '12:45 pm', departureTime: '12:47 pm', haltTime: '2m',  duration: '5h 45m'),
  Station(name: 'Sylhet',     arrivalTime: '01:30 pm', departureTime: null,        haltTime: '0m',  duration: '6h 30m'),
];

// ─────────────────────────────────────────────────────────────────────────────
// DHA–RAJ  (ঢাকা → রাজশাহী)
// ─────────────────────────────────────────────────────────────────────────────
const _dhaRaj = [
  Station(name: 'Dhaka (Kamalapur)',  departureTime: null, haltTime: '0m',  duration: '0h 0m'),
  Station(name: 'Airport',            arrivalTime: '02:55 pm', departureTime: '03:00 pm', haltTime: '5m',  duration: '0h 20m'),
  Station(name: 'Joydebpur',          arrivalTime: '03:25 pm', departureTime: '03:27 pm', haltTime: '2m',  duration: '0h 47m'),
  Station(name: 'Bangabandhu Bridge', arrivalTime: '05:05 pm', departureTime: '05:10 pm', haltTime: '5m',  duration: '2h 30m'),
  Station(name: 'Ishwardi',           arrivalTime: '07:05 pm', departureTime: '07:10 pm', haltTime: '5m',  duration: '4h 30m'),
  Station(name: 'Natore',             arrivalTime: '07:45 pm', departureTime: '07:47 pm', haltTime: '2m',  duration: '5h 7m'),
  Station(name: 'Rajshahi',           arrivalTime: '08:40 pm', departureTime: null,        haltTime: '0m',  duration: '6h 0m'),
];

// ─────────────────────────────────────────────────────────────────────────────
// DHA–KHL  (ঢাকা → খুলনা)
// ─────────────────────────────────────────────────────────────────────────────
const _dhaKhl = [
  Station(name: 'Dhaka (Kamalapur)', departureTime: null, haltTime: '0m',  duration: '0h 0m'),
  Station(name: 'Airport',           arrivalTime: '06:35 am', departureTime: '06:40 am', haltTime: '5m',  duration: '0h 20m'),
  Station(name: 'Joydebpur',         arrivalTime: '07:05 am', departureTime: '07:07 am', haltTime: '2m',  duration: '0h 47m'),
  Station(name: 'Poradah',           arrivalTime: '09:45 am', departureTime: '09:48 am', haltTime: '3m',  duration: '3h 28m'),
  Station(name: 'Kushtia',           arrivalTime: '10:35 am', departureTime: '10:38 am', haltTime: '3m',  duration: '4h 18m'),
  Station(name: 'Jessore',           arrivalTime: '12:15 pm', departureTime: '12:20 pm', haltTime: '5m',  duration: '5h 55m'),
  Station(name: 'Khulna',            arrivalTime: '01:50 pm', departureTime: null,        haltTime: '0m',  duration: '7h 30m'),
];

// ─────────────────────────────────────────────────────────────────────────────
// DHA–RNG  (ঢাকা → রংপুর)
// ─────────────────────────────────────────────────────────────────────────────
const _dhaRng = [
  Station(name: 'Dhaka (Kamalapur)',  departureTime: null, haltTime: '0m',  duration: '0h 0m'),
  Station(name: 'Airport',            arrivalTime: '09:15 am', departureTime: '09:20 am', haltTime: '5m',  duration: '0h 20m'),
  Station(name: 'Joydebpur',          arrivalTime: '09:45 am', departureTime: '09:47 am', haltTime: '2m',  duration: '0h 47m'),
  Station(name: 'Bangabandhu Bridge', arrivalTime: '11:25 am', departureTime: '11:30 am', haltTime: '5m',  duration: '2h 30m'),
  Station(name: 'Bogura',             arrivalTime: '01:25 pm', departureTime: '01:30 pm', haltTime: '5m',  duration: '4h 30m'),
  Station(name: 'Gaibandha',          arrivalTime: '02:25 pm', departureTime: '02:28 pm', haltTime: '3m',  duration: '5h 28m'),
  Station(name: 'Rangpur',            arrivalTime: '03:30 pm', departureTime: null,        haltTime: '0m',  duration: '6h 30m'),
];

// ─────────────────────────────────────────────────────────────────────────────
// DHA–DNJ  (ঢাকা → দিনাজপুর)
// ─────────────────────────────────────────────────────────────────────────────
const _dhaDnj = [
  Station(name: 'Dhaka (Kamalapur)',  departureTime: null, haltTime: '0m',  duration: '0h 0m'),
  Station(name: 'Airport',            arrivalTime: '10:15 pm', departureTime: '10:20 pm', haltTime: '5m',  duration: '0h 20m'),
  Station(name: 'Joydebpur',          arrivalTime: '10:45 pm', departureTime: '10:47 pm', haltTime: '2m',  duration: '0h 47m'),
  Station(name: 'Bangabandhu Bridge', arrivalTime: '12:25 am', departureTime: '12:30 am', haltTime: '5m',  duration: '2h 30m'),
  Station(name: 'Parbatipur',         arrivalTime: '03:25 am', departureTime: '03:30 am', haltTime: '5m',  duration: '5h 30m'),
  Station(name: 'Dinajpur',           arrivalTime: '04:30 am', departureTime: null,        haltTime: '0m',  duration: '6h 30m'),
];

// ─────────────────────────────────────────────────────────────────────────────
// Master train map  (route label → train name → stations)
// ─────────────────────────────────────────────────────────────────────────────
final Map<String, List<Station>> trainStations = {
  // DHA–CTG
  'Subarna Express (701)':       _dhaCtg,
  'Sonar Bangla Express (787)':  _dhaCtg,
  'Mahanagar Provati (703)':     _dhaCtg,
  'Turna Nishitha (741)':        _dhaCtg,
  // DHA–SYL
  'Parabat Express (709)':       _dhaSyl,
  'Jayantika Express (775)':     _dhaSyl,
  'Upaban Express (743)':        _dhaSyl,
  'Kalni Express (773)':         _dhaSyl,
  // CTG–SYL
  'Paharika Express (725)':      _ctgSyl,
  'Udayan Express (723)':        _ctgSyl,
  // DHA–RAJ
  'Silk City Express (753)':     _dhaRaj,
  'Padma Express (757)':         _dhaRaj,
  'Dhumketu Express (759)':      _dhaRaj,
  // DHA–KHL
  'Sundarban Express (725)':     _dhaKhl,
  'Chitra Express (763)':        _dhaKhl,
  // DHA–RNG
  'Rangpur Express (771)':       _dhaRng,
  'Kurigram Express (797)':      _dhaRng,
  // DHA–DNJ
  'Ekota Express (705)':         _dhaDnj,
  'Drutojan Express (757)':      _dhaDnj,
};

// ─────────────────────────────────────────────────────────────────────────────
// Train List Page
// ─────────────────────────────────────────────────────────────────────────────
class TrainListPage extends StatelessWidget {
  const TrainListPage({super.key});

  // Group trains by route for section headers
  static const Map<String, List<String>> _routeGroups = {
    '🚆 Dhaka → Chattogram': [
      'Subarna Express (701)', 'Sonar Bangla Express (787)',
      'Mahanagar Provati (703)', 'Turna Nishitha (741)',
    ],
    '🚆 Dhaka → Sylhet': [
      'Parabat Express (709)', 'Jayantika Express (775)',
      'Upaban Express (743)', 'Kalni Express (773)',
    ],
    '🚆 Chattogram → Sylhet': [
      'Paharika Express (725)', 'Udayan Express (723)',
    ],
    '🚆 Dhaka → Rajshahi': [
      'Silk City Express (753)', 'Padma Express (757)', 'Dhumketu Express (759)',
    ],
    '🚆 Dhaka → Khulna': [
      'Sundarban Express (725)', 'Chitra Express (763)',
    ],
    '🚆 Dhaka → Rangpur': [
      'Rangpur Express (771)', 'Kurigram Express (797)',
    ],
    '🚆 Dhaka → Dinajpur': [
      'Ekota Express (705)', 'Drutojan Express (757)',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Train List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Get.to(() => const MainHomeScreen()),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: r.sp8),
            children: _routeGroups.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: r.sp16, vertical: r.sp10),
                    color: const Color(0xFF1A3A6B).withValues(alpha: 0.08),
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: r.fs13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A3A6B),
                      ),
                    ),
                  ),
                  // Train tiles
                  ...entry.value.map((trainName) => Container(
                    margin: EdgeInsets.symmetric(vertical: r.sp4, horizontal: r.sp16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.3),
                        spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3),
                      )],
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.train, color: Color(0xFF1A3A6B)),
                      title: Text(trainName, style: TextStyle(fontSize: r.fs13)),
                      trailing: Icon(Icons.arrow_forward_ios, size: r.fs13),
                      onTap: () => Get.to(() => TrainDetailsPage(
                          trainStations: {trainName: trainStations[trainName] ?? []})),
                    ),
                  )),
                  SizedBox(height: r.sp8),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
