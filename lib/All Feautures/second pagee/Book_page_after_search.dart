import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:trackers/All%20Feautures/second%20pagee/trainSelection.dart';
import 'package:trackers/All%20Feautures/firstpage/booking.dart';
import 'modify_Search_box.dart';

// ignore: must_be_immutable
class TrainSearchPage extends StatefulWidget {
  late String fromStation;
  late String toStation;
  late String travelClass;
  late String journeyDate;
  late String returnJourneyDate;
  late String returnFromStation;
  late String returnToStation;
  late String returnJourneyClass;

  TrainSearchPage({
    super.key,
    required this.fromStation,
    required this.toStation,
    required this.travelClass,
    required this.journeyDate,
    required this.returnJourneyDate,
    required this.returnFromStation,
    required this.returnToStation,
    required this.returnJourneyClass,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TrainSearchPageState createState() {
    return _TrainSearchPageState();
  }

  Widget filterChipWidget(
      {required String label, required List<String> options}) {
    return FilterChip(
      label: Text(label),
      onSelected: (bool value) {},
    );
  }

  // ignore: non_constant_identifier_names
  Widget SwitchWidget({required String label}) {
    return Row(
      children: [
        Text(label),
        Switch(
          value: false,
          onChanged: (bool value) {},
        ),
      ],
    );
  }
}

class _TrainSearchPageState extends State<TrainSearchPage> {
  final TextEditingController fromStationController = TextEditingController();
  final TextEditingController toStationController = TextEditingController();
  final FocusNode fromStationFocusNode = FocusNode();
  final FocusNode toStationFocusNode = FocusNode();
  String? selectedClass;
  String? selectedReturnClass;
  String selectedJourneyType = 'One Way';
  String? _selectedType;
  bool isEditable = false;

  // ignore: unused_field
  final TextEditingController _journeyDateController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();
  final TextEditingController returnFromStationController =
      TextEditingController();
  final TextEditingController returnToStationController =
      TextEditingController();
  final FocusNode returnFromStationFocusNode = FocusNode();
  final FocusNode returnToStationFocusNode = FocusNode();
  late final int endTime;

  // ignore: unused_field
  final List<Map<String, String>> _trains = [];

  @override
  void initState() {
    super.initState();
    endTime =
        DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 6; // 6min from now
    _selectedType = 'Direct'; // Set default value for _selectedType
    //_updateTrains(); // Update trains based on the default type
  }

  List<String> routeDhakaToCtgToSylhet = [
    'Dhaka',
    'Airport',
    'Narshingdi',
    'Bhairab-Bazar',
    'Brahman_Baria',
    'Akhaura',
    'Comilla',
    'Laksham',
    'Feni',
    'Chattogram',
    'Feni',
    'Laksham',
    'Akhaura',
    'Brahman_Baria',
    'Bhairab-Bazar',
    'Narshingdi',
    'Sylhet'
  ];

  void swapStation() {
    String temp = fromStationController.text;
    fromStationController.text = toStationController.text;
    toStationController.text = temp;
  }

  void swapReturnStation() {
    String temp = returnFromStationController.text;
    returnFromStationController.text = returnToStationController.text;
    returnToStationController.text = temp;
  }

  void callPage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const ModifySearchBox(),
        );
      },
    );
  }

  void newUpdatedValues() {
    setState(() {
      if (fromStationController.text.isNotEmpty) {
        widget.fromStation = fromStationController.text;
      }
      if (toStationController.text.isNotEmpty) {
        widget.toStation = toStationController.text;
      }
      if (_journeyDateController.text.isNotEmpty) {
        widget.journeyDate = _journeyDateController.text;
      }
      if (selectedClass != null) {
        widget.travelClass = selectedClass!;
      }
      if (selectedJourneyType == 'One Way') {
        widget.returnFromStation = '';
        widget.returnToStation = '';
        widget.returnJourneyDate = '';
        widget.returnJourneyClass = '';
      } else if (selectedJourneyType == 'Round Way') {
        if (returnFromStationController.text.isNotEmpty) {
          widget.returnFromStation = returnFromStationController.text;
        }
        if (returnToStationController.text.isNotEmpty) {
          widget.returnToStation = returnToStationController.text;
        }
        if (_returnDateController.text.isNotEmpty) {
          widget.returnJourneyDate = _returnDateController.text;
        }
        if (selectedReturnClass != null) {
          widget.returnJourneyClass = selectedReturnClass!;
        }
      }
    });
  }

  bool isFormValid() {
    return fromStationController.text.isNotEmpty &&
        toStationController.text.isNotEmpty &&
        _journeyDateController.text.isNotEmpty &&
        selectedClass != null &&
        (selectedJourneyType == 'One Way' ||
            (returnFromStationController.text.isNotEmpty &&
                returnToStationController.text.isNotEmpty &&
                _returnDateController.text.isNotEmpty &&
                selectedReturnClass != null));
  }

  void updateSearchInfoCard() {
    setState(() {
      widget.fromStation = fromStationController.text;
      widget.toStation = toStationController.text;
      widget.journeyDate = _journeyDateController.text;
      widget.travelClass = selectedClass!;
      if (selectedJourneyType == 'Round Way') {
        widget.returnFromStation = returnFromStationController.text;
        widget.returnToStation = returnToStationController.text;
        widget.returnJourneyDate = _returnDateController.text;
        widget.returnJourneyClass = selectedReturnClass!;
      }
    });
  }

  Future showModifySearchBox(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const ModifySearchBox(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.offAll(() => const MainHomeScreen());
          },
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Train Search',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(width: 4),
            Icon(Icons.train, color: Colors.black),
          ],
        ),
        centerTitle: true,
        actions: [
          const SizedBox(height: 4, width: 30),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    newUpdatedValues();
                    callPage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(children: [
        // Background Image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/trainBackgrong/05.jpeg'),
                fit: BoxFit.cover),
          ),
        ),
        // Search Form Container with white background and shadow effect//
        //box shadow effect//
        SingleChildScrollView(
          child: Container(
            //full container height//
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              children: [
                //make a box information about what is search for by the user//
                SearchInfoCard(
                  from: widget.fromStation,
                  to: widget.toStation,
                  date: widget.journeyDate,
                  journeyClass: widget.travelClass,
                  returnDate: selectedJourneyType == 'Round Way'
                      ? _returnDateController.text
                      : '',
                  returnJourneyClass: selectedJourneyType == 'Round Way'
                      ? selectedReturnClass ?? ''
                      : '',
                  returnFrom: '',
                  returnTo: '', // Add the required argument here
                ),
                // // Countdown Timer
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey, width: 2.0), // Bold border
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: CountdownTimer(
                          endTime: endTime,
                          widgetBuilder: (_, time) {
                            if (time == null) {
                              Get.to(const MainHomeScreen());
                              return const Text('Time is up!');
                            }
                            return Text(
                              'Time left: ${time.min?.toString().padLeft(2, '0') ?? '00'}:${time.sec?.toString().padLeft(2, '0') ?? '00'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                                fontSize: 22,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Type: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                DropdownButton<String>(
                                  value: _selectedType,
                                  hint: const Text('Select Type'),
                                  items: <String>['Direct', 'Intercity']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedType = newValue;
                                      //_updateTrains();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          //variable passing here for the train selection//
                          const SizedBox(height: 16),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TrainCard(
                                    trainName: 'Subarna\nExpress',
                                    fromStation: widget.fromStation,
                                    toStation: widget.toStation,
                                    departureTime: '12:30pm',
                                    arrivalTime: '16:00pm',
                                    duration: '4h 30m',
                                    departureCity: widget.fromStation,
                                    arrivalCity: widget.toStation,
                                    travelClass: widget.travelClass,
                                    journeyDate: widget.journeyDate,
                                    tickets: [
                                      TicketType(
                                          type: widget.travelClass,
                                          price: 350,
                                          availableSeats: 5),
                                    ],
                                    trainId: 1,
                                  ),
                                  // Example train data
                                  TrainCard(
                                    trainName: 'Example Train',
                                    fromStation: widget.fromStation,
                                    toStation: widget.toStation,
                                    departureTime: '10:00am',
                                    arrivalTime: '2:00pm',
                                    duration: '4h 0m',
                                    departureCity: widget.fromStation,
                                    arrivalCity: widget.toStation,
                                    travelClass: widget.travelClass,
                                    journeyDate: widget.journeyDate,
                                    tickets: [
                                      TicketType(
                                          type: widget.travelClass,
                                          price: 300,
                                          availableSeats: 10),
                                    ],
                                    trainId: 2,
                                  ),
                                  TrainCard(
                                    trainName: 'Mohanagar\nExpress',
                                    fromStation: widget.fromStation,
                                    toStation: widget.toStation,
                                    departureTime: '10:00am',
                                    arrivalTime: '2:30pm',
                                    duration: '4h 30m',
                                    departureCity: widget.fromStation,
                                    arrivalCity: widget.toStation,
                                    travelClass: widget.travelClass,
                                    journeyDate: widget.journeyDate,
                                    tickets: [
                                      TicketType(
                                          type: widget.travelClass,
                                          price: 200,
                                          availableSeats: 10),
                                    ],
                                    trainId: 5,
                                  ),
                                  TrainCard(
                                    trainName: 'Turna\nNishitha',
                                    fromStation: widget.fromStation,
                                    toStation: widget.toStation,
                                    departureTime: '11:00am',
                                    arrivalTime: '9:30pm',
                                    duration: '4h 30m',
                                    departureCity: widget.fromStation,
                                    arrivalCity: widget.toStation,
                                    travelClass: widget.travelClass,
                                    journeyDate: widget.journeyDate,
                                    tickets: [
                                      TicketType(
                                          type: widget.travelClass,
                                          price: 250,
                                          availableSeats: 8),
                                    ],
                                    trainId: 7,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        // Ticket cards will be displayed here
                        // Add a Column widget to display the ticket cards
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class TrainDetailsAPi {
  final String baseUrl = "http://10.15.19.200:3000";

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

// box of the train card//
class SearchInfoCard extends StatelessWidget {
  final String from;
  final String to;
  final String date;
  final String journeyClass;
  final String returnFrom;
  final String returnTo;
  final String returnDate;
  final String returnJourneyClass;

  const SearchInfoCard({
    super.key,
    required this.from,
    required this.to,
    required this.date,
    required this.journeyClass,
    required this.returnFrom,
    required this.returnTo,
    required this.returnDate,
    required this.returnJourneyClass,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 5,
      child: Container(
        width: double.infinity, // Full width of the parent container
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: $from'),
            Text('To: $to'),
            Text('Date: $date'),
            Text('Class: $journeyClass'),
            if (returnFrom.isNotEmpty) Text('Return From: $returnFrom'),
            if (returnTo.isNotEmpty) Text('Return To: $returnTo'),
            if (returnDate.isNotEmpty) Text('Return Date: $returnDate'),
            if (returnJourneyClass.isNotEmpty)
              Text('Return Class: $returnJourneyClass'),
          ],
        ),
      ),
    );
  }
}
