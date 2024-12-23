// import 'package:flutter/material.dart';

// class MainTicketPage extends StatefulWidget {
//   final String name;
//   final String from;
//   final String to;
//   final String travelClass;
//   final String date;
//   final String departTime;
//   final String seat;

//   const MainTicketPage({
//     super.key,
//     required this.name,
//     required this.from,
//     required this.to,
//     required this.travelClass,
//     required this.date,
//     required this.departTime,
//     required this.seat,
//   });

//   @override
//   _MainTicketPageState createState() => _MainTicketPageState();
// }

// class _MainTicketPageState extends State<MainTicketPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   List<Ticket> pastTickets = [];
//   List<Ticket> upcomingTickets = [];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     List<Ticket> tickets = getTicketsFromUserPaymentsAndOtherPages();

//     DateTime now = DateTime.now();
//     for (var ticket in tickets) {
//       if (ticket.date.isBefore(now)) {
//         pastTickets.add(ticket);
//       } else {
//         upcomingTickets.add(ticket);
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   List<Ticket> getTicketsFromUserPaymentsAndOtherPages() {
//     return [
//       Ticket('Dhaka to Barishal', DateTime(2021, 10, 30)),
//       Ticket('Dhaka to Rangpur', DateTime(2021, 11, 5)),
//       Ticket('Dhaka to Sylhet', DateTime(2021, 11, 10)),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           'My Tickets',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Upcoming Tickets'),
//             Tab(text: 'Past Tickets'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           TicketList(
//             title: 'Upcoming Tickets',
//             tickets: upcomingTickets,
//           ),
//           TicketList(
//             title: 'Past Tickets',
//             tickets: pastTickets,
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => TrainTicketPage(
//                 name: widget.name,
//                 from: widget.from,
//                 to: widget.to,
//                 travelClass: widget.travelClass,
//                 date: widget.date,
//                 departTime: widget.departTime,
//                 seat: widget.seat,
//               ),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class TrainTicketPage extends StatelessWidget {
//   final String name;
//   final String from;
//   final String to;
//   final String travelClass;
//   final String date;
//   final String departTime;
//   final String seat;

//   const TrainTicketPage({
//     super.key,
//     required this.name,
//     required this.from,
//     required this.to,
//     required this.travelClass,
//     required this.date,
//     required this.departTime,
//     required this.seat,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Train Ticket'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Name: $name', style: const TextStyle(fontSize: 18)),
//             Text('From: $from', style: const TextStyle(fontSize: 18)),
//             Text('To: $to', style: const TextStyle(fontSize: 18)),
//             Text('Class: $travelClass', style: const TextStyle(fontSize: 18)),
//             Text('Date: $date', style: const TextStyle(fontSize: 18)),
//             Text('Departure Time: $departTime',
//                 style: const TextStyle(fontSize: 18)),
//             Text('Seat: $seat', style: const TextStyle(fontSize: 18)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TicketList extends StatelessWidget {
//   final String title;
//   final List<Ticket> tickets;

//   const TicketList({super.key, required this.title, required this.tickets});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(10),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               title,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: tickets.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(tickets[index].title),
//                   subtitle: Text(tickets[index].date.toString()),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Ticket {
//   final String title;
//   final DateTime date;

//   Ticket(this.title, this.date);
// }
