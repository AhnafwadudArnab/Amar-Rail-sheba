import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io'; // For file saving
import 'package:path_provider/path_provider.dart'; // For getting file path
import 'package:permission_handler/permission_handler.dart';
import 'package:trackers/All%20Feautures/firstpage/booking.dart'; // For permissions

class UpcomingTicket extends StatelessWidget {
  final List<Map<String, String>> tickets = [
    {
      //make it from database//
      'name': 'Ahnaf',
      'from': 'Dhaka',
      'to': 'Chattogram',
      'class': 'S-Chair',
      'date': '26 JAN 2025',
      'time': '18:45',
      'seat': '2, 1',
      'trainCode': 'TR123'
    },
  ];

  UpcomingTicket({super.key});

  Future<void> _downloadTicket(
      BuildContext context, Map<String, String> ticket) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          final filePath = '${directory.path}/${ticket['name']}_ticket.txt';
          final file = File(filePath);

          final ticketData = '''
          Name: ${ticket['name']}
          From: ${ticket['from']}
          To: ${ticket['to']}
          Class: ${ticket['class']}
          Date: ${ticket['date']}
          Time: ${ticket['time']}
          Seat: ${ticket['seat']}
          Train Code: ${ticket['trainCode']}
          ''';

          await file.writeAsString(ticketData);
          if (kDebugMode) {
            print('Ticket saved at $filePath');
          }
          // Optionally show a success message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ticket saved at $filePath')),
          );
        } else {
          if (kDebugMode) {
            print('Directory is null');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error saving file: $e');
        }
        // Optionally show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving ticket: $e')),
        );
      }
    } else {
      if (kDebugMode) {
        print('Permission denied');
      }
      // Optionally show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 240, 232, 232),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () {
           Get.to(() => const MainHomeScreen());
          },
        ),
        centerTitle: true,
        title: const Text('My Tickets'),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          //shamner ticket details ta//
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text('${ticket['from']} → ${ticket['to']}'),
              subtitle:
                  Text('Date: ${ticket['date']} | Time: ${ticket['time']}'),
              trailing: IconButton(
                icon: const Icon(Icons.download),
                onPressed: () => _downloadTicket(context, ticket),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketDetailsScreen(ticket: ticket),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class TicketDetailsScreen extends StatelessWidget {
  final Map<String, String> ticket;

  const TicketDetailsScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return TrainTicketPage(
      name: ticket['name']!,
      from: ticket['from']!,
      to: ticket['to']!,
      travelClass: ticket['class']!,
      date: ticket['date']!,
      departTime: ticket['time']!,
      seat: ticket['seat']!,
    );
  }
}

class TrainTicketPage extends StatelessWidget {
  final String name;
  final String from;
  final String to;
  final String travelClass;
  final String date;
  final String departTime;
  final String seat;

  const TrainTicketPage({
    super.key,
    required this.name,
    required this.from,
    required this.to,
    required this.travelClass,
    required this.date,
    required this.departTime,
    required this.seat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 240, 232, 232),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: const Text('My Tickets'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 100),
          Container(
            height: MediaQuery.of(context).size.height * 0.38,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top Section
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Train Ticket',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(Icons.train, color: Colors.white),
                      Text(
                        'Train Ticket',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Middle Section
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    color: Colors.white,
                    child: Row(
                      children: [
                        // Left Part
                        Expanded(
                          flex: -2,
                          child: Container(
                            padding: const EdgeInsets.all(1.0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                right: BorderSide(
                                  color: Colors.redAccent,
                                  width: 0.7,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('NAME',
                                    style: TextStyle(fontSize: 9)),
                                const SizedBox(height: 4),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('FROM',
                                    style: TextStyle(fontSize: 9)),
                                const SizedBox(height: 4),
                                Text(
                                  from,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('TO', style: TextStyle(fontSize: 9)),
                                const SizedBox(height: 4),
                                Text(
                                  to,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('CLASS',
                                    style: TextStyle(fontSize: 9)),
                                const SizedBox(height: 4),
                                Text(
                                  travelClass,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('DATE',
                                    style: TextStyle(fontSize: 9)),
                                const SizedBox(height: 4),
                                Text(
                                  date,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Barcode Section
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              Container(
                                height: 100,
                                width: 24,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/trainBackgrong/ladder.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right Middle Part
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('PASSENGER NAME',
                                  style: TextStyle(fontSize: 8)),
                              const SizedBox(height: 4),
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text('FROM', style: TextStyle(fontSize: 8)),
                              const SizedBox(height: 4),
                              Text(
                                from,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text('TO', style: TextStyle(fontSize: 8)),
                              const SizedBox(height: 4),
                              Text(
                                to,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text('CLASS',
                                  style: TextStyle(fontSize: 8)),
                              const SizedBox(height: 4),
                              Text(
                                travelClass,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text('DEPART TIME',
                                  style: TextStyle(fontSize: 8)),
                              const SizedBox(height: 4),
                              Text(
                                departTime,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Seat and QR Section
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 8),
                              const Text('SEAT', style: TextStyle(fontSize: 8)),
                              const SizedBox(height: 4),
                              Text(
                                seat,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 70),
                              Container(
                                height: 60,
                                width: 65,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.lightBlueAccent,
                                    width: 2,
                                  ),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/trainBackgrong/qr.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '* Please be at the platform well ahead of departure time',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
