import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import 'app_theme.dart';

class IlmApp extends StatelessWidget {
  const IlmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ILM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}