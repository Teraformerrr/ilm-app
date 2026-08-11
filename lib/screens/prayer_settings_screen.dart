import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_spacing.dart';
import '../models/prayer_reminder_mode.dart';
import '../models/prayer_time.dart';
import '../services/adhan_audio_service.dart';
import '../services/notification_service.dart';
import '../services/prayer_notification_service.dart';
import '../services/prayer_reminder_preferences.dart';

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

  static const List<PrayerType> _prayers = [
    PrayerType.fajr,
    PrayerType.dhuhr,
    PrayerType.asr,
    PrayerType.maghrib,
    PrayerType.isha,
  ];

  bool _prayerNotificationsEnabled = false;
  bool _isRequestingPermission = false;
  bool _isLoadingPreference = true;
  bool _isAdhanPlaying = false;

  Map<PrayerType, PrayerReminderMode> _prayerModes = {
    PrayerType.fajr: PrayerReminderMode.adhan,
    PrayerType.dhuhr: PrayerReminderMode.adhan,
    PrayerType.asr: PrayerReminderMode.adhan,
    PrayerType.maghrib: PrayerReminderMode.adhan,
    PrayerType.isha: PrayerReminderMode.adhan,
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final preferences = await SharedPreferences.getInstance();

    const reminderPreferences = PrayerReminderPreferences();

    final enabled =
        preferences.getBool(_prayerNotificationsKey) ?? false;

    final modes =
        await reminderPreferences.getAllPrayerModes();

    if (!mounted) return;

    setState(() {
      _prayerNotificationsEnabled = enabled;
      _prayerModes = modes;
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

  Future<void> _reschedulePrayerReminders() async {
    if (!_prayerNotificationsEnabled) {
      return;
    }

    const prayerNotificationService = PrayerNotificationService();

    await _cancelPrayerNotifications();

    await prayerNotificationService.scheduleUpcomingPrayers(
      latitude: widget.latitude,
      longitude: widget.longitude,
    );
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
          'Prayer reminders are scheduled for the next 7 days.',
        ),
      ),
    );
  }

  Future<void> _changePrayerMode(
    PrayerType prayerType,
    PrayerReminderMode? mode,
  ) async {
    if (mode == null) return;

    const reminderPreferences = PrayerReminderPreferences();

    await reminderPreferences.setMode(
      prayerType: prayerType,
      mode: mode,
    );

    if (!mounted) return;

    setState(() {
      _prayerModes = {
        ..._prayerModes,
        prayerType: mode,
      };
    });

    await _reschedulePrayerReminders();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_prayerName(prayerType)} reminder set to ${mode.label}.',
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

  String _prayerName(PrayerType prayerType) {
    switch (prayerType) {
      case PrayerType.fajr:
        return 'Fajr';
      case PrayerType.dhuhr:
        return 'Dhuhr';
      case PrayerType.asr:
        return 'Asr';
      case PrayerType.maghrib:
        return 'Maghrib';
      case PrayerType.isha:
        return 'Isha';
      case PrayerType.sunrise:
        return 'Sunrise';
      case PrayerType.tahajjud:
        return 'Tahajjud';
    }
  }

  IconData _prayerIcon(PrayerType prayerType) {
    switch (prayerType) {
      case PrayerType.fajr:
        return Icons.nights_stay_outlined;
      case PrayerType.dhuhr:
        return Icons.wb_sunny_outlined;
      case PrayerType.asr:
        return Icons.light_mode_outlined;
      case PrayerType.maghrib:
        return Icons.wb_twilight_outlined;
      case PrayerType.isha:
        return Icons.dark_mode_outlined;
      case PrayerType.sunrise:
        return Icons.wb_twilight_outlined;
      case PrayerType.tahajjud:
        return Icons.bedtime_outlined;
    }
  }

  IconData _modeIcon(PrayerReminderMode mode) {
    switch (mode) {
      case PrayerReminderMode.adhan:
        return Icons.volume_up_outlined;
      case PrayerReminderMode.notification:
        return Icons.notifications_outlined;
      case PrayerReminderMode.off:
        return Icons.notifications_off_outlined;
    }
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
                'Prayer Reminders',
              ),
              subtitle: const Text(
                'Enable scheduled reminders for your daily Salah.',
              ),
              value: _prayerNotificationsEnabled,
              onChanged:
                  _isRequestingPermission || _isLoadingPreference
                      ? null
                      : _togglePrayerNotifications,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            'Each Prayer',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),

          const SizedBox(height: AppSpacing.sm),

          ..._prayers.map(
            (prayerType) {
              final mode =
                  _prayerModes[prayerType] ??
                      PrayerReminderMode.adhan;

              return Card(
                child: ListTile(
                  leading: Icon(
                    _prayerIcon(prayerType),
                  ),
                  title: Text(
                    _prayerName(prayerType),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    mode.description,
                  ),
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<PrayerReminderMode>(
                      value: mode,
                      onChanged: _isLoadingPreference
                          ? null
                          : (newMode) {
                              _changePrayerMode(
                                prayerType,
                                newMode,
                              );
                            },
                      items: PrayerReminderMode.values
                          .map(
                            (reminderMode) {
                              return DropdownMenuItem(
                                value: reminderMode,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _modeIcon(reminderMode),
                                      size: 18,
                                    ),
                                    const SizedBox(
                                      width: AppSpacing.sm,
                                    ),
                                    Text(
                                      reminderMode.label,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                          .toList(),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppSpacing.lg),

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
                    'Preview the Adhan used for prayers set to Full Adhan.',
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
            'Full Adhan plays the complete Adhan at prayer time. '
            'Notification Only shows a reminder without Adhan. '
            'Off disables reminders for that prayer.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                ),
          ),
        ],
      ),
    );
  }
}