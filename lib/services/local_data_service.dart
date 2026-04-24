// Local data service replacing MySQL backend
// All data is stored locally using SharedPreferences + in-memory mock data

import 'dart:convert';
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
  final String bookingType; // 'one_way' or 'round_trip'
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

  // Mock train data
  List<TrainModel> getTrains(String from, String to) {
    final mockTrains = [
      TrainModel(
        trainId: 'TR001',
        trainName: 'Subarna Express',
        trainCode: '701',
        fromStation: from,
        toStation: to,
        departureTime: '07:00 AM',
        arrivalTime: '01:30 PM',
        duration: '6h 30m',
        classes: [
          TicketClass(type: 'AC', price: 1200, availableSeats: 12),
          TicketClass(type: 'Snigdha', price: 900, availableSeats: 20),
          TicketClass(type: 'S_Chair', price: 450, availableSeats: 35),
        ],
      ),
      TrainModel(
        trainId: 'TR002',
        trainName: 'Turna Nishitha',
        trainCode: '741',
        fromStation: from,
        toStation: to,
        departureTime: '11:30 PM',
        arrivalTime: '05:45 AM',
        duration: '6h 15m',
        classes: [
          TicketClass(type: 'AC', price: 1100, availableSeats: 8),
          TicketClass(type: 'Snigdha', price: 850, availableSeats: 15),
          TicketClass(type: 'S_Chair', price: 400, availableSeats: 40),
        ],
      ),
      TrainModel(
        trainId: 'TR003',
        trainName: 'Mahanagar Provati',
        trainCode: '703',
        fromStation: from,
        toStation: to,
        departureTime: '07:45 AM',
        arrivalTime: '02:15 PM',
        duration: '6h 30m',
        classes: [
          TicketClass(type: 'Snigdha', price: 880, availableSeats: 18),
          TicketClass(type: 'S_Chair', price: 430, availableSeats: 50),
          TicketClass(type: 'Shulov', price: 280, availableSeats: 60),
        ],
      ),
      TrainModel(
        trainId: 'TR004',
        trainName: 'Sonar Bangla Express',
        trainCode: '787',
        fromStation: from,
        toStation: to,
        departureTime: '06:20 AM',
        arrivalTime: '12:00 PM',
        duration: '5h 40m',
        classes: [
          TicketClass(type: 'AC', price: 1300, availableSeats: 6),
          TicketClass(type: 'Snigdha', price: 950, availableSeats: 22),
        ],
      ),
    ];
    return mockTrains;
  }

  // Save booking to SharedPreferences
  Future<String> saveBooking(BookingModel booking) async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getStringList('bookings') ?? [];
    bookingsJson.add(jsonEncode(booking.toJson()));
    await prefs.setStringList('bookings', bookingsJson);
    return booking.bookingId;
  }

  // Get all bookings for a user
  Future<List<BookingModel>> getUserBookings(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getStringList('bookings') ?? [];
    return bookingsJson
        .map((j) => BookingModel.fromJson(jsonDecode(j)))
        .where((b) => b.userId == userId)
        .toList();
  }

  // Session expiry duration — 30 days
  static const int _sessionExpiryDays = 30;

  // Save user session with expiry timestamp
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

  /// Returns the session if valid, null if missing or expired.
  Future<Map<String, dynamic>?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    if (userJson == null) return null;
    final data = jsonDecode(userJson) as Map<String, dynamic>;
    final expiryStr = data['sessionExpiry'] as String?;
    if (expiryStr != null) {
      final expiry = DateTime.tryParse(expiryStr);
      if (expiry != null && DateTime.now().isAfter(expiry)) {
        await clearSession(); // expired — force re-login
        return null;
      }
    }
    return data;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }

  // Simple local auth (stores users in SharedPreferences)
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
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
    usersJson.add(jsonEncode(user));
    await prefs.setStringList('users', usersJson);
    await saveUserSession(user);
    return {'success': true, 'user': user};
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList('users') ?? [];
    final users = usersJson.map((j) => jsonDecode(j) as Map<String, dynamic>).toList();

    final user = users.firstWhereOrNull(
        (u) => u['email'] == email && u['password'] == password);

    if (user == null) {
      return {'success': false, 'message': 'Invalid email or password'};
    }
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
