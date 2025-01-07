import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:trackers/All%20Feautures/second%20pagee/trainSelection.dart';
import 'package:trackers/booking.dart';
import 'package:trackers/rest_API/API_utils.dart';

// ignore: must_be_immutable
class TrainSearchPage extends StatefulWidget {
  late String fromStation;
  late String toStation;
  late String travelClass;
  late String journeyDate;

  TrainSearchPage({
    super.key,
    required this.fromStation,
    required this.toStation,
    required this.travelClass,
    required this.journeyDate,
    required String userId,
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
  final TextEditingController _journeyDateController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();
  final TextEditingController returnFromStationController =
      TextEditingController();
  final TextEditingController returnToStationController =
      TextEditingController();
  final FocusNode returnFromStationFocusNode = FocusNode();
  final FocusNode returnToStationFocusNode = FocusNode();
  late final int endTime;

  List<Map<String, String>> _trains = [];

  @override
  void initState() {
    super.initState();
    endTime =
        DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 6; // 6min from now
    _selectedType = 'Direct'; // Set default value for _selectedType
    _updateTrains(); // Update trains based on the default type
  }

  void _updateTrains() {
    if (_selectedType == 'Intercity') {
      _trains = [
        {'Train ID': '701', 'Name': 'Subarna Express (Dhaka–Chittagong)'},
        {'Train ID': '702', 'Name': 'Mohanagar Godhuli (Chittagong–Dhaka)'},
        {'Train ID': '703', 'Name': 'Mohanagar Express (Dhaka–Chittagong)'},
        {'Train ID': '704', 'Name': 'Turna Nishitha (Chittagong–Dhaka)'},
        {'Train ID': '705', 'Name': 'Parabat Express (Dhaka–Sylhet)'},
        {'Train ID': '706', 'Name': 'Jayantika Express (Sylhet–Dhaka)'},
        {'Train ID': '707', 'Name': 'Upakul Express (Dhaka–Noakhali)'},
        {'Train ID': '708', 'Name': 'Paharika Express (Chittagong–Sylhet)'},
        {'Train ID': '709', 'Name': 'Udayan Express (Sylhet–Chittagong)'},
      ];
    } else if (_selectedType == 'Mail and Local') {
      _trains = [
        {'Train ID': '31', 'Name': 'Dhaka Mail (Dhaka–Khulna)'},
        {'Train ID': '33', 'Name': 'Chattala Express (Dhaka–Chittagong)'},
        {'Train ID': '37', 'Name': 'Titas Commuter (Dhaka–Brahmanbaria)'},
        {'Train ID': '39', 'Name': 'Surma Mail (Dhaka–Sylhet)'},
      ];
    } else {
      _trains = [];
    }
  }

  List<String> editableStations = [
    'Airport',
    'Akhaura',
    'Bhairab-Bazar',
    'Bhola',
    'Brahman_Baria',
    'Chandpur',
    'Chattogram',
    'Comilla',
    'Dewanganj',
    'Dhaka',
    'Feni',
    'Gafargaon',
    'Jamalpur',
    'Joydebpur',
    'Khulna',
    'Laksham',
    'Madaripur',
    'Mohonganj',
    'Munshiganj',
    'Mymensingh',
    'Narshingdi'
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

  void updateSearchInfoCard(BuildContext context) {
    // Implement the logic to update the search info card
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
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              showModifySearchBox(context);
            },
            child: const Text(
              'Modify Search',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        centerTitle: true,
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
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
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
                          Row(
                            children: [
                              const Text('Type: ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              DropdownButton<String>(
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
                                    _updateTrains();
                                  });
                                },
                              ),
                            ],
                          ),
                          //variable passing here
                          const SizedBox(height: 16),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TrainCard(
                                    trainName: 'Train A',
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
                                  ),
                                  TrainCard(
                                    trainName: 'Train B',
                                    fromStation: widget.fromStation,
                                    toStation: widget.toStation,
                                    departureTime: '7:30am',
                                    arrivalTime: '12:00pm',
                                    duration: '4h 30min',
                                    departureCity: widget.fromStation,
                                    arrivalCity: widget.toStation,
                                    travelClass: widget.travelClass,
                                    journeyDate: widget.journeyDate,
                                    tickets: [
                                      TicketType(
                                          type: widget.travelClass,
                                          price: 150,
                                          availableSeats: 5),
                                    ],
                                  ),
                                  TrainCard(
                                    trainName: 'Train C',
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
                                  ),
                                  TrainCard(
                                    trainName: 'Train D',
                                    fromStation: widget.fromStation,
                                    toStation: widget.toStation,
                                    departureTime: '5:00pm',
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
      child: Padding(
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

Future fetchTrainCollections(
    String trainId,
    String trainName,
    String trainRoute,
    String trainStart,
    String trainEnd,
    String departure,
    String arrival,
    String numOfCompartment,
    String seatNumber,
    String offday) async {
  final response = await http.post(
    Uri.parse('${Utils.baseURL}/train_collections'),
    headers: {'Accept': 'application/json'},
    body: {
      "train_id": trainId,
      "train_name": trainName,
      "train_route": trainRoute,
      "train_start": trainStart,
      "train_end": trainEnd,
      "train_departure_time": departure,
      "arrival": arrival,
      "num_of_compartment": numOfCompartment,
      "no_of_seat": seatNumber,
      "train_Offday_status": offday
    },
  );

  var decodeData = jsonDecode(response.body);
  return decodeData;
}

class ModifySearchBox extends StatefulWidget {
  const ModifySearchBox({super.key});

  @override
  ModifySearchBoxState createState() => ModifySearchBoxState();
}

class ModifySearchBoxState extends State<ModifySearchBox> {
  bool isEditable = true;
  String selectedJourneyType = 'One Way';
  String? selectedClass;
  String? selectedReturnClass;
  TextEditingController fromStationController = TextEditingController();
  TextEditingController returnFromStationController = TextEditingController();
  TextEditingController toStationController = TextEditingController();
  TextEditingController returnToStationController = TextEditingController();
  final TextEditingController _journeyDateController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();
  FocusNode returnFromStationFocusNode = FocusNode();
  FocusNode returnToStationFocusNode = FocusNode();
  List<String> editableStations = [
    'Airport',
    'Akhaura',
    'Bhairab-Bazar',
    'Bhola',
    'Brahman_Baria',
    'Chandpur',
    'Chattogram',
    'Comilla',
    'Dewanganj',
    'Dhaka',
    'Feni',
    'Gafargaon',
    'Jamalpur',
    'Joydebpur',
    'Khulna',
    'Laksham',
    'Madaripur',
    'Mohonganj',
    'Munshiganj',
    'Mymensingh',
    'Narshingdi'
  ];

  void swapReturnStation() {
    setState(() {
      String temp = returnFromStationController.text;
      returnFromStationController.text = returnToStationController.text;
      returnToStationController.text = temp;
    });
  }

  void swapStation() {
    setState(() {
      final tempText = fromStationController.text;
      fromStationController.text = toStationController.text;
      toStationController.text = tempText;
    });
  }

  String from = '';
  String to = '';
  String date = '';
  String journeyClass = '';
  String returnFrom = '';
  String returnTo = '';
  String returnDate = '';
  String returnJourneyClass = '';

  void updateSearchInfoCard() {
    setState(() {
      from = fromStationController.text;
      to = toStationController.text;
      date = _journeyDateController.text;
      journeyClass = selectedClass ?? '';
      if (selectedJourneyType == 'One Way') {
        returnFrom = '';
        returnTo = '';
        returnDate = '';
        returnJourneyClass = '';
      } else if (selectedJourneyType == 'Round Way') {
        returnFrom = returnFromStationController.text;
        returnTo = returnToStationController.text;
        returnDate = _returnDateController.text;
        returnJourneyClass = selectedReturnClass ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        shadowColor: Colors.white.withOpacity(0.1),
        margin: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    if (isEditable)
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10.0,
                              spreadRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedJourneyType = 'One Way';
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          selectedJourneyType == 'One Way'
                                              ? Colors.black
                                              : Colors.grey,
                                    ),
                                    child: Text(
                                      'One Way',
                                      style: TextStyle(
                                        color: selectedJourneyType == 'One Way'
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedJourneyType = 'Round Way';
                                        fromStationController.text = from;
                                        toStationController.text = to;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          selectedJourneyType == 'Round Way'
                                              ? Colors.black
                                              : Colors.grey,
                                    ),
                                    child: Text(
                                      'Round Way',
                                      style: TextStyle(
                                        color:
                                            selectedJourneyType == 'Round Way'
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                          icon: Icon(Icons.train_rounded),
                                          labelText: 'From'),
                                      value: fromStationController.text.isEmpty
                                          ? null
                                          : fromStationController.text,
                                      items: editableStations.map((station) {
                                        return DropdownMenuItem<String>(
                                          value: station,
                                          child: Text(station),
                                        );
                                      }).toList(),
                                      onChanged:
                                          selectedJourneyType == 'One Way'
                                              ? (value) {
                                                  setState(() {
                                                    fromStationController.text =
                                                        value!;
                                                  });
                                                }
                                              : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: IconButton(
                                icon: const Icon(Icons.swap_calls_rounded),
                                onPressed: selectedJourneyType == 'One Way'
                                    ? swapStation
                                    : null,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                          icon: Icon(Icons.train_rounded),
                                          labelText: 'To'),
                                      value: toStationController.text.isEmpty
                                          ? null
                                          : toStationController.text,
                                      items: editableStations.map((station) {
                                        return DropdownMenuItem<String>(
                                          value: station,
                                          child: Text(station),
                                        );
                                      }).toList(),
                                      onChanged:
                                          selectedJourneyType == 'One Way'
                                              ? (value) {
                                                  setState(() {
                                                    toStationController.text =
                                                        value!;
                                                  });
                                                }
                                              : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                'From and To stations cannot be the same!!',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 192, 11, 11)),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                        labelText: 'Class'),
                                    value: selectedClass,
                                    items: ['AC', 'Cabin', 'S_chair']
                                        .map((classType) => DropdownMenuItem(
                                              value: classType,
                                              child: Text(classType),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedClass = value!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: TextFormField(
                                    controller: _journeyDateController,
                                    decoration: const InputDecoration(
                                        labelText: 'Journey Date'),
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 10)),
                                      );
                                      if (pickedDate != null) {
                                        _journeyDateController.text = pickedDate
                                            .toLocal()
                                            .toString()
                                            .split(' ')[0];
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (selectedJourneyType == 'Round Way') ...[
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                            icon: Icon(Icons.train_rounded),
                                            labelText: 'Return From'),
                                        value: returnFromStationController
                                                .text.isEmpty
                                            ? null
                                            : returnFromStationController.text,
                                        items: editableStations.map((station) {
                                          return DropdownMenuItem<String>(
                                            value: station,
                                            child: Text(station),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            returnFromStationController.text =
                                                value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: IconButton(
                                  icon: const Icon(Icons.swap_calls_rounded),
                                  onPressed: swapReturnStation,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                            icon: Icon(Icons.train_rounded),
                                            labelText: 'Return To'),
                                        value: returnToStationController
                                                .text.isEmpty
                                            ? null
                                            : returnToStationController.text,
                                        items: editableStations.map((station) {
                                          return DropdownMenuItem<String>(
                                            value: station,
                                            child: Text(station),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            returnToStationController.text =
                                                value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                          labelText: 'Return Class'),
                                      value: selectedReturnClass,
                                      items: ['AC', 'Cabin', 'S_chair']
                                          .map((classType) => DropdownMenuItem(
                                                value: classType,
                                                child: Text(classType),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedReturnClass = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _returnDateController,
                                      decoration: const InputDecoration(
                                          labelText: 'Return Date'),
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2101),
                                        );
                                        if (pickedDate != null) {
                                          if (pickedDate.isAtSameMomentAs(
                                              DateTime.parse(
                                                  _journeyDateController
                                                      .text))) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Journey date and return date cannot be the same',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            );
                                          } else {
                                            _returnDateController.text =
                                                pickedDate
                                                    .toLocal()
                                                    .toString()
                                                    .split(' ')[0];
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // Validate and update the state of the controllers and other variables
                                  if (fromStationController.text.isNotEmpty &&
                                      toStationController.text.isNotEmpty &&
                                      _journeyDateController.text.isNotEmpty &&
                                      (selectedJourneyType == 'One Way' ||
                                          (returnFromStationController
                                                  .text.isNotEmpty &&
                                              returnToStationController
                                                  .text.isNotEmpty &&
                                              _returnDateController
                                                  .text.isNotEmpty))) {
                                    isEditable =
                                        false; // Save the changes and exit edit mode
                                    updateSearchInfoCard(); // Update the SearchInfoCard
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please fill in all required fields',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    );
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text(
                                'Modify\nSearch',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            if (!isEditable)
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isEditable = true;
                                    fromStationController.text = from;
                                    toStationController.text = to;
                                    _journeyDateController.text = date;
                                    selectedClass = journeyClass;
                                    if (selectedJourneyType == 'Round Way') {
                                      returnFromStationController.text =
                                          returnFrom;
                                      returnToStationController.text = returnTo;
                                      _returnDateController.text = returnDate;
                                      selectedReturnClass = returnJourneyClass;
                                    }
                                    updateSearchInfoCard(); // Update the SearchInfoCard
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Modify',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            const SizedBox(height: 16),
                            if (!isEditable)
                              SearchInfoCard(
                                from: from,
                                to: to,
                                date: date,
                                journeyClass: journeyClass,
                                returnFrom: returnFrom,
                                returnTo: returnTo,
                                returnDate: returnDate,
                                returnJourneyClass: returnJourneyClass,
                              ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                // Add functionality to cancel the search
                                setState(() {
                                  fromStationController.clear();
                                  toStationController.clear();
                                  _journeyDateController.clear();
                                  _returnDateController.clear();
                                  returnFromStationController.clear();
                                  returnToStationController.clear();
                                  selectedClass = null;
                                  selectedReturnClass = null;
                                  selectedJourneyType = 'One Way';
                                  isEditable = false;
                                });
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
