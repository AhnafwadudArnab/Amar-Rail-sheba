import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:amarRailSheba/utils/responsive.dart';
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
    Logger().i(
      'Passenger: $name, Seat: $seatNO, Compartment: $coachName',
    );
  }
}

class Attendant {
  void receiveAlert(Passenger passenger, String? emergencyType) {
    Logger().i(
      'Alert received for Passenger: ${passenger.name}, Seat: ${passenger.seatNO}, Compartment: ${passenger.coachName}, Emergency Type: $emergencyType',
    );
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
                image: AssetImage('assets/trainBackgrong/em.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Builder(builder: (ctx) {
                    final r = R.of(ctx);
                    return Container(
                      padding: EdgeInsets.all(r.sp20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildInfoCard('Name: ${passenger.name}', r),
                          SizedBox(height: r.sp12),
                          _buildInfoCard('Seat Number: ${passenger.seatNO}', r),
                          SizedBox(height: r.sp12),
                          _buildInfoCard('Compartment: ${passenger.coachName}', r),
                          SizedBox(height: r.sp16),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: r.sp12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                dropdownColor: Colors.grey[200],
                                hint: Text('Select Emergency Type', style: TextStyle(fontSize: r.fs13)),
                                value: _selectedEmergencyType,
                                items: <String>['Fire', 'Medical', 'Security', 'Other']
                                    .map((v) => DropdownMenuItem(
                                          value: v,
                                          child: Text(v, style: TextStyle(fontSize: r.fs13)),
                                        ))
                                    .toList(),
                                onChanged: (v) {
                                  setState(() => _selectedEmergencyType = v);
                                  Logger().i('Selected Emergency Type: $v');
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: r.sp20),
                          SizedBox(
                            width: double.infinity,
                            height: r.btnH,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrangeAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: _alertAttendant,
                              child: Text(
                                'Press in case of emergency',
                                style: TextStyle(color: Colors.white, fontSize: r.fs14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String text, R r) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: r.sp12, horizontal: r.sp16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: r.fs13),
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
      // Emergency alert saved successfully
    } else {
      throw Exception('Failed to save emergency alert: ${response.body}');
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