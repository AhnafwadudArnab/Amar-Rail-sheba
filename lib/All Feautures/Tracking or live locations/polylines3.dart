import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Polylines3 extends StatefulWidget {
  const Polylines3({super.key});
  @override
  State<Polylines3> createState() => _Polylines2State();
}

class _Polylines2State extends State<Polylines3> {
  final Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(22.3398, 91.8315), // Chittagong coordinates
    zoom: 14.4746,
  );

  final Set<Marker> _maker = {};
  final Set<Polyline> _polyline = {};

final List<Marker> markers3 = [
  const Marker(
    markerId: MarkerId('Chittagong'),
    position: LatLng(22.3398, 91.8315),
    infoWindow: InfoWindow(title: 'Chittagong Railway Station'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Feni'),
    position: LatLng(23.0159, 91.4066),
    infoWindow: InfoWindow(title: 'Feni Railway Station'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Laksam'),
    position: LatLng(23.2453, 91.1235),
    infoWindow: InfoWindow(title: 'Laksam Railway Station'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Comilla'),
    position: LatLng(23.4531, 91.1900),
    infoWindow: InfoWindow(title: 'Comilla Railway Station'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Akhaura Junction'),
    position: LatLng(23.8698, 91.1110),
    infoWindow: InfoWindow(title: 'Akhaura Railway Station'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Shaistaganj'),
    position: LatLng(24.3025, 91.3913),
    infoWindow: InfoWindow(title: 'Shaistaganj Railway Station'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Srimangal'),
    position: LatLng(24.3065, 91.7315),
    infoWindow: InfoWindow(title: 'Srimangal Railway Station'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Kulaura'),
    position: LatLng(24.4910, 91.9584),
    infoWindow: InfoWindow(title: 'Kulaura Railway Station'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Sylhet'),
    position: LatLng(24.8995, 91.8698),
    infoWindow: InfoWindow(title: 'Sylhet Railway Station'),
    icon: BitmapDescriptor.defaultMarker,
  ),
];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < markers3.length; i++) {
      _maker.add(Marker(
        markerId: MarkerId('marker$i'),
        position: markers3[i].position,
        infoWindow: markers3[i].infoWindow,
        icon: BitmapDescriptor.defaultMarker,
      ));
      setState(() {});
      _polyline.add(Polyline(
        polylineId: PolylineId('polyline$i'),
        visible: true,
        points: markers3.map((marker) => marker.position).toList(),
        color: Colors.orange[800] ?? Colors.orange,
        width: 4,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GoogleMap(
        markers: _maker,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        polylines: _polyline,
        myLocationButtonEnabled: true,
        initialCameraPosition: _kGooglePlex,
        mapType: MapType.normal,
      ),
    );
  }
}
