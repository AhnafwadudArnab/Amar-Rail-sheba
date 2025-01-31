import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import '../firstpage/booking.dart';

class User {
  final String role;
  User(this.role);
  
}

class EmergencyAlertScreen extends StatelessWidget {
  final String name;
  const EmergencyAlertScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () {
            Get.to(() => const MainHomeScreen());
          },
        ),
        title: const Text('Emergency Alert'),
      ),
    );
  }
}

class Passenger {
  String name;
  String seatNO;
  String coachName; // Fixed typo from 'couach_name' to 'coachName'

  Passenger(this.name, this.seatNO, this.coachName);

  void showDetails() {
    if (kDebugMode) {
      Logger().i(
        'Passenger: $name, Seat: $seatNO, Compartment: $coachName',
      );
    }
  }
}

class Attendant {
  void receiveAlert(Passenger passenger, String? emergencyType) {
    if (kDebugMode) {
      Logger().i(
        'Alert received for Passenger: ${passenger.name}, Seat: ${passenger.seatNO}, Compartment: ${passenger.coachName}, Emergency Type: $emergencyType',
      );
    }
  }
}

class EmergencyScreen extends StatefulWidget {
  final User user;

  const EmergencyScreen({super.key, required this.user});

  @override
  EmergencyScreenState createState() => EmergencyScreenState();
}

class EmergencyScreenState extends State<EmergencyScreen> {
  final Attendant attendant = Attendant();
  final Passenger passenger = Passenger('Ahnaf', '8', 'C1');
  final ApiService apiService = ApiService();
  User? user;
  String? _selectedEmergencyType;

  @override
  void initState() {
    super.initState();
    fetchUserFromDatabase().then((fetchedUser ) {
      setState(() {
        user = fetchedUser ;
      });
    });
  }

  Future<User> fetchUserFromDatabase() async {
    // Simulate fetching user from a database
    await Future.delayed(const Duration(seconds: 2));
    return User('attendant'); // Example user role
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () {
            
           Navigator.pop(context);
            //Get.to(() => const MainHomeScreen());
          },
        ),
        centerTitle: true,
        title: const Text(
          'Emergency Alert',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/trainBackgrong/em.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              height: 500,
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInfoCard('Name: ${passenger.name}'),
                  const SizedBox(height: 20),
                  _buildInfoCard('Seat Number: ${passenger.seatNO}'),
                  const SizedBox(height: 20),
                  _buildInfoCard('Compartment: ${passenger.coachName}'),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    dropdownColor: Colors.grey[200],
                    hint: const Text('Select Emergency Type'),
                    value: _selectedEmergencyType,
                    items: <String>['Fire', 'Medical', 'Security', 'Other']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedEmergencyType = newValue;
                      });
                      Logger().i('Selected Emergency Type: $newValue');
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                    ),
                    onPressed: _alertAttendant,
                    child: const Text(
                      'Press in case of emergency',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String text) {
    return Container(
      width: 300,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey[200],
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _alertAttendant() async {
    if (user != null && (user!.role == 'admin' || user!.role == 'attendant')) {
      attendant.receiveAlert(passenger, _selectedEmergencyType);
      Logger().i('Attendant has been alerted!');
      try {
        await apiService.sendEmergencyAlert(
          seatNumber: passenger.seatNO,
          emergencyType: _selectedEmergencyType ?? 'Unknown',
          coachNo: passenger.coachName,
        );
        Get.snackbar('Success', 'Emergency alert sent successfully!');
      } catch (e) {
        Logger().e('Failed to send emergency alert: $e');
        Get.snackbar('Error', 'Failed to send emergency alert.');
      }
    } else {
      Get.snackbar('Error', 'User  is not authorized to send alerts.');
    }
  }
}

class ApiService {
  final String baseUrl = "http://10.15.10.140:3000";

  Future<void> sendEmergencyAlert({
    required String seatNumber,
    required String emergencyType,
    required String coachNo,
  }) async {
    final url = Uri.parse('$baseUrl/emergencyAlert');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'seatNumber': seatNumber,
        'emergencyType': emergencyType,
        'coachNo': coachNo,
      }),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Emergency alert saved successfully.');
      }
    } else {
      if (kDebugMode) {
        print('Failed to save emergency alert: ${response.body}');
      }
    }
  }
  Future<void> getUserDetails(String userId) async {
    final url = Uri.parse('$baseUrl/user/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      Logger().i('User Details: $userData');
    } else {
      Logger().e('Failed to fetch user details: ${response.body}');
    }
  }
}