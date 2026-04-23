import 'package:google_maps_flutter/google_maps_flutter.dart';

/// All Bangladesh Railway routes with real station coordinates
class TrainRouteData {
  // ── Station coordinates ──────────────────────────────────────────────────
  static const Map<String, LatLng> stations = {
    'Kamalapur':    LatLng(23.73527, 90.42592),
    'Tejgaon':      LatLng(23.76034, 90.39483),
    'Airport':      LatLng(23.85209, 90.40803),
    'Tongi':        LatLng(23.89875, 90.40843),
    'Ghorashal':    LatLng(23.94088, 90.61988),
    'Narshingdi':   LatLng(23.93211, 90.72142),
    'Bhairab':      LatLng(24.05003, 90.97776),
    'Ashuganj':     LatLng(24.03840, 91.00148),
    'Brahman_Baria':LatLng(23.96698, 91.10850),
    'Akhaura':      LatLng(23.88204, 91.20376),
    'Kasba':        LatLng(23.74557, 91.14804),
    'Comilla':      LatLng(23.46371, 91.16677),
    'Laksham':      LatLng(23.25497, 91.12400),
    'Feni':         LatLng(23.01374, 91.40198),
    'Chattogram':   LatLng(22.33401, 91.83010),
    // Dhaka–Sylhet
    'Shaistaganj':  LatLng(24.30250, 91.39130),
    'Sreemangal':   LatLng(24.30650, 91.73150),
    'Kulaura':      LatLng(24.49100, 91.95840),
    'Maijgaon':     LatLng(24.76470, 91.88420),
    'Sylhet':       LatLng(24.89950, 91.86980),
    // Dhaka–Rajshahi / Khulna
    'Joydebpur':    LatLng(23.99000, 90.39500),
    'Mymensingh':   LatLng(24.74700, 90.40700),
    'Jamalpur':     LatLng(24.91876, 89.95824),
    'Sirajganj':    LatLng(24.45000, 89.70000),
    'Rajshahi':     LatLng(24.37450, 88.60390),
    'Khulna':       LatLng(22.84500, 89.54000),
    'Jessore':      LatLng(23.16800, 89.21300),
    'Ishwardi':     LatLng(24.12500, 89.06500),
    'Rangpur':      LatLng(25.74500, 89.25000),
    'Dinajpur':     LatLng(25.62700, 88.63600),
  };

  // ── Named routes ─────────────────────────────────────────────────────────
  static const Map<String, TrainRoute> routes = {
    'dhaka_ctg': TrainRoute(
      id: 'dhaka_ctg',
      name: 'Dhaka → Chattogram',
      shortName: 'DHA–CTG',
      color: 0xFFE65100,
      trains: ['Subarna Express (701)', 'Turna Nishitha (741)', 'Mahanagar Provati (703)'],
      stationNames: [
        'Kamalapur', 'Tejgaon', 'Airport', 'Tongi',
        'Ghorashal', 'Narshingdi', 'Bhairab', 'Ashuganj',
        'Brahman_Baria', 'Akhaura', 'Kasba', 'Comilla',
        'Laksham', 'Feni', 'Chattogram',
      ],
    ),
    'dhaka_syl': TrainRoute(
      id: 'dhaka_syl',
      name: 'Dhaka → Sylhet',
      shortName: 'DHA–SYL',
      color: 0xFF1565C0,
      trains: ['Parabat Express (709)', 'Upaban Express (743)', 'Kalni Express (773)'],
      stationNames: [
        'Kamalapur', 'Tejgaon', 'Airport', 'Tongi',
        'Ghorashal', 'Narshingdi', 'Bhairab', 'Ashuganj',
        'Brahman_Baria', 'Akhaura', 'Shaistaganj',
        'Sreemangal', 'Kulaura', 'Maijgaon', 'Sylhet',
      ],
    ),
    'ctg_syl': TrainRoute(
      id: 'ctg_syl',
      name: 'Chattogram → Sylhet',
      shortName: 'CTG–SYL',
      color: 0xFF2E7D32,
      trains: ['Udayan Express (723)', 'Parbat Express (725)'],
      stationNames: [
        'Chattogram', 'Feni', 'Laksham', 'Comilla',
        'Akhaura', 'Shaistaganj', 'Sreemangal',
        'Kulaura', 'Sylhet',
      ],
    ),
    'dhaka_raj': TrainRoute(
      id: 'dhaka_raj',
      name: 'Dhaka → Rajshahi',
      shortName: 'DHA–RAJ',
      color: 0xFF6A1B9A,
      trains: ['Silk City Express (753)', 'Padma Express (757)'],
      stationNames: [
        'Kamalapur', 'Joydebpur', 'Mymensingh',
        'Jamalpur', 'Ishwardi', 'Rajshahi',
      ],
    ),
  };

  static List<LatLng> getRoutePoints(String routeId) {
    final route = routes[routeId];
    if (route == null) return [];
    return route.stationNames
        .map((name) => stations[name])
        .whereType<LatLng>()
        .toList();
  }

  static List<LatLng> getAllStationPoints() {
    return stations.values.toList();
  }
}

class TrainRoute {
  final String id;
  final String name;
  final String shortName;
  final int color;
  final List<String> trains;
  final List<String> stationNames;

  const TrainRoute({
    required this.id,
    required this.name,
    required this.shortName,
    required this.color,
    required this.trains,
    required this.stationNames,
  });
}

/// Simulates a train moving along a route
class TrainSimulator {
  final String routeId;
  final String trainName;
  final List<LatLng> routePoints;
  int _currentSegment = 0;
  double _progress = 0.0; // 0.0 to 1.0 within current segment
  double speedKmh = 80.0;

  TrainSimulator({
    required this.routeId,
    required this.trainName,
    required this.routePoints,
    int startSegment = 0,
  }) : _currentSegment = startSegment;

  /// Returns current interpolated position
  LatLng get currentPosition {
    if (routePoints.isEmpty) return const LatLng(23.8103, 90.4125);
    if (_currentSegment >= routePoints.length - 1) {
      return routePoints.last;
    }
    final a = routePoints[_currentSegment];
    final b = routePoints[_currentSegment + 1];
    return LatLng(
      a.latitude + (b.latitude - a.latitude) * _progress,
      a.longitude + (b.longitude - a.longitude) * _progress,
    );
  }

  /// Advance the train by [deltaSeconds] seconds
  void advance(double deltaSeconds) {
    if (_currentSegment >= routePoints.length - 1) return;

    final a = routePoints[_currentSegment];
    final b = routePoints[_currentSegment + 1];
    final segmentDistKm = _distanceKm(a, b);
    final segmentTimeSec = (segmentDistKm / speedKmh) * 3600;

    _progress += deltaSeconds / segmentTimeSec;
    if (_progress >= 1.0) {
      _progress = 0.0;
      _currentSegment++;
    }
  }

  bool get isAtDestination => _currentSegment >= routePoints.length - 1;

  String get nextStation {
    final idx = _currentSegment + 1;
    if (idx >= routePoints.length) return 'Destination';
    final route = TrainRouteData.routes[routeId];
    if (route == null || idx >= route.stationNames.length) return 'Next Station';
    return route.stationNames[idx];
  }

  String get currentStation {
    final route = TrainRouteData.routes[routeId];
    if (route == null || _currentSegment >= route.stationNames.length) return '';
    return route.stationNames[_currentSegment];
  }

  double get distanceToNextKm {
    if (_currentSegment >= routePoints.length - 1) return 0;
    final a = currentPosition;
    final b = routePoints[_currentSegment + 1];
    return _distanceKm(a, b) * (1 - _progress);
  }

  int get etaMinutes => speedKmh > 0
      ? (distanceToNextKm / speedKmh * 60).round()
      : 0;

  static double _distanceKm(LatLng a, LatLng b) {
    const r = 6371.0;
    final dlat = b.latitude - a.latitude;
    final dlon = b.longitude - a.longitude;
    return r * (dlat * dlat + dlon * dlon * 0.7) * 0.5;
  }
}
