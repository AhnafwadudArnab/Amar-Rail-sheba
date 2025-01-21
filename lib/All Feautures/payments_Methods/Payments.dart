import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:trackers/All%20Feautures/Dynamic%20Tickets/TicketDetails.dart';
import 'package:trackers/All%20Feautures/Seat%20management/Train_Seat.dart';

import 'package:shelf/shelf.dart' as shelf;

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

  const PaymentsPage({
    super.key,
    required this.orders,
    required this.totalPrice,
    required this.selectedSeats,
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
            Get.to(() =>
                const SeatSelectionPage(price: 250, ticketType: 'S-Chair'));
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
                    if (selectedPaymentMethod == "None") {
                      _showPaymentMethodError();
                    } else {
                      Get.off(() => TrainTicketPage(
                            name: 'John Doe',
                            from: 'Place Abu-1',
                            to: 'Place Bali-1',
                            travelClass: 'First Class',
                            date: '2023-10-10',
                            departTime: '10:00 AM',
                            seat: widget.selectedSeats.join(', '),
                            totalAmount: totalAmount.toStringAsFixed(2),
                            trainCode: 'TR-703',
                          ));
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
                const Text("Ticket ID #",
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

// Entry point for the server
Future<void> main() async {
  final app = const Pipeline().addMiddleware(logRequests()).addHandler(_router);
  final port = 3000;

  print('Server running on http://localhost:$port');
  await shelf_io.serve(app, 'localhost', port);
}

// Router to handle different endpoints
Future<shelf.Response> _router(shelf.Request request) async {
  if (request.url.path == 'payments' && request.method == 'POST') {
    return _savePayment(jsonDecode(await request.readAsString()));
  } else if (request.url.path == 'orders' && request.method == 'GET') {
    return _fetchOrders();
  } else {
    return shelf.Response.notFound('Not Found');
  }
}

// Handler to save payment details

Future<shelf.Response> _savePayment(Map<String, dynamic> requestBody) async {
  try {
    List<String> requiredFields = ['field1', 'field2', 'field3'];

    // Check for missing fields
    for (var field in requiredFields) {
      if (!requestBody.containsKey(field) || requestBody[field] == null) {
        return shelf.Response(400,
            body: jsonEncode({'error': 'Missing required fields'}));
      }
    }

    // Call your database operation here (abstracted)
    // Example: await savePaymentToDatabase(requestBody);

    return shelf.Response.ok(
        jsonEncode({'message': 'Payment saved successfully'}));
  } catch (e) {
    print('Error: $e');
    return shelf.Response(500,
        body: jsonEncode({'error': 'Internal server error'}));
  }
}

// Handler to fetch orders
Future<shelf.Response> _fetchOrders() async {
  try {
    // Call your database operation here (abstracted)
    // Example: final orders = await fetchOrdersFromDatabase();

    final orders = []; // Placeholder for actual database data
    return shelf.Response.ok(jsonEncode(orders));
  } catch (e) {
    print('Error: $e');
    return shelf.Response(500,
        body: jsonEncode({'error': 'Internal server error'}));
  }
}
