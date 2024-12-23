import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trackers/booking.dart';


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
        target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
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
      final GoogleMapController mapController = await _googleMapController.future;
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
      body: _buildBody()

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
}
