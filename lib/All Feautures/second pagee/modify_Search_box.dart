import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trackers/All%20Feautures/second%20pagee/Book_page_after_search.dart';

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
                                      onChanged: selectedJourneyType == 'One Way'
                                          ? (value) {
                                              setState(() {
                                                fromStationController.text = value!;
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
                                      onChanged: selectedJourneyType == 'One Way'
                                          ? (value) {
                                              setState(() {
                                                toStationController.text = value!;
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
                                style: TextStyle(color: Color.fromARGB(255, 192, 11, 11)),
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
                                isEditable = false; // Save the changes and exit edit mode
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
                                  returnFromStationController.text = returnFrom;
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