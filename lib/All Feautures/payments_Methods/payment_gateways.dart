import 'package:flutter/foundation.dart';

abstract class PaymentGateway {
  void pay(double amount);
}

class BkashPayment implements PaymentGateway {
  @override
  void pay(double amount) {
    if (kDebugMode) {
      print('Paying $amount using Bkash');
    }
    // Implement Bkash payment logic here
  }
}
// class BkashPaymentPage extends StatefulWidget {
//   final String paymentUrl;

//   BkashPaymentPage({required this.paymentUrl});

//   @override
//   _BkashPaymentPageState createState() => _BkashPaymentPageState();
// }

// class _BkashPaymentPageState extends State<BkashPaymentPage> {
//   late WebViewController _controller;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("bKash Payment"),
//       ),
//       body: WebView(
//         initialUrl: widget.paymentUrl,
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (controller) {
//           _controller = controller;
//         },
//         navigationDelegate: (navigation) {
//           if (navigation.url.contains('success')) {
//             Navigator.pop(context, "Payment Successful");
//           } else if (navigation.url.contains('failure')) {
//             Navigator.pop(context, "Payment Failed");
//           }
//           return NavigationDecision.navigate;
//         },
//       ),
//     );
//   }
// }

class NagadPayment implements PaymentGateway {
  @override
  void pay(double amount) {
    if (kDebugMode) {
      print('Paying $amount using Nagad');
    }
    // Implement Nagad payment logic here
  }
}

class CardPayment implements PaymentGateway {
  @override
  void pay(double amount) {
    if (kDebugMode) {
      print('Paying $amount using Card');
    }
    // Implement Card payment logic here
  }
}

void main() {
  PaymentGateway bkash = BkashPayment();
  bkash.pay(100.0);

  PaymentGateway nagad = NagadPayment();
  nagad.pay(200.0);

  PaymentGateway card = CardPayment();
  card.pay(300.0);
}