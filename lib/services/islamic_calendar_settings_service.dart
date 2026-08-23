import 'package:shared_preferences/shared_preferences.dart';

class IslamicCalendarSettingsService {
  const IslamicCalendarSettingsService();

  static const String _adjustmentKey =
      'ilm_hijri_adjustment_days';

  static const String _countryCodeKey =
      'ilm_islamic_calendar_country_code';

  Future<int> loadAdjustmentDays() async {
    final preferences =
        await SharedPreferences.getInstance();

    return preferences.getInt(
          _adjustmentKey,
        ) ??
        0;
  }

  Future<void> saveAdjustmentDays(
    int days,
  ) async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.setInt(
      _adjustmentKey,
      days,
    );
  }

  Future<String> loadCountryCode() async {
    final preferences =
        await SharedPreferences.getInstance();

    return preferences.getString(
          _countryCodeKey,
        ) ??
        'AE';
  }

  Future<void> saveCountryCode(
    String countryCode,
  ) async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.setString(
      _countryCodeKey,
      countryCode.toUpperCase(),
    );
  }

  Future<void> resetCalendarSettings() async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.remove(
      _adjustmentKey,
    );

    await preferences.remove(
      _countryCodeKey,
    );
  }
}