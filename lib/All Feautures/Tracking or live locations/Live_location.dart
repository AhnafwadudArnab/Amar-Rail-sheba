import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:amarRailSheba/services/train_route_data.dart';
import 'package:amarRailSheba/utils/responsive.dart';

class LiveLocation extends StatefulWidget {
  const LiveLocation({super.key});

  @override
  State<LiveLocation> createState() => _LiveLocationState();
}

class _LiveLocationState extends State<LiveLocation>
    with TickerProviderStateMixin {
  // ── Map ──────────────────────────────────────────────────────────────────
  final Completer<GoogleMapController> _mapCtrl = Completer();
  MapType _mapType = MapType.normal;

  // ── User location ─────────────────────────────────────────────────────────
  Position? _userPosition;
  StreamSubscription<Position>? _positionStream;
  bool _locationGranted = false;
  bool _followUser = true;

  // ── Train simulation ──────────────────────────────────────────────────────
  String _selectedRouteId = 'dhaka_ctg';
  String _selectedTrainName = 'Subarna Express (701)';
  TrainSimulator? _simulator;
  Timer? _simTimer;
  bool _isSimulating = false;

  // ── Map overlays ──────────────────────────────────────────────────────────
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final Set<Circle> _circles = {};

  // ── Animation ─────────────────────────────────────────────────────────────
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  // ── Info panel ────────────────────────────────────────────────────────────
  bool _showPanel = true;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.5, end: 1.0).animate(_pulseCtrl);

    _initLocation();
    _loadRoute(_selectedRouteId);
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _simTimer?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ── Location init ─────────────────────────────────────────────────────────
  Future<void> _initLocation() async {
    // On web, Geolocator uses the browser's Geolocation API
    // isLocationServiceEnabled() always returns true on web
    if (!kIsWeb) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack('Location services are disabled. Please enable GPS.');
        return;
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnack('Location permission denied.');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _showSnack('Location permission permanently denied. Enable in settings.');
      return;
    }

    setState(() => _locationGranted = true);

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    // Get initial position
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _onPositionUpdate(pos);
    } catch (e) {
      _showSnack('Could not get location: $e');
    }

    // Stream updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      _onPositionUpdate,
      onError: (e) => _showSnack('Location stream error. Check GPS settings.'),
    );
  }

  void _onPositionUpdate(Position pos) {
    setState(() {
      _userPosition = pos;
      _updateUserMarker(LatLng(pos.latitude, pos.longitude));
      _updateUserCircle(LatLng(pos.latitude, pos.longitude), pos.accuracy);
    });
    if (_followUser) {
      _animateCameraTo(LatLng(pos.latitude, pos.longitude));
    }
  }

  // ── Route loading ─────────────────────────────────────────────────────────
  void _loadRoute(String routeId) {
    final route = TrainRouteData.routes[routeId];
    if (route == null) return;

    final points = TrainRouteData.getRoutePoints(routeId);

    setState(() {
      _selectedRouteId = routeId;
      _selectedTrainName = route.trains.first;

      // Draw route polyline
      _polylines.removeWhere((p) => p.polylineId.value == 'route');
      _polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: points,
        color: Color(route.color),
        width: 5,
        patterns: const [],
        jointType: JointType.round,
        endCap: Cap.roundCap,
        startCap: Cap.roundCap,
      ));

      // Station markers
      _markers.removeWhere((m) => m.markerId.value.startsWith('station_'));
      for (int i = 0; i < route.stationNames.length; i++) {
        final name = route.stationNames[i];
        final pos = TrainRouteData.stations[name];
        if (pos == null) continue;
        _markers.add(Marker(
          markerId: MarkerId('station_$name'),
          position: pos,
          infoWindow: InfoWindow(
            title: name.replaceAll('_', ' '),
            snippet: i == 0
                ? '🚉 Origin'
                : i == route.stationNames.length - 1
                    ? '🏁 Destination'
                    : 'Stop ${i + 1}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            i == 0
                ? BitmapDescriptor.hueGreen
                : i == route.stationNames.length - 1
                    ? BitmapDescriptor.hueRed
                    : BitmapDescriptor.hueOrange,
          ),
        ));
      }

      // Init simulator
      _simulator = TrainSimulator(
        routeId: routeId,
        trainName: _selectedTrainName,
        routePoints: points,
        startSegment: 0,
      );
    });

    // Fit camera to route
    _fitCameraToRoute(points);
  }

  // ── Train simulation ──────────────────────────────────────────────────────
  void _startSimulation() {
    if (_simulator == null) return;
    setState(() => _isSimulating = true);
    _simTimer?.cancel();
    _simTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (_simulator!.isAtDestination) {
        _stopSimulation();
        return;
      }
      _simulator!.advance(30); // advance 30 sim-seconds per tick (fast demo)
      _updateTrainMarker(_simulator!.currentPosition);
      setState(() {});
    });
  }

  void _stopSimulation() {
    _simTimer?.cancel();
    setState(() => _isSimulating = false);
  }

  void _resetSimulation() {
    _stopSimulation();
    _loadRoute(_selectedRouteId);
  }

  void _updateTrainMarker(LatLng pos) {
    setState(() {
      _markers.removeWhere((m) => m.markerId.value == 'train');
      _markers.add(Marker(
        markerId: const MarkerId('train'),
        position: pos,
        infoWindow: InfoWindow(
          title: _selectedTrainName,
          snippet:
              '→ ${_simulator?.nextStation ?? ''} | ETA: ${_simulator?.etaMinutes ?? 0} min',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        zIndex: 10,
      ));
    });
    if (!_followUser) {
      _animateCameraTo(pos);
    }
  }

  // ── User marker & circle ──────────────────────────────────────────────────
  void _updateUserMarker(LatLng pos) {
    _markers.removeWhere((m) => m.markerId.value == 'user');
    _markers.add(Marker(
      markerId: const MarkerId('user'),
      position: pos,
      infoWindow: const InfoWindow(title: 'You are here'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      zIndex: 5,
    ));
  }

  void _updateUserCircle(LatLng pos, double accuracy) {
    _circles.removeWhere((c) => c.circleId.value == 'accuracy');
    _circles.add(Circle(
      circleId: const CircleId('accuracy'),
      center: pos,
      radius: accuracy,
      fillColor: Colors.blue.withValues(alpha: 0.1),
      strokeColor: Colors.blue.withValues(alpha: 0.4),
      strokeWidth: 1,
    ));
  }

  // ── Camera ────────────────────────────────────────────────────────────────
  Future<void> _animateCameraTo(LatLng pos, {double zoom = 14}) async {
    if (!_mapCtrl.isCompleted) return;
    final ctrl = await _mapCtrl.future;
    ctrl.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: pos, zoom: zoom),
    ));
  }

  Future<void> _fitCameraToRoute(List<LatLng> points) async {
    if (points.isEmpty || !_mapCtrl.isCompleted) return;
    final ctrl = await _mapCtrl.future;
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final p in points) {
      minLat = min(minLat, p.latitude);
      maxLat = max(maxLat, p.latitude);
      minLng = min(minLng, p.longitude);
      maxLng = max(maxLng, p.longitude);
    }
    ctrl.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: LatLng(minLat - 0.1, minLng - 0.1),
        northeast: LatLng(maxLat + 0.1, maxLng + 0.1),
      ),
      60,
    ));
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: const Color(0xFF1A3A6B)),
    );
  }

  // ── BUILD ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // ── Google Map ──────────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(23.8103, 90.4125), // Dhaka
              zoom: 7,
            ),
            mapType: _mapType,
            markers: _markers,
            polylines: _polylines,
            circles: _circles,
            myLocationEnabled: _locationGranted,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            trafficEnabled: true,
            onMapCreated: (ctrl) {
              if (!_mapCtrl.isCompleted) _mapCtrl.complete(ctrl);
            },
            onTap: (_) => setState(() => _followUser = false),
          ),

          // ── Top AppBar ──────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.all(r.sp12),
                padding: EdgeInsets.symmetric(
                    horizontal: r.sp16, vertical: r.sp10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10)
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.arrow_back_ios,
                          color: Color(0xFF1A3A6B)),
                    ),
                    SizedBox(width: r.sp10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Live Train Tracking',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: r.fs15,
                                  color: const Color(0xFF1A3A6B))),
                          Text(
                            _locationGranted
                                ? 'GPS Active'
                                : 'GPS Unavailable',
                            style: TextStyle(
                                fontSize: r.fs11,
                                color: _locationGranted
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                    ),
                    // Live indicator
                    if (_isSimulating)
                      AnimatedBuilder(
                        animation: _pulseAnim,
                        builder: (_, __) => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: r.sp8, vertical: r.sp4),
                          decoration: BoxDecoration(
                            color: Colors.red
                                .withValues(alpha: _pulseAnim.value),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.circle,
                                  color: Colors.white, size: 8),
                              SizedBox(width: r.sp4),
                              Text('LIVE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: r.fs10,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // ── Right side controls ─────────────────────────────────────────
          Positioned(
            right: r.sp12,
            top: MediaQuery.of(context).padding.top + 80,
            child: Column(
              children: [
                _mapBtn(Icons.layers, 'Map Type', _toggleMapType),
                SizedBox(height: r.sp8),
                _mapBtn(
                  _followUser ? Icons.gps_fixed : Icons.gps_not_fixed,
                  'Follow Me',
                  _goToUserLocation,
                  active: _followUser,
                ),
                SizedBox(height: r.sp8),
                _mapBtn(Icons.fit_screen, 'Fit Route', () {
                  final pts = TrainRouteData.getRoutePoints(_selectedRouteId);
                  _fitCameraToRoute(pts);
                }),
                SizedBox(height: r.sp8),
                _mapBtn(
                  _showPanel ? Icons.expand_more : Icons.expand_less,
                  'Panel',
                  () => setState(() => _showPanel = !_showPanel),
                ),
              ],
            ),
          ),

          // ── Bottom info panel ───────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSlide(
              offset: _showPanel ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _buildInfoPanel(r),
            ),
          ),
        ],
      ),
    );
  }

  // ── Map control button ────────────────────────────────────────────────────
  Widget _mapBtn(IconData icon, String tooltip, VoidCallback onTap,
      {bool active = false}) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1A3A6B) : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15), blurRadius: 6)
            ],
          ),
          child: Icon(icon,
              color: active ? Colors.white : const Color(0xFF1A3A6B),
              size: 20),
        ),
      ),
    );
  }

  // ── Info panel ────────────────────────────────────────────────────────────
  Widget _buildInfoPanel(R r) {
    final route = TrainRouteData.routes[_selectedRouteId];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -4))
        ],
      ),
      padding: EdgeInsets.fromLTRB(r.sp16, r.sp16, r.sp16,
          r.sp16 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: r.sp12),

          // Route selector
          Text('Select Route',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: r.fs13,
                  color: Colors.grey)),
          SizedBox(height: r.sp8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: TrainRouteData.routes.entries.map((e) {
                final selected = e.key == _selectedRouteId;
                return GestureDetector(
                  onTap: () {
                    _stopSimulation();
                    _loadRoute(e.key);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: r.sp8),
                    padding: EdgeInsets.symmetric(
                        horizontal: r.sp12, vertical: r.sp8),
                    decoration: BoxDecoration(
                      color: selected
                          ? Color(e.value.color)
                          : const Color(0xFFF0F4F8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      e.value.shortName,
                      style: TextStyle(
                          color: selected ? Colors.white : Colors.grey[700],
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: r.fs12),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: r.sp12),

          // Train selector
          if (route != null) ...[
            Text('Select Train',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: r.fs13,
                    color: Colors.grey)),
            SizedBox(height: r.sp8),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: r.sp12, vertical: r.sp4),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFDDE2EC)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTrainName,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: TextStyle(
                      fontSize: r.fs13, color: Colors.black87),
                  items: route.trains
                      .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t,
                              style: TextStyle(fontSize: r.fs13))))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _selectedTrainName = v);
                      _resetSimulation();
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: r.sp12),
          ],

          // Train status card
          if (_simulator != null) _buildTrainStatus(r),
          SizedBox(height: r.sp12),

          // Control buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: r.btnH,
                  child: ElevatedButton.icon(
                    onPressed: _isSimulating ? _stopSimulation : _startSimulation,
                    icon: Icon(
                        _isSimulating ? Icons.pause : Icons.play_arrow,
                        size: r.fs18),
                    label: Text(
                        _isSimulating ? 'Pause' : 'Start Tracking',
                        style: TextStyle(
                            fontSize: r.fs13,
                            fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSimulating
                          ? Colors.orange
                          : const Color(0xFF1A3A6B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: r.sp10),
              SizedBox(
                height: r.btnH,
                width: r.btnH,
                child: ElevatedButton(
                  onPressed: _resetSimulation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0F4F8),
                    foregroundColor: const Color(0xFF1A3A6B),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.zero,
                  ),
                  child: Icon(Icons.refresh, size: r.fs20),
                ),
              ),
            ],
          ),

          // User location info
          if (_userPosition != null) ...[
            SizedBox(height: r.sp12),
            _buildUserLocationInfo(r),
          ],
        ],
      ),
    );
  }

  // ── Train status card ─────────────────────────────────────────────────────
  Widget _buildTrainStatus(R r) {
    final sim = _simulator!;
    final route = TrainRouteData.routes[_selectedRouteId]!;
    return Container(
      padding: EdgeInsets.all(r.sp12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE2EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _isSimulating ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: r.sp8),
              Expanded(
                child: Text(
                  _selectedTrainName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: r.fs13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: r.sp8, vertical: r.sp4),
                decoration: BoxDecoration(
                  color: Color(route.color).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(route.shortName,
                    style: TextStyle(
                        color: Color(route.color),
                        fontSize: r.fs11,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(height: r.sp10),
          Row(
            children: [
              Expanded(
                  child: _statItem(r, Icons.location_on_outlined,
                      'Current', sim.currentStation.replaceAll('_', ' '))),
              Expanded(
                  child: _statItem(r, Icons.arrow_forward,
                      'Next Stop', sim.nextStation.replaceAll('_', ' '))),
            ],
          ),
          SizedBox(height: r.sp8),
          Row(
            children: [
              Expanded(
                  child: _statItem(r, Icons.speed, 'Speed',
                      '${sim.speedKmh.toStringAsFixed(0)} km/h')),
              Expanded(
                  child: _statItem(r, Icons.timer_outlined, 'ETA',
                      '${sim.etaMinutes} min')),
              Expanded(
                  child: _statItem(r, Icons.straighten, 'Distance',
                      '${sim.distanceToNextKm.toStringAsFixed(1)} km')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(R r, IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: r.fs12, color: Colors.grey),
            SizedBox(width: r.sp4),
            Text(label,
                style: TextStyle(color: Colors.grey, fontSize: r.fs10)),
          ],
        ),
        SizedBox(height: r.sp4 / 2),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: r.fs12,
                color: const Color(0xFF1A3A6B)),
            overflow: TextOverflow.ellipsis),
      ],
    );
  }

  // ── User location info ────────────────────────────────────────────────────
  Widget _buildUserLocationInfo(R r) {
    final pos = _userPosition!;
    final time = DateFormat('hh:mm a').format(DateTime.now());
    return Container(
      padding: EdgeInsets.all(r.sp12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.my_location, color: Colors.blue, size: 20),
          SizedBox(width: r.sp10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Location',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: r.fs12)),
                Text(
                  '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}',
                  style: TextStyle(color: Colors.grey, fontSize: r.fs11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: r.fs12)),
              Text(
                '±${pos.accuracy.toStringAsFixed(0)}m',
                style: TextStyle(color: Colors.grey, fontSize: r.fs10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  void _toggleMapType() {
    setState(() {
      _mapType = _mapType == MapType.normal
          ? MapType.hybrid
          : _mapType == MapType.hybrid
              ? MapType.satellite
              : MapType.normal;
    });
  }

  void _goToUserLocation() {
    setState(() => _followUser = true);
    if (_userPosition != null) {
      _animateCameraTo(
          LatLng(_userPosition!.latitude, _userPosition!.longitude),
          zoom: 15);
    }
  }
}
