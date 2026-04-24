// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:amarRailSheba/services/local_data_service.dart';
import 'package:amarRailSheba/utils/responsive.dart';
import 'package:amarRailSheba/Login&Signup/Login.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ADMIN PANEL — tabbed layout
// Tabs: Dashboard | Trains | Bookings | Users | Announcements | Lost & Found
// ─────────────────────────────────────────────────────────────────────────────

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  static const _tabs = [
    Tab(icon: Icon(Icons.dashboard_outlined), text: 'Dashboard'),
    Tab(icon: Icon(Icons.train_outlined), text: 'Trains'),
    Tab(icon: Icon(Icons.confirmation_num_outlined), text: 'Bookings'),
    Tab(icon: Icon(Icons.people_outline), text: 'Users'),
    Tab(icon: Icon(Icons.campaign_outlined), text: 'News'),
    Tab(icon: Icon(Icons.search_outlined), text: 'Lost & Found'),
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.admin_panel_settings, color: Color(0xFFE8A838)),
            SizedBox(width: r.sp8),
            Text('Admin Panel',
                style: TextStyle(
                    fontSize: r.fs16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            tooltip: 'Logout',
            onPressed: () => Get.offAll(() => const Login()),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          indicatorColor: const Color(0xFFE8A838),
          labelColor: const Color(0xFFE8A838),
          unselectedLabelColor: Colors.white54,
          labelStyle: TextStyle(fontSize: r.fs11, fontWeight: FontWeight.bold),
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          _DashboardTab(),
          _TrainsTab(),
          _BookingsTab(),
          _UsersTab(),
          _AnnouncementsTab(),
          _LostFoundTab(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DASHBOARD TAB — real-time stats
// ─────────────────────────────────────────────────────────────────────────────
class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  Stream<Map<String, int>> _statsStream() {
    final db = FirebaseDatabase.instance.ref();
    return Stream.periodic(const Duration(seconds: 3)).asyncMap((_) async {
      final results = await Future.wait([
        db.child('bookings').get(),
        db.child('users').get(),
        db.child('trains').get(),
        db.child('lostFound').get(),
      ]);
      int bookings = 0, users = 0, trains = 0, lostFound = 0;
      if (results[0].exists) bookings = (results[0].value as Map).length;
      if (results[1].exists) users = (results[1].value as Map).length;
      if (results[2].exists) trains = (results[2].value as Map).length;
      if (results[3].exists) lostFound = (results[3].value as Map).length;
      return {'bookings': bookings, 'users': users, 'trains': trains, 'lostFound': lostFound};
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return StreamBuilder<Map<String, int>>(
      stream: _statsStream(),
      builder: (ctx, snap) {
        final stats = snap.data ?? {'bookings': 0, 'users': 0, 'trains': 0, 'lostFound': 0};
        return SingleChildScrollView(
          padding: r.pagePad,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: r.sp8),
                  Row(
                    children: [
                      const Icon(Icons.circle, color: Colors.green, size: 10),
                      SizedBox(width: r.sp6),
                      Text('Live Data', style: TextStyle(color: Colors.green, fontSize: r.fs12)),
                    ],
                  ),
                  SizedBox(height: r.sp16),
                  // Stat cards
                  LayoutBuilder(builder: (ctx2, constraints) {
                    final cols = constraints.maxWidth > 500 ? 4 : 2;
                    return GridView.count(
                      crossAxisCount: cols,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: r.sp12,
                      mainAxisSpacing: r.sp12,
                      childAspectRatio: 1.6,
                      children: [
                        _StatCard('Total Bookings', '${stats['bookings']}', Icons.confirmation_num_outlined, const Color(0xFF1A3A6B)),
                        _StatCard('Registered Users', '${stats['users']}', Icons.people_outline, const Color(0xFF388E3C)),
                        _StatCard('Trains in DB', '${stats['trains']}', Icons.train_outlined, const Color(0xFFE8A838)),
                        _StatCard('Lost & Found', '${stats['lostFound']}', Icons.search_outlined, const Color(0xFFD32F2F)),
                      ],
                    );
                  }),
                  SizedBox(height: r.sp24),
                  Text('Recent Bookings',
                      style: TextStyle(fontSize: r.fs16, fontWeight: FontWeight.bold)),
                  SizedBox(height: r.sp12),
                  const _RecentBookingsList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Container(
      padding: EdgeInsets.all(r.sp14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: r.fs22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(fontSize: r.fs22, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: TextStyle(fontSize: r.fs11, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentBookingsList extends StatelessWidget {
  const _RecentBookingsList();

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('bookings').limitToLast(5).onValue,
      builder: (ctx, snap) {
        if (!snap.hasData || !snap.data!.snapshot.exists) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(r.sp20),
              child: Text('No bookings yet', style: TextStyle(color: Colors.grey, fontSize: r.fs13)),
            ),
          );
        }
        final raw = Map<String, dynamic>.from(snap.data!.snapshot.value as Map);
        final list = raw.entries.map((e) {
          final m = Map<String, dynamic>.from(e.value as Map);
          m['id'] = e.key;
          return m;
        }).toList().reversed.toList();

        return Column(
          children: list.map((b) => _BookingRow(b)).toList(),
        );
      },
    );
  }
}

class _BookingRow extends StatelessWidget {
  final Map<String, dynamic> booking;
  const _BookingRow(this.booking);

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    final status = booking['status'] ?? 'confirmed';
    final statusColor = status == 'confirmed' ? Colors.green : status == 'cancelled' ? Colors.red : Colors.orange;
    return Container(
      margin: EdgeInsets.only(bottom: r.sp8),
      padding: EdgeInsets.all(r.sp12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
          ),
          SizedBox(width: r.sp10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${booking['from'] ?? ''} → ${booking['to'] ?? ''}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs13)),
                Text('${booking['trainName'] ?? ''} · ${booking['date'] ?? ''}',
                    style: TextStyle(color: Colors.grey, fontSize: r.fs11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('৳${(booking['totalAmount'] ?? 0).toStringAsFixed(0)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs13, color: const Color(0xFF1A3A6B))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: r.sp6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: r.fs10)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TRAINS TAB — add / view / delete trains in Firebase
// ─────────────────────────────────────────────────────────────────────────────
class _TrainsTab extends StatefulWidget {
  const _TrainsTab();
  @override
  State<_TrainsTab> createState() => _TrainsTabState();
}

class _TrainsTabState extends State<_TrainsTab> {
  final _db = FirebaseDatabase.instance.ref('trains');
  final _formKey = GlobalKey<FormState>();
  bool _showForm = false;
  bool _saving = false;

  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _deptCtrl = TextEditingController();
  final _arrCtrl = TextEditingController();
  final _durCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String _classType = 'AC';

  @override
  void dispose() {
    for (final c in [_nameCtrl, _codeCtrl, _fromCtrl, _toCtrl, _deptCtrl, _arrCtrl, _durCtrl, _priceCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _saveTrain() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await _db.push().set({
      'trainName': _nameCtrl.text.trim(),
      'trainCode': _codeCtrl.text.trim(),
      'fromStation': _fromCtrl.text.trim(),
      'toStation': _toCtrl.text.trim(),
      'departureTime': _deptCtrl.text.trim(),
      'arrivalTime': _arrCtrl.text.trim(),
      'duration': _durCtrl.text.trim(),
      'classType': _classType,
      'price': double.tryParse(_priceCtrl.text) ?? 0,
      'createdAt': DateTime.now().toIso8601String(),
    });
    setState(() { _saving = false; _showForm = false; });
    for (final c in [_nameCtrl, _codeCtrl, _fromCtrl, _toCtrl, _deptCtrl, _arrCtrl, _durCtrl, _priceCtrl]) {
      c.clear();
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Train added!'), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _deleteTrain(String id) async {
    await _db.child(id).remove();
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Column(
      children: [
        // Add button bar
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: r.sp16, vertical: r.sp10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Trains', style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs15)),
              ElevatedButton.icon(
                onPressed: () => setState(() => _showForm = !_showForm),
                icon: Icon(_showForm ? Icons.close : Icons.add, size: r.fs16),
                label: Text(_showForm ? 'Cancel' : 'Add Train', style: TextStyle(fontSize: r.fs13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3A6B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),

        // Add form
        if (_showForm)
          Container(
            color: const Color(0xFFF0F4F8),
            padding: EdgeInsets.all(r.sp16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(r.sp16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text('New Train', style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs15)),
                          SizedBox(height: r.sp12),
                          Row(children: [
                            Expanded(child: _field(_nameCtrl, 'Train Name', r)),
                            SizedBox(width: r.sp10),
                            Expanded(child: _field(_codeCtrl, 'Train Code', r)),
                          ]),
                          SizedBox(height: r.sp10),
                          Row(children: [
                            Expanded(child: _stationDropdown(_fromCtrl, 'From', r)),
                            SizedBox(width: r.sp10),
                            Expanded(child: _stationDropdown(_toCtrl, 'To', r)),
                          ]),
                          SizedBox(height: r.sp10),
                          Row(children: [
                            Expanded(child: _field(_deptCtrl, 'Departure (e.g. 07:00 AM)', r)),
                            SizedBox(width: r.sp10),
                            Expanded(child: _field(_arrCtrl, 'Arrival (e.g. 01:30 PM)', r)),
                          ]),
                          SizedBox(height: r.sp10),
                          Row(children: [
                            Expanded(child: _field(_durCtrl, 'Duration (e.g. 6h 30m)', r)),
                            SizedBox(width: r.sp10),
                            Expanded(child: _field(_priceCtrl, 'Base Price (৳)', r, isNumber: true)),
                          ]),
                          SizedBox(height: r.sp10),
                          DropdownButtonFormField<String>(
                            value: _classType,
                            decoration: InputDecoration(
                              labelText: 'Class Type',
                              labelStyle: TextStyle(fontSize: r.fs13),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              contentPadding: EdgeInsets.symmetric(horizontal: r.sp12, vertical: r.sp10),
                            ),
                            items: ['AC', 'Snigdha', 'S_Chair', 'Shulov']
                                .map((c) => DropdownMenuItem(value: c, child: Text(c, style: TextStyle(fontSize: r.fs13))))
                                .toList(),
                            onChanged: (v) => setState(() => _classType = v!),
                          ),
                          SizedBox(height: r.sp16),
                          SizedBox(
                            width: double.infinity,
                            height: r.btnH,
                            child: ElevatedButton(
                              onPressed: _saving ? null : _saveTrain,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A3A6B),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: _saving
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : Text('Save Train', style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs14)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Train list (real-time)
        Expanded(
          child: StreamBuilder<DatabaseEvent>(
            stream: _db.onValue,
            builder: (ctx, snap) {
              if (!snap.hasData || !snap.data!.snapshot.exists) {
                return Center(child: Text('No trains added yet', style: TextStyle(color: Colors.grey, fontSize: r.fs13)));
              }
              final raw = Map<String, dynamic>.from(snap.data!.snapshot.value as Map);
              final trains = raw.entries.map((e) {
                final m = Map<String, dynamic>.from(e.value as Map);
                m['id'] = e.key;
                return m;
              }).toList();

              return ListView.builder(
                padding: EdgeInsets.all(r.sp12),
                itemCount: trains.length,
                itemBuilder: (ctx2, i) {
                  final t = trains[i];
                  return Card(
                    margin: EdgeInsets.only(bottom: r.sp8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(r.sp8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A3A6B).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.train, color: const Color(0xFF1A3A6B), size: r.fs20),
                      ),
                      title: Text('${t['trainName'] ?? ''} (${t['trainCode'] ?? ''})',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs13)),
                      subtitle: Text(
                          '${t['fromStation'] ?? ''} → ${t['toStation'] ?? ''} · ${t['departureTime'] ?? ''}',
                          style: TextStyle(fontSize: r.fs11, color: Colors.grey)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('৳${(t['price'] ?? 0).toStringAsFixed(0)}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs13, color: const Color(0xFF1A3A6B))),
                          SizedBox(width: r.sp8),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red, size: r.fs18),
                            onPressed: () => _deleteTrain(t['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _field(TextEditingController ctrl, String label, R r, {bool isNumber = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(fontSize: r.fs13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: r.fs12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: r.sp10, vertical: r.sp10),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
    );
  }

  Widget _stationDropdown(TextEditingController ctrl, String label, R r) {
    return DropdownButtonFormField<String>(
      value: ctrl.text.isEmpty ? null : ctrl.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: r.fs12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: r.sp10, vertical: r.sp10),
      ),
      isExpanded: true,
      items: LocalDataService.stations
          .map((s) => DropdownMenuItem(value: s, child: Text(s, style: TextStyle(fontSize: r.fs12))))
          .toList(),
      onChanged: (v) => setState(() => ctrl.text = v ?? ''),
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOOKINGS TAB — real-time all bookings, cancel/confirm
// ─────────────────────────────────────────────────────────────────────────────
class _BookingsTab extends StatefulWidget {
  const _BookingsTab();
  @override
  State<_BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends State<_BookingsTab> {
  String _filter = 'all'; // all | confirmed | cancelled

  Future<void> _updateStatus(String id, String status) async {
    await FirebaseDatabase.instance.ref('bookings/$id').update({'status': status});
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Column(
      children: [
        // Filter bar
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: r.sp16, vertical: r.sp10),
          child: Row(
            children: [
              Text('Filter: ', style: TextStyle(fontSize: r.fs13, color: Colors.grey)),
              SizedBox(width: r.sp8),
              ...[('all', 'All'), ('confirmed', 'Confirmed'), ('cancelled', 'Cancelled')]
                  .map((f) => Padding(
                        padding: EdgeInsets.only(right: r.sp8),
                        child: ChoiceChip(
                          label: Text(f.$2, style: TextStyle(fontSize: r.fs12)),
                          selected: _filter == f.$1,
                          selectedColor: const Color(0xFF1A3A6B),
                          labelStyle: TextStyle(
                              color: _filter == f.$1 ? Colors.white : Colors.black87,
                              fontSize: r.fs12),
                          onSelected: (_) => setState(() => _filter = f.$1),
                        ),
                      )),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<DatabaseEvent>(
            stream: FirebaseDatabase.instance.ref('bookings').onValue,
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snap.hasData || !snap.data!.snapshot.exists) {
                return Center(child: Text('No bookings found', style: TextStyle(color: Colors.grey, fontSize: r.fs13)));
              }
              final raw = Map<String, dynamic>.from(snap.data!.snapshot.value as Map);
              var list = raw.entries.map((e) {
                final m = Map<String, dynamic>.from(e.value as Map);
                m['id'] = e.key;
                return m;
              }).toList();

              if (_filter != 'all') {
                list = list.where((b) => b['status'] == _filter).toList();
              }
              list.sort((a, b) => (b['createdAt'] ?? '').compareTo(a['createdAt'] ?? ''));

              return ListView.builder(
                padding: EdgeInsets.all(r.sp12),
                itemCount: list.length,
                itemBuilder: (ctx2, i) {
                  final b = list[i];
                  final status = b['status'] ?? 'confirmed';
                  final statusColor = status == 'confirmed' ? Colors.green : Colors.red;
                  return Card(
                    margin: EdgeInsets.only(bottom: r.sp8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(r.sp12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text('${b['from'] ?? ''} → ${b['to'] ?? ''}',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs14)),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: r.sp8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(status, style: TextStyle(color: statusColor, fontSize: r.fs11)),
                              ),
                            ],
                          ),
                          SizedBox(height: r.sp6),
                          Row(
                            children: [
                              Icon(Icons.train, size: r.fs13, color: Colors.grey),
                              SizedBox(width: r.sp4),
                              Text('${b['trainName'] ?? ''}', style: TextStyle(fontSize: r.fs12, color: Colors.grey)),
                              SizedBox(width: r.sp12),
                              Icon(Icons.calendar_today, size: r.fs13, color: Colors.grey),
                              SizedBox(width: r.sp4),
                              Text('${b['date'] ?? ''}', style: TextStyle(fontSize: r.fs12, color: Colors.grey)),
                              SizedBox(width: r.sp12),
                              Icon(Icons.chair_outlined, size: r.fs13, color: Colors.grey),
                              SizedBox(width: r.sp4),
                              Text('${b['class'] ?? ''}', style: TextStyle(fontSize: r.fs12, color: Colors.grey)),
                            ],
                          ),
                          SizedBox(height: r.sp8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('৳${(b['totalAmount'] ?? 0).toStringAsFixed(0)}',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs15, color: const Color(0xFF1A3A6B))),
                              Row(
                                children: [
                                  if (status != 'confirmed')
                                    TextButton(
                                      onPressed: () => _updateStatus(b['id'], 'confirmed'),
                                      child: Text('Confirm', style: TextStyle(color: Colors.green, fontSize: r.fs12)),
                                    ),
                                  if (status != 'cancelled')
                                    TextButton(
                                      onPressed: () => _updateStatus(b['id'], 'cancelled'),
                                      child: Text('Cancel', style: TextStyle(color: Colors.red, fontSize: r.fs12)),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// USERS TAB — real-time user list
// ─────────────────────────────────────────────────────────────────────────────
class _UsersTab extends StatelessWidget {
  const _UsersTab();

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance.ref('users').onValue,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snap.hasData || !snap.data!.snapshot.exists) {
          return Center(child: Text('No users found', style: TextStyle(color: Colors.grey, fontSize: r.fs13)));
        }
        final raw = Map<String, dynamic>.from(snap.data!.snapshot.value as Map);
        final users = raw.entries.map((e) {
          final m = Map<String, dynamic>.from(e.value as Map);
          m['uid'] = e.key;
          return m;
        }).toList();

        return Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: r.sp16, vertical: r.sp12),
              child: Row(
                children: [
                  Icon(Icons.people, color: const Color(0xFF1A3A6B), size: r.fs18),
                  SizedBox(width: r.sp8),
                  Text('${users.length} Registered Users',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs14)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(r.sp12),
                itemCount: users.length,
                itemBuilder: (ctx2, i) {
                  final u = users[i];
                  return Card(
                    margin: EdgeInsets.only(bottom: r.sp8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF1A3A6B).withValues(alpha: 0.1),
                        child: Text(
                          (u['name'] ?? 'U').substring(0, 1).toUpperCase(),
                          style: TextStyle(color: const Color(0xFF1A3A6B), fontWeight: FontWeight.bold, fontSize: r.fs14),
                        ),
                      ),
                      title: Text(u['name'] ?? 'Unknown',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs13)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u['email'] ?? '', style: TextStyle(fontSize: r.fs11, color: Colors.grey)),
                          if (u['phone'] != null)
                            Text(u['phone'], style: TextStyle(fontSize: r.fs11, color: Colors.grey)),
                        ],
                      ),
                      trailing: Text(
                        u['createdAt'] != null
                            ? u['createdAt'].toString().substring(0, 10)
                            : '',
                        style: TextStyle(fontSize: r.fs10, color: Colors.grey),
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ANNOUNCEMENTS TAB — post / delete announcements (real-time)
// ─────────────────────────────────────────────────────────────────────────────
class _AnnouncementsTab extends StatefulWidget {
  const _AnnouncementsTab();
  @override
  State<_AnnouncementsTab> createState() => _AnnouncementsTabState();
}

class _AnnouncementsTabState extends State<_AnnouncementsTab> {
  final _db = FirebaseDatabase.instance.ref('announcements');
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  String _category = 'Schedule Updates';
  bool _pinned = false;
  bool _saving = false;
  bool _showForm = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    if (_titleCtrl.text.isEmpty || _bodyCtrl.text.isEmpty) return;
    setState(() => _saving = true);
    await _db.push().set({
      'title': _titleCtrl.text.trim(),
      'description': _bodyCtrl.text.trim(),
      'category': _category,
      'pinned': _pinned,
      'timestamp': DateTime.now().toIso8601String(),
    });
    _titleCtrl.clear();
    _bodyCtrl.clear();
    setState(() { _saving = false; _showForm = false; });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement posted!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: r.sp16, vertical: r.sp10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Announcements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs15)),
              ElevatedButton.icon(
                onPressed: () => setState(() => _showForm = !_showForm),
                icon: Icon(_showForm ? Icons.close : Icons.add, size: r.fs16),
                label: Text(_showForm ? 'Cancel' : 'Post', style: TextStyle(fontSize: r.fs13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3A6B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        if (_showForm)
          Container(
            color: const Color(0xFFF0F4F8),
            padding: EdgeInsets.all(r.sp16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(r.sp16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleCtrl,
                          style: TextStyle(fontSize: r.fs13),
                          decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: TextStyle(fontSize: r.fs13),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        SizedBox(height: r.sp10),
                        TextField(
                          controller: _bodyCtrl,
                          maxLines: 3,
                          style: TextStyle(fontSize: r.fs13),
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(fontSize: r.fs13),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        SizedBox(height: r.sp10),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _category,
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  labelStyle: TextStyle(fontSize: r.fs12),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: r.sp10, vertical: r.sp10),
                                ),
                                items: ['Schedule Updates', 'Promotions', 'Safety Alerts', 'Service Enhancements']
                                    .map((c) => DropdownMenuItem(value: c, child: Text(c, style: TextStyle(fontSize: r.fs12))))
                                    .toList(),
                                onChanged: (v) => setState(() => _category = v!),
                              ),
                            ),
                            SizedBox(width: r.sp12),
                            Row(
                              children: [
                                Checkbox(value: _pinned, onChanged: (v) => setState(() => _pinned = v!)),
                                Text('Pin', style: TextStyle(fontSize: r.fs13)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: r.sp12),
                        SizedBox(
                          width: double.infinity,
                          height: r.btnH,
                          child: ElevatedButton(
                            onPressed: _saving ? null : _post,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A3A6B),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: _saving
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Text('Post Announcement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs14)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        Expanded(
          child: StreamBuilder<DatabaseEvent>(
            stream: _db.onValue,
            builder: (ctx, snap) {
              if (!snap.hasData || !snap.data!.snapshot.exists) {
                return Center(child: Text('No announcements yet', style: TextStyle(color: Colors.grey, fontSize: r.fs13)));
              }
              final raw = Map<String, dynamic>.from(snap.data!.snapshot.value as Map);
              final list = raw.entries.map((e) {
                final m = Map<String, dynamic>.from(e.value as Map);
                m['id'] = e.key;
                return m;
              }).toList()
                ..sort((a, b) => (b['timestamp'] ?? '').compareTo(a['timestamp'] ?? ''));

              return ListView.builder(
                padding: EdgeInsets.all(r.sp12),
                itemCount: list.length,
                itemBuilder: (ctx2, i) {
                  final a = list[i];
                  final pinned = a['pinned'] == true;
                  return Card(
                    margin: EdgeInsets.only(bottom: r.sp8),
                    color: pinned ? const Color(0xFFFFF3E0) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: pinned ? const BorderSide(color: Color(0xFFE8A838)) : BorderSide.none,
                    ),
                    child: ListTile(
                      leading: Icon(
                        pinned ? Icons.push_pin : Icons.campaign_outlined,
                        color: pinned ? const Color(0xFFE8A838) : const Color(0xFF1A3A6B),
                        size: r.fs20,
                      ),
                      title: Text(a['title'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs13)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a['description'] ?? '', style: TextStyle(fontSize: r.fs12)),
                          SizedBox(height: r.sp4),
                          Text(a['category'] ?? '',
                              style: TextStyle(fontSize: r.fs11, color: Colors.grey)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red, size: r.fs18),
                        onPressed: () => _db.child(a['id']).remove(),
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOST & FOUND TAB — view reports, update status
// ─────────────────────────────────────────────────────────────────────────────
class _LostFoundTab extends StatefulWidget {
  const _LostFoundTab();
  @override
  State<_LostFoundTab> createState() => _LostFoundTabState();
}

class _LostFoundTabState extends State<_LostFoundTab> {
  String _filter = 'all'; // all | lost | found

  Future<void> _updateStatus(String id, String status) async {
    await FirebaseDatabase.instance.ref('lostFound/$id').update({'status': status});
  }

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: r.sp16, vertical: r.sp10),
          child: Row(
            children: [
              Text('Filter: ', style: TextStyle(fontSize: r.fs13, color: Colors.grey)),
              SizedBox(width: r.sp8),
              ...[('all', 'All'), ('lost', 'Lost'), ('found', 'Found')]
                  .map((f) => Padding(
                        padding: EdgeInsets.only(right: r.sp8),
                        child: ChoiceChip(
                          label: Text(f.$2, style: TextStyle(fontSize: r.fs12)),
                          selected: _filter == f.$1,
                          selectedColor: const Color(0xFF1A3A6B),
                          labelStyle: TextStyle(
                              color: _filter == f.$1 ? Colors.white : Colors.black87,
                              fontSize: r.fs12),
                          onSelected: (_) => setState(() => _filter = f.$1),
                        ),
                      )),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<DatabaseEvent>(
            stream: FirebaseDatabase.instance.ref('lostFound').onValue,
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snap.hasData || !snap.data!.snapshot.exists) {
                return Center(child: Text('No reports yet', style: TextStyle(color: Colors.grey, fontSize: r.fs13)));
              }
              final raw = Map<String, dynamic>.from(snap.data!.snapshot.value as Map);
              var list = raw.entries.map((e) {
                final m = Map<String, dynamic>.from(e.value as Map);
                m['id'] = e.key;
                return m;
              }).toList();

              if (_filter != 'all') {
                list = list.where((item) => item['type'] == _filter).toList();
              }
              list.sort((a, b) => (b['createdAt'] ?? '').compareTo(a['createdAt'] ?? ''));

              return ListView.builder(
                padding: EdgeInsets.all(r.sp12),
                itemCount: list.length,
                itemBuilder: (ctx2, i) {
                  final item = list[i];
                  final type = item['type'] ?? 'lost';
                  final status = item['status'] ?? 'open';
                  final typeColor = type == 'lost' ? Colors.red : Colors.green;
                  final statusColor = status == 'open' ? Colors.orange : Colors.green;

                  return Card(
                    margin: EdgeInsets.only(bottom: r.sp8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(r.sp12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: r.sp8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: typeColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(type.toUpperCase(),
                                    style: TextStyle(color: typeColor, fontSize: r.fs10, fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(width: r.sp8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: r.sp8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(status,
                                    style: TextStyle(color: statusColor, fontSize: r.fs10)),
                              ),
                              const Spacer(),
                              Text(
                                item['createdAt'] != null ? item['createdAt'].toString().substring(0, 10) : '',
                                style: TextStyle(fontSize: r.fs10, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(height: r.sp8),
                          Text(item['itemName'] ?? 'Unknown Item',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs13)),
                          if (item['description'] != null)
                            Text(item['description'], style: TextStyle(fontSize: r.fs12, color: Colors.grey)),
                          if (item['trainDetails'] != null)
                            Padding(
                              padding: EdgeInsets.only(top: r.sp4),
                              child: Row(
                                children: [
                                  Icon(Icons.train, size: r.fs12, color: Colors.grey),
                                  SizedBox(width: r.sp4),
                                  Text(item['trainDetails'], style: TextStyle(fontSize: r.fs11, color: Colors.grey)),
                                ],
                              ),
                            ),
                          SizedBox(height: r.sp8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (status == 'open')
                                TextButton(
                                  onPressed: () => _updateStatus(item['id'], 'resolved'),
                                  child: Text('Mark Resolved', style: TextStyle(color: Colors.green, fontSize: r.fs12)),
                                ),
                              if (status == 'resolved')
                                TextButton(
                                  onPressed: () => _updateStatus(item['id'], 'open'),
                                  child: Text('Reopen', style: TextStyle(color: Colors.orange, fontSize: r.fs12)),
                                ),
                              TextButton(
                                onPressed: () => FirebaseDatabase.instance.ref('lostFound/${item['id']}').remove(),
                                child: Text('Delete', style: TextStyle(color: Colors.red, fontSize: r.fs12)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
