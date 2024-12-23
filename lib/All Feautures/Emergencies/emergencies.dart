import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import '../../booking.dart';

class User {
  final String role;

  User(this.role);
}

class EmergencyAlertScreen extends StatelessWidget {
  const EmergencyAlertScreen({super.key});

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
  String seatNumber;
  String compartmentNumber;

  Passenger(this.name, this.seatNumber, this.compartmentNumber);

  void showDetails() {
    if (kDebugMode) {
      Logger().i('Passenger: $name, Seat: $seatNumber, Compartment: $compartmentNumber');
    }
  }
}

class Attendant {
  void receiveAlert(Passenger passenger, String? emergencyType) {
    if (kDebugMode) {
      Logger().i('Alert received for Passenger: ${passenger.name}, Seat: ${passenger.seatNumber}, Compartment: ${passenger.compartmentNumber}, Selected Emergency Type: $emergencyType');
    }
  }
}

class EmergencyScreen extends StatefulWidget {
  final User user;

  const EmergencyScreen({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final Attendant attendant = Attendant();
  final Passenger passenger = Passenger('Ahnaf', '13', 'C3');
  late User user;
  String? _selectedEmergencyType;

  @override
  void initState() {
    super.initState();
    fetchUserFromDatabase().then((fetchedUser) {
      setState(() {
        user = fetchedUser;
      });
    });
  }

  Future<User> fetchUserFromDatabase() async {
    // Simulate fetching user from a database
    await Future.delayed(const Duration(seconds: 2));
    return User('attendant'); // Example user role
  }

  void _alertAttendant() {
    if (user.role == 'admin' || user.role == 'attendant') {
      attendant.receiveAlert(passenger, _selectedEmergencyType);
      Logger().i('Attendant has been alerted!');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 240, 232, 232),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () {
            Get.to(() => const MainHomeScreen());
          },
        ),
        centerTitle: true,
        title: const Text('Emergency Alert', style: TextStyle(fontSize: 24)),
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
                  Container(
                    width: 300,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[200],
                    ),
                    child: Center(
                      child: Text(
                        'Name: ${passenger.name}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 300,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[200],
                    ),
                    child: Center(
                      child: Text(
                        'Seat Number: ${passenger.seatNumber}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 300,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[200],
                    ),
                    child: Center(
                      child: Text(
                        'Compartment: ${passenger.compartmentNumber}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    dropdownColor: Colors.grey[200],
                    hint: const Text('Select Emergency Type'),
                    value: _selectedEmergencyType,
                    items: <String>['Fire', 'Medical', 'Security', 'Other'].map((String value) {
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
                    child: const Text('Press in case of emergency',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
