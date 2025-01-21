import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trackers/All%20Feautures/Tracking%20or%20live%20locations/polyLines.dart';
import 'package:trackers/All%20Feautures/Tracking%20or%20live%20locations/polyLines2.dart';
import 'package:trackers/All%20Feautures/Tracking%20or%20live%20locations/polylines3.dart';
import 'package:trackers/All%20Feautures/firstpage/booking.dart';

class LiveLocation extends StatefulWidget {
  const LiveLocation({super.key});

  @override
  State<LiveLocation> createState() => _LiveLocationState();
}

class _LiveLocationState extends State<LiveLocation> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _location = Location();

    // Check permissions
    bool serviceEnabled = await _location!.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location!.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location!.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location!.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Get initial location
    _currentLocation = await _location!.getLocation();
    if (_currentLocation != null) {
      _cameraPosition = CameraPosition(
        target:
            LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        zoom: 15,
      );
      setState(() {});
    }

    // Listen to location changes
    _location!.onLocationChanged.listen((newLocation) {
      _currentLocation = newLocation;
      moveToPosition(LatLng(newLocation.latitude!, newLocation.longitude!));
    });
  }

  Future<void> moveToPosition(LatLng latLng) async {
    if (_googleMapController.isCompleted) {
      final GoogleMapController mapController =
          await _googleMapController.future;
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 15),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 240, 232, 232),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.to(() => const MainHomeScreen());
          },
        ),
      ),
      body: Stack(
        children: [
          _buildBody(),
          _buildDropdowns(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return _cameraPosition == null
        ? const Center(child: CircularProgressIndicator())
        : _getMap();
  }

  Widget _getMarker() {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 3),
            spreadRadius: 6,
            blurRadius: 6,
          )
        ],
      ),
      child: ClipOval(
        child: Image.asset("assets/trainBackgrong/profile.jpg"),
      ),
    );
  }

  Widget _getMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: _getMarker(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdowns() {
    return Positioned(
      bottom: 5,
      left: 0.1,
      right: 50,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Card(
            //color: Colors.orange,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'My location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'You can See the live location of the train here',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        items: <String>['TR-701', 'TR-703', 'TR-705']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          // Handle dropdown change
                        },
                        hint: const Text("Train Locations"),
                      ),
                      DropdownButton<String>(
                        items: <String>[
                          'DHA to CTG',
                          'DHA to SYL',
                          'SLY to CTG'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue == 'DHA to CTG') {
                            Get.to(() => const Polylines());
                          } else if (newValue == 'DHA to SYL') {
                            Get.to(() => const Polylines2());
                          } else if (newValue == 'SLY to CTG') {
                            Get.to(() => const Polylines3());
                          }
                          // Handle other dropdown changes if needed
                        },
                        hint: const Text("Train Routes"),
                      )
                    ],
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
