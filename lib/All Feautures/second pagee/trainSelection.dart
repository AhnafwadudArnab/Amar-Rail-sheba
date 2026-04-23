// trainSelection.dart — backward-compat TrainCard wrapper
// The main train listing is now in Book_page_after_search.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackers/All%20Feautures/Seat%20management/Train_Seat.dart';

// TicketType kept for backward compat
class TicketType {
  final String type;
  final double price;
  final int availableSeats;

  const TicketType({required this.type, required this.price, required this.availableSeats});
}

class TrainCard extends StatelessWidget {
  final String trainName;
  final String departureCity;
  final String arrivalCity;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final List<TicketType> tickets;
  final String fromStation;
  final String toStation;
  final String travelClass;
  final String journeyDate;
  final dynamic trainId;

  const TrainCard({
    super.key,
    required this.trainName,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.tickets,
    required this.fromStation,
    required this.toStation,
    required this.travelClass,
    required this.journeyDate,
    required this.trainId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(trainName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(departureTime, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(departureCity, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ]),
                Text(duration, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(arrivalTime, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(arrivalCity, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ]),
              ],
            ),
            const SizedBox(height: 8),
            ...tickets.map((t) => Text('${t.type}: ৳${t.price.toStringAsFixed(0)} (${t.availableSeats} seats)',
                style: const TextStyle(fontSize: 12, color: Colors.grey))),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3A6B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Get.to(() => SeatSelectionPage(
                        price: tickets.first.price.toInt(),
                        ticketType: tickets.first.type,
                        fromStation: fromStation,
                        toStation: toStation,
                        travelClass: travelClass,
                        journeyDate: journeyDate,
                        departureTime: departureTime,
                      ));
                },
                child: const Text('Select'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
