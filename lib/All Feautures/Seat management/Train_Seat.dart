import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';

import '../payments_Methods/Payments.dart';
import '../second pagee/Book_page_after_search.dart';

void navigateToPage(BuildContext context, String ticketType) {
  if (ticketType == "AC_S") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const SeatSelectionApp(price: 350, ticketType: 'AC_S'),
      ),
    );
  } else if (ticketType == "SNIGDHA") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const SeatSelectionApp(price: 400, ticketType: 'SNIGDHA'),
      ),
    );
  } else if (ticketType == "S_CHAIR") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const SeatSelectionApp(price: 250, ticketType: 'S_CHAIR'),
      ),
    );
  }
}

class SeatSelectionApp extends StatelessWidget {
  const SeatSelectionApp(
      {super.key, required int price, required String ticketType});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SeatSelectionPage(),
    );
  }
}

class SeatSelectionPage extends StatefulWidget {
  const SeatSelectionPage({super.key});

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  List<String> seatStatus = [];
  List<int> selectedSeats = [];
  Timer? timer;
  int allowedSeats = 4;
  List<Map<String, dynamic>> coaches = [
    {"name": "C-1", "seats": 60, "type": "AC_S"},
    {"name": "C-2", "seats": 58, "type": "AC_S"},
    {"name": "C-5A", "seats": 35, "type": "SNIGDHA"},
    {"name": "C-7A", "seats": 35, "type": "SNIGDHA"},
    {"name": "C-1S", "seats": 25, "type": "S_CHAIR"},
    {"name": "C-3S", "seats": 25, "type": "S_CHAIR"},
    {"name": "C-4S", "seats": 59, "type": "S_CHAIR"},
  ];
  String selectedCoach = "C-1";

  @override
  void initState() {
    super.initState();
    seatStatus = List.generate(
        coaches.firstWhere((coach) => coach['name'] == selectedCoach)['seats'],
        (index) => 'available');
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      setState(() {
        selectedSeats.clear();
      });
    });
  }

  void handleSeatSelection(int index) {
    setState(() {
      if (selectedSeats.contains(index)) {
        selectedSeats.remove(index);
        seatStatus[index] = 'available';
      } else if (selectedSeats.length < allowedSeats &&
          seatStatus[index] == 'available') {
        selectedSeats.add(index);
        seatStatus[index] = 'selected';
      }
    });
  }

  Color getSeatColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'selected':
        return Colors.orange;
      case 'booked':
        return Colors.red;
      case 'unselected':
        return Colors.grey[300]!;
      default:
        return Colors.grey;
    }
  }

  void bookSeats() {
    setState(() {
      for (int index in selectedSeats) {
        seatStatus[index] = 'booked';
      }
      selectedSeats.clear();
    });
  }

  int getSeatPrice(String coachType) {
    switch (coachType) {
      case 'AC_S':
        return 500;
      case 'SNIGDHA':
        return 400;
      case 'S_CHAIR':
        return 300;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => TrainSearchPage(
                  fromStation: 'Station A',
                  toStation: 'Station B',
                  travelClass: 'AC_S',
                  journeyDate: '2023-12-01', userId: '12',
                ));
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text("Seat Selection"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: coaches.map((coach) {
                  return buildCoachIcon(coach['name']);
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Selected Coach: $selectedCoach',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Seats Available: ${coaches.firstWhere((coach) => coach['name'] == selectedCoach)['seats'] - seatStatus.where((status) => status == 'booked' || status == 'selected').length}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                legendItem(Colors.green, 'Available'),
                legendItem(Colors.orange, 'Selected'),
                legendItem(Colors.red, 'Booked'),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: seatStatus.length ~/ 4,
                itemBuilder: (context, rowIndex) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              buildSeat(rowIndex * 4 + 1),
                              buildSeat(rowIndex * 4),
                            ],
                          ),
                          const SizedBox(width: 40),
                          Row(
                            children: [
                              buildSeat(rowIndex * 4 + 2),
                              buildSeat(rowIndex * 4 + 3),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Seat: ${selectedSeats.isNotEmpty ? "Seat no - ${selectedSeats.map((index) => index + 1).join(', ')}" : "Not Selected"}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  "Total Price: ${(selectedSeats.length * getSeatPrice(coaches.firstWhere((coach) => coach['name'] == selectedCoach)['type'])).toStringAsFixed(2)}/-",
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedSeats.isNotEmpty
                        ? () {
                            Get.offAll(PaymentsPage(
                              orders: [
                                Order(
                                  'orderId',
                                  trainId: 'TR-703',
                                  paymentId: '12',
                                  paymentDate: '12/11/2025',
                                  status: 'Pending',
                                  total: (selectedSeats.length *
                                          getSeatPrice(coaches.firstWhere(
                                              (coach) =>
                                                  coach['name'] ==
                                                  selectedCoach)['type']))
                                      .toDouble(),
                                  seatNumbers: selectedSeats
                                      .map((index) => index + 1)
                                      .toList(),
                                ),
                              ],
                              totalPrice: (selectedSeats.length *
                                      getSeatPrice(coaches.firstWhere(
                                          (coach) =>
                                              coach['name'] ==
                                              selectedCoach)['type']) *
                                      1.15)
                                  .toStringAsFixed(2),
                              selectedSeats: selectedSeats
                                  .map((index) => index + 1)
                                  .toList(),
                            ));
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("Continue"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSeat(int index) {
    if (index >= seatStatus.length) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () {
        if (seatStatus[index] == 'available' ||
            seatStatus[index] == 'selected') {
          handleSeatSelection(index);
        }
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: getSeatColor(seatStatus[index]),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(
              fontSize: 12,
              color:
                  seatStatus[index] == 'booked' ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black),
          ),
        ),
        Text(text),
      ],
    );
  }

  Widget buildCoachIcon(String coach) {
    bool isSelected = coach == selectedCoach;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCoach = coach;
          selectedSeats.clear();
          seatStatus = List.generate(
              coaches.firstWhere((c) => c['name'] == coach)['seats'],
              (index) => 'available');
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black),
        ),
        alignment: Alignment.center,
        child: Text(
          coach,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
