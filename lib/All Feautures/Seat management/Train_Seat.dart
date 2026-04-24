import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:amarRailSheba/services/local_data_service.dart';
import 'package:amarRailSheba/utils/responsive.dart';
import '../payments_Methods/Payments.dart';

// ═══════════════════════════════════════════════════════════════════════════
// BD Railway Style Seat Selection Page
// ═══════════════════════════════════════════════════════════════════════════

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
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  final SeatController _controller = Get.put(SeatController());

  // Coach data
  final List<Map<String, dynamic>> _coaches = [
    {"name": "C-1", "seats": 60, "type": "AC_S"},
    {"name": "C-2", "seats": 58, "type": "AC_S"},
    {"name": "C-5A", "seats": 35, "type": "SNIGDHA"},
    {"name": "C-7A", "seats": 35, "type": "SNIGDHA"},
    {"name": "C-1S", "seats": 25, "type": "S_CHAIR"},
    {"name": "C-3S", "seats": 25, "type": "S_CHAIR"},
    {"name": "C-4S", "seats": 59, "type": "S_CHAIR"},
  ];

  final Map<String, int> _prices = {
    "AC_S": 320,
    "SNIGDHA": 420,
    "S_CHAIR": 280,
  };

  final List<String> _boardingStations = [
    "Kamalapur Station",
    "Airport Station",
    "Tongi Station",
    "Joydebpur Station",
  ];

  int _selectedCoachIndex = 0;
  String? _selectedBoardingStation;

  @override
  void initState() {
    super.initState();
    _selectedBoardingStation = _boardingStations.first;
    _controller.initializeSeats(_coaches[0]["seats"] as int);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<String, dynamic> get _currentCoach => _coaches[_selectedCoachIndex];

  int get _seatPrice => _prices[_currentCoach["type"]] ?? 280;

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    final isWide = r.width >= 700;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        foregroundColor: Colors.white,
        title: Text(
          'Select Seats',
          style: TextStyle(fontSize: r.fs16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: isWide ? _buildWideLayout(r) : _buildNarrowLayout(r),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Wide layout (tablet/web): side by side, both sides scrollable
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildWideLayout(R r) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: seat map — scrollable
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(r.sp16),
            child: _buildSeatMapSection(r),
          ),
        ),
        // Divider
        Container(width: 1, color: Colors.white.withValues(alpha: 0.1)),
        // Right: details panel — scrollable, fixed width
        SizedBox(
          width: 340,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(r.sp16),
            child: _buildDetailsPanel(r),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Narrow layout (mobile): everything in ONE scrollable list
  // seat map on top, details panel below — no Expanded conflict
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildNarrowLayout(R r) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(r.sp16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seat map section
          _buildSeatMapSection(r),
          SizedBox(height: r.sp16),

          // Details panel — inline, no bottom sheet
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            padding: EdgeInsets.all(r.sp16),
            child: _buildDetailsPanel(r),
          ),
          SizedBox(height: r.sp24),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Seat map section
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSeatMapSection(R r) {
    return Column(
      children: [
        // Round trip banner
        if (widget.isRoundTrip) _buildRoundTripBanner(r),
        if (widget.isRoundTrip) SizedBox(height: r.sp12),

        // Coach selector tabs
        _buildCoachTabs(r),
        SizedBox(height: r.sp16),

        // Legend
        _buildLegend(r),
        SizedBox(height: r.sp16),

        // Seat grid
        _buildSeatGrid(r),
        SizedBox(height: r.sp16),

        // Coach label
        _buildCoachLabel(r),
      ],
    );
  }

  Widget _buildRoundTripBanner(R r) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.sp12, vertical: r.sp8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE8A838).withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          const Icon(Icons.swap_horiz, color: Color(0xFFE8A838), size: 18),
          SizedBox(width: r.sp8),
          Expanded(
            child: Text(
              'Round Trip: ${widget.outboundTrain?.trainName ?? ''} ↔ ${widget.returnTrain?.trainName ?? ''}',
              style: TextStyle(
                color: const Color(0xFFE8A838),
                fontSize: r.fs12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachTabs(R r) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_coaches.length, (i) {
          final coach = _coaches[i];
          final selected = i == _selectedCoachIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCoachIndex = i;
                _controller.initializeSeats(coach["seats"] as int);
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: r.sp8),
              padding: EdgeInsets.symmetric(horizontal: r.sp16, vertical: r.sp10),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.25)
                    : Colors.white.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                coach["name"] as String,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.white60,
                  fontSize: r.fs13,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLegend(R r) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(r, const Color(0xFFE8A838), 'Available'),
        SizedBox(width: r.sp16),
        _legendItem(r, const Color(0xFF1A3A6B), 'Selected'),
        SizedBox(width: r.sp16),
        _legendItem(r, const Color(0xFFE53935), 'Booked'),
        SizedBox(width: r.sp16),
        _legendItem(r, const Color(0xFF4CAF50), 'In Progress'),
      ],
    );
  }

  Widget _legendItem(R r, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: r.sp6),
        Text(label, style: TextStyle(fontSize: r.fs11, color: Colors.white70)),
      ],
    );
  }

  Widget _buildSeatGrid(R r) {
    final totalSeats = _currentCoach["seats"] as int;
    final rows = (totalSeats / 4).ceil();

    return Container(
      padding: EdgeInsets.all(r.sp16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          // Column headers: A  B    C  D
          Padding(
            padding: EdgeInsets.only(bottom: r.sp12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 30),
                _columnHeader(r, 'A'),
                SizedBox(width: r.sp8),
                _columnHeader(r, 'B'),
                SizedBox(width: r.sp24),
                _columnHeader(r, 'C'),
                SizedBox(width: r.sp8),
                _columnHeader(r, 'D'),
              ],
            ),
          ),
          // Rows
          ...List.generate(rows, (rowIndex) {
            return _buildSeatRow(r, rowIndex, totalSeats);
          }),
        ],
      ),
    );
  }

  Widget _columnHeader(R r, String letter) {
    return SizedBox(
      width: 40,
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: r.fs12,
            fontWeight: FontWeight.bold,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }

  Widget _buildSeatRow(R r, int rowIndex, int totalSeats) {
    final rowNumber = rowIndex + 1;
    final seatA = rowIndex * 4 + 1;
    final seatB = rowIndex * 4 + 2;
    final seatC = rowIndex * 4 + 3;
    final seatD = rowIndex * 4 + 4;

    return Padding(
      padding: EdgeInsets.only(bottom: r.sp10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Row number
          SizedBox(
            width: 30,
            child: Text(
              '$rowNumber',
              style: TextStyle(
                fontSize: r.fs12,
                fontWeight: FontWeight.bold,
                color: Colors.white54,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Seat A
          if (seatA <= totalSeats) _buildSeat(r, seatA),
          if (seatA > totalSeats) SizedBox(width: 40),
          SizedBox(width: r.sp8),
          // Seat B
          if (seatB <= totalSeats) _buildSeat(r, seatB),
          if (seatB > totalSeats) SizedBox(width: 40),
          SizedBox(width: r.sp24), // aisle
          // Seat C
          if (seatC <= totalSeats) _buildSeat(r, seatC),
          if (seatC > totalSeats) SizedBox(width: 40),
          SizedBox(width: r.sp8),
          // Seat D
          if (seatD <= totalSeats) _buildSeat(r, seatD),
          if (seatD > totalSeats) SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildSeat(R r, int seatNumber) {
    return Obx(() {
      final seat = _controller.seats.firstWhere((s) => s.number == seatNumber);
      Color color;
      switch (seat.status) {
        case SeatStatus.available:
          color = const Color(0xFFE8A838); // orange
          break;
        case SeatStatus.selected:
          color = const Color(0xFF1A3A6B); // dark blue
          break;
        case SeatStatus.booked:
          color = const Color(0xFFE53935); // red
          break;
        case SeatStatus.inProgress:
          color = const Color(0xFF4CAF50); // green
          break;
      }

      return GestureDetector(
        onTap: () {
          if (seat.status == SeatStatus.available) {
            if (_controller.selectedSeats.length >= widget.passengers) {
              Get.snackbar(
                'Seat Limit Reached',
                'You can only select ${widget.passengers} seat${widget.passengers > 1 ? 's' : ''} for ${widget.passengers} passenger${widget.passengers > 1 ? 's' : ''}',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
              return;
            }
            _controller.selectSeat(seatNumber);
          } else if (seat.status == SeatStatus.selected) {
            _controller.deselectSeat(seatNumber);
          }
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$seatNumber',
              style: TextStyle(
                color: Colors.white,
                fontSize: r.fs11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCoachLabel(R r) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.sp16, vertical: r.sp10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Text(
        'COACH ${_currentCoach["name"]}',
        style: TextStyle(
          color: Colors.white,
          fontSize: r.fs14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Details panel (right side or bottom)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildDetailsPanel(R r) {
    return Obx(() {
      final selectedSeats = _controller.selectedSeats;
      final totalFare = selectedSeats.length * _seatPrice;
      final remaining = widget.passengers - selectedSeats.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seat Details',
            style: TextStyle(
              fontSize: r.fs16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: r.sp8),

          // Seat limit indicator
          Container(
            padding: EdgeInsets.symmetric(vertical: r.sp8, horizontal: r.sp12),
            decoration: BoxDecoration(
              color: remaining == 0
                  ? Colors.green.withValues(alpha: 0.25)
                  : Colors.orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: remaining == 0 ? Colors.green : Colors.orange,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  remaining == 0 ? Icons.check_circle : Icons.event_seat,
                  color: remaining == 0 ? Colors.green : Colors.orange,
                  size: r.fs14,
                ),
                SizedBox(width: r.sp8),
                Text(
                  remaining == 0
                      ? 'All ${widget.passengers} seat${widget.passengers > 1 ? 's' : ''} selected'
                      : 'Select $remaining more seat${remaining > 1 ? 's' : ''} (${selectedSeats.length}/${widget.passengers})',
                  style: TextStyle(
                    color: remaining == 0 ? Colors.green : Colors.orange,
                    fontSize: r.fs12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: r.sp12),

          // Table header
          Container(
            padding: EdgeInsets.symmetric(vertical: r.sp8, horizontal: r.sp12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('Class', style: TextStyle(fontSize: r.fs12, fontWeight: FontWeight.bold, color: Colors.white))),
                Expanded(flex: 2, child: Text('Seats', style: TextStyle(fontSize: r.fs12, fontWeight: FontWeight.bold, color: Colors.white))),
                Expanded(flex: 1, child: Text('Fare', style: TextStyle(fontSize: r.fs12, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.right)),
              ],
            ),
          ),

          // Table rows
          if (selectedSeats.isEmpty)
            Container(
              padding: EdgeInsets.all(r.sp16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
              ),
              child: Center(
                child: Text('No seats selected', style: TextStyle(fontSize: r.fs12, color: Colors.white54)),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
              ),
              child: Column(
                children: selectedSeats.map((seatNum) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: r.sp8, horizontal: r.sp12),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text(_currentCoach["type"] as String, style: TextStyle(fontSize: r.fs12, color: Colors.white70))),
                        Expanded(flex: 2, child: Text('$seatNum', style: TextStyle(fontSize: r.fs12, color: Colors.white70))),
                        Expanded(flex: 1, child: Text('৳$_seatPrice', style: TextStyle(fontSize: r.fs12, color: Colors.white70), textAlign: TextAlign.right)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

          SizedBox(height: r.sp16),

          // Boarding station dropdown
          Text('Boarding Station', style: TextStyle(fontSize: r.fs13, fontWeight: FontWeight.w600, color: Colors.white)),
          SizedBox(height: r.sp8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: r.sp12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withValues(alpha: 0.08),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBoardingStation,
                isExpanded: true,
                dropdownColor: const Color(0xFF0A1628),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                style: TextStyle(fontSize: r.fs13, color: Colors.white),
                items: _boardingStations.map((station) {
                  return DropdownMenuItem(
                    value: station,
                    child: Text(station, style: TextStyle(fontSize: r.fs13, color: Colors.white)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedBoardingStation = val),
              ),
            ),
          ),

          SizedBox(height: r.sp16),

          // Total fare
          Container(
            padding: EdgeInsets.all(r.sp12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Fare', style: TextStyle(color: Colors.white, fontSize: r.fs14, fontWeight: FontWeight.bold)),
                Text('৳$totalFare', style: TextStyle(color: const Color(0xFFE8A838), fontSize: r.fs16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          SizedBox(height: r.sp16),

          // Continue button
          SizedBox(
            width: double.infinity,
            height: r.btnH,
            child: ElevatedButton(
              onPressed: selectedSeats.length == widget.passengers ? _confirmBooking : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: Text(
                selectedSeats.length == widget.passengers
                    ? 'Continue Purchase'
                    : 'Select ${widget.passengers - selectedSeats.length} more seat${(widget.passengers - selectedSeats.length) > 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: r.fs14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Confirm booking with Firebase transaction locking
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _confirmBooking() async {
    final selectedSeats = _controller.selectedSeats;
    if (selectedSeats.isEmpty) {
      Get.snackbar('Error', 'Please select at least one seat',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (selectedSeats.length != widget.passengers) {
      Get.snackbar(
        'Select Exact Seats',
        'Please select exactly ${widget.passengers} seat${widget.passengers > 1 ? 's' : ''} for ${widget.passengers} passenger${widget.passengers > 1 ? 's' : ''}',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'Please login to continue',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Show loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final db = FirebaseDatabase.instance;
      final coachName = _currentCoach["name"] as String;
      final coachRef = db.ref('seats/$coachName');

      // Transaction to lock seats
      final result = await coachRef.runTransaction((currentData) {
        if (currentData == null) {
          // Initialize coach data
          final Map<String, dynamic> newData = {};
          for (final seatNum in selectedSeats) {
            newData['seat_$seatNum'] = {
              'status': 'locked',
              'userId': user.uid,
              'timestamp': DateTime.now().millisecondsSinceEpoch,
            };
          }
          return Transaction.success(newData);
        }

        final seats = Map<String, dynamic>.from(currentData as Map);
        // Check if any seat is already taken
        for (final seatNum in selectedSeats) {
          final seatKey = 'seat_$seatNum';
          if (seats.containsKey(seatKey)) {
            final seatData = seats[seatKey] as Map?;
            if (seatData != null && seatData['status'] == 'locked') {
              // Seat already locked
              return Transaction.abort();
            }
          }
        }

        // Lock all seats
        for (final seatNum in selectedSeats) {
          seats['seat_$seatNum'] = {
            'status': 'locked',
            'userId': user.uid,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          };
        }

        return Transaction.success(seats);
      });

      Get.back(); // Close loading

      if (!result.committed) {
        Get.snackbar('Error', 'Some seats are no longer available',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // Start 10-minute timer to release seats if not paid
      Timer(const Duration(minutes: 10), () async {
        final snapshot = await coachRef.get();
        if (snapshot.exists) {
          final seats = Map<String, dynamic>.from(snapshot.value as Map);
          bool needsUpdate = false;
          for (final seatNum in selectedSeats) {
            final seatKey = 'seat_$seatNum';
            if (seats.containsKey(seatKey)) {
              final seatData = seats[seatKey] as Map?;
              if (seatData != null &&
                  seatData['userId'] == user.uid &&
                  seatData['status'] == 'locked') {
                seats.remove(seatKey);
                needsUpdate = true;
              }
            }
          }
          if (needsUpdate) {
            await coachRef.set(seats);
          }
        }
      });

      // Navigate to payment
      final totalFare = selectedSeats.length * _seatPrice;
      final bookingId = 'BK${DateTime.now().millisecondsSinceEpoch}';

      final order = Order(
        bookingId,
        trainId: widget.outboundTrain?.trainId ?? 'TRAIN001',
        paymentId: '',
        paymentDate: DateTime.now().toString(),
        status: 'pending',
        total: totalFare.toDouble(),
        seatNumbers: selectedSeats,
      );

      Get.to(() => PaymentsPage(
            orders: [order],
            totalPrice: totalFare.toString(),
            selectedSeats: selectedSeats,
            trainId: widget.outboundTrain?.trainId ?? 'TRAIN001',
            trainName: widget.outboundTrain?.trainName ?? 'Express Train',
            fromStation: widget.fromStation ?? 'Dhaka',
            toStation: widget.toStation ?? 'Chattogram',
            departureTime: widget.departureTime ?? '08:00 AM',
            tickets: [
              TicketType(
                type: _currentCoach["type"] as String,
                price: _seatPrice.toDouble(),
                availableSeats: _currentCoach["seats"] as int,
              ),
            ],
            travelClass: widget.travelClass ?? 'AC',
            date: widget.journeyDate ?? DateTime.now().toString(),
            isRoundTrip: widget.isRoundTrip,
            outboundTrain: widget.outboundTrain,
            returnTrain: widget.returnTrain,
          ));
    } catch (e) {
      Get.back(); // Close loading
      Get.snackbar('Error', 'Failed to book seats: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Seat Controller (GetX)
// ═══════════════════════════════════════════════════════════════════════════

enum SeatStatus { available, selected, booked, inProgress }

class Seat {
  final int number;
  final Rx<SeatStatus> _status;

  Seat(this.number, SeatStatus status) : _status = status.obs;

  SeatStatus get status => _status.value;
  set status(SeatStatus val) => _status.value = val;
}

class SeatController extends GetxController {
  final RxList<Seat> seats = <Seat>[].obs;

  List<int> get selectedSeats =>
      seats.where((s) => s.status == SeatStatus.selected).map((s) => s.number).toList();

  void initializeSeats(int count) {
    seats.clear();
    final random = Random();
    for (int i = 1; i <= count; i++) {
      // Randomly mark some seats as booked (10% chance)
      final isBooked = random.nextDouble() < 0.1;
      seats.add(Seat(i, isBooked ? SeatStatus.booked : SeatStatus.available));
    }
  }

  void selectSeat(int number) {
    final seat = seats.firstWhere((s) => s.number == number);
    if (seat.status == SeatStatus.available) {
      seat.status = SeatStatus.selected;
      seats.refresh();
    }
  }

  void deselectSeat(int number) {
    final seat = seats.firstWhere((s) => s.number == number);
    if (seat.status == SeatStatus.selected) {
      seat.status = SeatStatus.available;
      seats.refresh();
    }
  }
}
