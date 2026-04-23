import 'package:flutter/material.dart';

/// Responsive helper — use R.of(context) anywhere
class R {
  final double width;
  final double height;
  final double _base;

  R._(this.width, this.height) : _base = width < 600 ? width : 600;

  factory R.of(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return R._(s.width, s.height);
  }

  // ── breakpoints ──────────────────────────────────────────────────────────
  bool get isPhone => width < 600;
  bool get isTablet => width >= 600 && width < 900;
  bool get isDesktop => width >= 900;

  // ── font sizes ───────────────────────────────────────────────────────────
  double get fs10 => _scale(10);
  double get fs11 => _scale(11);
  double get fs12 => _scale(12);
  double get fs13 => _scale(13);
  double get fs14 => _scale(14);
  double get fs15 => _scale(15);
  double get fs16 => _scale(16);
  double get fs18 => _scale(18);
  double get fs20 => _scale(20);
  double get fs22 => _scale(22);
  double get fs24 => _scale(24);
  double get fs28 => _scale(28);
  double get fs32 => _scale(32);

  double _scale(double size) {
    // Scale relative to 375 (iPhone SE baseline)
    final factor = (_base / 375).clamp(0.85, 1.4);
    return size * factor;
  }

  // ── spacing ───────────────────────────────────────────────────────────────
  double get sp4 => _sp(4);
  double get sp6 => _sp(6);
  double get sp8 => _sp(8);
  double get sp10 => _sp(10);
  double get sp12 => _sp(12);
  double get sp14 => _sp(14);
  double get sp16 => _sp(16);
  double get sp20 => _sp(20);
  double get sp24 => _sp(24);
  double get sp32 => _sp(32);
  double get sp40 => _sp(40);

  double _sp(double size) => (size * (_base / 375)).clamp(size * 0.8, size * 1.5);

  // ── horizontal padding ────────────────────────────────────────────────────
  EdgeInsets get hPad => EdgeInsets.symmetric(horizontal: isPhone ? 16 : isTablet ? 32 : 48);
  EdgeInsets get cardPad => EdgeInsets.all(isPhone ? 14 : 20);
  EdgeInsets get pagePad => EdgeInsets.symmetric(
        horizontal: isPhone ? 16 : isTablet ? 40 : 80,
        vertical: isPhone ? 16 : 24,
      );

  // ── max content width (for web/tablet centering) ─────────────────────────
  double get maxWidth => isPhone ? double.infinity : isTablet ? 560 : 480;

  // ── button height ─────────────────────────────────────────────────────────
  double get btnH => isPhone ? 48 : 52;

  // ── grid columns ─────────────────────────────────────────────────────────
  int get paymentCols => isPhone ? 2 : 4;
  int get quickLinkCols => isPhone ? 4 : 6;
}

/// Centered max-width wrapper for web/tablet
class Centered extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  const Centered({super.key, required this.child, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final r = R.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? r.maxWidth),
        child: child,
      ),
    );
  }
}
