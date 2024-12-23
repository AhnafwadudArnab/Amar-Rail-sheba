import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Seat management/Train_Seat.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.24,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trainName,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(departureTime, style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(departureCity,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Train Details',
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ),
                      const Icon(Icons.arrow_right_alt_rounded,
                          color: Colors.blue),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(arrivalTime, style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(arrivalCity,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: tickets.map((ticket) {
                      return Text('  BDT\n ${ticket.price}',
                          style: const TextStyle(fontSize: 12));
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    duration,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: tickets.map((ticket) {
                        return Text(ticket.type,
                            style: const TextStyle(fontSize: 12));
                      }).toList(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                        'Seats: ${tickets.map((ticket) => ticket.availableSeats).join(', ')}',
                        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlue,
                    minimumSize: const Size(280, 35), // Set the button size to match the page width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), // Changed to 40 for rounded corners
                    ),
                  ),
                  onPressed: () {
                    Get.offAll(() => SeatSelectionApp(
                      price: tickets[0].price.toInt(), ticketType: ' ',
                    ));
                  },
                  child: const Text('Select', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketType {
  final String type;
  final double price;
  final int availableSeats;

  const TicketType({
    required this.type,
    required this.price,
    required this.availableSeats,
  });
}

List<String> getStationsBetween(String fromStation, String toStation) {
  Map<String, List<String>> routes = {
    // Add more routes as needed
  'DHAKA-CHITTAGONG': ['DHAKA', 'NARAYANGANJ', 'CHANDPUR', 'COMILLA', 'CHITTAGONG'],
  'CHITTAGONG-DHAKA': ['CHITTAGONG', 'COMILLA', 'CHANDPUR', 'NARAYANGANJ', 'DHAKA'],
  'DHAKA-KHULNA': ['DHAKA', 'JOYDEBPUR', 'JAMALPUR', 'KHULNA'],
  'KHULNA-DHAKA': ['KHULNA', 'JAMALPUR', 'JOYDEBPUR', 'DHAKA'],
  'DHAKA-MYMENSINGH': ['DHAKA', 'GAFARGAON', 'MYMENSINGH'],
  'MYMENSINGH-DHAKA': ['MYMENSINGH', 'GAFARGAON', 'DHAKA'],
  'DHAKA-MOHONGANJ': ['DHAKA', 'GAFARGAON', 'MYMENSINGH', 'MOHONGANJ'],
  'MOHONGANJ-DHAKA': ['MOHONGANJ', 'MYMENSINGH', 'GAFARGAON', 'DHAKA'],
  'DHAKA-JOYDEBPUR': ['DHAKA', 'JOYDEBPUR'],
  'JOYDEBPUR-DHAKA': ['JOYDEBPUR', 'DHAKA'],
  'DHAKA-JAMALPUR': ['DHAKA', 'JOYDEBPUR', 'JAMALPUR'],
  'JAMALPUR-DHAKA': ['JAMALPUR', 'JOYDEBPUR', 'DHAKA'],
  'DHAKA-FENI': ['DHAKA', 'NARAYANGANJ', 'CHANDPUR', 'COMILLA', 'FENI'],
  'FENI-DHAKA': ['FENI', 'COMILLA', 'CHANDPUR', 'NARAYANGANJ', 'DHAKA'],
  'DHAKA-MUNSHIGANJ': ['DHAKA', 'MUNSHIGANJ'],
  'MUNSHIGANJ-DHAKA': ['MUNSHIGANJ', 'DHAKA'],
  'DHAKA-MADARIPUR': ['DHAKA', 'MADARIPUR'],
  'MADARIPUR-DHAKA': ['MADARIPUR', 'DHAKA'],
  'DHAKA-SHIBCHAR': ['DHAKA', 'SHIBCHAR'],
  'SHIBCHAR-DHAKA': ['SHIBCHAR', 'DHAKA'],
  'DHAKA-NARAYANGANJ': ['DHAKA', 'NARAYANGANJ'],
  'NARAYANGANJ-DHAKA': ['NARAYANGANJ', 'DHAKA'],
  'DHAKA-NARSHINGDI': ['DHAKA', 'NARSHINGDI'],
  'NARSHINGDI-DHAKA': ['NARSHINGDI', 'DHAKA'],
  'DHAKA-GAFARGAON': ['DHAKA', 'GAFARGAON'],
  'GAFARGAON-DHAKA': ['GAFARGAON', 'DHAKA'],
  'DHAKA-DEWANGANJ': ['DHAKA', 'DEWANGANJ'],
  'DEWANGANJ-DHAKA': ['DEWANGANJ', 'DHAKA'],
  'DHAKA-BHOLA': ['DHAKA', 'BHOLA'],
  'BHOLA-DHAKA': ['BHOLA', 'DHAKA'],
  'DHAKA-AKHAURA': ['DHAKA', 'AKHAURA'],
  'AKHAURA-DHAKA': ['AKHAURA', 'DHAKA'],
  'DHAKA-AIRPORT': ['DHAKA', 'AIRPORT'],
  'AIRPORT-DHAKA': ['AIRPORT', 'DHAKA'],
  };

  String routeKey = '${fromStation.toUpperCase()}-${toStation.toUpperCase()}';
  return routes[routeKey] ?? [];
}