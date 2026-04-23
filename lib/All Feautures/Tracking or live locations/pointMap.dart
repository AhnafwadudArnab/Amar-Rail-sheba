import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackers/services/train_route_data.dart';
import 'package:trackers/utils/responsive.dart';

/// Shows all Bangladesh railway stations on the map
class Pointmap extends StatefulWidget {
  const Pointmap({super.key});
  @override
  State<Pointmap> createState() => _PointmapState();
}

class _PointmapState extends State<Pointmap> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  void _loadStations() {
    TrainRouteData.stations.forEach((name, pos) {
      _markers.add(Marker(
        markerId: MarkerId(name),
        position: pos,
        infoWindow: InfoWindow(title: name.replaceAll('_', ' ')),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3A6B),
        foregroundColor: Colors.white,
        title: Text('All Stations',
            style: TextStyle(fontSize: r.fs15, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(23.8103, 90.4125),
          zoom: 7,
        ),
        markers: _markers,
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        onMapCreated: (c) => _controller.complete(c),
      ),
    );
  }
}
