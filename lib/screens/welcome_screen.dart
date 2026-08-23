import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    required this.onContinue,
    super.key,
  });

  final VoidCallback onContinue;

  @override
  State<WelcomeScreen> createState() =>
      _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;

  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleOffset;

  late final Animation<double> _subtitleOpacity;
  late final Animation<Offset> _subtitleOffset;

  late final Animation<double> _buttonOpacity;
  late final Animation<Offset> _buttonOffset;

  bool _isLeaving = false;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1800,
      ),
    );

    _logoOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(
        0.0,
        0.45,
        curve: Curves.easeOut,
      ),
    );

    _logoScale = Tween<double>(
      begin: 0.86,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.0,
          0.55,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _titleOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(
        0.22,
        0.62,
        curve: Curves.easeOut,
      ),
    );

    _titleOffset = Tween<Offset>(
      begin: const Offset(
        0,
        0.18,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.22,
          0.62,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _subtitleOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(
        0.42,
        0.78,
        curve: Curves.easeOut,
      ),
    );

    _subtitleOffset = Tween<Offset>(
      begin: const Offset(
        0,
        0.18,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.42,
          0.78,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _buttonOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(
        0.68,
        1.0,
        curve: Curves.easeOut,
      ),
    );

    _buttonOffset = Tween<Offset>(
      begin: const Offset(
        0,
        0.3,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.68,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _introController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_isLeaving) {
      return;
    }

    setState(() {
      _isLeaving = true;
    });

    await _introController.reverse(
      from: 1,
    );

    if (!mounted) {
      return;
    }

    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerLowest,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 24,
            ),
            child: Column(
              children: [
                const Spacer(
                  flex: 3,
                ),

                FadeTransition(
                  opacity: _logoOpacity,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: _IlmMark(
                      color:
                          colorScheme.primary,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 34,
                ),

                FadeTransition(
                  opacity: _titleOpacity,
                  child: SlideTransition(
                    position: _titleOffset,
                    child: Text(
                      'ILM',
                      textAlign:
                          TextAlign.center,
                      style: theme
                          .textTheme
                          .displaySmall
                          ?.copyWith(
                            fontWeight:
                                FontWeight.w700,
                            letterSpacing:
                                -1.5,
                          ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 14,
                ),

                FadeTransition(
                  opacity:
                      _subtitleOpacity,
                  child: SlideTransition(
                    position:
                        _subtitleOffset,
                    child: Text(
                      'Knowledge. Guidance. Reflection.',
                      textAlign:
                          TextAlign.center,
                      style: theme
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            color:
                                colorScheme
                                    .onSurfaceVariant,
                            fontWeight:
                                FontWeight.w400,
                            letterSpacing:
                                -0.15,
                          ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                FadeTransition(
                  opacity:
                      _subtitleOpacity,
                  child: Text(
                    'Qur’an, prayer, authentic Islamic knowledge '
                    'and reflection — thoughtfully brought together.',
                    textAlign:
                        TextAlign.center,
                    style: theme
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                          color:
                              colorScheme
                                  .onSurfaceVariant,
                          height: 1.55,
                        ),
                  ),
                ),

                const Spacer(
                  flex: 4,
                ),

                FadeTransition(
                  opacity:
                      _buttonOpacity,
                  child: SlideTransition(
                    position:
                        _buttonOffset,
                    child: SizedBox(
                      width:
                          double.infinity,
                      height: 58,
                      child:
                          FilledButton(
                        onPressed:
                            _isLeaving
                                ? null
                                : _continue,
                        style:
                            FilledButton
                                .styleFrom(
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          children: [
                            Text(
                              'Continue',
                              style: theme
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color:
                                        colorScheme
                                            .onPrimary,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons
                                  .arrow_forward_rounded,
                              color:
                                  colorScheme
                                      .onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IlmMark extends StatelessWidget {
  const _IlmMark({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(
          30,
        ),
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(
              alpha: 0.20,
            ),
            blurRadius: 36,
            offset: const Offset(
              0,
              18,
            ),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.auto_stories_rounded,
          size: 46,
          color: Colors.white,
        ),
      ),
    );
  }
}