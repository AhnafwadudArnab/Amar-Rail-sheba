import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LiveTracing extends StatefulWidget {
  const LiveTracing({super.key});

  @override
  State<LiveTracing> createState() => _LiveTracingState();
}

class _LiveTracingState extends State<LiveTracing> {
  final Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocation;
  final Location location = Location();
  final List<LatLng> polylineCoordinates = [];
  final Set<Polyline> polylines = {};
  final Set<Marker> markers = {};
  static const LatLng sourceLocation = LatLng(40.7128, -74.0060); // NYC
  static const LatLng intermediateLocation = LatLng(41.8781, -87.6298); // Chicago
  static const LatLng destination = LatLng(34.0522, -118.2437); // LA
  final String googleApiKey = "AIzaSyC9MXVfuyl5waFhrAlyg_cW0XwMdGLaQO8"; // Replace with your API key

  void _getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result1 = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        destination: PointLatLng(intermediateLocation.latitude, intermediateLocation.longitude),
        mode: TravelMode.driving,
      ),
    );

    PolylineResult result2 = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(intermediateLocation.latitude, intermediateLocation.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result1.status == "OK" && result2.status == "OK") {
      setState(() {
        polylineCoordinates.clear();
        polylineCoordinates.addAll(
          result1.points.map((point) => LatLng(point.latitude, point.longitude)),
        );
        polylineCoordinates.addAll(
          result2.points.map((point) => LatLng(point.latitude, point.longitude)),
        );

        polylines.clear();
        polylines.add(
          Polyline(
            polylineId: const PolylineId("combinedRoute"),
            color: Colors.blue,
            width: 5,
            points: polylineCoordinates,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching route: ${result1.errorMessage ?? result2.errorMessage}")),
      );
    }
  }

  void _initializeLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    currentLocation = await location.getLocation();
    location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        currentLocation = newLocation;
        _updateUserMarker();
      });
      _animateToCurrentLocation();
    });
  }

  void _animateToCurrentLocation() async {
    if (currentLocation != null && _controller.isCompleted) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  void _updateUserMarker() {
    setState(() {
      markers.removeWhere((marker) => marker.markerId.value == "user");
      if (currentLocation != null) {
        markers.add(
          Marker(
            markerId: const MarkerId("user"),
            position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            infoWindow: const InfoWindow(title: "Your Location"),
          ),
        );
      }
    });
  }

  void _addMarkers() {
    setState(() {
      markers.addAll([
        const Marker(
          markerId: MarkerId("source"),
          position: sourceLocation,
          infoWindow: InfoWindow(title: "Source Location"),
        ),
        const Marker(
          markerId: MarkerId("intermediate"),
          position: intermediateLocation,
          infoWindow: InfoWindow(title: "Intermediate Location"),
        ),
        const Marker(
          markerId: MarkerId("destination"),
          position: destination,
          infoWindow: InfoWindow(title: "Destination"),
        ),
      ]);
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _getPolyPoints();
    _addMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Train Tracking'),
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentLocation!.latitude!,
                  currentLocation!.longitude!,
                ),
                zoom: 13.5,
              ),
              polylines: polylines,
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
    );
  }
}
