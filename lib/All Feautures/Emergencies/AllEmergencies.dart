import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Login&Signup/Login.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

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
            Get.to(() => const Login());
          },
        ),
        centerTitle: true,
        title: const Text('Emergency System'),
      ),
      body: Center(
        child: Flex(
          direction: Axis.vertical,
          children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,  
            children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RealTimeSafetyPage(),
            ),
              );
            },
            child: Container(
              color: Colors.blue,
              child: const Center(
            child: Text(
              'Real-time Emergency and Safety Management',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
            ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmergencyResponsePage(),
            ),
              );
            },
            child: Container(
              color: Colors.green,
              child: const Center(
            child: Text(
              'Emergency Response and Assistance',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
            ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SafetyAlertPage(),
            ),
              );
            },
            child: Container(
              color: Colors.red,
              child: const Center(
            child: Text(
              'Safety Alert and Emergency Help',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
            ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const IncidentReportingPage(),
            ),
              );
            },
            child: Container(
              color: Colors.orange,
              child: const Center(
            child: Text(
              'Incident Reporting and Management',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
            ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PassengerSupportPage(),
            ),
              );
            },
            child: Container(
              color: Colors.purple,
              child: const Center(
            child: Text(
              'Passenger Safety and Support',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
            ),
              ),
            ),
          ),
            ],
          ),
              ),
              ],
            ),
          ),
      );
    }
  }
  
  class RealTimeSafetyPage extends StatelessWidget {
  const RealTimeSafetyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-time Safety Management'),
      ),
      body: const Center(
        child: Text('This page will handle real-time emergency management.'),
      ),
    );
  }
}

class EmergencyResponsePage extends StatelessWidget {
  const EmergencyResponsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Response and Assistance'),
      ),
      body: const Center(
        child: Text('This page will provide emergency assistance.'),
      ),
    );
  }
}

class SafetyAlertPage extends StatelessWidget {
  const SafetyAlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Alert and Help'),
      ),
      body: const Center(
        child: Text('This page will provide safety alerts.'),
      ),
    );
  }
}

class IncidentReportingPage extends StatelessWidget {
  const IncidentReportingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident Reporting'),
      ),
      body: const Center(
        child: Text('This page will allow users to report incidents.'),
      ),
    );
  }
}

class PassengerSupportPage extends StatelessWidget {
  const PassengerSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Support'),
      ),
      body: const Center(
        child: Text('This page will provide safety support for passengers.'),
      ),
    );
  }
}
