import 'package:flutter/material.dart';

class DuaAdhkarCategory {
  const DuaAdhkarCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.featured = false,
  });

  final String id;

  final String title;

  final String subtitle;

  final IconData icon;

  final bool featured;
}