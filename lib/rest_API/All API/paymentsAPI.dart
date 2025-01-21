import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> main() async {
  final app = const Pipeline().addMiddleware(logRequests()).addHandler(_router);
  const port = 3000;

  if (kDebugMode) {
    print('Server running on http://localhost:$port');
  }
  await shelf_io.serve(app, 'localhost', port);
}

// Router
Future<Response> _router(Request request) async {
  if (request.url.path == 'payments' && request.method == 'POST') {
    return _savePaymentDetails(request);
  } else if (request.url.path == 'orders' && request.method == 'GET') {
    return _fetchOrders();
  } else {
    return Response.notFound('Not Found');
  }
}

// Save Payment Details
Future<Response> _savePaymentDetails(Request request) async {
  try {
    final requestBody = jsonDecode(await request.readAsString());
    final ticketId = requestBody['ticket_id'];
    final paymentId = requestBody['payment_id'];
    final paymentDate = requestBody['payment_date'];
    final paymentStatus = requestBody['payment_status'];
    final totalAmount = requestBody['total_amount'];
    final paymentType = requestBody['payment_type'];

    if ([ticketId, paymentId, paymentDate, paymentStatus, totalAmount, paymentType].contains(null)) {
      return Response(400, body: jsonEncode({'error': 'Missing required fields'}));
    }

    // Simulate saving payment details
    return Response.ok(jsonEncode({'message': 'Payment saved successfully'}));
  } catch (e) {
    print('Error: $e');
    return Response(500, body: jsonEncode({'error': 'Server error'}));
  }
}

// Fetch Orders
Future<Response> _fetchOrders() async {
  try {
    // Simulate fetching orders
    final orders = [
      {'order_id': 1, 'item': 'Item 1', 'quantity': 2},
      {'order_id': 2, 'item': 'Item 2', 'quantity': 1},
    ];
    return Response.ok(jsonEncode(orders));
  } catch (e) {
    print('Error: $e');
    return Response(500, body: jsonEncode({'error': 'Server error'}));
  }
}
