import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Polylines2 extends StatefulWidget {
  const Polylines2({super.key});
  @override
  State<Polylines2> createState() => _Polylines2State();
}

class _Polylines2State extends State<Polylines2> {
  _Polylines2State();
  final Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(23.8103, 90.4125), // Temporary initial value
    zoom: 14.4746,
  );

  final Set<Marker> _maker = {};
  final Set<Polyline> _polyline = {};

  final List<Marker> markers2 = [
    const Marker(
      markerId: MarkerId('Kamalapur'),
      position: LatLng(23.73527624151151, 90.4259246537372),
      infoWindow: InfoWindow(title: 'Kamalapur Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Tejgaon'),
      position: LatLng(23.76034910935217, 90.39483656908082),
      infoWindow: InfoWindow(title: 'Tejgaon Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Airport'),
      position: LatLng(23.85209319162333, 90.40803745189065),
      infoWindow: InfoWindow(title: 'Airport Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Tongi'),
      position: LatLng(23.898756731250877, 90.4084396672349),
      infoWindow: InfoWindow(title: 'Tongi Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Ghorashal'),
      position: LatLng(23.94088866369907, 90.61988780921763),
      infoWindow: InfoWindow(title: 'Ghorashal Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Nareshingdi'),
      position: LatLng(23.93211643496608, 90.72142957962532),
      infoWindow: InfoWindow(title: 'Nareshingdi Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Khanabari'),
      position: LatLng(23.95548762502869, 90.79848367233814),
      infoWindow: InfoWindow(title: 'Khanabari Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Methikanda'),
      position: LatLng(23.994050797638504, 90.86710043796215),
      infoWindow: InfoWindow(title: 'Methikanda Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Bhairab-Bazar'),
      position: LatLng(24.05003403547662, 90.97776695374658),
      infoWindow: InfoWindow(title: 'Bhairab-Bazar Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Ashuganj'),
      position: LatLng(24.038404969983183, 91.00148154128884),
      infoWindow: InfoWindow(title: 'Ashuganj Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Brahman_Baria'),
      position: LatLng(23.966981173567415, 91.10850046723695),
      infoWindow: InfoWindow(title: 'Brahman_Baria Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Akhaura'),
      position: LatLng(23.882045001715028, 91.20376437262235),
      infoWindow: InfoWindow(title: 'Akhaura Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Shaistaganj Railway Station'),
      position: LatLng(24.3025, 91.3913),
      infoWindow: InfoWindow(title: 'Shaistaganj Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Srimangal Railway Station'),
      position: LatLng(24.3065, 91.7315),
      infoWindow: InfoWindow(title: 'Srimangal Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Kulaura Junction'),
      position: LatLng(24.4910, 91.9584),
      infoWindow: InfoWindow(title: 'Kulaura Junction Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Maijgaon Railway Station'),
      position: LatLng(24.7647, 91.8842),
      infoWindow: InfoWindow(title: 'Maijgaon Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Sylhet Railway Station'),
      position: LatLng(24.8995, 91.8698),
      infoWindow: InfoWindow(title: 'Sylhet Railway Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
  ];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < markers2.length; i++) {
      _maker.add(Marker(
        markerId: MarkerId('marker$i'),
        position: markers2[i].position,
        infoWindow: markers2[i].infoWindow,
        icon: BitmapDescriptor.defaultMarker,
      ));
      setState(() {});
      _polyline.add(Polyline(
        polylineId: PolylineId('polyline$i'),
        visible: true,
        points: markers2.map((marker) => marker.position).toList(),
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
