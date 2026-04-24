abstract class PaymentGateway {
  /// Returns true if payment succeeded, false otherwise.
  Future<bool> pay(double amount);
}

class BkashPayment implements PaymentGateway {
  @override
  Future<bool> pay(double amount) async {
    // TODO: Integrate bKash Payment Gateway API
    // See: https://developer.bka.sh/docs
    throw UnimplementedError('bKash payment not yet integrated.');
  }
}

class NagadPayment implements PaymentGateway {
  @override
  Future<bool> pay(double amount) async {
    // TODO: Integrate Nagad Payment Gateway API
    // See: https://nagad.com.bd/developer
    throw UnimplementedError('Nagad payment not yet integrated.');
  }
}

class CardPayment implements PaymentGateway {
  @override
  Future<bool> pay(double amount) async {
    // TODO: Integrate SSLCommerz or similar card payment gateway
    // See: https://developer.sslcommerz.com
    throw UnimplementedError('Card payment not yet integrated.');
  }
}