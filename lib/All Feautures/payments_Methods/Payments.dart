import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:trackers/All%20Feautures/Dynamic%20Tickets/TicketDetails.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf.dart';
import 'package:mysql1/mysql1.dart';
import 'package:trackers/All%20Feautures/firstpage/booking.dart';

class TrainCard extends StatelessWidget {
  final String trainName;
  final String fromStation;
  final String toStation;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String departureCity;
  final String arrivalCity;
  final String travelClass;
  final String journeyDate;
  final List<TicketType> tickets;
  final int trainId;

  const TrainCard({
    super.key,
    required this.trainName,
    required this.fromStation,
    required this.toStation,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.departureCity,
    required this.arrivalCity,
    required this.travelClass,
    required this.journeyDate,
    required this.tickets,
    required this.trainId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(trainName),
          Text('From: $fromStation'),
          Text('To: $toStation'),
          Text('Departure: $departureTime'),
          Text('Arrival: $arrivalTime'),
          Text('Duration: $duration'),
          Text('Class: $travelClass'),
          Text('Date: $journeyDate'),
          Text('Train ID: $trainId'),
          ...tickets.map((ticket) => Text(
              'Ticket: ${ticket.type}, Price: ${ticket.price}, Available Seats: ${ticket.availableSeats}')),
        ],
      ),
    );
  }
}

class TicketType {
  final String type;
  final double price;
  final int availableSeats;

  TicketType({
    required this.type,
    required this.price,
    required this.availableSeats,
  });
}

class Order {
  final String trainId;
  final String paymentId;
  final String paymentDate;
  final String status;
  final double total;

  Order(
    String s, {
    required this.trainId,
    required this.paymentId,
    required this.paymentDate,
    required this.status,
    required this.total,
    required List<int> seatNumbers,
  });
}

class PaymentsPage extends StatefulWidget {
  final List<Order> orders;
  final String totalPrice;
  final List<int> selectedSeats;
  final String trainId;
  final List<TicketType> tickets;
  final String trainName;
  final String fromStation;
  final String toStation;
  final String departureTime;
  final String travelClass;
  final String date;


  const PaymentsPage({
    super.key,
    required this.orders,
    required this.totalPrice,
    required this.selectedSeats,
    required this.trainId,
    required this.trainName,
    required this.fromStation,
    required this.toStation,
    required this.departureTime,
    required this.tickets,
     required this.travelClass,
      required this.date,
  });

  @override
  PaymentsPageState createState() => PaymentsPageState();
}

class PaymentsPageState extends State<PaymentsPage> {
  String selectedPaymentMethod = "None";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount =
        widget.orders.fold(0, (sum, order) => sum + order.total);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.to(() => MainHomeScreen());
          },
        ),
        centerTitle: true,
        title: const Center(child: Text("Payments Details")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.orders.map((order) => OrderSummaryCard(order: order)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Amount",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "${(totalAmount + 20).toStringAsFixed(2)}/tk",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "You Have to Pay",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${(totalAmount + 20).toStringAsFixed(2)}/tk",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedPaymentMethod == "bKash"
                            ? Colors.red
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedPaymentMethod = "bKash";
                        });
                      },
                      child: Text(
                        "bKash",
                        style: TextStyle(
                          color: selectedPaymentMethod == "bKash"
                              ? Colors.white
                              : Colors.blue,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedPaymentMethod == "Card"
                            ? Colors.red
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedPaymentMethod = "Card";
                        });
                      },
                      child: Text(
                        "Card",
                        style: TextStyle(
                          color: selectedPaymentMethod == "Card"
                              ? Colors.white
                              : Colors.blue,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedPaymentMethod == "Nagad"
                            ? Colors.red
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedPaymentMethod = "Nagad";
                        });
                      },
                      child: Text(
                        "Nagad",
                        style: TextStyle(
                          color: selectedPaymentMethod == "Nagad"
                              ? Colors.white
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    final response = await http.post(
                      Uri.parse('http://10.15.10.140:3000/payments'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'ticket_id': '12345',
                        'payment_id': 'pay_001',
                        'payment_date': DateTime.now().toIso8601String(),
                        'payment_status': 'completed',
                        'total_amount': totalAmount + 20,
                        'payment_type': selectedPaymentMethod,
                      }),
                    );

                    if (response.statusCode == 200) {
                      Get.to(
                        () => TrainTicketPage(
                          name: "(User)",
                          from: widget.fromStation,
                          to:widget.toStation,
                          travelClass: widget.travelClass,
                          date:widget.date,
                          departTime: widget.departureTime,
                          seat: widget.selectedSeats.join(', '),
                          totalAmount: widget.totalPrice,
                          trainCode: widget.trainId,
                        ),
                      );
                    } else {
                      _showPaymentMethodError();
                    }
                  },
                  child: const Center(
                    child: Text(
                      "Pay Now",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Selected Payment Method: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      selectedPaymentMethod,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentMethodError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text("Please select a payment method."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class OrderSummaryCard extends StatelessWidget {
  final Order order;
  const OrderSummaryCard({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Train ID #",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(order.trainId.toString()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Payment ID #",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(order.paymentId.toString()),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Payment Date #",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(order.paymentDate),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Status #",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(order.status.toString()),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total price (with extra VAT%):",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${order.total.toStringAsFixed(2)}/tk"),
              ],
            ),
            const SizedBox(height: 5),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bank Charge:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("20/tk"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Amount (including Bank Charge):",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${(order.total + 20).toStringAsFixed(2)}/tk"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//api call//

const int PORT = 3000;

// Database Configuration
final ConnectionSettings settings = ConnectionSettings(
  host: 'localhost',
  port: 3306,
  user: 'root',
  db: 'bd_railways',
  password: '',
);

Future<shelf.Response> savePaymentDetails(Request request) async {
  try {
    final body = jsonDecode(await request.readAsString());
    if (!body.containsKey('ticket_id') ||
        !body.containsKey('payment_id') ||
        !body.containsKey('payment_date') ||
        !body.containsKey('payment_status') ||
        !body.containsKey('total_amount') ||
        !body.containsKey('payment_type')) {
      return shelf.Response(400,
          body: jsonEncode({'error': 'Missing required fields'}));
    }

    final conn = await MySqlConnection.connect(settings);
    await conn.query(
      'INSERT INTO payments (ticket_id, payment_id, payment_date, payment_status, total_amount, payment_type) VALUES (?, ?, ?, ?, ?, ?)',
      [
        body['ticket_id'],
        body['payment_id'],
        body['payment_date'],
        body['payment_status'],
        body['total_amount'],
        body['payment_type'],
      ],
    );
    await conn.close();

    return shelf.Response.ok(
        jsonEncode({'message': 'Payment saved successfully'}));
  } catch (e) {
    return shelf.Response.internalServerError(
        body: jsonEncode({'error': 'Database error', 'details': e.toString()}));
  }
}

Future<shelf.Response> fetchOrders(Request request) async {
  try {
    final conn = await MySqlConnection.connect(settings);
    final results = await conn.query('SELECT * FROM orders');
    await conn.close();

    final orders = results.map((row) => row.fields).toList();
    return shelf.Response.ok(jsonEncode(orders));
  } catch (e) {
    return shelf.Response.internalServerError(
        body: jsonEncode({'error': 'Database error', 'details': e.toString()}));
  }
}













// }
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:shelf/shelf.dart';
// import 'package:shelf_router/shelf_router.dart';
// import 'package:shelf/shelf_io.dart' as shelf_io;

//   shelf.Response _handleBadRequest(String message) {
//     return shelf.Response(400,
//         body: jsonEncode({'error': message}),
//         headers: {'Content-Type': 'application/json'});
//   }

//   Future<shelf.Response> savePayment(shelf.Response request) async {
//     final payload = await request.readAsString();

//     final data = jsonDecode(payload) as Map<String, dynamic>;
//     final requiredFields = [
//       'ticket_id',
//       'payment_id',
//       'payment_date',
//       'payment_status',
//       'total_amount',
//       'payment_type'
//     ];

//     for (var field in requiredFields) {
//       if (!data.containsKey(field)) {
//         return _handleBadRequest('Missing required fields');
//       }
//     }

//     // Simulate saving payment
//     final payment = {
//       'ticket_id': data['ticket_id'],
//       'payment_id': data['payment_id'],
//       'payment_date': data['payment_date'],
//       'payment_status': data['payment_status'],
//       'total_amount': data['total_amount'],
//       'payment_type': data['payment_type'],
//     };

//     return shelf.Response.ok(
//       jsonEncode({'message': 'Payment saved successfully', 'payment': payment}),
//       headers: {'Content-Type': 'application/json'},
//     );
//   }

//   Future<shelf.Response> fetchOrders(Request request) async {
//     // Simulate fetching orders
//     final orders = [
//       {
//         'order_id': 1,
//         'train_id': 101,
//         'payment_id': 'pay_001',
//         'payment_date': '2023-01-01',
//         'status': 'completed',
//         'total': 100.0,
//         'created_at': '2023-01-01T10:00:00Z',
//       },
//       {
//         'order_id': 2,
//         'train_id': 102,
//         'payment_id': 'pay_002',
//         'payment_date': '2023-01-02',
//         'status': 'pending',
//         'total': 150.0,
//         'created_at': '2023-01-02T11:00:00Z',
//       },
//     ];

//     return shelf.Response.ok(
//       jsonEncode(orders),
//       headers: {'Content-Type': 'application/json'},
//     );
//   }
// }
