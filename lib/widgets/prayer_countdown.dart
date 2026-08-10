import 'dart:async';

import 'package:flutter/material.dart';

import '../models/prayer_time.dart';

class PrayerCountdown extends StatefulWidget {
  const PrayerCountdown({
    required this.prayer,
    super.key,
  });

  final PrayerTime prayer;

  @override
  State<PrayerCountdown> createState() => _PrayerCountdownState();
}

class _PrayerCountdownState extends State<PrayerCountdown> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();

    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _updateRemaining(),
    );
  }

  void _updateRemaining() {
    final now = DateTime.now();
    final difference = widget.prayer.time.difference(now);

    if (!mounted) return;

    setState(() {
      _remaining = difference.isNegative
          ? Duration.zero
          : difference;
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m remaining';
    }

    return '${minutes}m remaining';
  }

  @override
  void didUpdateWidget(covariant PrayerCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.prayer.time != widget.prayer.time) {
      _updateRemaining();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_remaining),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
    );
  }
}