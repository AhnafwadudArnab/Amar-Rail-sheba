import 'package:flutter/material.dart';

class UpdateBasedTrain extends StatefulWidget {
  const UpdateBasedTrain({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UpdateBasedTrainState createState() => _UpdateBasedTrainState();
}

class _UpdateBasedTrainState extends State<UpdateBasedTrain> {
  String _selectedType = 'Intercity';
  List<Map<String, String>> _trains = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Based Train'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _selectedType,
            onChanged: (String? newValue) {
              setState(() {
                _selectedType = newValue!;
                _updateTrains();
              });
            },
            items: <String>['Intercity', 'Mail and Local']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
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