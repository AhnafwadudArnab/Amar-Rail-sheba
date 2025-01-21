import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:trackers/All%20Feautures/Seat%20management/Train_Seat.dart';
import 'package:logger/logger.dart';

class Utils {
  static String baseURL = "https://192.168.68.105:3000"; // home
  //static String baseURL = "http://10.15.57.22:3000"; // university 
}

class TrainDetailsPage extends StatelessWidget {
  final String fromStation;
  final String toStation;

  const TrainDetailsPage({
    super.key,
    required this.fromStation,
    required this.toStation,
  });
  Future<List<Train>> fetchTrainDetails() async {
    final url = Uri.parse(
        '${Utils.baseURL}/trains?from_station=$fromStation&to_station=$toStation');
    var logger = Logger();
    logger.d('Fetching train details from: $url');

    try {
      final response = await http.get(url);
      if (kDebugMode) {
        logger.d('Response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        logger.d('Response body: ${response.body}');
      }
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        return data.map((trainJson) => Train.fromJson(trainJson)).toList();
      } else {
        logger.e('Failed to load train details: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception('Failed to load train details: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      logger.e('Error: $e');
      throw Exception('Error fetching train details: $e. Please check your server and URL.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train Details'),
      ),
      body: FutureBuilder<List<Train>>(
        future: fetchTrainDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No trains available for this route.'));
          } else {
            final trains = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: trains.length,
                itemBuilder: (context, index) {
                  final train = trains[index];
                  return TrainCard(
                    trainName: train.trainName,
                    departureCity: train.departureCity,
                    arrivalCity: train.arrivalCity,
                    departureTime: train.departureTime,
                    arrivalTime: train.arrivalTime,
                    duration: train.duration,
                    tickets: train.tickets,
                    fromStation: fromStation,
                    toStation: toStation,
                    travelClass:
                        '', // You can adjust this if you have a specific class in the response
                    journeyDate: '', // Adjust accordingly
                    trainId: train.trainName, // Example, modify as needed
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class Train {
  final String trainName;
  final String departureCity;
  final String arrivalCity;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final List<TicketType> tickets;

  const Train({
    required this.trainName,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.tickets,
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    var list = json['tickets'] as List;
    List<TicketType> ticketList =
        list.map((i) => TicketType.fromJson(i)).toList();

    return Train(
      trainName: json['trainName'],
      departureCity: json['departureCity'],
      arrivalCity: json['arrivalCity'],
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      duration: json['duration'],
      tickets: ticketList,
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

  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      type: json['type'],
      price: json['price'].toDouble(),
      availableSeats: json['availableSeats'],
    );
  }
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.22,
      width: MediaQuery.of(context).size.width * 0.95,
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
                      IconButton(
                      icon: const Icon(Icons.train, color: Colors.blue),
                      onPressed: () {
                       //Navigator.push(context, MaterialPageRoute(builder: (context) => TrainDetailsPage()));
                      },
                      ),
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
                        style: const TextStyle(
                            fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlue,
                    minimumSize: const Size(
                        280, 35), // Set the button size to match the page width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          40), // Changed to 40 for rounded corners
                    ),
                  ),
                  onPressed: () async {
                    bool success = await ApiService().addBooking(
                      tprice: tickets[0].price.toString(),
                      ticketType: tickets[0].type,
                    );
                    if (success) {
                      Get.offAll(() => SeatSelectionPage(
                            price: tickets[0].price.toInt(),
                            ticketType: tickets[0].type,
                          ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to update booking')),
                      );
                    }
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

/// A P I--->CALL ///

//all train details API //

class TrainDetailsAPi {
  final String baseUrl = Utils.baseURL;

  /// Fetches the train details by from_station and to_station
  Future<List<dynamic>> getTrains(String fromStation, String toStation) async {
    final url = Uri.parse(
        '$baseUrl/trains?from_station=$fromStation&to_station=$toStation');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load train details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching train details: $e');
    }
  }
}

///Select button api call///
class ApiService {
  final String baseUrl = Utils.baseURL; //university wifi ip//

  Future<bool> addBooking({
    required String tprice,
    required String ticketType,
  }) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
    };
    Map<String, dynamic> requestBody = {
      "Tprice": tprice,
      "ticketType": ticketType,
    };
    var response = await http.post(Uri.parse("$baseUrl/secondPage"),
        headers: requestHeaders, body: jsonEncode(requestBody));

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateBooking(String tprice, String ticketType) async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
    };
    Map<String, dynamic> requestBody = {
      "Tprice": tprice,
      "ticketType": ticketType,
    };
    var response = await http.put(
      Uri.parse("$baseUrl/secondPage"),
      headers: requestHeaders,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}



  // FutureBuilder<Map<String, dynamic>>(
  //                             future: FP2API().selectTrain(1),
  //                             builder: (context, snapshot) {
  //                             if (snapshot.connectionState == ConnectionState.waiting) {
  //                               return const CircularProgressIndicator();
  //                             } else if (snapshot.hasError) {
  //                               return Text('Error: ${snapshot.error}');
  //                             } else if (snapshot.hasData) {
  //                               final trainData = snapshot.data!;
  //                               return Column(
  //                               children: [
  //                                 Text('Train Name: ${trainData['trainName']}'),
  //                                 Text('Departure Time: ${trainData['departureTime']}'),
  //                                 Text('Arrival Time: ${trainData['arrivalTime']}'),
  //                                 // Add more fields as needed
  //                               ],
  //                               );
  //                             } else {
  //                               return const Text('No data available');
  //                             }
  //                             },
  //                           ),