// ignore_for_file: camel_case_types, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amarRailSheba/All%20Feautures/Emergencies/emergencies.dart';
import 'package:amarRailSheba/All%20Feautures/Maintainence/LostAndFound.dart';
import 'package:amarRailSheba/All%20Feautures/Maintainence/about.dart';
import 'package:amarRailSheba/All%20Feautures/Maintainence/privacy%20&%20policy.dart';
import 'package:amarRailSheba/All%20Feautures/Tracking%20or%20live%20locations/Live_location.dart';
import 'package:amarRailSheba/All%20Feautures/second%20pagee/Book_page_after_search.dart';
import 'package:amarRailSheba/Info%20page/Announcement.dart';
import 'package:amarRailSheba/Info%20page/TrainInfo.dart';
import 'package:amarRailSheba/Info%20page/ratings&review.dart';
import 'package:amarRailSheba/profileBar.dart';
import 'package:amarRailSheba/services/local_data_service.dart';
import 'package:amarRailSheba/utils/responsive.dart';
import '../../ADMIN/ticketUpcoming.dart';
import '../../ADMIN/adminPage.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const RailwayBookingPage(),
    UpcomingTicket(),
    const ProfileBar(loggedIn: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 59,
          decoration: BoxDecoration(
            color: const Color(0xFF0A1628).withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black26, offset: Offset(0, 5), blurRadius: 20),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              selectedItemColor: Colors.white,
              unselectedItemColor: const Color(0xFFE8A838),
              showSelectedLabels: true,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.confirmation_num_outlined), label: 'My Tickets'),
                BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'My Account'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GOZAYAAN-STYLE BOOKING PAGE
// ─────────────────────────────────────────────────────────────────────────────
class RailwayBookingPage extends StatefulWidget {
  const RailwayBookingPage({super.key});
  @override
  _RailwayBookingPageState createState() => _RailwayBookingPageState();
}

class _RailwayBookingPageState extends State<RailwayBookingPage> {
  // Trip type: 0 = One Way, 1 = Round Trip
  int _tripType = 0;

  // Outbound
  String? _fromStation;
  String? _toStation;
  DateTime? _departDate;
  String _travelClass = 'AC';
  int _passengers = 1;

  // Return (Round Trip only)
  DateTime? _returnDate;
  String _returnClass = 'AC';

  final List<String> _stations = LocalDataService.stations;
  final List<String> _classes = LocalDataService.travelClasses;

  // ── helpers ──────────────────────────────────────────────────────────────
  String _fmt(DateTime? d) =>
      d == null ? 'Select Date' : '${d.day} ${_monthName(d.month)} ${d.year}';

  String _monthName(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];

  Future<void> _pickDate(bool isReturn) async {
    final now = DateTime.now();
    final first = isReturn ? (_departDate ?? now) : now;
    final picked = await showDatePicker(
      context: context,
      initialDate: first,
      firstDate: first,
      lastDate: now.add(const Duration(days: 90)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1A3A6B)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isReturn) {
          _returnDate = picked;
        } else {
          _departDate = picked;
          if (_returnDate != null && _returnDate!.isBefore(picked)) {
            _returnDate = null;
          }
        }
      });
    }
  }

  void _swapStations() {
    setState(() {
      final tmp = _fromStation;
      _fromStation = _toStation;
      _toStation = tmp;
    });
  }

  void _search() {
    if (_fromStation == null || _toStation == null) {
      _snack('Please select From and To stations');
      return;
    }
    if (_fromStation == _toStation) {
      _snack('From and To stations cannot be the same');
      return;
    }
    if (_departDate == null) {
      _snack('Please select a journey date');
      return;
    }
    if (_tripType == 1 && _returnDate == null) {
      _snack('Please select a return date');
      return;
    }

    Get.to(() => TrainSearchPage(
          fromStation: _fromStation!,
          toStation: _toStation!,
          travelClass: _travelClass,
          journeyDate: _departDate!.toIso8601String().split('T')[0],
          passengers: _passengers,
          isRoundTrip: _tripType == 1,
          returnFromStation: _tripType == 1 ? _toStation! : '',
          returnToStation: _tripType == 1 ? _fromStation! : '',
          returnJourneyDate: _tripType == 1
              ? (_returnDate?.toIso8601String().split('T')[0] ?? '')
              : '',
          returnJourneyClass: _tripType == 1 ? _returnClass : '',
        ));
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: const Color(0xFF1A3A6B)),
    );
  }

  // ── build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/trainBackgrong/05.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: const Color(0xFF0A1628).withOpacity(0.72)),

          SafeArea(
            child: ListView(
              padding: R.of(context).pagePad,
              children: [
                _buildTopBar(),
                const SizedBox(height: 24),
                _buildHeroText(),
                const SizedBox(height: 20),
                _buildBookingCard(),
                const SizedBox(height: 24),
                _buildQuickLinks(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── top bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: () => Get.to(() => const LiveLocation()),
              icon: const Icon(Icons.location_on, color: Colors.white70, size: 18),
              label: const Text('Live', style: TextStyle(color: Colors.white70)),
            ),
            IconButton(
              icon: const Icon(Icons.railway_alert, color: Colors.white70),
              onPressed: () => Get.to(() => EmergencyScreen(user: User('defaultUser'))),
            ),
          ],
        ),
      ],
    );
  }

  // ── hero text ─────────────────────────────────────────────────────────────
  Widget _buildHeroText() {
    final r = R.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bangladesh Railway',
          style: TextStyle(
              color: Colors.white,
              fontSize: r.fs28,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: r.sp6),
        Text(
          'Book train tickets easily — one way or round trip',
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8), fontSize: r.fs13),
        ),
      ],
    );
  }

  // ── main booking card ─────────────────────────────────────────────────────
  Widget _buildBookingCard() {
    final r = R.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 8)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTripTypeTabs(),
              Padding(
                padding: EdgeInsets.fromLTRB(r.sp16, r.sp12, r.sp16, r.sp16),
                child: Column(
                  children: [
                    _buildRouteLabel('Outbound Journey', Icons.train, const Color(0xFF1A3A6B)),
                    SizedBox(height: r.sp10),
                    _buildRouteRow(
                      fromValue: _fromStation,
                      toValue: _toStation,
                      onFromChanged: (v) => setState(() => _fromStation = v),
                      onToChanged: (v) => setState(() => _toStation = v),
                      onSwap: _swapStations,
                    ),
                    SizedBox(height: r.sp12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateTile(
                            label: 'Departure',
                            value: _fmt(_departDate),
                            icon: Icons.calendar_today,
                            onTap: () => _pickDate(false),
                          ),
                        ),
                        SizedBox(width: r.sp10),
                        Expanded(
                            child: _buildClassDropdown(
                                _travelClass,
                                (v) => setState(() => _travelClass = v!))),
                      ],
                    ),
                    if (_tripType == 1) ...[
                      SizedBox(height: r.sp16),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      SizedBox(height: r.sp16),
                      _buildRouteLabel('Return Journey', Icons.swap_horiz, const Color(0xFFE8A838)),
                      SizedBox(height: r.sp10),
                      _buildRouteRow(
                        fromValue: _toStation,
                        toValue: _fromStation,
                        onFromChanged: null,
                        onToChanged: null,
                        onSwap: null,
                        locked: true,
                      ),
                      SizedBox(height: r.sp12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateTile(
                              label: 'Return Date',
                              value: _fmt(_returnDate),
                              icon: Icons.calendar_today,
                              onTap: () => _pickDate(true),
                              accent: const Color(0xFFE8A838),
                            ),
                          ),
                          SizedBox(width: r.sp10),
                          Expanded(
                              child: _buildClassDropdown(
                                  _returnClass,
                                  (v) => setState(() => _returnClass = v!),
                                  accent: const Color(0xFFE8A838))),
                        ],
                      ),
                    ],
                    SizedBox(height: r.sp14),
                    _buildPassengerRow(),
                    SizedBox(height: r.sp16),
                    SizedBox(
                      width: double.infinity,
                      height: r.btnH,
                      child: ElevatedButton.icon(
                        onPressed: _search,
                        icon: const Icon(Icons.search, color: Colors.white),
                        label: Text(
                          _tripType == 0 ? 'Search Trains' : 'Search Round Trip',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: r.fs15,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A3A6B),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── trip type tabs ────────────────────────────────────────────────────────
  Widget _buildTripTypeTabs() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          _tripTab(0, 'One Way', Icons.arrow_forward),
          _tripTab(1, 'Round Trip', Icons.swap_horiz),
        ],
      ),
    );
  }

  Widget _tripTab(int index, String label, IconData icon) {
    final selected = _tripType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tripType = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1A3A6B) : Colors.transparent,
            borderRadius: index == 0
                ? const BorderRadius.only(topLeft: Radius.circular(16))
                : const BorderRadius.only(topRight: Radius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: selected ? Colors.white : Colors.grey),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey[600],
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── route label ───────────────────────────────────────────────────────────
  Widget _buildRouteLabel(String text, IconData icon, Color color) {
    final r = R.of(context);
    return Row(
      children: [
        Icon(icon, size: r.fs16, color: color),
        SizedBox(width: r.sp6),
        Text(text,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: r.fs13)),
      ],
    );
  }

  // ── from / to row ─────────────────────────────────────────────────────────
  Widget _buildRouteRow({
    required String? fromValue,
    required String? toValue,
    required ValueChanged<String?>? onFromChanged,
    required ValueChanged<String?>? onToChanged,
    required VoidCallback? onSwap,
    bool locked = false,
  }) {
    final r = R.of(context);
    return Row(
      children: [
        Expanded(
          child: _buildStationDropdown(
            label: 'From',
            value: fromValue,
            onChanged: locked ? null : onFromChanged,
            icon: Icons.radio_button_checked,
          ),
        ),
        GestureDetector(
          onTap: locked ? null : onSwap,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: r.sp6),
            padding: EdgeInsets.all(r.sp6),
            decoration: BoxDecoration(
              color: locked ? Colors.grey[200] : const Color(0xFF1A3A6B),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.swap_horiz,
                color: locked ? Colors.grey : Colors.white, size: r.fs18),
          ),
        ),
        Expanded(
          child: _buildStationDropdown(
            label: 'To',
            value: toValue,
            onChanged: locked ? null : onToChanged,
            icon: Icons.location_on,
          ),
        ),
      ],
    );
  }

  // ── station dropdown ──────────────────────────────────────────────────────
  Widget _buildStationDropdown({
    required String label,
    required String? value,
    required ValueChanged<String?>? onChanged,
    required IconData icon,
  }) {
    final r = R.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.sp10, vertical: r.sp4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDDE2EC), width: 1.5),
        borderRadius: BorderRadius.circular(10),
        color: onChanged == null ? const Color(0xFFF5F7FA) : Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Row(
            children: [
              Icon(icon, size: r.fs13, color: Colors.grey),
              SizedBox(width: r.sp4),
              Text(label,
                  style: TextStyle(color: Colors.grey, fontSize: r.fs12)),
            ],
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, size: r.fs18, color: Colors.grey),
          style: TextStyle(fontSize: r.fs13, color: Colors.black87),
          items: _stations
              .map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s, style: TextStyle(fontSize: r.fs13))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ── date tile ─────────────────────────────────────────────────────────────
  Widget _buildDateTile({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    Color accent = const Color(0xFF1A3A6B),
  }) {
    final r = R.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: r.sp10, vertical: r.sp10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDDE2EC), width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: r.fs15, color: accent),
            SizedBox(width: r.sp6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(fontSize: r.fs10, color: Colors.grey)),
                  Text(value,
                      style: TextStyle(
                          fontSize: r.fs12, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── class dropdown ────────────────────────────────────────────────────────
  Widget _buildClassDropdown(String value, ValueChanged<String?> onChanged,
      {Color accent = const Color(0xFF1A3A6B)}) {
    final r = R.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.sp10, vertical: r.sp4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDDE2EC), width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, size: r.fs18, color: accent),
          style: TextStyle(fontSize: r.fs13, color: Colors.black87),
          items: _classes
              .map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c, style: TextStyle(fontSize: r.fs13))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ── passenger row ─────────────────────────────────────────────────────────
  Widget _buildPassengerRow() {
    final r = R.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.sp12, vertical: r.sp10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDDE2EC), width: 1.5),
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF9FAFB),
      ),
      child: Row(
        children: [
          Icon(Icons.people_outline, size: r.fs18, color: const Color(0xFF1A3A6B)),
          SizedBox(width: r.sp8),
          Text('Passengers',
              style: TextStyle(fontSize: r.fs13, color: Colors.grey)),
          const Spacer(),
          IconButton(
            onPressed: _passengers > 1 ? () => setState(() => _passengers--) : null,
            icon: Icon(Icons.remove_circle_outline, size: r.fs20),
            color: const Color(0xFF1A3A6B),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.sp12),
            child: Text('$_passengers',
                style: TextStyle(
                    fontSize: r.fs16, fontWeight: FontWeight.bold)),
          ),
          IconButton(
            onPressed: _passengers < 4 ? () => setState(() => _passengers++) : null,
            icon: Icon(Icons.add_circle_outline, size: r.fs20),
            color: const Color(0xFF1A3A6B),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // ── quick links ───────────────────────────────────────────────────────────
  Widget _buildQuickLinks() {
    final r = R.of(context);
    final items = [
      {'icon': Icons.train, 'label': 'Train Info', 'page': () => const TrainListPage()},
      {'icon': Icons.search, 'label': 'Lost & Found', 'page': () => const LostAndFoundPage()},
      {'icon': Icons.star_outline, 'label': 'Reviews', 'page': () => const RatingsReviewsPage()},
      {'icon': Icons.campaign_outlined, 'label': 'News', 'page': () => const AnnouncementPage()},
    ];
    return GridView.count(
      crossAxisCount: r.quickLinkCols > 4 ? 4 : 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((item) {
        return GestureDetector(
          onTap: () => Get.to(item['page'] as Widget Function()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(r.sp12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item['icon'] as IconData,
                    color: Colors.white, size: r.fs22),
              ),
              SizedBox(height: r.sp6),
              Text(item['label'] as String,
                  style: TextStyle(
                      color: Colors.white70, fontSize: r.fs11)),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── drawer ────────────────────────────────────────────────────────────────
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0A1628)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage('assets/trainBackgrong/12.png'),
                ),
                SizedBox(height: 10),
                Text('Amar Rail Sheba', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _drawerItem(Icons.train, 'Train Information', () => Get.to(() => const TrainListPage())),
          _drawerItem(Icons.search, 'Lost & Found', () => Get.to(() => const LostAndFoundPage())),
          _drawerItem(Icons.star_outline, 'Ratings & Reviews', () => Get.to(() => const RatingsReviewsPage())),
          _drawerItem(Icons.campaign_outlined, 'Announcements', () => Get.to(() => const AnnouncementPage())),
          _drawerItem(Icons.privacy_tip_outlined, 'Privacy & Policy', () => Get.to(() => const PrivacyPolicyPage())),
          _drawerItem(Icons.info_outline, 'About', () => Get.to(() => const DeveloperInfoDialog())),
          _drawerItem(Icons.admin_panel_settings, 'Admin', () => Get.to(() => const AdminPage())),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1A3A6B)),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
