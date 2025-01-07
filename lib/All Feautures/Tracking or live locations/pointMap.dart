import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// Removed unused import

class Pointmap extends StatefulWidget {
  const Pointmap({super.key});

  @override
  State<Pointmap> createState() => _PointmapState();

}

class _PointmapState extends State<Pointmap> {

final Completer<GoogleMapController> _controller = Completer();

// ignore: unused_field
final LatLng _currentLocation = const LatLng(23.8103, 90.4125); // Example initial location, replace with actual location fetching logic

late final CameraPosition _kGooglePlex = const CameraPosition(
  target: LatLng(23.8103, 90.4125), // Temporary initial value
  zoom: 14.4746,
);

final List<Marker> _marker = [];
 final List<Marker> _list = [
  const Marker(
    markerId: MarkerId('Airport'),
    position: LatLng(23.843416, 90.397029),
    infoWindow: InfoWindow(title: 'Airport'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Akhaura'),
    position: LatLng(23.118229, 91.685570),
    infoWindow: InfoWindow(title: 'Akhaura'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Bhairab-Bazar'),
    position: LatLng(24.074290, 91.435153),
    infoWindow: InfoWindow(title: 'Bhairab-Bazar'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  
  const Marker(
    markerId: MarkerId('Ashuganj'),
    position: LatLng(23.728073, 90.942063),
    infoWindow: InfoWindow(title: 'Ashuganj'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Brahman_Baria'),
    position: LatLng(23.953184, 91.010846),
    infoWindow: InfoWindow(title: 'Brahman_Baria'),
    icon: BitmapDescriptor.defaultMarker,
  ),

  const Marker(
    markerId: MarkerId('Bhairab-Bazar'),
    position: LatLng(24.074290, 91.435153),
    infoWindow: InfoWindow(title: 'Bhairab-Bazar'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Madhobpur'),
    position: LatLng(24.259461, 91.501725),
    infoWindow: InfoWindow(title: 'Madhobpur'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Shaistaganj'),
    position: LatLng(24.463325, 91.445438),
    infoWindow: InfoWindow(title: 'Shaistaganj'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Sreemangal'),
    position: LatLng(24.303331, 91.727186),
    infoWindow: InfoWindow(title: 'Sreemangal'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Moulvibazar'),
    position: LatLng(24.501883, 91.713081),
    infoWindow: InfoWindow(title: 'Moulvibazar'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Fenchuganj'),
    position: LatLng(24.852526, 91.518618),
    infoWindow: InfoWindow(title: 'Fenchuganj'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Sylhet'),
    position: LatLng(24.894779, 91.868707),
    infoWindow: InfoWindow(title: 'Sylhet'),
    icon: BitmapDescriptor.defaultMarker,
  ),


  const Marker(
    markerId: MarkerId('Chattogram'),
    position: LatLng(22.33405870786462, 91.8301040248612),
    infoWindow: InfoWindow(title: 'Chattogram'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Comilla'),
    position: LatLng(23.464487, 91.183406),
    infoWindow: InfoWindow(title: 'Comilla'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Dewanganj'),
    position: LatLng(24.740282, 89.090749),
    infoWindow: InfoWindow(title: 'Dewanganj'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Dhaka'),
    position: LatLng(23.8103, 90.4125),
    infoWindow: InfoWindow(title: 'Dhaka'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Feni'),
    position: LatLng(23.015278, 91.398611),
    infoWindow: InfoWindow(title: 'Feni'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Jamalpur'),
    position: LatLng(24.918762, 89.958247),
    infoWindow: InfoWindow(title: 'Jamalpur'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
    markerId: MarkerId('Laksham'),
    position: LatLng(23.084698, 91.291450),
    infoWindow: InfoWindow(title: 'Laksham'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  
  const Marker(
    markerId: MarkerId('Narshingdi'),
    position: LatLng(23.929393, 90.717651),
    infoWindow: InfoWindow(title: 'Narshingdi'),
    icon: BitmapDescriptor.defaultMarker,
  ),
  const Marker(
  markerId:  MarkerId('Tejgaon'),
  position:  LatLng(23.812627, 90.397423),
  infoWindow:  InfoWindow(title: 'Tejgaon'),
  icon: BitmapDescriptor.defaultMarker,
),


];


@override
void initState() {
  super.initState();
  _marker.addAll(_list);
}
@override
  Widget build(BuildContext context) {
  return Scaffold( 
    body: GoogleMap(initialCameraPosition: _kGooglePlex, 
    markers: Set.from(_marker),
    mapType: MapType.hybrid,
   onMapCreated: (GoogleMapController controller) => _controller.complete(controller)),
  );
}
}