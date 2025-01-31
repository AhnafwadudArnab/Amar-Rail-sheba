import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:trackers/All%20Feautures/second%20pagee/Book_page_after_search.dart';
import '../payments_Methods/Payments.dart';

class SeatController extends GetxController {
  var seatStatus = <String, List<String>>{}.obs;

  void initializeSeats(String coach, int seats) {
    seatStatus.putIfAbsent(coach, () => List.filled(seats, 'available'));
  }

  void updateSeatStatus(String coach, int index, String status) {
    seatStatus[coach]?[index] = status;
  }

  List<String> getSeatStatus(String coach) {
    return seatStatus[coach] ?? [];
  }
}

class SeatSelectionPage extends StatefulWidget {
  final int price;
  final String ticketType;
  final String? fromStation;
  final String? toStation;
  final String? travelClass;
  final String? journeyDate;
  final String? departureTime;

  const SeatSelectionPage(
      {super.key,
      required this.price,
      required this.ticketType,
      required this.fromStation,
      required this.toStation,
      required this.travelClass,
      required this.journeyDate,
      required this.departureTime});

  @override
  SeatSelectionPageState createState() => SeatSelectionPageState();
}

class SeatSelectionPageState extends State<SeatSelectionPage> {
  final SeatController seatController = Get.put(SeatController());
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
    seatController.initializeSeats(selectedCoach,
        coaches.firstWhere((coach) => coach['name'] == selectedCoach)['seats']);
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
        seatController.updateSeatStatus(selectedCoach, index, 'available');
      } else if (selectedSeats.length < allowedSeats &&
          seatController.getSeatStatus(selectedCoach)[index] == 'available') {
        selectedSeats.add(index);
        seatController.updateSeatStatus(selectedCoach, index, 'selected');
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
        seatController.updateSeatStatus(selectedCoach, index, 'booked');
      }
      selectedSeats.clear();
    });
  }

  int getSeatPrice(String coachType) {
    switch (coachType) {
      case 'AC_S':
        return 320;
      case 'SNIGDHA':
        return 420;
      case 'S_CHAIR':
        return 280;
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
                  journeyDate: '2023-12-01',
                  returnJourneyDate: '2023-12-02',
                  returnFromStation: 'Station B',
                  returnToStation: 'Station A',
                  returnJourneyClass: 'AC_S',
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
                  'Seats Available: ${coaches.firstWhere((coach) => coach['name'] == selectedCoach)['seats'] - seatController.getSeatStatus(selectedCoach).where((status) => status == 'booked' || status == 'selected').length}',
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
              child: Obx(() {
                return ListView.builder(
                  itemCount:
                      (seatController.getSeatStatus(selectedCoach).length / 4)
                          .ceil(),
                  itemBuilder: (context, rowIndex) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            buildSeat(rowIndex * 4),
                            buildSeat(rowIndex * 4 + 1),
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
                    );
                  },
                );
              }),
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
                        ? () async {
                            await ApiService().insertUserData(
                                 Random().nextInt(1000), selectedSeats, selectedCoach, 'booked');
                            Get.offAll(() => PaymentsPage(
                                  orders: [
                                    Order(
                                      'ord-TN01',
                                      trainId: 'TN001',
                                      paymentId: 'pay-TN01',
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
                                  trainId: 'TN001',
                                  trainName: widget.ticketType,
                                  fromStation: widget.fromStation ?? 'Unknown',
                                  toStation: widget.toStation ?? 'Unknown',
                                  departureTime:
                                      widget.departureTime ?? 'Unknown',
                                  tickets: const [],
                                  travelClass: widget.travelClass ?? 'Unknown', date: widget.journeyDate ?? 'Unknown',
                                    
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
    if (index >= seatController.getSeatStatus(selectedCoach).length) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () {
        if (seatController.getSeatStatus(selectedCoach)[index] == 'available' ||
            seatController.getSeatStatus(selectedCoach)[index] == 'selected') {
          handleSeatSelection(index);
        }
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color:
              getSeatColor(seatController.getSeatStatus(selectedCoach)[index]),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(
              fontSize: 12,
              color:
                  seatController.getSeatStatus(selectedCoach)[index] == 'booked'
                      ? Colors.white
                      : Colors.black,
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
          seatController.initializeSeats(
              coach, coaches.firstWhere((c) => c['name'] == coach)['seats']);
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
class ApiService {
  final String baseUrl = 'http://10.15.10.140:3000';

  Future<void> insertUserData(int userId, List<int> seatNumbers, String coachName, String seatStatus) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/insert-user-data'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'seat_numbers': seatNumbers,
          'coachname': coachName,
          'seat_status': seatStatus,
        }),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('User data inserted successfully');
        }
      } else {
        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        throw Exception('Failed to insert user data: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      throw Exception('Network error: $error');
    }
  }
}
