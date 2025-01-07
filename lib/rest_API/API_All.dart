import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trackers/rest_API/API_utils.dart';
Future userLogin(String name, String email, String password) async {
  final response = await http.post(
    Uri.parse(Utils.LOGIN),
    headers: {'Accept': 'application/json'},
    body: {
      'name': name,
      'email': email,
      'password': password,
    },
  );

  var decodeData = jsonDecode(response.body);
  return decodeData;
}

Future userLogout(String token) async {
  final response = await http.post(
    Uri.parse('${Utils.baseURL}/user/logout'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  var decodeData = jsonDecode(response.body);
  return decodeData;
}

Future fetchTrainDataByPost({String? trainId}) async {
  final response = await http.post(
    Uri.parse('${Utils.baseURL}/train.js'),
    headers: {'Accept': 'application/json'},
    body: trainId != null ? {'train_id': trainId} : {},
  );

  var decodeData = jsonDecode(response.body);
  return decodeData;
}


Future bookFirstPageV2({
  required String userFrom,
  required String userTo,
  required String userClass,
  required String userDate,
}) async {
  final response = await http.post(
    Uri.parse('${Utils.baseURL}/firstpage.js'),
    headers: {'Accept': 'application/json'},
    body: {
      'user_from': userFrom,
      'user_to': userTo,
      'user_class': userClass,
      'user_date': userDate,
    },
  );

  var decodeData = jsonDecode(response.body);
  return decodeData;
}


Future makePayment({
  required String ticketId,
  required String paymentId,
  required String paymentDate,
  required String paymentStatus,
  required String totalAmount,
  required String paymentType,
}) async {
  final response = await http.post(
    Uri.parse('${Utils.baseURL}/payments'),
    headers: {'Accept': 'application/json'},
    body: {
      'ticket_id': ticketId,
      'payment_id': paymentId,
      'payment_date': paymentDate,
      'payment_status': paymentStatus,
      'total_amount': totalAmount,
      'payment_type': paymentType,
    },
  );

  var decodeData = jsonDecode(response.body);
  return decodeData;
}

