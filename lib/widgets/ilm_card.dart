import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_radius.dart';
import '../core/app_spacing.dart';

class IlmCard extends StatefulWidget {
  const IlmCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding,
    this.interactive,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  /// If null, the card automatically becomes interactive
  /// whenever [onTap] is provided.
  final bool? interactive;

  final double? borderRadius;

  @override
  State<IlmCard> createState() =>
      _IlmCardState();
}

class _IlmCardState extends State<IlmCard> {
  bool _isPressed = false;

  bool get _isInteractive =>
      widget.interactive ??
      widget.onTap != null;

  void _setPressed(
    bool value,
  ) {
    if (!_isInteractive ||
        _isPressed == value) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final radius =
        widget.borderRadius ??
            AppRadius.lg;

    final borderRadius =
        BorderRadius.circular(
      radius,
    );

    final primary =
        colorScheme.primary;

    final surface =
        colorScheme.surface;

    final pressedSurface =
        Color.alphaBlend(
      primary.withValues(
        alpha: 0.035,
      ),
      surface,
    );

    final card = AnimatedContainer(
      duration: Duration(
        milliseconds:
            _isPressed ? 110 : 220,
      ),
      curve:
          _isPressed
              ? Curves.easeOutCubic
              : Curves.easeOutCubic,
      width:
          double.infinity,
      padding:
          widget.padding ??
              const EdgeInsets.all(
                AppSpacing.lg,
              ),
      decoration: BoxDecoration(
        color:
            _isPressed &&
                    _isInteractive
                ? pressedSurface
                : surface,
        borderRadius:
            borderRadius,
        border: Border.all(
          color:
              _isPressed &&
                      _isInteractive
                  ? primary.withValues(
                      alpha: 0.18,
                    )
                  : AppColors.borderSoft,
          width:
              1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha:
                  _isPressed
                      ? 0.025
                      : 0.055,
            ),
            blurRadius:
                _isPressed
                    ? 8
                    : 20,
            spreadRadius:
                _isPressed
                    ? -1
                    : -5,
            offset: Offset(
              0,
              _isPressed
                  ? 2
                  : 7,
            ),
          ),
        ],
      ),
      child:
          widget.child,
    );

    if (!_isInteractive) {
      return card;
    }

    return Semantics(
      button:
          widget.onTap != null,
      child:
          GestureDetector(
        behavior:
            HitTestBehavior.opaque,

        onTapDown: (_) {
          _setPressed(
            true,
          );
        },

        onTapCancel: () {
          _setPressed(
            false,
          );
        },

        onTapUp: (_) {
          _setPressed(
            false,
          );
        },

        onTap:
            widget.onTap,

        child:
            AnimatedScale(
          scale:
              _isPressed
                  ? 0.975
                  : 1,
          duration:
              Duration(
            milliseconds:
                _isPressed
                    ? 105
                    : 240,
          ),
          curve:
              _isPressed
                  ? Curves.easeOutCubic
                  : Curves.easeOutBack,

          child:
              AnimatedSlide(
            offset:
                _isPressed
                    ? const Offset(
                        0,
                        0.006,
                      )
                    : Offset.zero,
            duration:
                Duration(
              milliseconds:
                  _isPressed
                      ? 105
                      : 220,
            ),
            curve:
                _isPressed
                    ? Curves.easeOutCubic
                    : Curves.easeOutBack,
            child:
                card,
          ),
        ),
      ),
    );
  }
}