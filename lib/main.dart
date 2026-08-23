import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app.dart';
import 'screens/profile_onboarding_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/notification_service.dart';
import 'services/widget_bridge_service.dart';

const String _welcomeCompletedKey = 'ilm_welcome_completed_v1';

const String _profileCompletedKey = 'ilm_profile_completed_v1';

const String _profileNameKey = 'ilm_profile_name';

const String _profileAgeKey = 'ilm_profile_age';

const String _profileGenderKey = 'ilm_profile_gender';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.instance.initialize();

  final preferences = await SharedPreferences.getInstance();

  final hasCompletedWelcome =
      preferences.getBool(_welcomeCompletedKey) ?? false;

  final hasCompletedProfile =
      preferences.getBool(_profileCompletedKey) ?? false;

  runApp(
    IlmBootstrap(
      hasCompletedWelcome: hasCompletedWelcome,
      hasCompletedProfile: hasCompletedProfile,
    ),
  );

  // Do not block application startup while
  // synchronizing Android widget content.
  unawaited(const WidgetBridgeService().syncIfNeededSafely());
}

enum _StartupStage { welcome, profile, app }

class IlmBootstrap extends StatefulWidget {
  const IlmBootstrap({
    required this.hasCompletedWelcome,
    required this.hasCompletedProfile,
    super.key,
  });

  final bool hasCompletedWelcome;
  final bool hasCompletedProfile;

  @override
  State<IlmBootstrap> createState() => _IlmBootstrapState();
}

class _IlmBootstrapState extends State<IlmBootstrap>
    with WidgetsBindingObserver {
  static const _widgetBridge = WidgetBridgeService();

  late _StartupStage _stage;

  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    if (!widget.hasCompletedWelcome) {
      _stage = _StartupStage.welcome;
    } else if (!widget.hasCompletedProfile) {
      _stage = _StartupStage.profile;
    } else {
      _stage = _StartupStage.app;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      return;
    }

    // When the user returns to ILM,
    // check whether a new calendar day has
    // started and refresh the widget if needed.
    unawaited(_widgetBridge.syncIfNeededSafely());
  }

  Future<void> _completeWelcome() async {
    if (_isTransitioning) {
      return;
    }

    _isTransitioning = true;

    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(_welcomeCompletedKey, true);

    if (!mounted) {
      return;
    }

    setState(() {
      _stage = _StartupStage.profile;

      _isTransitioning = false;
    });
  }

  Future<void> _completeProfile(ProfileOnboardingResult result) async {
    if (_isTransitioning) {
      return;
    }

    _isTransitioning = true;

    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_profileNameKey, result.name.trim());

    await preferences.setInt(_profileAgeKey, result.age);

    if (result.gender != null) {
      await preferences.setString(_profileGenderKey, result.gender!);
    } else {
      await preferences.remove(_profileGenderKey);
    }

    await preferences.setBool(_profileCompletedKey, true);

    if (!mounted) {
      return;
    }

    setState(() {
      _stage = _StartupStage.app;

      _isTransitioning = false;
    });

    // The user has now completed setup.
    // Force one widget synchronization so the
    // native widget has today's content.
    unawaited(_widgetBridge.syncTodaySafely());
  }

  @override
  Widget build(BuildContext context) {
    if (_stage == _StartupStage.app) {
      return const IlmApp();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ILM',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1C6B5A),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F8F6),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F1EE),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFF1C6B5A), width: 1.5),
          ),
        ),
      ),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final slide =
              Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slide, child: child),
          );
        },
        child: switch (_stage) {
          _StartupStage.welcome => WelcomeScreen(
            key: const ValueKey('welcome'),
            onContinue: _completeWelcome,
          ),

          _StartupStage.profile => ProfileOnboardingScreen(
            key: const ValueKey('profile'),
            onCompleted: _completeProfile,
          ),

          _StartupStage.app => const SizedBox.shrink(),
        },
      ),
    );
  }
}
