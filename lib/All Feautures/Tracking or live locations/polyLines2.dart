import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trackers/services/train_route_data.dart';
import 'package:trackers/utils/responsive.dart';

/// Dhaka → Sylhet route map
class Polylines2 extends StatefulWidget {
  const Polylines2({super.key});
  @override
  State<Polylines2> createState() => _Polylines2State();
}

class _Polylines2State extends State<Polylines2> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _buildRoute('dhaka_syl');
  }

  void _buildRoute(String routeId) {
    final route = TrainRouteData.routes[routeId]!;
    final points = TrainRouteData.getRoutePoints(routeId);

    _polylines.add(Polyline(
      polylineId: PolylineId(routeId),
      points: points,
      color: Color(route.color),
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    ));

    for (int i = 0; i < route.stationNames.length; i++) {
      final name = route.stationNames[i];
      final pos = TrainRouteData.stations[name];
      if (pos == null) continue;
      _markers.add(Marker(
        markerId: MarkerId(name),
        position: pos,
        infoWindow: InfoWindow(title: name.replaceAll('_', ' ')),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          i == 0
              ? BitmapDescriptor.hueGreen
              : i == route.stationNames.length - 1
                  ? BitmapDescriptor.hueRed
                  : BitmapDescriptor.hueOrange,
        ),
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3A6B),
        foregroundColor: Colors.white,
        title: Text('Dhaka → Sylhet',
            style: TextStyle(fontSize: r.fs15, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GoogleMap(
        markers: _markers,
        polylines: _polylines,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        initialCameraPosition: const CameraPosition(
          target: LatLng(24.2, 91.2),
          zoom: 7,
        ),
        onMapCreated: (c) => _controller.complete(c),
      ),
    );
  }
}
