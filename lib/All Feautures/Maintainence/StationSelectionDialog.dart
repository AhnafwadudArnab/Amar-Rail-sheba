import 'package:flutter/material.dart';

class StationSelectionDialog extends StatefulWidget {
  const StationSelectionDialog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StationSelectionDialogState createState() => _StationSelectionDialogState();
}

class _StationSelectionDialogState extends State<StationSelectionDialog> {
  String? _selectedStation;

  final List<String> _stations = [
    'Dhaka',
    'Airport',
    'Narshingdi',
    'Bhairab-Bazar',
    'Brahman_Baria',
    'Akhaura',
    'Comilla',
    'Feni',
    'Laksham',
    'Chattogram',
  ];

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select a Station'),
      children: _stations.map((String station) {
        return SimpleDialogOption(
          onPressed: () {
            setState(() {
              _selectedStation = station;
            });
            Navigator.of(context).pop(_selectedStation);
          },
          child: Text(station),
        );
      }).toList(),
    );
  }
}
