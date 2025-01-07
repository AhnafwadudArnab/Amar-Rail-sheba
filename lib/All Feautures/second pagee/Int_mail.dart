import 'package:flutter/material.dart';

class IntMail extends StatelessWidget {
  const IntMail({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dropdown Example'),
        ),
        body: const IntercityMail(),
      ),
    );
  }
}

class IntercityMail extends StatefulWidget {
  const IntercityMail({super.key});

  @override
  createState() => _IntercityMailState();
}

class _IntercityMailState extends State<IntercityMail> {
  String? _selectedType;
  List<Map<String, String>> _trains = [];

  @override
  void initState() {
    super.initState();
    _updateTrains();
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
        {'Train ID': '710', 'Name': 'Bijoy Express (Chittagong–Mymensingh)'},
      ];
    } else if (_selectedType == 'Mail and Local') {
      _trains = [
        {'Train ID': '31', 'Name': 'Dhaka Mail (Dhaka–Khulna)'},
        {'Train ID': '33', 'Name': 'Chattala Express (Dhaka–Chittagong)'},
        {'Train ID': '37', 'Name': 'Titas Commuter (Dhaka–Brahmanbaria)'},
        {'Train ID': '39', 'Name': 'Surma Mail (Dhaka–Sylhet)'},
        {'Train ID': '41', 'Name': 'Khulna Mail (Khulna–Parbatipur)'},
      ];
    } else {
      _trains = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Type: ',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              DropdownButton<String>(
                hint: const Text('Select Type'),
                value: _selectedType,
                items: <String>['Intercity', 'Mail and Local']
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
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _trains.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_trains[index]['Name']!),
                  subtitle: Text('Train ID: ${_trains[index]['Train ID']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
