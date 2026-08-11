import 'package:flutter/services.dart';

class AdhanAlarmService {
  AdhanAlarmService._();

  static final AdhanAlarmService instance =
      AdhanAlarmService._();

  static const MethodChannel _channel =
      MethodChannel(
    'com.example.ilm/adhan_alarm',
  );

  Future<void> scheduleAdhanAlarm({
    required int alarmId,
    required DateTime prayerTime,
    required String prayerName,
  }) async {
    final triggerAtMillis =
        prayerTime.millisecondsSinceEpoch;

    await _channel.invokeMethod<bool>(
      'scheduleAdhanAlarm',
      {
        'alarmId': alarmId,
        'triggerAtMillis': triggerAtMillis,
        'prayerName': prayerName,
      },
    );
  }

  Future<void> cancelAdhanAlarm({
    required int alarmId,
  }) async {
    await _channel.invokeMethod<bool>(
      'cancelAdhanAlarm',
      {
        'alarmId': alarmId,
      },
    );
  }
}