// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ApiService {
//   final String baseUrl = "http://192.168.68.103:3000";

//   Future<bool> addBooking({
//     required String name,
//     required String fromStation,
//     required String toStation,
//     required String travelClass,
//     required String date,
//     required String departTime,
//     required String seat,
//     required double totalAmount,
//     required String trainCode,
//   }) async {
//     Map<String, String> requestHeaders = {
//       "Content-Type": "application/json",
//     };
//     Map<String, dynamic> requestBody = {
//       "name": name,
//       "from_station": fromStation,
//       "to_station": toStation,
//       "travel_class": travelClass,
//       "date": date,
//       "depart_time": departTime,
//       "seat": seat,
//       "total_amount": totalAmount,
//       "train_code": trainCode,
//     };
//     var response = await http.post(Uri.parse("$baseUrl/ticket"),
//         headers: requestHeaders, body: jsonEncode(requestBody));

//     if (response.statusCode == 200) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<List<dynamic>> getAllBookings() async {
//     var response = await http.get(Uri.parse("$baseUrl/tickets"));

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load bookings');
//     }
//   }

//   Future<Map<String, dynamic>> getBookingById(int bookingId) async {
//     var response = await http.get(Uri.parse("$baseUrl/ticket/$bookingId"));

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load booking');
//     }
//   }

//   Future<bool> updateBooking({
//     required int id,
//     required String name,
//     required String fromStation,
//     required String toStation,
//     required String travelClass,
//     required String date,
//     required String departTime,
//     required String seat,
//     required double totalAmount,
//     required String trainCode,
//   }) async {
//     Map<String, String> requestHeaders = {
//       "Content-Type": "application/json",
//     };
//     Map<String, dynamic> requestBody = {
//       "name": name,
//       "from_station": fromStation,
//       "to_station": toStation,
//       "travel_class": travelClass,
//       "date": date,
//       "depart_time": departTime,
//       "seat": seat,
//       "total_amount": totalAmount,
//       "train_code": trainCode,
//     };
//     var response = await http.put(Uri.parse("$baseUrl/ticket/$id"),
//         headers: requestHeaders, body: jsonEncode(requestBody));

//     if (response.statusCode == 200) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> deleteBooking(int bookingId) async {
//     var response = await http.delete(Uri.parse("$baseUrl/ticket/$bookingId"));

//     if (response.statusCode == 200) {
//       return true;
//     } else {
//       return false;
//     }
//   }
// }
//
// class SocketService {
//   late IO.Socket socket;
//
//   void connect() {
//     socket = IO.io('http://192.168.68.103:3000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });
//
//     socket.connect();
//
//     socket.on('connect', (_) {
//       print('Connected to socket server');
//     });
//
//     socket.on('locationUpdate', (data) {
//       print('Location update: $data');
//     });
//
//     socket.on('disconnect', (_) {
//       print('Disconnected from socket server');
//     });
//   }
//
//   void join(String userId) {
//     socket.emit('join', userId);
//   }
//
//   void sendLocationUpdate(String userId, String location) {
//     socket.emit('locationUpdate', {'userId': userId, 'location': location});
//   }
//
//   void disconnect() {
//     socket.disconnect();
//   }
// }
