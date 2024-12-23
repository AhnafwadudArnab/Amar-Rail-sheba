import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackers/All%20Feautures/Seat%20management/Train_Seat.dart';
import 'Dynamic Tickets/TicketDetails.dart';

class PaymentsPage extends StatefulWidget {
  final List<Order> orders;

  const PaymentsPage({super.key, required this.orders});

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
                const SeatSelectionApp(price: 250, ticketType: 'S-Chair'));
          },
        ),
        centerTitle: true,
        title: const Center(child: Text("Payments Details")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            //full box decoration//
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
                        "${totalAmount.toStringAsFixed(2)}/tk",
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
                      "${totalAmount.toStringAsFixed(2)}/tk",
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
                // Add more payment methods here
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (selectedPaymentMethod == "None") {
                      _showPaymentMethodError();
                    } else {
                      Get.to(
                        () => const TrainTicketPage(
                          name: 'Ahnaf',
                          from: 'Brahmanbaria',
                          to: 'Comilla',
                          travelClass: 'S-Chair',
                          date: '26 JAN 2025',
                          departTime: '18:45',
                          seat: 'A-5',
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Pay Now",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
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
      decoration: BoxDecoration(
        //order summary card decoration//
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
                const Text("Total(with bank charge):",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${order.total.toStringAsFixed(2)}/tk"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Order {
  final String trainId;
  final String paymentId;
  final String paymentDate;
  final String status;
  final double total;
  final String seatnumbers;
  Order(
    this.seatnumbers, {
    required this.trainId,
    required this.paymentId,
    required this.paymentDate,
    required this.status,
    required this.total,
    required List<int> seatNumbers,
  });
}

// class MainTicketPage extends StatelessWidget {
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
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Ticket Details"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Name: $name", style: const TextStyle(fontSize: 18)),
//             Text("From: $from", style: const TextStyle(fontSize: 18)),
//             Text("To: $to", style: const TextStyle(fontSize: 18)),
//             Text("Class: $travelClass", style: const TextStyle(fontSize: 18)),
//             Text("Date: $date", style: const TextStyle(fontSize: 18)),
//             Text("Departure Time: $departTime",
//                 style: const TextStyle(fontSize: 18)),
//             Text("Seat: $seat", style: const TextStyle(fontSize: 18)),
//           ],
//         ),
//       ),
//     );
//   }
// }
