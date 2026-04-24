import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class PaymentGateway {
  /// Initiates payment. Returns a [PaymentResult].
  Future<PaymentResult> pay({
    required double amount,
    required String bookingId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
  });
}

class PaymentResult {
  final bool success;
  final String? redirectUrl; // SSLCommerz redirects to this URL
  final String? transactionId;
  final String? errorMessage;

  const PaymentResult({
    required this.success,
    this.redirectUrl,
    this.transactionId,
    this.errorMessage,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// SSLCommerz — handles bKash, Nagad, Rocket, Card all in one gateway
// Docs: https://developer.sslcommerz.com/doc/v4/
//
// Setup:
//   1. Register at https://sslcommerz.com → get store_id + store_passwd
//   2. Add to android/local.properties (gitignored):
//        SSLCOMMERZ_STORE_ID=your_store_id
//        SSLCOMMERZ_STORE_PASS=your_store_password
//   3. For sandbox testing use:
//        store_id: testbox   store_passwd: qwerty
//        sandbox URL: https://sandbox.sslcommerz.com/gwprocess/v4/api.php
//   4. For production:
//        URL: https://securepay.sslcommerz.com/gwprocess/v4/api.php
// ─────────────────────────────────────────────────────────────────────────────
class SSLCommerzPayment implements PaymentGateway {
  final String storeId;
  final String storePassword;
  final bool isSandbox;

  const SSLCommerzPayment({
    required this.storeId,
    required this.storePassword,
    this.isSandbox = true, // set false for production
  });

  String get _apiUrl => isSandbox
      ? 'https://sandbox.sslcommerz.com/gwprocess/v4/api.php'
      : 'https://securepay.sslcommerz.com/gwprocess/v4/api.php';

  @override
  Future<PaymentResult> pay({
    required double amount,
    required String bookingId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        body: {
          'store_id': storeId,
          'store_passwd': storePassword,
          'total_amount': amount.toStringAsFixed(2),
          'currency': 'BDT',
          'tran_id': bookingId,
          'success_url': 'https://yourapp.com/payment/success',
          'fail_url': 'https://yourapp.com/payment/fail',
          'cancel_url': 'https://yourapp.com/payment/cancel',
          'cus_name': customerName,
          'cus_email': customerEmail,
          'cus_phone': customerPhone,
          'cus_add1': 'Bangladesh',
          'cus_city': 'Dhaka',
          'cus_country': 'Bangladesh',
          'shipping_method': 'NO',
          'product_name': 'Train Ticket',
          'product_category': 'Travel',
          'product_profile': 'non-physical-goods',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['status'] == 'SUCCESS') {
          return PaymentResult(
            success: true,
            redirectUrl: data['GatewayPageURL'] as String?,
            transactionId: data['sessionkey'] as String?,
          );
        }
        return PaymentResult(
          success: false,
          errorMessage: data['failedreason'] as String? ?? 'Payment initiation failed',
        );
      }
      return const PaymentResult(
        success: false,
        errorMessage: 'Server error. Please try again.',
      );
    } catch (e) {
      return PaymentResult(success: false, errorMessage: e.toString());
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Factory — returns the right gateway based on selected method
// ─────────────────────────────────────────────────────────────────────────────
class PaymentGatewayFactory {
  // Sandbox credentials for testing — replace with real credentials in production
  static const _sandboxStoreId = 'testbox';
  static const _sandboxStorePass = 'qwerty';

  static PaymentGateway create(String method) {
    // SSLCommerz handles all BD payment methods (bKash, Nagad, Rocket, Card)
    return SSLCommerzPayment(
      storeId: _sandboxStoreId,
      storePassword: _sandboxStorePass,
      isSandbox: true, // ← set false + real credentials for production
    );
  }
}
