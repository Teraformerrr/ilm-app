import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_spacing.dart';
import '../services/adhan_audio_service.dart';
import '../services/notification_service.dart';
import '../services/prayer_notification_service.dart';

class PrayerSettingsScreen extends StatefulWidget {
  const PrayerSettingsScreen({
    required this.latitude,
    required this.longitude,
    super.key,
  });

  final double latitude;
  final double longitude;

  @override
  State<PrayerSettingsScreen> createState() =>
      _PrayerSettingsScreenState();
}

class _PrayerSettingsScreenState extends State<PrayerSettingsScreen> {
  static const String _prayerNotificationsKey =
      'prayer_notifications_enabled';

  bool _prayerNotificationsEnabled = false;
  bool _isRequestingPermission = false;
  bool _isLoadingPreference = true;
  bool _isAdhanPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final preferences = await SharedPreferences.getInstance();

    final enabled =
        preferences.getBool(_prayerNotificationsKey) ?? false;

    if (!mounted) return;

    setState(() {
      _prayerNotificationsEnabled = enabled;
      _isLoadingPreference = false;
    });
  }

  Future<void> _saveNotificationPreference(bool enabled) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(
      _prayerNotificationsKey,
      enabled,
    );
  }

  Future<void> _cancelPrayerNotifications() async {
    final pending =
        await NotificationService.instance.getPendingNotifications();

    for (final notification in pending) {
      final id = notification.id;

      if (id >= 100000) {
        await NotificationService.instance.cancelNotification(id);
      }
    }

    const prayerNotificationService = PrayerNotificationService();

    await prayerNotificationService.cancelUpcomingAdhanAlarms();
  }

  Future<void> _togglePrayerNotifications(bool enabled) async {
    if (!enabled) {
      setState(() {
        _isRequestingPermission = true;
      });

      await _cancelPrayerNotifications();
      await _saveNotificationPreference(false);

      if (!mounted) return;

      setState(() {
        _prayerNotificationsEnabled = false;
        _isRequestingPermission = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Prayer notifications and Adhan have been turned off.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isRequestingPermission = true;
    });

    final notificationsGranted =
        await NotificationService.instance.requestPermissions();

    if (!mounted) return;

    if (!notificationsGranted) {
      await _saveNotificationPreference(false);

      if (!mounted) return;

      setState(() {
        _isRequestingPermission = false;
        _prayerNotificationsEnabled = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notification permission is required for prayer reminders.',
          ),
        ),
      );

      return;
    }

    final exactAlarmGranted =
        await NotificationService.instance.requestExactAlarmPermission();

    if (!mounted) return;

    if (!exactAlarmGranted) {
      await _saveNotificationPreference(false);

      if (!mounted) return;

      setState(() {
        _isRequestingPermission = false;
        _prayerNotificationsEnabled = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Exact alarm access is required for prayer-time Adhan.',
          ),
        ),
      );

      return;
    }

    const prayerNotificationService = PrayerNotificationService();

    await _cancelPrayerNotifications();

    await prayerNotificationService.scheduleUpcomingPrayers(
      latitude: widget.latitude,
      longitude: widget.longitude,
    );

    await _saveNotificationPreference(true);

    if (!mounted) return;

    setState(() {
      _prayerNotificationsEnabled = true;
      _isRequestingPermission = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Prayer reminders and Adhan are scheduled for the next 7 days.',
        ),
      ),
    );
  }

  Future<void> _requestExactAlarmPermission() async {
    final granted =
        await NotificationService.instance.requestExactAlarmPermission();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          granted
              ? 'Exact prayer alarm access is enabled.'
              : 'Exact prayer alarm access was not enabled.',
        ),
      ),
    );
  }

  Future<void> _showPendingNotifications() async {
    final pending =
        await NotificationService.instance.getPendingNotifications();

    if (!mounted) return;

    final prayerNotifications = pending
        .where(
          (notification) => notification.id >= 100000,
        )
        .toList()
      ..sort(
        (a, b) => a.id.compareTo(b.id),
      );

    final message = prayerNotifications.isEmpty
        ? 'No prayer reminders are currently scheduled.'
        : prayerNotifications
            .map(
              (notification) =>
                  '${notification.id}: '
                  '${notification.title ?? 'Prayer Reminder'}',
            )
            .join('\n');

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Scheduled Prayer Reminders',
          ),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _playAdhan() async {
    await AdhanAudioService.instance.playDefaultAdhan();

    if (!mounted) return;

    setState(() {
      _isAdhanPlaying = true;
    });
  }

  Future<void> _stopAdhan() async {
    await AdhanAudioService.instance.stop();

    if (!mounted) return;

    setState(() {
      _isAdhanPlaying = false;
    });
  }

  @override
  void dispose() {
    AdhanAudioService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prayer Settings',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Prayer Reminders',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),

          const SizedBox(height: AppSpacing.md),

          Card(
            child: SwitchListTile(
              title: const Text(
                'Prayer Notifications & Adhan',
              ),
              subtitle: const Text(
                'Receive Salah reminders and play the full Adhan at prayer time.',
              ),
              value: _prayerNotificationsEnabled,
              onChanged:
                  _isRequestingPermission || _isLoadingPreference
                      ? null
                      : _togglePrayerNotifications,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          OutlinedButton.icon(
            onPressed: _requestExactAlarmPermission,
            icon: const Icon(
              Icons.alarm_on_outlined,
            ),
            label: const Text(
              'Exact Prayer Alarm Access',
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          OutlinedButton.icon(
            onPressed: _showPendingNotifications,
            icon: const Icon(
              Icons.event_available_outlined,
            ),
            label: const Text(
              'View Scheduled Prayer Reminders',
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          Text(
            'Adhan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),

          const SizedBox(height: AppSpacing.md),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Default Adhan',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  const Text(
                    'Preview the Adhan that ILM will play at Salah time.',
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed:
                              _isAdhanPlaying ? null : _playAdhan,
                          icon: const Icon(
                            Icons.play_arrow,
                          ),
                          label: const Text(
                            'Play Adhan',
                          ),
                        ),
                      ),

                      const SizedBox(width: AppSpacing.md),

                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              _isAdhanPlaying ? _stopAdhan : null,
                          icon: const Icon(
                            Icons.stop,
                          ),
                          label: const Text(
                            'Stop',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            'Prayer reminders are currently prepared for the next 7 days. '
            'ILM will later refresh this schedule automatically.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                ),
          ),
        ],
      ),
    );
  }
}