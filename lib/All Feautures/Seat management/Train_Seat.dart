import 'package:flutter/material.dart';
import 'dart:async';

import 'package:get/get.dart';

import '../Payments.dart';
import '../second pagee/Book_page_after_search.dart';

void navigateToPage(BuildContext context, String ticketType) {
  if (ticketType == "AC_S") {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SeatSelectionApp(price: 350, ticketType: 'AC_S',)),
    );
  } else if (ticketType == "SNIGDHA") {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SeatSelectionApp(price: 400, ticketType: 'SNIGDHA')),
    );
  } else if (ticketType == "S_CHAIR") {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SeatSelectionApp(price: 250, ticketType: 'S_CHAIR')),
    );
  }

}

class SeatSelectionApp extends StatelessWidget {
  const SeatSelectionApp({super.key, required int price, required String ticketType});

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
  // ignore: library_private_types_in_public_api
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  List<String> seatStatus = [];
  List<int> selectedSeats = [];
  Timer? timer;
  int allowedSeats = 4; // Maximum 4 seats per 10 minutes
  List<Map<String, dynamic>> coaches = [
    {"name": "C-1", "seats": 60, "type": "AC_S"},
    {"name": "C-2", "seats": 58, "type": "AC_S"},
    {"name": "C-5A", "seats": 35, "type": "SNIGDHA"},
    {"name": "C-7A", "seats": 35, "type": "SNIGDHA"},
    {"name": "C-1S", "seats": 25, "type": "S_CHAIR"},
    {"name": "C-3S", "seats": 25, "type": "S_CHAIR"},
    {"name": "C-4S", "seats": 59, "type": "S_CHAIR"}
  ]; // List of coach names, seat counts, and types
  String selectedCoach = "C-1"; // Initially selected coach

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
        selectedSeats.clear(); // Clear selected seats every 10 minutes
      });
    });
  }

  void selectSeat(int index) {
    setState(() {
      if (selectedSeats.contains(index)) {
        selectedSeats.remove(index);
      } else if (selectedSeats.length < allowedSeats) {
        selectedSeats.add(index);
        seatStatus[index] = 'selected';
      }
    });
  }

  int getSeatPrice(String coachType) {
    switch (coachType) {
      case 'AC_S':
        return 500; // Price for AC_S
      case 'SNIGDHA':
        return 400; // Price for SNIGDHA
      case 'S_CHAIR':
        return 300; // Price for S_CHAIR
      default:
        return 0; // Default price
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

  Color getSeatColor(String status) {
    switch (status) {
      case 'available':
        return const Color.fromARGB(255, 71, 153, 207);
      case 'selected':
        return const Color.fromARGB(255, 236, 134, 51);
      case 'booked':
        return Colors.redAccent;
      default:
        return Colors.white;
    }
  }

  String getSeatType(int seatNumber) {
    return seatNumber % 2 == 0 ? 'W' : 'C'; // Even -> Window, Odd -> Business
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAll(() =>  TrainSearchPage(
              fromStation: 'Station A',
              toStation: 'Station B',
              travelClass: 'AC_S',
              journeyDate: '2023-12-01', ));
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text("Seat Selection"),
      ),
      body: Column(
        children: [
          // Coach selection icons
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
                  'Seats Available: ${coaches.firstWhere((coach) => coach['name'] == selectedCoach)['seats'] - seatStatus.where((status) => status == 'booked').length - selectedSeats.length}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Legend
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                legendItem(const Color.fromARGB(255, 71, 153, 207), 'Available'),
                legendItem(const Color.fromARGB(255, 236, 134, 51), 'Selected'),
                legendItem(Colors.redAccent, 'Booked'),
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
                          // Left side seats
                          Row(
                            children: [
                              buildSeat(
                                  rowIndex * 4 + 1), // Left-side Seat 2 "W"
                              buildSeat(rowIndex * 4), // Left-side Seat 1 "C"
                            ],
                          ),
                          // Aisle space

                          const SizedBox(
                              width: 40), // Adjust width for aisle space
                          // Right side seats
                          Row(
                            children: [
                              buildSeat(
                                  rowIndex * 4 + 2), // Right-side Seat 3 "C"
                              buildSeat(
                                  rowIndex * 4 + 3), // Right-side Seat 4 "W"
                            ],
                          ),
                        ],
                      ),
                      if (rowIndex == (seatStatus.length ~/ 8) ||
                          rowIndex == (seatStatus.length ~/ 8) + 1) ...[
                        const SizedBox(height: 5),
                      ]
                      // Space between rows
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
                    "Total Price (with vat 15%): ${selectedSeats.length * getSeatPrice(coaches.firstWhere((coach) => coach['name'] == selectedCoach)['type'])}/-"), // Calculate total price based on selected coach
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                  onPressed: selectedSeats.isNotEmpty
                    ? () {
                      Get.offAll(PaymentsPage(
                        orders: [
                        Order(
                          'orderId', // Add the missing positional argument
                          trainId: 'TR-001',
                          paymentId: '12',
                          paymentDate: '12/11/2025',
                          status: selectedSeats.isNotEmpty ? 'Pending' : 'In Progress',
                            total: (selectedSeats.length * getSeatPrice(coaches.firstWhere((coach) => coach['name'] == selectedCoach)['type'])).toDouble(),
                          seatNumbers: selectedSeats.map((index) => index + 1).toList(),
                        ),
                        ],
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
      return const SizedBox.shrink(); // For boundary safety
    }

    return GestureDetector(
      onTap: () {
        if (seatStatus[index] == 'available' ||
            seatStatus[index] == 'selected') {
          selectSeat(index);
        }
      },
      child: Container(
        width: 40, // Fixed width for seat box
        height: 40, // Fixed height for seat box
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: getSeatColor(seatStatus[index]),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 10,
                    color: seatStatus[index] == 'booked'
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                Text(
                  getSeatType(index + 1),
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: seatStatus[index] == 'booked'
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ],
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

  Widget buildCoachIconWithSave(String coach) {
    bool isSelected = coach == selectedCoach;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCoach = coach;
          selectedSeats.clear(); // Clear selected seats when changing coach
          seatStatus = List.generate(
              coaches.firstWhere((c) => c['name'] == coach)['seats'],
              (index) => 'available'); // Reset seat status
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey[300],
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

  Map<String, List<String>> bookedSeats = {};

  void saveBookedSeats(String selectedCoach) {
    bookedSeats[selectedCoach] = List.from(seatStatus);
  }

  void loadBookedSeats() {
    if (bookedSeats.containsKey(selectedCoach)) {
      seatStatus = List.from(bookedSeats[selectedCoach]!);
    } else {
      seatStatus = List.generate(
          coaches
              .firstWhere((coach) => coach['name'] == selectedCoach)['seats'],
          (index) => 'available');
    }
  }

  Widget buildCoachIcon(String coach) {
    bool isSelected = coach == selectedCoach;
    return GestureDetector(
      onTap: () {
        setState(() {
          saveBookedSeats(selectedCoach);
          selectedCoach = coach;
          selectedSeats.clear(); // Clear selected seats when changing coach
          loadBookedSeats();
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey[300],
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
