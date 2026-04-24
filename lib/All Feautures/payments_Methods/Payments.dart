import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amarRailSheba/All%20Feautures/Dynamic%20Tickets/TicketDetails.dart';
import 'package:amarRailSheba/All%20Feautures/firstpage/booking.dart';
import 'package:amarRailSheba/All%20Feautures/payments_Methods/payment_gateways.dart';
import 'package:amarRailSheba/services/firebase_service.dart';
import 'package:amarRailSheba/services/local_data_service.dart';
import 'package:amarRailSheba/utils/responsive.dart';

// ── Order model ───────────────────────────────────────────────────────────────
class Order {
  final String id;
  final String trainId;
  final String paymentId;
  final String paymentDate;
  final String status;
  final double total;
  final List<int> seatNumbers;

  Order(
    this.id, {
    required this.trainId,
    required this.paymentId,
    required this.paymentDate,
    required this.status,
    required this.total,
    required this.seatNumbers,
  });
}

// ── TicketType (kept for backward compat) ─────────────────────────────────────
class TicketType {
  final String type;
  final double price;
  final int availableSeats;

  const TicketType({required this.type, required this.price, required this.availableSeats});
}

// ── Payments Page ─────────────────────────────────────────────────────────────
class PaymentsPage extends StatefulWidget {
  final List<Order> orders;
  final String totalPrice;
  final List<int> selectedSeats;
  final String trainId;
  final List<TicketType> tickets;
  final String trainName;
  final String fromStation;
  final String toStation;
  final String departureTime;
  final String travelClass;
  final String date;
  final bool isRoundTrip;
  final TrainModel? outboundTrain;
  final TrainModel? returnTrain;

  const PaymentsPage({
    super.key,
    required this.orders,
    required this.totalPrice,
    required this.selectedSeats,
    required this.trainId,
    required this.trainName,
    required this.fromStation,
    required this.toStation,
    required this.departureTime,
    required this.tickets,
    required this.travelClass,
    required this.date,
    this.isRoundTrip = false,
    this.outboundTrain,
    this.returnTrain,
  });

  @override
  PaymentsPageState createState() => PaymentsPageState();
}

class PaymentsPageState extends State<PaymentsPage> {
  String _selectedMethod = '';
  bool _processing = false;

  double get totalAmount =>
      widget.orders.fold<double>(0.0, (sum, o) => sum + o.total) + 20;

  final List<Map<String, dynamic>> _methods = [
    {'id': 'bkash', 'label': 'bKash', 'color': const Color(0xFFE2136E), 'icon': Icons.phone_android},
    {'id': 'nagad', 'label': 'Nagad', 'color': const Color(0xFFFF6600), 'icon': Icons.account_balance_wallet},
    {'id': 'card', 'label': 'Card', 'color': const Color(0xFF1A3A6B), 'icon': Icons.credit_card},
    {'id': 'rocket', 'label': 'Rocket', 'color': const Color(0xFF8B1A8B), 'icon': Icons.rocket_launch},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3A6B),
        foregroundColor: Colors.white,
        title: const Text('Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.offAll(() => const MainHomeScreen()),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: R.of(context).pagePad,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Round trip badge
            if (widget.isRoundTrip)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE8A838)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.swap_horiz, color: Color(0xFFE65100), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Round Trip: ${widget.outboundTrain?.trainName ?? ''} ↔ ${widget.returnTrain?.trainName ?? ''}',
                      style: const TextStyle(color: Color(0xFFE65100), fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

            // Journey summary card
            _buildJourneySummary(),
            const SizedBox(height: 16),

            // Order summary
            _buildOrderSummary(),
            const SizedBox(height: 16),

            // Payment methods
            Text('Select Payment Method',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: R.of(context).fs15)),
            SizedBox(height: R.of(context).sp10),
            LayoutBuilder(builder: (ctx, constraints) {
              final r = R.of(ctx);
              final cols = constraints.maxWidth > 400 ? 4 : 2;
              return GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: r.sp10,
                mainAxisSpacing: r.sp10,
                childAspectRatio: constraints.maxWidth > 400 ? 2.2 : 2.8,
                children: _methods.map((m) => _buildMethodTile(m)).toList(),
              );
            }),
            SizedBox(height: R.of(context).sp20),

            // Pay button
            SizedBox(
              width: double.infinity,
              height: R.of(context).btnH,
              child: ElevatedButton(
                onPressed: _selectedMethod.isEmpty || _processing ? null : _pay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3A6B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _processing
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(
                        _selectedMethod.isEmpty
                            ? 'Select a payment method'
                            : 'Pay ৳${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: R.of(context).fs15, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    ),  // ConstrainedBox
    ),  // Center
    );
  }

  Widget _buildJourneySummary() {
    final r = R.of(context);
    return Container(
      padding: EdgeInsets.all(r.sp16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Journey Details',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: r.fs14)),
          SizedBox(height: r.sp10),
          _summaryRow('From', widget.fromStation),
          _summaryRow('To', widget.toStation),
          _summaryRow('Date', widget.date),
          _summaryRow('Class', widget.travelClass),
          _summaryRow('Seats', widget.selectedSeats.join(', ')),
          _summaryRow('Train', widget.trainName),
          _summaryRow('Departure', widget.departureTime),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    final r = R.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: r.sp4 / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: Colors.grey, fontSize: r.fs12)),
          Flexible(
            child: Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: r.fs12),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    final r = R.of(context);
    return Container(
      padding: EdgeInsets.all(r.sp16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A6B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ticket Price',
                  style: TextStyle(color: Colors.white70, fontSize: r.fs13)),
              Text('৳${(totalAmount - 20).toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.white, fontSize: r.fs13)),
            ],
          ),
          SizedBox(height: r.sp6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Service Charge',
                  style: TextStyle(color: Colors.white70, fontSize: r.fs13)),
              Text('৳20.00',
                  style: TextStyle(color: Colors.white, fontSize: r.fs13)),
            ],
          ),
          const Divider(color: Colors.white30, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: r.fs16)),
              Text('৳${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: const Color(0xFFE8A838),
                      fontWeight: FontWeight.bold,
                      fontSize: r.fs18)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMethodTile(Map<String, dynamic> m) {
    final r = R.of(context);
    final selected = _selectedMethod == m['id'];
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = m['id']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: r.sp12, vertical: r.sp8),
        decoration: BoxDecoration(
          color: selected
              ? (m['color'] as Color).withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? m['color'] as Color : Colors.grey[300]!,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(m['icon'] as IconData,
                color: m['color'] as Color, size: r.fs20),
            SizedBox(width: r.sp8),
            Flexible(
              child: Text(m['label'] as String,
                  style: TextStyle(
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.normal,
                      fontSize: r.fs12,
                      color: selected
                          ? m['color'] as Color
                          : Colors.black87),
                  overflow: TextOverflow.ellipsis),
            ),
            const Spacer(),
            if (selected)
              Icon(Icons.check_circle,
                  color: m['color'] as Color, size: r.fs15),
          ],
        ),
      ),
    );
  }

  Future<void> _pay() async {
    if (totalAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid payment amount.'), backgroundColor: Colors.red),
      );
      return;
    }
    if (widget.selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No seats selected.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _processing = true);

    final bookingId = widget.orders.isNotEmpty ? widget.orders.first.id : 'BK000000';
    final user = await FirebaseService().getUserProfile();
    final gateway = PaymentGatewayFactory.create(_selectedMethod);

    final result = await gateway.pay(
      amount: totalAmount,
      bookingId: bookingId,
      customerName: user?['name'] ?? 'Passenger',
      customerEmail: user?['email'] ?? 'passenger@example.com',
      customerPhone: user?['phone'] ?? '01700000000',
    );

    setState(() => _processing = false);

    if (!result.success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Payment failed. Try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // SSLCommerz returns a redirect URL — open it in a WebView-style page
    if (result.redirectUrl != null && mounted) {
      Get.to(() => _PaymentWebView(
            url: result.redirectUrl!,
            onSuccess: () => _onPaymentSuccess(bookingId),
            onFail: () {
              Get.back();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment failed or cancelled.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ));
    } else {
      // Fallback for sandbox/test — treat as success
      _onPaymentSuccess(bookingId);
    }
  }

  void _onPaymentSuccess(String bookingId) {
    Get.to(() => TrainTicketPage(
          name: 'Passenger',
          from: widget.fromStation,
          to: widget.toStation,
          travelClass: widget.travelClass,
          date: widget.date,
          departTime: widget.departureTime,
          seat: widget.selectedSeats.join(', '),
          totalAmount: totalAmount.toStringAsFixed(2),
          trainCode: widget.trainId,
        ));
  }
}

// ── SSLCommerz WebView ────────────────────────────────────────────────────────
// Opens the SSLCommerz payment page in a full-screen web view.
// Detects success/fail/cancel from the redirect URL.
class _PaymentWebView extends StatelessWidget {
  final String url;
  final VoidCallback onSuccess;
  final VoidCallback onFail;

  const _PaymentWebView({
    required this.url,
    required this.onSuccess,
    required this.onFail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3A6B),
        foregroundColor: Colors.white,
        title: const Text('Complete Payment', style: TextStyle(fontSize: 15)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onFail,
        ),
      ),
      // NOTE: To render the actual SSLCommerz page, add webview_flutter:
      //   flutter pub add webview_flutter
      // Then replace this placeholder with:
      //   WebViewWidget(controller: WebViewController()..loadRequest(Uri.parse(url)))
      // and detect success/fail by intercepting navigation to your success_url / fail_url.
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.payment, size: 64, color: Color(0xFF1A3A6B)),
              const SizedBox(height: 16),
              const Text(
                'Payment Gateway',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Add webview_flutter package to render the payment page.\n\nURL: $url',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              // Sandbox test buttons
              ElevatedButton(
                onPressed: onSuccess,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Simulate Success (sandbox)', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: onFail,
                child: const Text('Simulate Fail (sandbox)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── OrderSummaryCard (kept for backward compat) ───────────────────────────────
class OrderSummaryCard extends StatelessWidget {
  final Order order;
  const OrderSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order: ${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Total: ৳${order.total.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
