import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Polylines extends StatefulWidget {
  const Polylines({super.key});

  @override
  State<Polylines> createState() => _PolylinesState();
}

class _PolylinesState extends State<Polylines> {
  final Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(23.8103, 90.4125), // Temporary initial value
    zoom: 14.4746,
  );

  final Set<Marker> _maker = {};
  final Set<Polyline> _polyline = {};

  /*List<LatLng> lattlng = const [
    LatLng(23.73527624151151, 90.4259246537372),
    LatLng(23.76034910935217, 90.39483656908082),
    LatLng(23.85209319162333, 90.40803745189065),
    LatLng(23.898756731250877, 90.4084396672349), //tongi station
    LatLng(23.94088866369907, 90.61988780921763),
    LatLng(23.930853553590516, 90.67415702098421),
    LatLng(23.93211643496608, 90.72142957962532),
    LatLng(23.95548762502869, 90.79848367233814),
    LatLng(23.994050797638504, 90.86710043796215),
    LatLng(24.05003403547662, 90.97776695374658),
    LatLng(24.038404969983183, 91.00148154128884),
    LatLng(23.966981173567415, 91.10850046723695),
    LatLng(23.882045001715028, 91.20376437262235),
    LatLng(23.745578928300844, 91.14804106908034),
    LatLng(23.463718670743436, 91.16677703838637),
    LatLng(23.254978272570032, 91.12400020742314),
    LatLng(23.013741203358386, 91.40198995371615),
    LatLng(22.3340190118533, 91.8301040248612),
  ];*/
  final List<Marker> markers = [
    const Marker(
      markerId: MarkerId('Kamalapur'),
      position: LatLng(23.73527624151151, 90.4259246537372),
      infoWindow: InfoWindow(title: 'Kamalapur Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Tejgaon'),
      position: LatLng(23.76034910935217, 90.39483656908082),
      infoWindow: InfoWindow(title: 'Tejgaon Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Airport'),
      position: LatLng(23.85209319162333, 90.40803745189065),
      infoWindow: InfoWindow(title: 'Airport Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Tongi'),
      position: LatLng(23.898756731250877, 90.4084396672349),
      infoWindow: InfoWindow(title: 'Tongi Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Ghorashal'),
      position: LatLng(23.94088866369907, 90.61988780921763),
      infoWindow: InfoWindow(title: 'Ghorashal Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Nareshingdi'),
      position: LatLng(23.93211643496608, 90.72142957962532),
      infoWindow: InfoWindow(title: 'Nareshingdi Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Khanabari'),
      position: LatLng(23.95548762502869, 90.79848367233814),
      infoWindow: InfoWindow(title: 'Khanabari Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Methikanda'),
      position: LatLng(23.994050797638504, 90.86710043796215),
      infoWindow: InfoWindow(title: 'Methikanda Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Bhairab-Bazar'),
      position: LatLng(24.05003403547662, 90.97776695374658),
      infoWindow: InfoWindow(title: 'Bhairab-Bazar Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Ashuganj'),
      position: LatLng(24.038404969983183, 91.00148154128884),
      infoWindow: InfoWindow(title: 'Ashuganj Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Brahman_Baria'),
      position: LatLng(23.966981173567415, 91.10850046723695),
      infoWindow: InfoWindow(title: 'Brahman_Baria Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Akhaura'),
      position: LatLng(23.882045001715028, 91.20376437262235),
      infoWindow: InfoWindow(title: 'Akhaura Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Kasba'),
      position: LatLng(23.745578928300844, 91.14804106908034),
      infoWindow: InfoWindow(title: 'Kasba Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Comilla'),
      position: LatLng(23.463718670743436, 91.16677703838637),
      infoWindow: InfoWindow(title: 'Comilla Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Laksham'),
      position: LatLng(23.254978272570032, 91.12400020742314),
      infoWindow: InfoWindow(title: 'Laksham Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Feni'),
      position: LatLng(23.013741203358386, 91.40198995371615),
      infoWindow: InfoWindow(title: 'Feni Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
    const Marker(
      markerId: MarkerId('Chittagong'),
      position: LatLng(22.3340190118533, 91.8301040248612),
      infoWindow: InfoWindow(title: 'Chittagong Station'),
      icon: BitmapDescriptor.defaultMarker,
    ),
  ];

  
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < markers.length; i++) {
      _maker.add(Marker(
        markerId: MarkerId('marker$i'),
        position: markers[i].position,
        infoWindow: markers[i].infoWindow,
        icon: BitmapDescriptor.defaultMarker,
      ));
      setState(() {});
      _polyline.add(Polyline(
        polylineId: PolylineId('polyline$i'),
        visible: true,
        points: markers.map((marker) => marker.position).toList(),
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
