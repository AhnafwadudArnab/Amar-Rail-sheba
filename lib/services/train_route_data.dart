import 'package:google_maps_flutter/google_maps_flutter.dart';

/// All Bangladesh Railway routes with real station coordinates
class TrainRouteData {
  // ── Station coordinates ──────────────────────────────────────────────────
  static const Map<String, LatLng> stations = {
    // Dhaka area
    'Dhaka (Kamalapur)': LatLng(23.73527, 90.42592),
    'Tejgaon':           LatLng(23.76034, 90.39483),
    'Airport':           LatLng(23.85209, 90.40803),
    'Tongi':             LatLng(23.89875, 90.40843),
    'Joydebpur':         LatLng(23.99000, 90.39500),
    'Narayanganj':       LatLng(23.62300, 90.49900),
    'Munshiganj':        LatLng(23.54200, 90.52900),
    // Dhaka–Chattogram corridor
    'Narshingdi':        LatLng(23.93211, 90.72142),
    'Ghorashal':         LatLng(23.94088, 90.61988),
    'Bhairab Bazar':     LatLng(24.05003, 90.97776),
    'Ashuganj':          LatLng(24.03840, 91.00148),
    'Brahman Baria':     LatLng(23.96698, 91.10850),
    'Akhaura':           LatLng(23.88204, 91.20376),
    'Kasba':             LatLng(23.74557, 91.14804),
    'Comilla':           LatLng(23.46371, 91.16677),
    'Laksham':           LatLng(23.25497, 91.12400),
    'Feni':              LatLng(23.01374, 91.40198),
    'Chattogram':        LatLng(22.33401, 91.83010),
    'Chandpur':          LatLng(23.23200, 90.65200),
    'Noakhali':          LatLng(22.86900, 91.09900),
    'Lakshmipur':        LatLng(22.94200, 90.84100),
    'Coxs Bazar':        LatLng(21.44500, 91.97800),
    'Kishoreganj':       LatLng(24.44400, 90.77600),
    // Dhaka–Sylhet corridor
    'Shaistaganj':       LatLng(24.30250, 91.39130),
    'Sreemangal':        LatLng(24.30650, 91.73150),
    'Kulaura':           LatLng(24.49100, 91.95840),
    'Moulvibazar':       LatLng(24.48200, 91.77800),
    'Habiganj':          LatLng(24.37400, 91.41500),
    'Sylhet':            LatLng(24.89950, 91.86980),
    // Dhaka–Mymensingh–Jamalpur
    'Mymensingh':        LatLng(24.74700, 90.40700),
    'Jamalpur':          LatLng(24.91876, 89.95824),
    'Dewanganj':         LatLng(25.04200, 89.76700),
    'Bahadurabad Ghat':  LatLng(25.10000, 89.80000),
    'Netrokona':         LatLng(24.87000, 90.72700),
    'Sherpur':           LatLng(25.01900, 90.01600),
    // Dhaka–Rajshahi / Khulna corridor
    'Ishwardi':          LatLng(24.12500, 89.06500),
    'Sirajganj':         LatLng(24.45000, 89.70000),
    'Pabna':             LatLng(24.00600, 89.24500),
    'Natore':            LatLng(24.41600, 88.98700),
    'Rajshahi':          LatLng(24.37450, 88.60390),
    'Naogaon':           LatLng(24.91300, 88.75100),
    'Chapai Nawabganj':  LatLng(24.59600, 88.27600),
    // Khulna corridor
    'Khulna':            LatLng(22.84500, 89.54000),
    'Jessore':           LatLng(23.16800, 89.21300),
    'Benapole':          LatLng(23.02200, 88.93200),
    'Chuadanga':         LatLng(23.64000, 88.84200),
    'Meherpur':          LatLng(23.76200, 88.63200),
    'Kushtia':           LatLng(23.90100, 89.12000),
    'Magura':            LatLng(23.48700, 89.41900),
    'Narail':            LatLng(23.17200, 89.51200),
    'Satkhira':          LatLng(22.71800, 89.07200),
    // Rangpur / North Bengal
    'Rangpur':           LatLng(25.74500, 89.25000),
    'Dinajpur':          LatLng(25.62700, 88.63600),
    'Bogura':            LatLng(24.85100, 89.37200),
    'Gaibandha':         LatLng(25.32900, 89.52800),
    'Lalmonirhat':       LatLng(25.92200, 89.44900),
    'Nilphamari':        LatLng(25.93100, 88.85600),
    'Panchagarh':        LatLng(26.34100, 88.55500),
    'Thakurgaon':        LatLng(26.03400, 88.45800),
    'Saidpur':           LatLng(25.77600, 88.89800),
    // Junctions
    'Santahar':          LatLng(24.75700, 89.03700),
    'Parbatipur':        LatLng(25.65100, 88.91200),
    'Chilahati':         LatLng(26.00000, 88.93000),
    'Darsana':           LatLng(23.53200, 88.72700),
    'Poradah':           LatLng(23.74200, 88.87200),
    'Akkelpur':          LatLng(24.90700, 89.04200),
  };

  // ── Named routes ─────────────────────────────────────────────────────────
  static const Map<String, TrainRoute> routes = {
    'dhaka_ctg': TrainRoute(
      id: 'dhaka_ctg',
      name: 'Dhaka → Chattogram',
      shortName: 'DHA–CTG',
      color: 0xFFE65100,
      trains: ['Subarna Express (701)', 'Turna Nishitha (741)', 'Mahanagar Provati (703)', 'Sonar Bangla Express (787)'],
      stationNames: [
        'Dhaka (Kamalapur)', 'Tejgaon', 'Airport', 'Tongi',
        'Ghorashal', 'Narshingdi', 'Bhairab Bazar', 'Ashuganj',
        'Brahman Baria', 'Akhaura', 'Kasba', 'Comilla',
        'Laksham', 'Feni', 'Chattogram',
      ],
    ),
    'dhaka_syl': TrainRoute(
      id: 'dhaka_syl',
      name: 'Dhaka → Sylhet',
      shortName: 'DHA–SYL',
      color: 0xFF1565C0,
      trains: ['Parabat Express (709)', 'Upaban Express (743)', 'Kalni Express (773)', 'Jayantika Express (775)'],
      stationNames: [
        'Dhaka (Kamalapur)', 'Tejgaon', 'Airport', 'Tongi',
        'Ghorashal', 'Narshingdi', 'Bhairab Bazar', 'Ashuganj',
        'Brahman Baria', 'Akhaura', 'Shaistaganj',
        'Sreemangal', 'Kulaura', 'Sylhet',
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
      trains: ['Silk City Express (753)', 'Padma Express (757)', 'Dhaka Mail (1)'],
      stationNames: [
        'Dhaka (Kamalapur)', 'Joydebpur', 'Mymensingh',
        'Jamalpur', 'Santahar', 'Natore', 'Ishwardi', 'Rajshahi',
      ],
    ),
    'dhaka_khulna': TrainRoute(
      id: 'dhaka_khulna',
      name: 'Dhaka → Khulna',
      shortName: 'DHA–KHL',
      color: 0xFF00838F,
      trains: ['Sundarban Express (725)', 'Chitra Express (763)'],
      stationNames: [
        'Dhaka (Kamalapur)', 'Joydebpur', 'Ishwardi',
        'Poradah', 'Jessore', 'Khulna',
      ],
    ),
    'dhaka_rangpur': TrainRoute(
      id: 'dhaka_rangpur',
      name: 'Dhaka → Rangpur',
      shortName: 'DHA–RNG',
      color: 0xFFAD1457,
      trains: ['Rangpur Express (771)', 'Lalmoni Express (751)'],
      stationNames: [
        'Dhaka (Kamalapur)', 'Joydebpur', 'Mymensingh',
        'Jamalpur', 'Bogura', 'Gaibandha', 'Rangpur',
      ],
    ),
    'dhaka_dinajpur': TrainRoute(
      id: 'dhaka_dinajpur',
      name: 'Dhaka → Dinajpur',
      shortName: 'DHA–DNJ',
      color: 0xFF4E342E,
      trains: ['Drutojan Express (757)', 'Ekota Express (705)'],
      stationNames: [
        'Dhaka (Kamalapur)', 'Joydebpur', 'Mymensingh',
        'Jamalpur', 'Bogura', 'Santahar', 'Parbatipur', 'Dinajpur',
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
  double _progress = 0.0;
  double speedKmh = 80.0;

  TrainSimulator({
    required this.routeId,
    required this.trainName,
    required this.routePoints,
    int startSegment = 0,
  }) : _currentSegment = startSegment;

  LatLng get currentPosition {
    if (routePoints.isEmpty) return const LatLng(23.8103, 90.4125);
    if (_currentSegment >= routePoints.length - 1) return routePoints.last;
    final a = routePoints[_currentSegment];
    final b = routePoints[_currentSegment + 1];
    return LatLng(
      a.latitude + (b.latitude - a.latitude) * _progress,
      a.longitude + (b.longitude - a.longitude) * _progress,
    );
  }

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

  int get etaMinutes =>
      speedKmh > 0 ? (distanceToNextKm / speedKmh * 60).round() : 0;

  static double _distanceKm(LatLng a, LatLng b) {
    const r = 6371.0;
    final dlat = b.latitude - a.latitude;
    final dlon = b.longitude - a.longitude;
    return r * (dlat * dlat + dlon * dlon * 0.7) * 0.5;
  }
}
