import 'package:flutter/material.dart';

import '../models/dua_adhkar_category.dart';

const List<DuaAdhkarCategory> duaAdhkarCategories = [
  //
  // DAILY ESSENTIALS
  //

  DuaAdhkarCategory(
    id: 'morning',
    title: 'Morning Adhkar',
    subtitle:
        'Authentic remembrance for the beginning of your day',
    icon: Icons.wb_sunny_rounded,
    featured: true,
  ),

  DuaAdhkarCategory(
    id: 'evening',
    title: 'Evening Adhkar',
    subtitle:
        'Authentic remembrance for the evening',
    icon: Icons.nights_stay_rounded,
    featured: true,
  ),

  DuaAdhkarCategory(
    id: 'sleep',
    title: 'Before Sleeping',
    subtitle:
        'Authentic bedtime adhkar and Sunnah practices',
    icon: Icons.bedtime_rounded,
    featured: true,
  ),

  DuaAdhkarCategory(
    id: 'waking',
    title: 'After Waking Up',
    subtitle:
        'Duas and remembrance when waking from sleep',
    icon: Icons.wb_twilight_rounded,
  ),

  //
  // RUQYAH, PROTECTION & HEALING
  //

  DuaAdhkarCategory(
    id: 'ruqyah',
    title: 'Ruqyah',
    subtitle:
        'Qur’anic and Prophetic supplications for authentic Ruqyah',
    icon: Icons.health_and_safety_rounded,
    featured: true,
  ),

  DuaAdhkarCategory(
    id: 'protection',
    title: 'Protection',
    subtitle:
        'Authentic duas seeking Allah’s protection from harm',
    icon: Icons.shield_rounded,
    featured: true,
  ),

  DuaAdhkarCategory(
    id: 'illness_healing',
    title: 'Illness & Healing',
    subtitle:
        'Supplications for sickness, pain and healing',
    icon: Icons.healing_rounded,
  ),

  DuaAdhkarCategory(
    id: 'distress',
    title: 'Anxiety & Distress',
    subtitle:
        'Duas for worry, sadness, fear and hardship',
    icon: Icons.favorite_rounded,
  ),

  //
  // FORGIVENESS, RIZQ & PERSONAL NEEDS
  //

  DuaAdhkarCategory(
    id: 'forgiveness',
    title: 'Forgiveness & Tawbah',
    subtitle:
        'Istighfar, repentance and seeking Allah’s forgiveness',
    icon: Icons.volunteer_activism_rounded,
    featured: true,
  ),

  DuaAdhkarCategory(
    id: 'debt_rizq',
    title: 'Provision & Debt',
    subtitle:
        'Authentic duas for halal provision, sufficiency and debt',
    icon: Icons.account_balance_wallet_rounded,
  ),

  //
  // FOOD & HOME
  //

  DuaAdhkarCategory(
    id: 'food',
    title: 'Food & Drink',
    subtitle:
        'Before eating, after eating and related remembrance',
    icon: Icons.restaurant_rounded,
  ),

  DuaAdhkarCategory(
    id: 'home',
    title: 'Home',
    subtitle:
        'Duas for entering and leaving the home',
    icon: Icons.home_rounded,
  ),

  //
  // PURIFICATION & MOSQUE
  //

  DuaAdhkarCategory(
    id: 'restroom',
    title: 'Restroom',
    subtitle:
        'Before entering and after leaving the restroom',
    icon: Icons.wc_rounded,
  ),

  DuaAdhkarCategory(
    id: 'wudu',
    title: 'Wudu',
    subtitle:
        'Authentic remembrance connected to ablution',
    icon: Icons.water_drop_rounded,
  ),

  DuaAdhkarCategory(
    id: 'mosque',
    title: 'Mosque',
    subtitle:
        'Duas for entering and leaving the masjid',
    icon: Icons.mosque_rounded,
  ),

  //
  // TRAVEL & WEATHER
  //

  DuaAdhkarCategory(
    id: 'travel',
    title: 'Travel',
    subtitle:
        'Journey, transport and returning from travel',
    icon: Icons.flight_takeoff_rounded,
  ),

  DuaAdhkarCategory(
    id: 'weather',
    title: 'Rain & Weather',
    subtitle:
        'Authentic duas for rain, wind and weather',
    icon: Icons.cloud_rounded,
  ),

  //
  // FAMILY & MARRIAGE
  //

  DuaAdhkarCategory(
    id: 'family_children',
    title: 'Family & Children',
    subtitle:
        'Duas for spouses, children and righteous offspring',
    icon: Icons.family_restroom_rounded,
  ),

  DuaAdhkarCategory(
    id: 'marriage',
    title: 'Marriage',
    subtitle:
        'Marriage blessings and duas for family life',
    icon: Icons.favorite_border_rounded,
  ),

  //
  // FASTING
  //

  DuaAdhkarCategory(
    id: 'fasting',
    title: 'Fasting',
    subtitle:
        'Authentic duas connected to fasting and iftar',
    icon: Icons.dark_mode_rounded,
  ),

  //
  // DAILY ETIQUETTE
  //

  DuaAdhkarCategory(
    id: 'sneezing',
    title: 'Sneezing',
    subtitle:
        'What to say when sneezing and how to respond',
    icon: Icons.air_rounded,
  ),

  DuaAdhkarCategory(
    id: 'gathering',
    title: 'Gatherings',
    subtitle:
        'Remembrance and expiation when leaving a gathering',
    icon: Icons.groups_rounded,
  ),

  DuaAdhkarCategory(
    id: 'social_daily',
    title: 'Daily Life',
    subtitle:
        'Greetings, blessings and everyday Islamic etiquette',
    icon: Icons.event_note_rounded,
  ),

  //
  // LARGE DUA COLLECTIONS
  //

  DuaAdhkarCategory(
    id: 'quranic_duas',
    title: 'Qur’anic Duas',
    subtitle:
        'Supplications directly from the Noble Qur’an',
    icon: Icons.menu_book_rounded,
    featured: true,
  ),

  DuaAdhkarCategory(
    id: 'prophetic_duas',
    title: 'Prophetic Duas',
    subtitle:
        'Authentic supplications taught by the Prophet ﷺ',
    icon: Icons.auto_stories_rounded,
    featured: true,
  ),

  DuaAdhkarCategory(
    id: 'general_dhikr',
    title: 'General Dhikr',
    subtitle:
        'Tasbih, tahmid, tahlil and everyday remembrance',
    icon: Icons.spa_rounded,
  ),

  //
  // NOT BUILT YET
  //

  DuaAdhkarCategory(
    id: 'prayer',
    title: 'Salah Adhkar',
    subtitle:
        'Adhkar and supplications connected to prayer',
    icon: Icons.front_hand_rounded,
  ),

  //
  // PERSONAL FEATURES
  //

  DuaAdhkarCategory(
    id: 'custom_routines',
    title: 'My Routines',
    subtitle:
        'Create personal adhkar routines and goals',
    icon: Icons.checklist_rounded,
  ),
];