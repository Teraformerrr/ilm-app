import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

class UserProfileService {
  const UserProfileService();

  static const String welcomeCompletedKey =
      'ilm_welcome_completed_v1';

  static const String profileCompletedKey =
      'ilm_profile_completed_v1';

  static const String profileNameKey =
      'ilm_profile_name';

  static const String profileAgeKey =
      'ilm_profile_age';

  static const String profileGenderKey =
      'ilm_profile_gender';

  Future<UserProfile?> loadProfile() async {
    final preferences =
        await SharedPreferences.getInstance();

    final completed =
        preferences.getBool(
          profileCompletedKey,
        ) ??
        false;

    if (!completed) {
      return null;
    }

    final name =
        preferences.getString(
      profileNameKey,
    );

    final age =
        preferences.getInt(
      profileAgeKey,
    );

    if (name == null ||
        name.trim().isEmpty ||
        age == null) {
      return null;
    }

    return UserProfile(
      name: name.trim(),
      age: age,
      gender:
          preferences.getString(
        profileGenderKey,
      ),
    );
  }

  Future<void> saveProfile({
    required String name,
    required int age,
    String? gender,
  }) async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.setString(
      profileNameKey,
      name.trim(),
    );

    await preferences.setInt(
      profileAgeKey,
      age,
    );

    if (gender == null ||
        gender.trim().isEmpty) {
      await preferences.remove(
        profileGenderKey,
      );
    } else {
      await preferences.setString(
        profileGenderKey,
        gender,
      );
    }

    await preferences.setBool(
      profileCompletedKey,
      true,
    );
  }

  Future<bool> hasCompletedWelcome() async {
    final preferences =
        await SharedPreferences.getInstance();

    return preferences.getBool(
          welcomeCompletedKey,
        ) ??
        false;
  }

  Future<bool> hasCompletedProfile() async {
    final preferences =
        await SharedPreferences.getInstance();

    return preferences.getBool(
          profileCompletedKey,
        ) ??
        false;
  }

  Future<void> markWelcomeCompleted() async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.setBool(
      welcomeCompletedKey,
      true,
    );
  }

  Future<void> resetOnboarding() async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.remove(
      welcomeCompletedKey,
    );

    await preferences.remove(
      profileCompletedKey,
    );

    await preferences.remove(
      profileNameKey,
    );

    await preferences.remove(
      profileAgeKey,
    );

    await preferences.remove(
      profileGenderKey,
    );
  }
}