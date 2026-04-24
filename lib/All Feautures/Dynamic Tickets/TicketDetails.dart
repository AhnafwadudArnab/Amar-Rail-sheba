// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:amarRailSheba/All%20Feautures/firstpage/booking.dart';

class MainTicketPage extends StatefulWidget {
  const MainTicketPage({
    super.key,
    required this.name,
    required this.from,
    required this.to,
    required this.travelClass,
    required this.date,
    required this.departTime,
    required this.seat,
    required this.trainCode,
    // ignore: non_constant_identifier_names
    required this.totalAmount,
    required String train_code,
  });

  final String name;
  final String from;
  final String to;
  final String travelClass;
  final String date;
  final String departTime;
  final String seat;
  final String totalAmount;
  final String trainCode;

  @override
  _MainTicketPageState createState() => _MainTicketPageState();
}

class _MainTicketPageState extends State<MainTicketPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Ticket> pastTickets = [];
  List<Ticket> upcomingTickets = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    List<Ticket> tickets = getTicketsFromUserPaymentsAndOtherPages();

    DateTime now = DateTime.now();
    for (var ticket in tickets) {
      if (ticket.date.isBefore(now)) {
        pastTickets.add(ticket);
      } else {
        upcomingTickets.add(ticket);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Ticket> getTicketsFromUserPaymentsAndOtherPages() {
    // This method should return the list of tickets from user payments and other pages
    return [];
  }

  void addTicket(Ticket ticket) {
    setState(() {
      DateTime now = DateTime.now();
      if (ticket.date.isBefore(now)) {
        pastTickets.add(ticket);
      } else {
        upcomingTickets.add(ticket);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Tickets',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming Tickets'),
            Tab(text: 'Past Tickets'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TicketListView(
            title: 'Upcoming Tickets',
            tickets: upcomingTickets,
          ),
          TicketListView(
            title: 'Past Tickets',
            tickets: pastTickets,
          ),
        ],
      ),
    );
  }
}

class TicketListView extends StatelessWidget {
  final String title;
  final List<Ticket> tickets;

  const TicketListView({super.key, required this.title, required this.tickets});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: tickets.isEmpty
                ? _EmptyState(
                    icon: Icons.confirmation_number_outlined,
                    message: title == 'Upcoming Tickets'
                        ? 'No upcoming tickets'
                        : 'No past tickets',
                    subtitle: title == 'Upcoming Tickets'
                        ? 'Book a train to see your tickets here'
                        : 'Your completed journeys will appear here',
                  )
                : ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(tickets[index].title),
                        subtitle: Text(tickets[index].date.toString()),
                        onTap: () {
                          Get.to(() => TrainTicketPage(
                                name: tickets[index].title,
                                from: 'From Location',
                                to: 'To Location',
                                travelClass: 'Class',
                                date: tickets[index].date.toString(),
                                departTime: 'Departure Time',
                                seat: 'Seat Number',
                                totalAmount: '',
                                trainCode: '',
                              ));
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Ticket {
  final String title;
  final DateTime date;

  Ticket(this.title, this.date);
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
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
  final String totalAmount;
  final String trainCode;

  const TrainTicketPage({
    super.key,
    required this.name,
    required this.from,
    required this.to,
    required this.travelClass,
    required this.date,
    required this.departTime,
    required this.seat,
    required this.totalAmount,
    required this.trainCode,
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
            Get.to(() => const MainHomeScreen());
          },
        ),
        centerTitle: true,
        title: const Text('My Tickets'),
        actions: [
          //add a home icon to the appbar
          IconButton(
            icon: Icon(Icons.home, color: Colors.blue[400]),
            onPressed: () {
              Get.to(() => const MainHomeScreen());
            },
          ),
        ],
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
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    color: Colors.white,
                    child: Row(
                      children: [
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
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 8),
                              const Text('SEAT NO',
                                  style: TextStyle(fontSize: 8)),
                              const SizedBox(height: 4),
                              Text(
                                seat,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('Train code',
                                  style: TextStyle(fontSize: 8)),
                              const SizedBox(height: 4),
                              Text(
                                trainCode,
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

class ApiService {
  final String baseUrl = "http://10.15.10.140:3000";

  Future<bool> addBooking({
    required String name,
    required String fromStation,
    required String toStation,
    required String travelClass,
    required String date,
    required String departTime,
    required String seat,
    required double totalAmount,
    required String trainCode,
  }) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
    };
    Map<String, dynamic> requestBody = {
      "name": name,
      "from_station": fromStation,
      "to_station": toStation,
      "travel_class": travelClass,
      "date": date,
      "depart_time": departTime,
      "seat": seat,
      "total_amount": totalAmount,
      "train_code": trainCode,
    };
    var response = await http.post(Uri.parse("$baseUrl/ticket"),
        headers: requestHeaders, body: jsonEncode(requestBody));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<dynamic>> getAllBookings() async {
    var response = await http.get(Uri.parse("$baseUrl/tickets"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<Map<String, dynamic>> getBookingById(int bookingId) async {
    var response = await http.get(Uri.parse("$baseUrl/ticket/$bookingId"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load booking');
    }
  }

  Future<bool> updateBooking({
    required int id,
    required String name,
    required String fromStation,
    required String toStation,
    required String travelClass,
    required String date,
    required String departTime,
    required String seat,
    required double totalAmount,
    required String trainCode,
  }) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
    };
    Map<String, dynamic> requestBody = {
      "name": name,
      "from_station": fromStation,
      "to_station": toStation,
      "travel_class": travelClass,
      "date": date,
      "depart_time": departTime,
      "seat": seat,
      "total_amount": totalAmount,
      "train_code": trainCode,
    };
    var response = await http.put(Uri.parse("$baseUrl/ticket/$id"),
        headers: requestHeaders, body: jsonEncode(requestBody));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteBooking(int bookingId) async {
    var response = await http.delete(Uri.parse("$baseUrl/ticket/$bookingId"));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
