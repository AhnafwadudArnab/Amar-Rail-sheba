import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:amarRailSheba/All%20Feautures/firstpage/booking.dart';
import 'package:amarRailSheba/services/firebase_service.dart';

import 'pdf_download_stub.dart'
    if (dart.library.html) 'pdf_download_web.dart'
    if (dart.library.io) 'pdf_download_mobile.dart';

// ─────────────────────────────────────────────────────────────────────────────
// My Tickets Page — monthly grouped, Firebase-backed
// ─────────────────────────────────────────────────────────────────────────────
class UpcomingTicket extends StatefulWidget {
  UpcomingTicket({super.key});

  @override
  State<UpcomingTicket> createState() => _UpcomingTicketState();
}

class _UpcomingTicketState extends State<UpcomingTicket> {
  List<Map<String, dynamic>> _tickets = [];
  bool _loading = true;

  static const _red = Color(0xFF2E7D32);

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    final bookings = await FirebaseService().getMyBookings();
    if (mounted) setState(() { _tickets = bookings; _loading = false; });
  }

  // Returns how many tickets bought in the current week (Mon–Sun)
  int _ticketsThisWeek() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDay = DateTime(weekStart.year, weekStart.month, weekStart.day);
    return _tickets.where((t) {
      final raw = t['createdAt'] as String? ?? '';
      final dt = DateTime.tryParse(raw);
      return dt != null && !dt.isBefore(weekStartDay);
    }).length;
  }

  // Check limit before navigating to booking — call this from outside if needed
  static Future<bool> canBookThisWeek(List<Map<String, dynamic>> tickets) async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDay = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final count = tickets.where((t) {
      final raw = t['createdAt'] as String? ?? '';
      final dt = DateTime.tryParse(raw);
      return dt != null && !dt.isBefore(weekStartDay);
    }).length;
    return count < 4;
  }

  // Group tickets by "Month Year" from the 'createdAt' or 'date' field
  Map<String, List<Map<String, dynamic>>> get _grouped {
    final Map<String, List<Map<String, dynamic>>> map = {};
    for (final t in _tickets) {
      final raw = t['createdAt'] as String? ?? t['date'] as String? ?? '';
      final dt = DateTime.tryParse(raw) ?? DateTime.now();
      final key = _monthYear(dt);
      map.putIfAbsent(key, () => []).add(t);
    }
    return map;
  }

  String _monthYear(DateTime d) {
    const months = ['', 'January', 'February', 'March', 'April', 'May',
      'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[d.month]} ${d.year}';
  }

  Future<void> _download(BuildContext ctx, Map<String, dynamic> t) async {
    final seats = _seats(t);
    try {
      final pdfBytes = await _buildPdf(t, seats);
      final filename = 'ticket_${t['id'] ?? DateTime.now().millisecondsSinceEpoch}.pdf';
      await downloadPdfFile(pdfBytes, filename);
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Ticket downloaded!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('Download failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<Uint8List> _buildPdf(Map<String, dynamic> t, String seats) async {
    final pdf = pw.Document();
    final red = PdfColor.fromHex('#2E7D32');
    final name = t['name'] ?? t['passengerName'] ?? 'Passenger';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5.landscape,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: pw.BoxDecoration(
                color: red,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TRAIN TICKET',
                      style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 18)),
                  pw.Text(t['trainCode'] ?? '',
                      style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 14)),
                ],
              ),
            ),
            pw.SizedBox(height: 16),
            // Body — two columns
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Left
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _pdfField('NAME OF PASSENGER', name),
                      pw.SizedBox(height: 10),
                      pw.Row(children: [
                        pw.Expanded(child: _pdfField('FROM', t['from'] ?? '')),
                        pw.SizedBox(width: 12),
                        pw.Expanded(child: _pdfField('TO', t['to'] ?? '')),
                      ]),
                      pw.SizedBox(height: 10),
                      pw.Row(children: [
                        pw.Expanded(child: _pdfField('DATE', t['date'] ?? '')),
                        pw.SizedBox(width: 12),
                        pw.Expanded(child: _pdfField('DEPARTURE', t['departureTime'] ?? '')),
                      ]),
                      pw.SizedBox(height: 10),
                      pw.Row(children: [
                        pw.Expanded(child: _pdfField('SEAT(S)', seats)),
                        pw.SizedBox(width: 12),
                        pw.Expanded(child: _pdfField('CLASS', t['class'] ?? '')),
                      ]),
                      pw.SizedBox(height: 10),
                      pw.Row(children: [
                        pw.Expanded(child: _pdfField('TRAIN', t['trainName'] ?? '')),
                        pw.SizedBox(width: 12),
                        pw.Expanded(child: _pdfField('AMOUNT', '৳${t['totalAmount'] ?? ''}')),
                      ]),
                    ],
                  ),
                ),
                // Dashed divider
                pw.Container(
                  width: 1,
                  height: 160,
                  margin: const pw.EdgeInsets.symmetric(horizontal: 12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      left: pw.BorderSide(
                        color: PdfColors.grey400,
                        width: 1,
                        style: pw.BorderStyle.dashed,
                      ),
                    ),
                  ),
                ),
                // Right stub
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _pdfField('PASSENGER', name),
                      pw.SizedBox(height: 8),
                      _pdfField('FROM', t['from'] ?? ''),
                      pw.SizedBox(height: 8),
                      _pdfField('TO', t['to'] ?? ''),
                      pw.SizedBox(height: 8),
                      pw.Row(children: [
                        pw.Expanded(child: _pdfField('TRAIN', t['trainCode'] ?? '')),
                        pw.SizedBox(width: 6),
                        pw.Expanded(child: _pdfField('SEAT', seats)),
                      ]),
                      pw.SizedBox(height: 8),
                      _pdfField('DATE', t['date'] ?? ''),
                    ],
                  ),
                ),
              ],
            ),
            pw.Spacer(),
            // Footer barcode-style line
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 4),
            pw.Text(
              'Booking ID: ${t['id'] ?? ''}',
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
            ),
          ],
        ),
      ),
    );
    return pdf.save();
  }

  pw.Widget _pdfField(String label, String value) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label,
              style: pw.TextStyle(
                  fontSize: 7,
                  color: PdfColors.grey600,
                  letterSpacing: 0.5)),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold)),
        ],
      );

  String _seats(Map<String, dynamic> t) =>
      (t['seats'] as List?)?.join(', ') ?? t['seat']?.toString() ?? '-';

  @override
  Widget build(BuildContext context) {
    final grouped = _grouped;
    final months = grouped.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.to(() => const MainHomeScreen()),
        ),
        centerTitle: true,
        title: const Text('My Tickets',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () { setState(() => _loading = true); _loadTickets(); },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : _tickets.isEmpty
              ? _emptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: months.length,
                  itemBuilder: (ctx, i) {
                    final month = months[i];
                    final list = grouped[month]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Month header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: Row(
                            children: [
                              Container(
                                width: 4, height: 18,
                                decoration: BoxDecoration(
                                  color: _red,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(month,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333))),
                              const SizedBox(width: 8),
                              Text('(${list.length} ticket${list.length > 1 ? 's' : ''})',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        // Tickets in this month
                        ...list.map((t) => _TicketCard(
                              ticket: t,
                              onDownload: () => _download(context, t),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TrainTicketDetailPage(ticket: t),
                                ),
                              ),
                            )),
                      ],
                    );
                  },
                ),
    );
  }

  Widget _emptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_number_outlined, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No tickets yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[500])),
            const SizedBox(height: 8),
            Text('Book a train to see your tickets here',
                style: TextStyle(fontSize: 13, color: Colors.grey[400])),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Ticket Card (list item)
// ─────────────────────────────────────────────────────────────────────────────
class _TicketCard extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final VoidCallback onDownload;
  final VoidCallback onTap;

  const _TicketCard({
    required this.ticket,
    required this.onDownload,
    required this.onTap,
  });

  static const _red = Color(0xFF2E7D32);

  String get _seats =>
      (ticket['seats'] as List?)?.join(', ') ?? ticket['seat']?.toString() ?? '-';

  @override
  Widget build(BuildContext context) {
    final status = ticket['status'] ?? 'confirmed';
    final isConfirmed = status == 'confirmed';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            // Red header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: _red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.train, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  const Text('TRAIN TICKET',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 1)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isConfirmed ? Colors.green[600] : Colors.orange[700],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left info
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow('FROM', ticket['from'] ?? ''),
                        const SizedBox(height: 6),
                        _infoRow('TO', ticket['to'] ?? ''),
                        const SizedBox(height: 6),
                        _infoRow('DATE', ticket['date'] ?? ''),
                        const SizedBox(height: 6),
                        _infoRow('DEPARTURE', ticket['departureTime'] ?? ''),
                      ],
                    ),
                  ),

                  // Dashed divider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomPaint(
                      size: const Size(1, 80),
                      painter: _DashedLinePainter(),
                    ),
                  ),

                  // Right info
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow('SEAT', _seats),
                        const SizedBox(height: 6),
                        _infoRow('CLASS', ticket['class'] ?? ''),
                        const SizedBox(height: 6),
                        _infoRow('TRAIN', ticket['trainCode'] ?? ''),
                        const SizedBox(height: 6),
                        _infoRow('AMOUNT', '৳${ticket['totalAmount'] ?? ''}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Footer with booking ID + download
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Text(
                    'ID: ${(ticket['id'] ?? '').toString().length > 12 ? (ticket['id'] as String).substring(0, 12) + '...' : ticket['id'] ?? ''}',
                    style: TextStyle(fontSize: 10, color: Colors.grey[500], fontFamily: 'monospace'),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onDownload,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: _red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.download, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text('Download',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey, letterSpacing: 0.5)),
          Text(value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
              overflow: TextOverflow.ellipsis),
        ],
      );
}

// Dashed vertical line painter
class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;
    const dashH = 4.0;
    const gap = 3.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashH), paint);
      y += dashH + gap;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Full Ticket Detail Page — image design (red header, two panels, barcode)
// ─────────────────────────────────────────────────────────────────────────────
class TrainTicketDetailPage extends StatelessWidget {
  final Map<String, dynamic> ticket;

  const TrainTicketDetailPage({super.key, required this.ticket});

  static const _red = Color(0xFF2E7D32);

  String get _seats =>
      (ticket['seats'] as List?)?.join(', ') ?? ticket['seat']?.toString() ?? '-';

  String get _name => ticket['name'] ?? ticket['passengerName'] ?? 'Passenger';

  Future<void> _download(BuildContext ctx) async {
    try {
      final pdf = pw.Document();
      final red = PdfColor.fromHex('#2E7D32');
      final seats = _seats;
      final name = _name;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a5.landscape,
          margin: const pw.EdgeInsets.all(24),
          build: (pw.Context c) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: pw.BoxDecoration(
                  color: red,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('TRAIN TICKET',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 18)),
                    pw.Text(ticket['trainCode'] ?? '',
                        style: pw.TextStyle(color: PdfColors.white, fontSize: 14)),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _pdfF('NAME OF PASSENGER', name),
                        pw.SizedBox(height: 10),
                        pw.Row(children: [
                          pw.Expanded(child: _pdfF('FROM', ticket['from'] ?? '')),
                          pw.SizedBox(width: 12),
                          pw.Expanded(child: _pdfF('TO', ticket['to'] ?? '')),
                        ]),
                        pw.SizedBox(height: 10),
                        pw.Row(children: [
                          pw.Expanded(child: _pdfF('DATE', ticket['date'] ?? '')),
                          pw.SizedBox(width: 12),
                          pw.Expanded(child: _pdfF('DEPARTURE', ticket['departureTime'] ?? '')),
                        ]),
                        pw.SizedBox(height: 10),
                        pw.Row(children: [
                          pw.Expanded(child: _pdfF('SEAT(S)', seats)),
                          pw.SizedBox(width: 12),
                          pw.Expanded(child: _pdfF('CLASS', ticket['class'] ?? '')),
                        ]),
                        pw.SizedBox(height: 10),
                        pw.Row(children: [
                          pw.Expanded(child: _pdfF('TRAIN', ticket['trainName'] ?? '')),
                          pw.SizedBox(width: 12),
                          pw.Expanded(child: _pdfF('AMOUNT', '৳${ticket['totalAmount'] ?? ''}')),
                        ]),
                      ],
                    ),
                  ),
                  pw.Container(
                    width: 1, height: 160,
                    margin: const pw.EdgeInsets.symmetric(horizontal: 12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border(
                        left: pw.BorderSide(
                          color: PdfColors.grey400,
                          style: pw.BorderStyle.dashed,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _pdfF('PASSENGER', name),
                        pw.SizedBox(height: 8),
                        _pdfF('FROM', ticket['from'] ?? ''),
                        pw.SizedBox(height: 8),
                        _pdfF('TO', ticket['to'] ?? ''),
                        pw.SizedBox(height: 8),
                        pw.Row(children: [
                          pw.Expanded(child: _pdfF('TRAIN', ticket['trainCode'] ?? '')),
                          pw.SizedBox(width: 6),
                          pw.Expanded(child: _pdfF('SEAT', seats)),
                        ]),
                        pw.SizedBox(height: 8),
                        _pdfF('DATE', ticket['date'] ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 4),
              pw.Text('Booking ID: ${ticket['id'] ?? ''}',
                  style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
            ],
          ),
        ),
      );

      final bytes = await pdf.save();
      final filename = 'ticket_${ticket['id'] ?? DateTime.now().millisecondsSinceEpoch}.pdf';
      await downloadPdfFile(bytes, filename);
    } catch (e) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('Download failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  pw.Widget _pdfF(String label, String value) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label,
              style: pw.TextStyle(fontSize: 7, color: PdfColors.grey600, letterSpacing: 0.5)),
          pw.Text(value,
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: _red,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Ticket Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _download(context),
            tooltip: 'Download Ticket',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              children: [
                _buildTicket(context),
                const SizedBox(height: 20),
                // Download button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _download(context),
                    icon: const Icon(Icons.download),
                    label: const Text('Download Ticket',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '* Please be at the platform well ahead of departure time',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicket(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Red header ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: _red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.train, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                const Text('TRAIN TICKET',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.5)),
                const Spacer(),
                // Right stub header
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.white38,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                const Text('TRAIN TICKET',
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1)),
              ],
            ),
          ),

          // ── Main body ───────────────────────────────────────────────────
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left panel (main ticket)
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row 1: Name | Train | Seat
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _field('NAME OF PASSENGER', _name)),
                            const SizedBox(width: 12),
                            Expanded(flex: 2, child: _field('TRAIN', ticket['trainCode'] ?? '')),
                            const SizedBox(width: 12),
                            Expanded(flex: 2, child: _field('SEAT', _seats)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Row 2: From | Platform | Date
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _field('FROM', ticket['from'] ?? '')),
                            const SizedBox(width: 12),
                            Expanded(flex: 2, child: _field('CLASS', ticket['class'] ?? '')),
                            const SizedBox(width: 12),
                            Expanded(flex: 2, child: _field('DATE', ticket['date'] ?? '')),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Row 3: To | Carriage | Time
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _field('TO', ticket['to'] ?? '')),
                            const SizedBox(width: 12),
                            Expanded(flex: 2, child: _field('TRAIN NAME', ticket['trainName'] ?? '')),
                            const SizedBox(width: 12),
                            Expanded(flex: 2, child: _field('TIME', ticket['departureTime'] ?? '')),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Row 4: Departure | Arrive | Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _field('DEPARTURE', ticket['departureTime'] ?? '')),
                            const SizedBox(width: 12),
                            Expanded(flex: 2, child: _field('ARRIVE', ticket['arrivalTime'] ?? '-')),
                            const SizedBox(width: 12),
                            Expanded(flex: 2, child: _field('PRICE', '৳${ticket['totalAmount'] ?? ''}')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Dashed separator + notch
                _TicketSeparator(),

                // Right stub panel
                SizedBox(
                  width: 90,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _field('NAME OF PASSENGER', _name),
                        const SizedBox(height: 10),
                        _field('FROM', ticket['from'] ?? ''),
                        const SizedBox(height: 10),
                        _field('TO', ticket['to'] ?? ''),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _field('TRAIN', ticket['trainCode'] ?? '')),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(child: _field('SEAT', _seats)),
                            const SizedBox(width: 4),
                            Expanded(child: _field('DATE', ticket['date'] ?? '')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Barcode footer ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                // Barcode
                CustomPaint(
                  size: const Size(160, 28),
                  painter: _BarcodePainter(ticket['id'] ?? ''),
                ),
                const Spacer(),
                Text(
                  ticket['id']?.toString().substring(0, math.min(12, (ticket['id'] ?? '').toString().length)) ?? '',
                  style: TextStyle(fontSize: 9, color: Colors.grey[500], fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 8, color: Colors.grey, letterSpacing: 0.4),
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1),
        ],
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Ticket separator with notch cutouts (like a real ticket)
// ─────────────────────────────────────────────────────────────────────────────
class _TicketSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: CustomPaint(
        painter: _SeparatorPainter(),
      ),
    );
  }
}

class _SeparatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;

    const dashH = 5.0;
    const gap = 4.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, math.min(y + dashH, size.height)),
        paint,
      );
      y += dashH + gap;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Simple barcode painter (decorative)
// ─────────────────────────────────────────────────────────────────────────────
class _BarcodePainter extends CustomPainter {
  final String seed;
  _BarcodePainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black87;
    final rng = math.Random(seed.hashCode);
    double x = 0;
    while (x < size.width) {
      final w = rng.nextDouble() * 3 + 1;
      if (rng.nextBool()) {
        canvas.drawRect(Rect.fromLTWH(x, 0, w, size.height), paint);
      }
      x += w + rng.nextDouble() * 2;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Legacy TrainTicketPage — kept for backward compat from Payments.dart
// ─────────────────────────────────────────────────────────────────────────────
class TrainTicketPage extends StatelessWidget {
  final String name;
  final String from;
  final String to;
  final String travelClass;
  final String date;
  final String departTime;
  final String seat;
  final String? totalAmount;
  final String? trainCode;

  const TrainTicketPage({
    super.key,
    required this.name,
    required this.from,
    required this.to,
    required this.travelClass,
    required this.date,
    required this.departTime,
    required this.seat,
    this.totalAmount,
    this.trainCode,
  });

  @override
  Widget build(BuildContext context) {
    // Convert to map and show the new detail page
    final ticket = {
      'name': name,
      'from': from,
      'to': to,
      'class': travelClass,
      'date': date,
      'departureTime': departTime,
      'seat': seat,
      'totalAmount': totalAmount ?? '',
      'trainCode': trainCode ?? '',
      'status': 'confirmed',
      'id': 'BK${DateTime.now().millisecondsSinceEpoch}',
    };
    return TrainTicketDetailPage(ticket: ticket);
  }
}
