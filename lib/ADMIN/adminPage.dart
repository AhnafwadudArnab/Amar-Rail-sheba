// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:trackers/Login&Signup/sign_up.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool isEditable = true;
  String? selectedClass;
  final TextEditingController fromStationController = TextEditingController();
  final TextEditingController toStationController = TextEditingController();
  final TextEditingController journeyDateController = TextEditingController();
  final TextEditingController returnDateController = TextEditingController();
  final TextEditingController returnPriceController = TextEditingController();
  final TextEditingController returnTrainCodeController = TextEditingController();
  final TextEditingController deptTimeController = TextEditingController();
  final TextEditingController arrTimeController = TextEditingController();
  bool isLoading = false;

  List<String> editableStations = [
    'Airport',
    'Akhaura',
    'Bhairab-Bazar',
    'Brahman_Baria',
    'Chandpur',
    'Chattogram',
    'Comilla',
    'Dewanganj',
    'Dhaka',
    'Feni',
    'Khulna',
    'Laksham',
    'Narshingdi'
  ];

  final TrainService apiService = TrainService();

  void swapStation() {
    setState(() {
      final tempText = fromStationController.text;
      fromStationController.text = toStationController.text;
      toStationController.text = tempText;
    });
  }

  bool isFormValid() {
    return fromStationController.text.isNotEmpty &&
        toStationController.text.isNotEmpty &&
        journeyDateController.text.isNotEmpty &&
        returnPriceController.text.isNotEmpty &&
        returnTrainCodeController.text.isNotEmpty &&
        deptTimeController.text.isNotEmpty &&
        arrTimeController.text.isNotEmpty;
  }

  Future<void> addTrain() async {
    if (!isFormValid()) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final trainData = {
      "train_name": "New Train", // Modify this to get from user input
      "train_code": returnTrainCodeController.text,
      "from_station": fromStationController.text,
      "to_station": toStationController.text,
      "dept_time": deptTimeController.text.isNotEmpty ? deptTimeController.text : "00:00",
      "arr_time": arrTimeController.text.isNotEmpty ? arrTimeController.text : "00:00",
      "class_type": selectedClass,
      "duration": "4h", // Modify this to get from user input
      "price": returnPriceController.text,
    };

    try {
      final response = await apiService.addTrain(
        trainName: "New Train",
        trainCode: trainData['train_code']!,
        fromStation: trainData['from_station']!,
        toStation: trainData['to_station']!,
        deptTime: trainData['dept_time']!,
        arrTime: trainData['arr_time']!,
        classType: trainData['class_type']!,
        duration: trainData['duration']!,
        price: double.parse(trainData['price']!),
      );
      print('Response: $response');
      if (response.containsKey('id')) {
        Get.snackbar('Success', 'Train added successfully: ${response['id']}');
      } else {
        Get.snackbar('Error', 'Failed to add train');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add train: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
      clearForm();
    }
  }

  void clearForm() {
    fromStationController.clear();
    toStationController.clear();
    journeyDateController.clear();
    returnDateController.clear();
    returnPriceController.clear();
    returnTrainCodeController.clear();
    deptTimeController.clear();
    arrTimeController.clear();
    selectedClass = null;
  }

  @override
  void dispose() {
    fromStationController.dispose();
    toStationController.dispose();
    journeyDateController.dispose();
    returnDateController.dispose();
    returnPriceController.dispose();
    returnTrainCodeController.dispose();
    deptTimeController.dispose();
    arrTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Admin Panel')),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.to(() => const SignUp());
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.blue,
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 400,
              height: 768,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
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
                          color: Colors.blue[400]?.withOpacity(0.1),
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
                              const Text(
                                'Add New Train',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 22.0),
                              if (isEditable)
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                                  decoration: BoxDecoration(
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
                                      const SizedBox(height: 16),
                                      Container(
                                        decoration: BoxDecoration(
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
                                                  labelText: 'From',
                                                ),
                                                value: fromStationController.text.isEmpty
                                                    ? null
                                                    : fromStationController.text,
                                                items: editableStations.map((station) {
                                                  return DropdownMenuItem<String>(
                                                    value: station,
                                                    child: Text(station),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    fromStationController.text = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: IconButton(
                                          icon: const Icon(Icons.swap_calls_rounded),
                                          onPressed: swapStation,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
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
                                                  labelText: 'To',
                                                ),
                                                value: toStationController.text.isEmpty
                                                    ? null
                                                    : toStationController.text,
                                                items: editableStations.map((station) {
                                                  return DropdownMenuItem<String>(
                                                    value: station,
                                                    child: Text(station),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    toStationController.text = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: DropdownButtonFormField<String>(
                                              decoration: const InputDecoration(labelText: 'Class'),
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
                                              controller: journeyDateController,
                                              decoration: const InputDecoration(labelText: 'Date'),
                                              onTap: () async {
                                                DateTime? pickedDate = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.now().add(const Duration(days: 10)),
                                                );
                                                if (pickedDate != null) {
                                                  journeyDateController.text =
                                                      pickedDate.toLocal().toString().split(' ')[0];
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        decoration: BoxDecoration(
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
                                              child: TextFormField(
                                                controller: returnPriceController,
                                                decoration: const InputDecoration(
                                                  icon: Icon(Icons.attach_money),
                                                  labelText: 'Tickets Price',
                                                ),
                                                keyboardType: TextInputType.number,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        decoration: BoxDecoration(
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
                                              child: TextFormField(
                                                controller: returnTrainCodeController,
                                                decoration: const InputDecoration(
                                                  icon: Icon(Icons.code),
                                                  labelText: 'Train Code',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        decoration: BoxDecoration(
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
                                              child: TextFormField(
                                                controller: deptTimeController,
                                                decoration: const InputDecoration(
                                                  icon: Icon(Icons.access_time),
                                                  labelText: 'Departure Time',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        decoration: BoxDecoration(
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
                                              child: TextFormField(
                                                controller: arrTimeController,
                                                decoration: const InputDecoration(
                                                  icon: Icon(Icons.access_time),
                                                  labelText: 'Arrival Time',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: isLoading ? null : addTrain,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[200],
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0, horizontal: 32.0),
                                        ),
                                        child: isLoading
                                            ? const CircularProgressIndicator()
                                            : const Text(
                                                'Add Train',
                                                style: TextStyle(color: Colors.black, fontSize: 18),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TrainService {
  final String baseUrl = 'http://10.15.32.229:3000/api/trains';

  // Add a new train
  Future<Map<String, dynamic>> addTrain({
    required String trainName,
    required String trainCode,
    required String fromStation,
    required String toStation,
    required String deptTime,
    required String arrTime,
    required String classType,
    required String duration,
    required double price,
  }) async {
    final Uri url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'train_name': trainName,
          'train_code': trainCode,
          'from_station': fromStation,
          'to_station': toStation,
          'dept_time': deptTime,
          'arr_time': arrTime,
          'class_type': classType,
          'duration': duration,
          'price': price,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add train: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
