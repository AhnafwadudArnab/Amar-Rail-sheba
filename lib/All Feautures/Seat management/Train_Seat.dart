import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:amarRailSheba/services/local_data_service.dart';
import 'package:amarRailSheba/utils/responsive.dart';
import '../payments_Methods/Payments.dart';

class SeatController extends GetxController {
  var seatStatus = <String, List<String>>{}.obs;

  void initializeSeats(String coach, int seats) {
    seatStatus.putIfAbsent(coach, () => List.filled(seats, 'available'));
  }

  void updateSeatStatus(String coach, int index, String status) {
    seatStatus[coach]?[index] = status;
  }

  List<String> getSeatStatus(String coach) {
    return seatStatus[coach] ?? [];
  }
}

class SeatSelectionPage extends StatefulWidget {
  final int price;
  final String ticketType;
  final String? fromStation;
  final String? toStation;
  final String? travelClass;
  final String? journeyDate;
  final String? departureTime;
  final bool isRoundTrip;
  final TrainModel? outboundTrain;
  final TrainModel? returnTrain;
  final int passengers;

  const SeatSelectionPage({
    super.key,
    required this.price,
    required this.ticketType,
    this.fromStation,
    this.toStation,
    this.travelClass,
    this.journeyDate,
    this.departureTime,
    this.isRoundTrip = false,
    this.outboundTrain,
    this.returnTrain,
    this.passengers = 1,
  });

  @override
  SeatSelectionPageState createState() => SeatSelectionPageState();
}

class SeatSelectionPageState extends State<SeatSelectionPage> {
  final SeatController seatController = Get.put(SeatController());
  List<int> selectedSeats = [];
  Timer? timer;
  int get allowedSeats => widget.passengers;

  final List<Map<String, dynamic>> coaches = [
    {"name": "C-1", "seats": 60, "type": "AC_S"},
    {"name": "C-2", "seats": 58, "type": "AC_S"},
    {"name": "C-5A", "seats": 35, "type": "SNIGDHA"},
    {"name": "C-7A", "seats": 35, "type": "SNIGDHA"},
    {"name": "C-1S", "seats": 25, "type": "S_CHAIR"},
    {"name": "C-3S", "seats": 25, "type": "S_CHAIR"},
    {"name": "C-4S", "seats": 59, "type": "S_CHAIR"},
  ];
  String selectedCoach = "C-1";

  @override
  void initState() {
    super.initState();
    seatController.initializeSeats(
        selectedCoach,
        coaches.firstWhere((c) => c['name'] == selectedCoach)['seats']);
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(minutes: 10), (_) {
      setState(() => selectedSeats.clear());
    });
  }

  void handleSeatSelection(int index) {
    setState(() {
      if (selectedSeats.contains(index)) {
        selectedSeats.remove(index);
        seatController.updateSeatStatus(selectedCoach, index, 'available');
      } else if (selectedSeats.length < allowedSeats &&
          seatController.getSeatStatus(selectedCoach)[index] == 'available') {
        selectedSeats.add(index);
        seatController.updateSeatStatus(selectedCoach, index, 'selected');
      }
    });
  }

  Color getSeatColor(String status) {
    switch (status) {
      case 'available': return Colors.green;
      case 'selected': return const Color(0xFFE8A838);
      case 'booked': return Colors.red;
      default: return Colors.grey[300]!;
    }
  }

  int getSeatPrice(String coachType) {
    switch (coachType) {
      case 'AC_S': return 320;
      case 'SNIGDHA': return 420;
      case 'S_CHAIR': return 280;
      default: return 0;
    }
  }

  double get totalPrice {
    final coachType = coaches.firstWhere((c) => c['name'] == selectedCoach)['type'];
    return selectedSeats.length * getSeatPrice(coachType).toDouble();
  }

  void _confirmBooking() async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? 'user_local';
    final arrivalTime = widget.outboundTrain?.arrivalTime ??
        widget.returnTrain?.arrivalTime ?? '';

    final bookingId = 'BK${Random().nextInt(999999).toString().padLeft(6, '0')}';
    final booking = BookingModel(
      bookingId: bookingId,
      userId: currentUid,
      fromStation: widget.fromStation ?? '',
      toStation: widget.toStation ?? '',
      journeyDate: widget.journeyDate ?? '',
      travelClass: widget.travelClass ?? '',
      trainName: widget.ticketType,
      trainCode: widget.outboundTrain?.trainCode ?? 'TR001',
      departureTime: widget.departureTime ?? '',
      arrivalTime: arrivalTime,
      seatNumbers: selectedSeats.map((i) => i + 1).toList(),
      coachName: selectedCoach,
      totalAmount: totalPrice * 1.15,
      status: 'confirmed',
      bookingType: widget.isRoundTrip ? 'round_trip' : 'one_way',
    );

    try {
      await LocalDataService().saveBooking(booking);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save booking. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    Get.offAll(() => PaymentsPage(
          orders: [
            Order(
              bookingId,
              trainId: 'TN001',
              paymentId: 'PAY-${Random().nextInt(99999)}',
              paymentDate: DateTime.now().toString().split(' ')[0],
              status: 'Pending',
              total: totalPrice * 1.15,
              seatNumbers: selectedSeats.map((i) => i + 1).toList(),
            ),
          ],
          totalPrice: (totalPrice * 1.15).toStringAsFixed(2),
          selectedSeats: selectedSeats.map((i) => i + 1).toList(),
          trainId: 'TN001',
          trainName: widget.ticketType,
          fromStation: widget.fromStation ?? 'Unknown',
          toStation: widget.toStation ?? 'Unknown',
          departureTime: widget.departureTime ?? 'Unknown',
          tickets: const [],
          travelClass: widget.travelClass ?? 'Unknown',
          date: widget.journeyDate ?? 'Unknown',
          isRoundTrip: widget.isRoundTrip,
          outboundTrain: widget.outboundTrain,
          returnTrain: widget.returnTrain,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3A6B),
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Seats', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('${widget.fromStation} → ${widget.toStation}',
                style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Round trip info banner
          if (widget.isRoundTrip)
            Container(
              color: const Color(0xFFFFF3E0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.swap_horiz, color: Color(0xFFE65100), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Round Trip: ${widget.outboundTrain?.trainName ?? ''} + ${widget.returnTrain?.trainName ?? ''}',
                      style: const TextStyle(color: Color(0xFFE65100), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

          // Coach selector
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Coach', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: coaches.map((c) => _buildCoachChip(c['name'])).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Legend
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _legendItem(Colors.green, 'Available'),
                _legendItem(const Color(0xFFE8A838), 'Selected'),
                _legendItem(Colors.red, 'Booked'),
              ],
            ),
          ),

          // Seat grid
          Expanded(
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                final r = R.of(ctx);
                // Responsive columns: more columns on wider screens
                final cols = constraints.maxWidth < 360
                    ? 5
                    : constraints.maxWidth < 500
                        ? 6
                        : 8;
                final seatSize = (constraints.maxWidth - (cols + 1) * 6) / cols;
                return Padding(
                  padding: EdgeInsets.all(r.sp12),
                  child: Obx(() {
                    final statuses = seatController.getSeatStatus(selectedCoach);
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1,
                      ),
                      itemCount: statuses.length,
                      itemBuilder: (ctx2, i) =>
                          _buildSeat(i, statuses[i], seatSize),
                    );
                  }),
                );
              },
            ),
          ),

          // Bottom summary
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildCoachChip(String name) {
    final selected = name == selectedCoach;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCoach = name;
          selectedSeats.clear();
          seatController.initializeSeats(
              name, coaches.firstWhere((c) => c['name'] == name)['seats']);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1A3A6B) : const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF1A3A6B) : Colors.grey[300]!,
          ),
        ),
        child: Text(name,
            style: TextStyle(
                color: selected ? Colors.white : Colors.grey[700],
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12)),
      ),
    );
  }

  Widget _buildSeat(int index, String status, [double? size]) {
    final r = R.of(context);
    return GestureDetector(
      onTap: () {
        if (status == 'available' || status == 'selected') {
          handleSeatSelection(index);
        }
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: getSeatColor(status),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black12),
        ),
        child: Center(
          child: Text('${index + 1}',
              style: TextStyle(
                  fontSize: r.fs10,
                  color: status == 'booked' ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    final r = R.of(context);
    return Row(
      children: [
        Container(
          width: r.sp16,
          height: r.sp16,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(3)),
        ),
        SizedBox(width: r.sp4),
        Text(label, style: TextStyle(fontSize: r.fs12)),
      ],
    );
  }

  Widget _buildBottomBar() {
    final r = R.of(context);
    return Container(
      padding: EdgeInsets.all(r.sp16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedSeats.isEmpty
                          ? 'No seats selected'
                          : 'Seats: ${selectedSeats.map((i) => i + 1).join(', ')}',
                      style: TextStyle(fontSize: r.fs13),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Select $allowedSeats seat${allowedSeats > 1 ? 's' : ''}',
                      style: TextStyle(color: Colors.grey, fontSize: r.fs11),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '৳${totalPrice.toStringAsFixed(0)}',
                    style: TextStyle(
                        fontSize: r.fs20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A3A6B)),
                  ),
                  Text('+15% VAT',
                      style: TextStyle(color: Colors.grey, fontSize: r.fs10)),
                ],
              ),
            ],
          ),
          SizedBox(height: r.sp12),
          SizedBox(
            width: double.infinity,
            height: r.btnH,
            child: ElevatedButton(
              onPressed:
                  selectedSeats.length == allowedSeats ? _confirmBooking : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3A6B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                selectedSeats.length == allowedSeats
                    ? 'Continue to Payment'
                    : 'Select ${allowedSeats - selectedSeats.length} more seat${(allowedSeats - selectedSeats.length) > 1 ? 's' : ''}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: r.fs14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
