import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:trackers/All%20Feautures/second%20pagee/trainSelection.dart';// Import UserController
import 'package:trackers/Login&Signup/Login.dart';
import 'package:trackers/booking.dart';

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

  // ignore: non_constant_identifier_names
  Widget DropDownWidget({required String label}) {
    return DropdownButton<String>(
      hint: Text(label),
      items: <String>['Option 1', 'Option 2', 'Option 3'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (_) {},
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

  @override
  void initState() {
    super.initState();
    endTime =
        DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 6; // 6min from now
  }

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            child: const Text(
              'Sign In',
              style: TextStyle(color: Colors.white),
            ),
          ),/*
          Obx(() {
          if (Get.find<UserController>().isLoggedIn.value) {
            return GestureDetector(
            onTap: () {
              // Navigate to profile page
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                Get.find<UserController>().userProfilePicUrl.value),
            ),
            );
          } else {
            return TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            child: const Text(
              'Sign In',
              style: TextStyle(color: Colors.white),
            ),
            );
          }
          }
          ),*/
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
                //make a box information about what is seach for by the user//
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Column(
                      children: [
                      Row(
                        children: [
                        Text(
                          'From: ${widget.fromStation}',
                          style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'To: ${widget.toStation}',
                          style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Class: ${widget.travelClass}',
                          style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                        Text(
                          'Date: ${widget.journeyDate}',
                          style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        if (selectedJourneyType == 'Round Way') ...[
                          const SizedBox(width: 10),
                          Text(
                          'Return Date: ${_returnDateController.text}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                          ),
                        ],
                        ],
                      ),
                      ],
                    ),
                    const SizedBox(height: 4,width: 40,),
                    SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        ElevatedButton(
                        onPressed: () {
                        setState(() {
                          isEditable = true;
                        });
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
                        const SizedBox(width: 8),
                        if (isEditable)
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

                const SizedBox(height: 16),
                if (isEditable)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                                    color: selectedJourneyType == 'Round Way'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                Expanded(
                                  child: SizedBox(
                                  height: 50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: TextFormField(
                                    controller: fromStationController,
                                    focusNode: fromStationFocusNode,
                                    decoration: const InputDecoration(
                                      hintText: 'From',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(16.0),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                      widget.fromStation = value;
                                      });
                                    },
                                    ),
                                  ),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                  icon: const Icon(Icons.swap_horiz),
                                  onPressed: swapStation,
                                  iconSize: 30,
                                  padding: const EdgeInsets.all(8),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                  height: 50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: TextFormField(
                                    controller: toStationController,
                                    focusNode: toStationFocusNode,
                                    decoration: const InputDecoration(
                                      hintText: 'To',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(16.0),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                      widget.toStation = value;
                                      });
                                    },
                                    ),
                                  ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: SizedBox(
                                  height: 50,
                                  child: DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                    hintText: 'Class'),
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
                                      widget.travelClass = value;
                                    });
                                    },
                                  ),
                                  ),
                                ),
                                ],
                              ),
                              if (selectedJourneyType == 'Round Way') ...[
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 50,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: TextFormField(
                                            controller:
                                                returnFromStationController,
                                            focusNode:
                                                returnFromStationFocusNode,
                                            decoration: const InputDecoration(
                                              hintText: 'Return From',
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.all(16.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: IconButton(
                                        icon: const Icon(Icons.swap_horiz),
                                        onPressed: swapReturnStation,
                                        iconSize: 30,
                                        padding: const EdgeInsets.all(8),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 50,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: TextFormField(
                                            controller:
                                                returnToStationController,
                                            focusNode: returnToStationFocusNode,
                                            decoration: const InputDecoration(
                                              hintText: 'Return To',
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.all(16.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: SizedBox(
                                        height: 50,
                                        child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                              hintText: 'Return Class'),
                                          value: selectedReturnClass,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedReturnClass = newValue!;
                                            });
                                          },
                                          items: ['AC', 'Cabin', 'S_chair']
                                              .map((classType) =>
                                                  DropdownMenuItem(
                                                    value: classType,
                                                    child: Text(classType),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    controller: _journeyDateController,
                                    decoration: InputDecoration(
                                      hintText: 'Journey Date',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2101),
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
                              ),
                              const SizedBox(width: 8),
                              if (selectedJourneyType == 'Round Way')
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      controller: _returnDateController,
                                      decoration: InputDecoration(
                                        hintText: 'Return Date',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
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
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Journey date and return date cannot be the same')),
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
                                ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isEditable =
                                        false; // Save the changes and exit edit mode
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      height: MediaQuery.of(context).size.height * 0.2,
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
                              const Text('Stopages:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              ...[1, 3, 7].map((option) {
                                return ElevatedButton(
                                  onPressed: () {
                                    // Handle option selection
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    backgroundColor: Colors.blueAccent,
                                    padding: const EdgeInsets.all(8),
                                    minimumSize:
                                        const Size(30, 30), // Small size
                                  ),
                                  child: Text(
                                    option.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                                // ignore: unnecessary_to_list_in_spreads
                              }).toList(),
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
                                        price:350,
                                        availableSeats: 5),
                                    ], ),
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
                                        price:150,
                                        availableSeats: 5),
                                    ], ),
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


