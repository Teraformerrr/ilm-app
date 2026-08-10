import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_radius.dart';
import '../core/app_spacing.dart';

class IlmCard extends StatelessWidget {
  const IlmCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.divider,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}