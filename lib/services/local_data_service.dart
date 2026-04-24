// Local data service replacing MySQL backend
// All data is stored locally using SharedPreferences + in-memory mock data

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainModel {
  final String trainId;
  final String trainName;
  final String trainCode;
  final String fromStation;
  final String toStation;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final List<TicketClass> classes;
  final List<TrainStation> stations;

  TrainModel({
    required this.trainId,
    required this.trainName,
    required this.trainCode,
    required this.fromStation,
    required this.toStation,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.classes,
    this.stations = const [],
  });

  Map<String, dynamic> toJson() => {
        'trainId': trainId,
        'trainName': trainName,
        'trainCode': trainCode,
        'fromStation': fromStation,
        'toStation': toStation,
        'departureTime': departureTime,
        'arrivalTime': arrivalTime,
        'duration': duration,
        'classes': classes.map((c) => c.toJson()).toList(),
        'stations': stations.map((s) => s.toJson()).toList(),
      };
}

class TrainStation {
  final String name;
  final String? arrivalTime;
  final String? departureTime;
  final String haltTime;
  final String duration;

  const TrainStation({
    required this.name,
    this.arrivalTime,
    this.departureTime,
    required this.haltTime,
    required this.duration,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'arrivalTime': arrivalTime,
        'departureTime': departureTime,
        'haltTime': haltTime,
        'duration': duration,
      };
}

class TicketClass {
  final String type;
  final double price;
  final int availableSeats;

  TicketClass({required this.type, required this.price, required this.availableSeats});

  Map<String, dynamic> toJson() => {
        'type': type,
        'price': price,
        'availableSeats': availableSeats,
      };
}

class BookingModel {
  final String bookingId;
  final String userId;
  final String fromStation;
  final String toStation;
  final String journeyDate;
  final String travelClass;
  final String trainName;
  final String trainCode;
  final String departureTime;
  final String arrivalTime;
  final List<int> seatNumbers;
  final String coachName;
  final double totalAmount;
  final String status;
  final String bookingType;
  final String? returnBookingId;

  BookingModel({
    required this.bookingId,
    required this.userId,
    required this.fromStation,
    required this.toStation,
    required this.journeyDate,
    required this.travelClass,
    required this.trainName,
    required this.trainCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.seatNumbers,
    required this.coachName,
    required this.totalAmount,
    required this.status,
    required this.bookingType,
    this.returnBookingId,
  });

  Map<String, dynamic> toJson() => {
        'bookingId': bookingId,
        'userId': userId,
        'fromStation': fromStation,
        'toStation': toStation,
        'journeyDate': journeyDate,
        'travelClass': travelClass,
        'trainName': trainName,
        'trainCode': trainCode,
        'departureTime': departureTime,
        'arrivalTime': arrivalTime,
        'seatNumbers': seatNumbers,
        'coachName': coachName,
        'totalAmount': totalAmount,
        'status': status,
        'bookingType': bookingType,
        'returnBookingId': returnBookingId,
      };

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        bookingId: json['bookingId'],
        userId: json['userId'],
        fromStation: json['fromStation'],
        toStation: json['toStation'],
        journeyDate: json['journeyDate'],
        travelClass: json['travelClass'],
        trainName: json['trainName'],
        trainCode: json['trainCode'],
        departureTime: json['departureTime'],
        arrivalTime: json['arrivalTime'],
        seatNumbers: List<int>.from(json['seatNumbers']),
        coachName: json['coachName'],
        totalAmount: (json['totalAmount'] as num).toDouble(),
        status: json['status'],
        bookingType: json['bookingType'],
        returnBookingId: json['returnBookingId'],
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Route-wise static station lists
// ─────────────────────────────────────────────────────────────────────────────

// DHA–CTG stops
const _dhaCtgStations = [
  TrainStation(name: 'Dhaka (Kamalapur)', departureTime: null, haltTime: '0m', duration: '0h 0m'),
  TrainStation(name: 'Airport',           haltTime: '5m',  duration: '0h 20m'),
  TrainStation(name: 'Bhairab Bazar',     haltTime: '3m',  duration: '2h 10m'),
  TrainStation(name: 'Brahman Baria',     haltTime: '2m',  duration: '2h 45m'),
  TrainStation(name: 'Akhaura',           haltTime: '5m',  duration: '3h 20m'),
  TrainStation(name: 'Comilla',           haltTime: '2m',  duration: '4h 5m'),
  TrainStation(name: 'Laksham',           haltTime: '2m',  duration: '4h 30m'),
  TrainStation(name: 'Feni',              haltTime: '2m',  duration: '5h 0m'),
  TrainStation(name: 'Chattogram',        haltTime: '0m',  duration: '6h 30m'),
];

// DHA–SYL stops
const _dhaSylStations = [
  TrainStation(name: 'Dhaka (Kamalapur)', haltTime: '0m', duration: '0h 0m'),
  TrainStation(name: 'Airport',           haltTime: '5m', duration: '0h 20m'),
  TrainStation(name: 'Bhairab Bazar',     haltTime: '3m', duration: '2h 10m'),
  TrainStation(name: 'Brahman Baria',     haltTime: '2m', duration: '2h 45m'),
  TrainStation(name: 'Akhaura',           haltTime: '5m', duration: '3h 20m'),
  TrainStation(name: 'Sreemangal',        haltTime: '3m', duration: '5h 0m'),
  TrainStation(name: 'Kulaura',           haltTime: '2m', duration: '5h 45m'),
  TrainStation(name: 'Moulvibazar',       haltTime: '2m', duration: '6h 10m'),
  TrainStation(name: 'Sylhet',            haltTime: '0m', duration: '7h 0m'),
];

// CTG–SYL stops
const _ctgSylStations = [
  TrainStation(name: 'Chattogram', haltTime: '0m', duration: '0h 0m'),
  TrainStation(name: 'Feni',       haltTime: '2m', duration: '1h 30m'),
  TrainStation(name: 'Laksham',    haltTime: '2m', duration: '2h 0m'),
  TrainStation(name: 'Akhaura',    haltTime: '5m', duration: '3h 30m'),
  TrainStation(name: 'Sreemangal', haltTime: '3m', duration: '5h 0m'),
  TrainStation(name: 'Kulaura',    haltTime: '2m', duration: '5h 45m'),
  TrainStation(name: 'Sylhet',     haltTime: '0m', duration: '6h 30m'),
];

// DHA–RAJ stops
const _dhaRajStations = [
  TrainStation(name: 'Dhaka (Kamalapur)',   haltTime: '0m', duration: '0h 0m'),
  TrainStation(name: 'Airport',             haltTime: '5m', duration: '0h 20m'),
  TrainStation(name: 'Joydebpur',           haltTime: '2m', duration: '0h 50m'),
  TrainStation(name: 'Bangabandhu Bridge',  haltTime: '5m', duration: '2h 30m'),
  TrainStation(name: 'Ishwardi',            haltTime: '5m', duration: '4h 30m'),
  TrainStation(name: 'Natore',              haltTime: '2m', duration: '5h 10m'),
  TrainStation(name: 'Rajshahi',            haltTime: '0m', duration: '6h 0m'),
];

// DHA–KHL stops
const _dhaKhlStations = [
  TrainStation(name: 'Dhaka (Kamalapur)',  haltTime: '0m', duration: '0h 0m'),
  TrainStation(name: 'Airport',            haltTime: '5m', duration: '0h 20m'),
  TrainStation(name: 'Joydebpur',          haltTime: '2m', duration: '0h 50m'),
  TrainStation(name: 'Poradah',            haltTime: '3m', duration: '3h 30m'),
  TrainStation(name: 'Kushtia',            haltTime: '3m', duration: '4h 20m'),
  TrainStation(name: 'Jessore',            haltTime: '5m', duration: '6h 0m'),
  TrainStation(name: 'Khulna',             haltTime: '0m', duration: '7h 30m'),
];

// DHA–RNG stops
const _dhaRngStations = [
  TrainStation(name: 'Dhaka (Kamalapur)',  haltTime: '0m', duration: '0h 0m'),
  TrainStation(name: 'Airport',            haltTime: '5m', duration: '0h 20m'),
  TrainStation(name: 'Joydebpur',          haltTime: '2m', duration: '0h 50m'),
  TrainStation(name: 'Bangabandhu Bridge', haltTime: '5m', duration: '2h 30m'),
  TrainStation(name: 'Bogura',             haltTime: '5m', duration: '4h 30m'),
  TrainStation(name: 'Gaibandha',          haltTime: '3m', duration: '5h 30m'),
  TrainStation(name: 'Rangpur',            haltTime: '0m', duration: '6h 30m'),
];

// DHA–DNJ stops
const _dhaDnjStations = [
  TrainStation(name: 'Dhaka (Kamalapur)',  haltTime: '0m', duration: '0h 0m'),
  TrainStation(name: 'Airport',            haltTime: '5m', duration: '0h 20m'),
  TrainStation(name: 'Joydebpur',          haltTime: '2m', duration: '0h 50m'),
  TrainStation(name: 'Bangabandhu Bridge', haltTime: '5m', duration: '2h 30m'),
  TrainStation(name: 'Parbatipur',         haltTime: '5m', duration: '5h 30m'),
  TrainStation(name: 'Dinajpur',           haltTime: '0m', duration: '6h 30m'),
];

// ─────────────────────────────────────────────────────────────────────────────
// Route key helper
// ─────────────────────────────────────────────────────────────────────────────
String _routeKey(String from, String to) {
  final f = from.toLowerCase();
  final t = to.toLowerCase();
  bool isDhaka(String s) => s.contains('dhaka') || s.contains('kamalapur');
  bool isCtg(String s) => s.contains('chattogram') || s.contains('chittagong');
  bool isSyl(String s) => s.contains('sylhet');
  bool isRaj(String s) => s.contains('rajshahi');
  bool isKhl(String s) => s.contains('khulna');
  bool isRng(String s) => s.contains('rangpur');
  bool isDnj(String s) => s.contains('dinajpur');

  if (isDhaka(f) && isCtg(t)) return 'dha_ctg';
  if (isCtg(f) && isDhaka(t)) return 'ctg_dha';
  if (isDhaka(f) && isSyl(t)) return 'dha_syl';
  if (isSyl(f) && isDhaka(t)) return 'syl_dha';
  if (isCtg(f) && isSyl(t))   return 'ctg_syl';
  if (isSyl(f) && isCtg(t))   return 'syl_ctg';
  if (isDhaka(f) && isRaj(t)) return 'dha_raj';
  if (isRaj(f) && isDhaka(t)) return 'raj_dha';
  if (isDhaka(f) && isKhl(t)) return 'dha_khl';
  if (isKhl(f) && isDhaka(t)) return 'khl_dha';
  if (isDhaka(f) && isRng(t)) return 'dha_rng';
  if (isRng(f) && isDhaka(t)) return 'rng_dha';
  if (isDhaka(f) && isDnj(t)) return 'dha_dnj';
  if (isDnj(f) && isDhaka(t)) return 'dnj_dha';
  return 'other';
}

class LocalDataService {
  static final LocalDataService _instance = LocalDataService._internal();
  factory LocalDataService() => _instance;
  LocalDataService._internal();

  static const List<String> stations = [
    // Dhaka Division
    'Dhaka (Kamalapur)', 'Tejgaon', 'Airport', 'Tongi', 'Joydebpur',
    'Narshingdi', 'Ghorashal', 'Bhairab Bazar', 'Kishoreganj',
    'Mymensingh', 'Jamalpur', 'Dewanganj', 'Bahadurabad Ghat',
    'Munshiganj', 'Narayanganj',
    // Chattogram Division
    'Chattogram', 'Feni', 'Laksham', 'Comilla', 'Brahman Baria',
    'Akhaura', 'Kasba', 'Chandpur', 'Noakhali', 'Lakshmipur',
    'Coxs Bazar',
    // Sylhet Division
    'Sylhet', 'Sreemangal', 'Kulaura', 'Shaistaganj', 'Habiganj',
    'Moulvibazar',
    // Rajshahi Division
    'Rajshahi', 'Ishwardi', 'Natore', 'Sirajganj', 'Pabna',
    'Naogaon', 'Chapai Nawabganj',
    // Khulna Division
    'Khulna', 'Jessore', 'Benapole', 'Chuadanga', 'Meherpur',
    'Kushtia', 'Magura', 'Narail', 'Satkhira',
    // Rangpur Division
    'Rangpur', 'Dinajpur', 'Bogura', 'Gaibandha', 'Lalmonirhat',
    'Nilphamari', 'Panchagarh', 'Thakurgaon', 'Saidpur',
    // Barisal Division
    'Barisal', 'Bhola', 'Pirojpur',
    // Mymensingh Division
    'Netrokona', 'Sherpur',
    // Other major junctions
    'Ashuganj', 'Akkelpur', 'Santahar', 'Parbatipur',
    'Chilahati', 'Darsana', 'Poradah',
  ];

  static const List<String> travelClasses = ['AC', 'Snigdha', 'S_Chair', 'Shulov'];

  Future<List<TrainModel>> getTrainsAsync(String from, String to) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      final snap = await db.child('trains').get();
      if (snap.exists && snap.value != null) {
        final raw = Map<String, dynamic>.from(snap.value as Map);
        final all = raw.entries.map((e) {
          final m = Map<String, dynamic>.from(e.value as Map);
          return TrainModel(
            trainId: e.key,
            trainName: m['trainName'] ?? '',
            trainCode: m['trainCode'] ?? '',
            fromStation: m['fromStation'] ?? from,
            toStation: m['toStation'] ?? to,
            departureTime: m['departureTime'] ?? '',
            arrivalTime: m['arrivalTime'] ?? '',
            duration: m['duration'] ?? '',
            classes: [
              TicketClass(
                type: m['classType'] ?? 'AC',
                price: (m['price'] as num?)?.toDouble() ?? 0,
                availableSeats: (m['availableSeats'] as num?)?.toInt() ?? 40,
              ),
            ],
          );
        }).where((t) =>
            t.fromStation.toLowerCase() == from.toLowerCase() &&
            t.toStation.toLowerCase() == to.toLowerCase()).toList();
        if (all.isNotEmpty) return all;
      }
    } catch (_) {}
    return _mockTrains(from, to);
  }

  List<TrainModel> getTrains(String from, String to) => _mockTrains(from, to);

  List<TrainModel> _mockTrains(String from, String to) {
    final key = _routeKey(from, to);
    switch (key) {
      case 'dha_ctg':
      case 'ctg_dha':
        return _buildDhaCtg(from, to);
      case 'dha_syl':
      case 'syl_dha':
        return _buildDhaSyl(from, to);
      case 'ctg_syl':
      case 'syl_ctg':
        return _buildCtgSyl(from, to);
      case 'dha_raj':
      case 'raj_dha':
        return _buildDhaRaj(from, to);
      case 'dha_khl':
      case 'khl_dha':
        return _buildDhaKhl(from, to);
      case 'dha_rng':
      case 'rng_dha':
        return _buildDhaRng(from, to);
      case 'dha_dnj':
      case 'dnj_dha':
        return _buildDhaDnj(from, to);
      default:
        return _buildGeneric(from, to);
    }
  }

  // ── DHA ↔ CTG  (4 trains) ────────────────────────────────────────────────
  List<TrainModel> _buildDhaCtg(String from, String to) {
    final stns = _maybeReverse(_dhaCtgStations, from, to);
    return [
      _train('TR_CTG_01', 'Subarna Express',      '701', from, to, '07:00 AM', '01:30 PM', '6h 30m',
          [_cls('AC', 1200, 12), _cls('Snigdha', 900, 20), _cls('S_Chair', 450, 35)], stns),
      _train('TR_CTG_02', 'Sonar Bangla Express',  '787', from, to, '06:20 AM', '12:00 PM', '5h 40m',
          [_cls('AC', 1300, 6),  _cls('Snigdha', 950, 22)], stns),
      _train('TR_CTG_03', 'Mahanagar Provati',     '703', from, to, '07:45 AM', '02:15 PM', '6h 30m',
          [_cls('Snigdha', 880, 18), _cls('S_Chair', 430, 50), _cls('Shulov', 280, 60)], stns),
      _train('TR_CTG_04', 'Turna Nishitha',        '741', from, to, '11:30 PM', '05:45 AM', '6h 15m',
          [_cls('AC', 1100, 8),  _cls('Snigdha', 850, 15), _cls('S_Chair', 400, 40)], stns),
    ];
  }

  // ── DHA ↔ SYL  (4 trains) ────────────────────────────────────────────────
  List<TrainModel> _buildDhaSyl(String from, String to) {
    final stns = _maybeReverse(_dhaSylStations, from, to);
    return [
      _train('TR_SYL_01', 'Parabat Express',   '709', from, to, '06:40 AM', '01:40 PM', '7h 0m',
          [_cls('Snigdha', 420, 20), _cls('S_Chair', 215, 50), _cls('Shulov', 145, 60)], stns),
      _train('TR_SYL_02', 'Jayantika Express', '775', from, to, '12:00 PM', '07:00 PM', '7h 0m',
          [_cls('Snigdha', 420, 18), _cls('S_Chair', 215, 45), _cls('Shulov', 145, 55)], stns),
      _train('TR_SYL_03', 'Upaban Express',    '743', from, to, '09:50 PM', '04:50 AM', '7h 0m',
          [_cls('AC', 820, 10), _cls('Snigdha', 420, 20), _cls('S_Chair', 215, 40)], stns),
      _train('TR_SYL_04', 'Kalni Express',     '773', from, to, '03:15 PM', '10:15 PM', '7h 0m',
          [_cls('S_Chair', 215, 50), _cls('Shulov', 145, 70)], stns),
    ];
  }

  // ── CTG ↔ SYL  (2 trains) ────────────────────────────────────────────────
  List<TrainModel> _buildCtgSyl(String from, String to) {
    final stns = _maybeReverse(_ctgSylStations, from, to);
    return [
      _train('TR_CS_01', 'Paharika Express', '725', from, to, '07:00 AM', '01:30 PM', '6h 30m',
          [_cls('Snigdha', 380, 18), _cls('S_Chair', 195, 45), _cls('Shulov', 130, 55)], stns),
      _train('TR_CS_02', 'Udayan Express',   '723', from, to, '09:30 PM', '04:00 AM', '6h 30m',
          [_cls('AC', 750, 8), _cls('Snigdha', 380, 20), _cls('S_Chair', 195, 40)], stns),
    ];
  }

  // ── DHA ↔ RAJ  (3 trains) ────────────────────────────────────────────────
  List<TrainModel> _buildDhaRaj(String from, String to) {
    final stns = _maybeReverse(_dhaRajStations, from, to);
    return [
      _train('TR_RAJ_01', 'Silk City Express',  '753', from, to, '02:40 PM', '08:40 PM', '6h 0m',
          [_cls('AC', 1050, 10), _cls('Snigdha', 680, 20), _cls('S_Chair', 340, 40)], stns),
      _train('TR_RAJ_02', 'Padma Express',      '757', from, to, '11:00 PM', '05:00 AM', '6h 0m',
          [_cls('AC', 1050, 8),  _cls('Snigdha', 680, 18), _cls('S_Chair', 340, 45)], stns),
      _train('TR_RAJ_03', 'Dhumketu Express',   '759', from, to, '06:00 AM', '12:00 PM', '6h 0m',
          [_cls('Snigdha', 680, 22), _cls('S_Chair', 340, 50), _cls('Shulov', 220, 60)], stns),
    ];
  }

  // ── DHA ↔ KHL  (2 trains) ────────────────────────────────────────────────
  List<TrainModel> _buildDhaKhl(String from, String to) {
    final stns = _maybeReverse(_dhaKhlStations, from, to);
    return [
      _train('TR_KHL_01', 'Sundarban Express', '725', from, to, '06:20 AM', '01:50 PM', '7h 30m',
          [_cls('AC', 1150, 10), _cls('Snigdha', 750, 20), _cls('S_Chair', 375, 40)], stns),
      _train('TR_KHL_02', 'Chitra Express',    '763', from, to, '08:40 PM', '04:10 AM', '7h 30m',
          [_cls('AC', 1150, 8),  _cls('Snigdha', 750, 18), _cls('S_Chair', 375, 45)], stns),
    ];
  }

  // ── DHA ↔ RNG  (2 trains) ────────────────────────────────────────────────
  List<TrainModel> _buildDhaRng(String from, String to) {
    final stns = _maybeReverse(_dhaRngStations, from, to);
    return [
      _train('TR_RNG_01', 'Rangpur Express',   '771', from, to, '09:00 AM', '03:30 PM', '6h 30m',
          [_cls('Snigdha', 600, 20), _cls('S_Chair', 300, 50), _cls('Shulov', 200, 60)], stns),
      _train('TR_RNG_02', 'Kurigram Express',  '797', from, to, '10:30 PM', '05:00 AM', '6h 30m',
          [_cls('AC', 1000, 8), _cls('Snigdha', 600, 18), _cls('S_Chair', 300, 45)], stns),
    ];
  }

  // ── DHA ↔ DNJ  (2 trains) ────────────────────────────────────────────────
  List<TrainModel> _buildDhaDnj(String from, String to) {
    final stns = _maybeReverse(_dhaDnjStations, from, to);
    return [
      _train('TR_DNJ_01', 'Ekota Express',    '705', from, to, '10:00 PM', '04:30 AM', '6h 30m',
          [_cls('AC', 1050, 10), _cls('Snigdha', 680, 20), _cls('S_Chair', 340, 45)], stns),
      _train('TR_DNJ_02', 'Drutojan Express', '757', from, to, '08:00 AM', '02:30 PM', '6h 30m',
          [_cls('Snigdha', 680, 22), _cls('S_Chair', 340, 50), _cls('Shulov', 220, 60)], stns),
    ];
  }

  // ── Generic fallback (unknown route) ─────────────────────────────────────
  List<TrainModel> _buildGeneric(String from, String to) {
    return [
      _train('TR_GEN_01', 'Intercity Express', '001', from, to, '07:00 AM', '01:00 PM', '6h 0m',
          [_cls('AC', 900, 10), _cls('Snigdha', 600, 20), _cls('S_Chair', 300, 40)], const []),
    ];
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  TrainModel _train(
    String id, String name, String code,
    String from, String to,
    String dep, String arr, String dur,
    List<TicketClass> classes,
    List<TrainStation> stns,
  ) =>
      TrainModel(
        trainId: id, trainName: name, trainCode: code,
        fromStation: from, toStation: to,
        departureTime: dep, arrivalTime: arr, duration: dur,
        classes: classes, stations: stns,
      );

  TicketClass _cls(String type, double price, int seats) =>
      TicketClass(type: type, price: price, availableSeats: seats);

  /// Reverses station list when travelling in opposite direction
  List<TrainStation> _maybeReverse(List<TrainStation> stns, String from, String to) {
    final key = _routeKey(from, to);
    final reversed = key.endsWith('_dha') || key == 'ctg_syl' ||
        key == 'syl_ctg' || key == 'raj_dha' || key == 'khl_dha' ||
        key == 'rng_dha' || key == 'dnj_dha';
    return reversed ? stns.reversed.toList() : List.from(stns);
  }

  // Save booking to SharedPreferences
  Future<String> saveBooking(BookingModel booking) async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getStringList('bookings') ?? [];
    bookingsJson.add(jsonEncode(booking.toJson()));
    await prefs.setStringList('bookings', bookingsJson);
    return booking.bookingId;
  }

  Future<List<BookingModel>> getUserBookings(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getStringList('bookings') ?? [];
    return bookingsJson
        .map((j) => BookingModel.fromJson(jsonDecode(j)))
        .where((b) => b.userId == userId)
        .toList();
  }

  static const int _sessionExpiryDays = 30;

  Future<void> saveUserSession(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionData = {
      ...user,
      'sessionExpiry': DateTime.now()
          .add(const Duration(days: _sessionExpiryDays))
          .toIso8601String(),
    };
    await prefs.setString('current_user', jsonEncode(sessionData));
  }

  Future<Map<String, dynamic>?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    if (userJson == null) return null;
    final data = jsonDecode(userJson) as Map<String, dynamic>;
    final expiryStr = data['sessionExpiry'] as String?;
    if (expiryStr != null) {
      final expiry = DateTime.tryParse(expiryStr);
      if (expiry != null && DateTime.now().isAfter(expiry)) {
        await clearSession();
        return null;
      }
    }
    return data;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }

  String _hashPassword(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  Future<Map<String, dynamic>> register(
      String name, String email, String phone, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList('users') ?? [];
    final users = usersJson.map((j) => jsonDecode(j) as Map<String, dynamic>).toList();
    if (users.any((u) => u['email'] == email)) {
      return {'success': false, 'message': 'Email already registered'};
    }
    final user = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name, 'email': email, 'phone': phone,
      'password': _hashPassword(password),
    };
    usersJson.add(jsonEncode(user));
    await prefs.setStringList('users', usersJson);
    await saveUserSession(user);
    return {'success': true, 'user': user};
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final lockKey = 'login_lock_${email.toLowerCase()}';
    final attemptsKey = 'login_attempts_${email.toLowerCase()}';
    final lockUntilStr = prefs.getString(lockKey);
    if (lockUntilStr != null) {
      final lockUntil = DateTime.tryParse(lockUntilStr);
      if (lockUntil != null && DateTime.now().isBefore(lockUntil)) {
        final remaining = lockUntil.difference(DateTime.now()).inMinutes + 1;
        return {'success': false, 'message': 'Too many attempts. Try again in $remaining minute(s).'};
      } else {
        await prefs.remove(lockKey);
        await prefs.remove(attemptsKey);
      }
    }
    final usersJson = prefs.getStringList('users') ?? [];
    final users = usersJson.map((j) => jsonDecode(j) as Map<String, dynamic>).toList();
    final user = users.firstWhereOrNull(
        (u) => u['email'] == email && u['password'] == _hashPassword(password));
    if (user == null) {
      final attempts = (prefs.getInt(attemptsKey) ?? 0) + 1;
      await prefs.setInt(attemptsKey, attempts);
      if (attempts >= 5) {
        final lockUntil = DateTime.now().add(const Duration(minutes: 15));
        await prefs.setString(lockKey, lockUntil.toIso8601String());
        return {'success': false, 'message': 'Too many failed attempts. Account locked for 15 minutes.'};
      }
      return {'success': false, 'message': 'Invalid email or password. ${5 - attempts} attempt(s) remaining.'};
    }
    await prefs.remove(attemptsKey);
    await prefs.remove(lockKey);
    await saveUserSession(user);
    return {'success': true, 'user': user};
  }
}

extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
