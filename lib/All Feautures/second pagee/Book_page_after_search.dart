import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amarRailSheba/All%20Feautures/Seat%20management/Train_Seat.dart';
import 'package:amarRailSheba/services/local_data_service.dart';
import 'package:amarRailSheba/utils/responsive.dart';

// ignore: must_be_immutable
class TrainSearchPage extends StatefulWidget {
  final String fromStation;
  final String toStation;
  final String travelClass;
  final String journeyDate;
  final String returnJourneyDate;
  final String returnFromStation;
  final String returnToStation;
  final String returnJourneyClass;
  final int passengers;
  final bool isRoundTrip;

  const TrainSearchPage({
    super.key,
    required this.fromStation,
    required this.toStation,
    required this.travelClass,
    required this.journeyDate,
    this.returnJourneyDate = '',
    this.returnFromStation = '',
    this.returnToStation = '',
    this.returnJourneyClass = '',
    this.passengers = 1,
    this.isRoundTrip = false,
  });

  @override
  _TrainSearchPageState createState() => _TrainSearchPageState();
}

class _TrainSearchPageState extends State<TrainSearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TrainModel> _outboundTrains = [];
  List<TrainModel> _returnTrains = [];
  bool _loading = true;

  // For round trip: track which outbound train was selected
  TrainModel? _selectedOutbound;
  bool _outboundConfirmed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.isRoundTrip ? 2 : 1,
      vsync: this,
    );
    _loadTrains();
  }

  Future<void> _loadTrains() async {
    final outbound = await LocalDataService()
        .getTrainsAsync(widget.fromStation, widget.toStation);
    final ret = widget.isRoundTrip
        ? await LocalDataService()
            .getTrainsAsync(widget.toStation, widget.fromStation)
        : <TrainModel>[];
    if (mounted) {
      setState(() {
        _outboundTrains = outbound;
        _returnTrains = ret;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3A6B),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.fromStation} → ${widget.toStation}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.isRoundTrip ? 'Round Trip · ${widget.passengers} pax' : 'One Way · ${widget.passengers} pax',
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        bottom: widget.isRoundTrip
            ? TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFFE8A838),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Outbound', style: TextStyle(fontSize: 12)),
                        Text(widget.journeyDate,
                            style: const TextStyle(fontSize: 10, color: Colors.white70)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Return', style: TextStyle(fontSize: 12)),
                        Text(widget.returnJourneyDate,
                            style: const TextStyle(fontSize: 10, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              )
            : null,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A3A6B)))
          : widget.isRoundTrip
          ? TabBarView(
              controller: _tabController,
              physics: _outboundConfirmed
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              children: [
                _buildTrainList(_outboundTrains, isReturn: false),
                _buildTrainList(_returnTrains, isReturn: true),
              ],
            )
          : _buildTrainList(_outboundTrains, isReturn: false),
    );
  }

  Widget _buildTrainList(List<TrainModel> trains, {required bool isReturn}) {
    return Column(
      children: [
        // Journey summary bar
        _buildJourneySummary(isReturn),
        // Round trip step indicator
        if (widget.isRoundTrip) _buildStepIndicator(isReturn),
        Expanded(
          child: trains.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.train_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No trains found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different route or date',
                          style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: trains.length,
                  itemBuilder: (ctx, i) => TrainCard(
                    train: trains[i],
                    passengers: widget.passengers,
                    isReturn: isReturn,
                    isLocked: isReturn && !_outboundConfirmed,
                    onSelect: (train) => _handleSelect(train, isReturn),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildJourneySummary(bool isReturn) {
    final from = isReturn ? widget.toStation : widget.fromStation;
    final to = isReturn ? widget.fromStation : widget.toStation;
    final date = isReturn ? widget.returnJourneyDate : widget.journeyDate;
    final cls = isReturn ? widget.returnJourneyClass : widget.travelClass;

    return Container(
      color: const Color(0xFF1A3A6B),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$from → $to',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('$date · $cls · ${widget.passengers} pax',
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Modify', style: TextStyle(color: Color(0xFFE8A838))),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(bool isReturn) {
    return Container(
      color: const Color(0xFFEEF2F7),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _stepDot(1, 'Select Outbound', !isReturn),
          Expanded(child: Container(height: 2, color: _outboundConfirmed ? const Color(0xFF1A3A6B) : Colors.grey[300])),
          _stepDot(2, 'Select Return', isReturn && _outboundConfirmed),
        ],
      ),
    );
  }

  Widget _stepDot(int step, String label, bool active) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1A3A6B) : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text('$step',
                style: TextStyle(
                    color: active ? Colors.white : Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 9, color: active ? const Color(0xFF1A3A6B) : Colors.grey)),
      ],
    );
  }

  void _handleSelect(TrainModel train, bool isReturn) {
    if (!isReturn) {
      // Outbound selected — for round trip, move to return tab
      setState(() {
        _selectedOutbound = train;
        _outboundConfirmed = true;
      });
      if (widget.isRoundTrip) {
        _tabController.animateTo(1);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Outbound train selected! Now choose your return train.'),
            backgroundColor: Color(0xFF1A3A6B),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        _goToSeatSelection(train, isReturn: false);
      }
    } else {
      // Return selected — go to seat selection with both trains
      _goToSeatSelection(train, isReturn: true);
    }
  }

  void _goToSeatSelection(TrainModel train, {required bool isReturn}) {
    Get.to(() => SeatSelectionPage(
          price: train.classes.first.price.toInt(),
          ticketType: train.classes.first.type,
          fromStation: isReturn ? widget.toStation : widget.fromStation,
          toStation: isReturn ? widget.fromStation : widget.toStation,
          travelClass: isReturn ? widget.returnJourneyClass : widget.travelClass,
          journeyDate: isReturn ? widget.returnJourneyDate : widget.journeyDate,
          departureTime: train.departureTime,
          isRoundTrip: widget.isRoundTrip,
          outboundTrain: _selectedOutbound,
          returnTrain: isReturn ? train : null,
          passengers: widget.passengers,
        ));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TRAIN CARD
// ─────────────────────────────────────────────────────────────────────────────
class TrainCard extends StatefulWidget {
  final TrainModel train;
  final int passengers;
  final bool isReturn;
  final bool isLocked;
  final void Function(TrainModel) onSelect;

  const TrainCard({
    super.key,
    required this.train,
    required this.passengers,
    required this.isReturn,
    required this.isLocked,
    required this.onSelect,
  });

  @override
  State<TrainCard> createState() => _TrainCardState();
}

class _TrainCardState extends State<TrainCard> {
  bool _expanded = false;
  bool _showStations = false;
  String? _selectedClass;

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    final t = widget.train;
    return Container(
      margin: EdgeInsets.only(bottom: r.sp12),
      decoration: BoxDecoration(
        color: widget.isLocked ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // Main row
          Padding(
            padding: EdgeInsets.all(r.sp14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.trainName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: r.fs14)),
                          Text('Train #${t.trainCode}',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: r.fs11)),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: r.sp10, vertical: r.sp4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'From ৳${t.classes.map((c) => c.price).reduce((a, b) => a < b ? a : b).toStringAsFixed(0)}',
                        style: TextStyle(
                            color: const Color(0xFFE65100),
                            fontWeight: FontWeight.bold,
                            fontSize: r.fs12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: r.sp12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _timeBlock(r, t.departureTime, t.fromStation),
                    Column(
                      children: [
                        Text(t.duration,
                            style: TextStyle(
                                color: Colors.grey, fontSize: r.fs11)),
                        SizedBox(height: r.sp4),
                        Row(
                          children: [
                            Container(
                                width: 36,
                                height: 1.5,
                                color: Colors.grey[300]),
                            Icon(Icons.train,
                                size: r.fs16,
                                color: const Color(0xFF1A3A6B)),
                            Container(
                                width: 36,
                                height: 1.5,
                                color: Colors.grey[300]),
                          ],
                        ),
                      ],
                    ),
                    _timeBlock(r, t.arrivalTime, t.toStation,
                        alignRight: true),
                  ],
                ),
              ],
            ),
          ),

          // Class selector
          if (!widget.isLocked) ...[
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            // Stations toggle
            if (t.stations.isNotEmpty)
              InkWell(
                onTap: () => setState(() => _showStations = !_showStations),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: r.sp14, vertical: r.sp8),
                  child: Row(
                    children: [
                      Icon(Icons.place_outlined, size: r.fs14, color: Colors.grey[600]),
                      SizedBox(width: r.sp6),
                      Text(
                        '${t.stations.length} Stations',
                        style: TextStyle(fontSize: r.fs12, color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Text(
                        _showStations ? 'Hide' : 'View Route',
                        style: TextStyle(
                            fontSize: r.fs12,
                            color: const Color(0xFF1A3A6B),
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: r.sp4),
                      Icon(
                        _showStations ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: r.fs16,
                        color: const Color(0xFF1A3A6B),
                      ),
                    ],
                  ),
                ),
              ),
            // Station list
            if (_showStations && t.stations.isNotEmpty) ...[
              Container(
                margin: EdgeInsets.fromLTRB(r.sp14, 0, r.sp14, r.sp8),
                padding: EdgeInsets.all(r.sp12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: List.generate(t.stations.length, (i) {
                    final s = t.stations[i];
                    final isFirst = i == 0;
                    final isLast = i == t.stations.length - 1;
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline column
                          SizedBox(
                            width: 24,
                            child: Column(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: const EdgeInsets.only(top: 3),
                                  decoration: BoxDecoration(
                                    color: isFirst
                                        ? const Color(0xFF1A3A6B)
                                        : isLast
                                            ? const Color(0xFFE65100)
                                            : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isFirst
                                          ? const Color(0xFF1A3A6B)
                                          : isLast
                                              ? const Color(0xFFE65100)
                                              : Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                if (!isLast)
                                  Expanded(
                                    child: Container(
                                      width: 2,
                                      color: Colors.grey[300],
                                      margin: const EdgeInsets.symmetric(vertical: 2),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: r.sp8),
                          // Station info
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: isLast ? 0 : r.sp12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.name,
                                    style: TextStyle(
                                      fontSize: r.fs13,
                                      fontWeight: isFirst || isLast
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isFirst
                                          ? const Color(0xFF1A3A6B)
                                          : isLast
                                              ? const Color(0xFFE65100)
                                              : Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: r.sp4),
                                  Row(
                                    children: [
                                      if (s.departureTime != null) ...[
                                        Icon(Icons.arrow_circle_right_outlined,
                                            size: r.fs11, color: Colors.green[600]),
                                        const SizedBox(width: 3),
                                        Text(s.departureTime!,
                                            style: TextStyle(
                                                fontSize: r.fs11,
                                                color: Colors.green[700],
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(width: r.sp8),
                                      ],
                                      if (s.arrivalTime != null && !isFirst) ...[
                                        Icon(Icons.arrow_circle_left_outlined,
                                            size: r.fs11, color: Colors.orange[600]),
                                        const SizedBox(width: 3),
                                        Text(s.arrivalTime!,
                                            style: TextStyle(
                                                fontSize: r.fs11,
                                                color: Colors.orange[700],
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(width: r.sp8),
                                      ],
                                      if (s.haltTime != '0m' && !isFirst && !isLast) ...[
                                        Text('· Halt: ${s.haltTime}',
                                            style: TextStyle(
                                                fontSize: r.fs10,
                                                color: Colors.grey[500])),
                                      ],
                                    ],
                                  ),
                                  if (!isFirst)
                                    Text(
                                      'From start: ${s.duration}',
                                      style: TextStyle(
                                          fontSize: r.fs10,
                                          color: Colors.grey[400]),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: r.sp14, vertical: r.sp10),
                child: Row(
                  children: [
                    Text('Select Class',
                        style: TextStyle(
                            fontSize: r.fs13,
                            color: const Color(0xFF1A3A6B),
                            fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: const Color(0xFF1A3A6B)),
                  ],
                ),
              ),
            ),
            if (_expanded) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(
                    r.sp14, 0, r.sp14, r.sp14),
                child: Column(
                  children: [
                    ...t.classes.map((cls) => _classRow(r, cls)),
                    SizedBox(height: r.sp10),
                    SizedBox(
                      width: double.infinity,
                      height: r.btnH,
                      child: ElevatedButton(
                        onPressed: _selectedClass != null
                            ? () => widget.onSelect(widget.train)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.isReturn
                              ? const Color(0xFFE8A838)
                              : const Color(0xFF1A3A6B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          widget.isReturn
                              ? 'Select Return Train'
                              : 'Select This Train',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: r.fs14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],

          if (widget.isLocked)
            Padding(
              padding: EdgeInsets.all(r.sp12),
              child: Row(
                children: [
                  Icon(Icons.lock_outline, size: r.fs13, color: Colors.grey),
                  SizedBox(width: r.sp6),
                  Text('Select outbound train first',
                      style: TextStyle(
                          color: Colors.grey[500], fontSize: r.fs12)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _timeBlock(R r, String time, String station,
      {bool alignRight = false}) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(time,
            style: TextStyle(
                fontSize: r.fs16, fontWeight: FontWeight.bold)),
        Text(station,
            style: TextStyle(color: Colors.grey, fontSize: r.fs11)),
      ],
    );
  }

  Widget _classRow(R r, TicketClass cls) {
    final selected = _selectedClass == cls.type;
    return GestureDetector(
      onTap: () => setState(() => _selectedClass = cls.type),
      child: Container(
        margin: EdgeInsets.only(bottom: r.sp8),
        padding: EdgeInsets.symmetric(
            horizontal: r.sp12, vertical: r.sp10),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFE8F0FE)
              : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? const Color(0xFF1A3A6B)
                : const Color(0xFFE0E0E0),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: r.fs18,
              color: selected
                  ? const Color(0xFF1A3A6B)
                  : Colors.grey,
            ),
            SizedBox(width: r.sp10),
            Expanded(
              child: Text(cls.type,
                  style: TextStyle(
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: r.fs13)),
            ),
            Text('${cls.availableSeats} seats',
                style: TextStyle(
                    color: Colors.grey, fontSize: r.fs11)),
            SizedBox(width: r.sp12),
            Text('৳${cls.price.toStringAsFixed(0)}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: r.fs14,
                    color: const Color(0xFF1A3A6B))),
          ],
        ),
      ),
    );
  }
}

// Keep TicketType for backward compatibility
class TicketType {
  final String type;
  final double price;
  final int availableSeats;

  const TicketType({required this.type, required this.price, required this.availableSeats});
}
