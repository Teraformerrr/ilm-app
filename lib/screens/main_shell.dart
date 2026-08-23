import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/premium_route.dart';
import 'duas_adhkar_screen.dart';
import 'home_screen.dart';
import 'more_screen.dart';
import 'prayer_screen.dart';
import 'qibla_finder_screen.dart';
import 'quran_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
  });

  @override
  State<MainShell> createState() =>
      _MainShellState();
}

class _MainShellState
    extends State<MainShell> {
  int _selectedIndex = 0;

  void _onDestinationSelected(
    int index,
  ) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void _openQiblaFinder() {
    Navigator.of(context).push(
      premiumRoute(
        builder: (_) =>
            const QiblaFinderScreen(),
      ),
    );
  }

  void _openDuasAdhkar() {
    Navigator.of(context).push(
      premiumRoute(
        builder: (_) =>
            const DuasAdhkarScreen(),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final pages = [
      HomeScreen(
        onNavigateToTab:
            _onDestinationSelected,
        onOpenQiblaFinder:
            _openQiblaFinder,
        onOpenDuas:
            _openDuasAdhkar,
      ),

      const QuranScreen(),

      const PrayerScreen(),

      const _PlaceholderPage(
        title: 'Hadith',
        icon:
            Icons.library_books_outlined,
      ),

      MoreScreen(
        onOpenDuas:
            _openDuasAdhkar,
      ),
    ];

    return Scaffold(
      extendBody: false,
      body: _PremiumTabView(
        selectedIndex:
            _selectedIndex,
        children:
            pages,
      ),
      bottomNavigationBar:
          _PremiumBottomBar(
        selectedIndex:
            _selectedIndex,
        onSelected:
            _onDestinationSelected,
      ),
    );
  }
}

class _PremiumTabView
    extends StatefulWidget {
  const _PremiumTabView({
    required this.selectedIndex,
    required this.children,
  });

  final int selectedIndex;
  final List<Widget> children;

  @override
  State<_PremiumTabView> createState() =>
      _PremiumTabViewState();
}

class _PremiumTabViewState
    extends State<_PremiumTabView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late Animation<double>
      _fadeAnimation;

  late Animation<Offset>
      _slideAnimation;

  int _displayedIndex = 0;

  @override
  void initState() {
    super.initState();

    _displayedIndex =
        widget.selectedIndex;

    _controller =
        AnimationController(
      vsync: this,
      duration:
          const Duration(
        milliseconds: 320,
      ),
    );

    _createAnimations();

    _controller.value = 1;
  }

  void _createAnimations() {
    final curve =
        CurvedAnimation(
      parent:
          _controller,
      curve:
          Curves.easeOutCubic,
    );

    _fadeAnimation =
        Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      curve,
    );

    _slideAnimation =
        Tween<Offset>(
      begin:
          const Offset(
        0,
        0.018,
      ),
      end:
          Offset.zero,
    ).animate(
      curve,
    );
  }

  @override
  void didUpdateWidget(
    covariant _PremiumTabView
        oldWidget,
  ) {
    super.didUpdateWidget(
      oldWidget,
    );

    if (widget.selectedIndex ==
        oldWidget.selectedIndex) {
      return;
    }

    setState(() {
      _displayedIndex =
          widget.selectedIndex;
    });

    _controller
      ..stop()
      ..forward(
        from: 0,
      );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Stack(
      fit:
          StackFit.expand,
      children: [
        IndexedStack(
          index:
              _displayedIndex,
          children:
              List.generate(
            widget.children.length,
            (
              index,
            ) {
              final child =
                  widget.children[index];

              if (index !=
                  _displayedIndex) {
                return child;
              }

              return FadeTransition(
                opacity:
                    _fadeAnimation,
                child:
                    SlideTransition(
                  position:
                      _slideAnimation,
                  child:
                      child,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PremiumBottomBar
    extends StatelessWidget {
  const _PremiumBottomBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;

  final ValueChanged<int>
      onSelected;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      decoration:
          BoxDecoration(
        color:
            colorScheme.surface
                .withValues(
          alpha: 0.82,
        ),
        border:
            Border(
          top:
              BorderSide(
            color:
                colorScheme
                    .outlineVariant
                    .withValues(
              alpha: 0.45,
            ),
            width:
                0.7,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withValues(
              alpha:
                  0.055,
            ),
            blurRadius:
                28,
            spreadRadius:
                0,
            offset:
                const Offset(
              0,
              -8,
            ),
          ),
        ],
      ),
      child:
          ClipRect(
        child:
            BackdropFilter(
          filter:
              ImageFilter.blur(
            sigmaX:
                22,
            sigmaY:
                22,
          ),
          child:
              SafeArea(
            top:
                false,
            minimum:
                const EdgeInsets.only(
              bottom:
                  4,
            ),
            child:
                Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                8,
                7,
                8,
                5,
              ),
              child:
                  Row(
                children: [
                  Expanded(
                    child:
                        _PremiumNavigationItem(
                      index:
                          0,
                      selectedIndex:
                          selectedIndex,
                      icon:
                          Icons
                              .home_outlined,
                      selectedIcon:
                          Icons
                              .home_rounded,
                      label:
                          'Home',
                      onSelected:
                          onSelected,
                    ),
                  ),

                  Expanded(
                    child:
                        _PremiumNavigationItem(
                      index:
                          1,
                      selectedIndex:
                          selectedIndex,
                      icon:
                          Icons
                              .menu_book_outlined,
                      selectedIcon:
                          Icons
                              .menu_book_rounded,
                      label:
                          'Qur’an',
                      onSelected:
                          onSelected,
                    ),
                  ),

                  Expanded(
                    child:
                        _PremiumNavigationItem(
                      index:
                          2,
                      selectedIndex:
                          selectedIndex,
                      icon:
                          Icons
                              .mosque_outlined,
                      selectedIcon:
                          Icons
                              .mosque_rounded,
                      label:
                          'Prayer',
                      onSelected:
                          onSelected,
                    ),
                  ),

                  Expanded(
                    child:
                        _PremiumNavigationItem(
                      index:
                          3,
                      selectedIndex:
                          selectedIndex,
                      icon:
                          Icons
                              .library_books_outlined,
                      selectedIcon:
                          Icons
                              .library_books_rounded,
                      label:
                          'Hadith',
                      onSelected:
                          onSelected,
                    ),
                  ),

                  Expanded(
                    child:
                        _PremiumNavigationItem(
                      index:
                          4,
                      selectedIndex:
                          selectedIndex,
                      icon:
                          Icons
                              .grid_view_outlined,
                      selectedIcon:
                          Icons
                              .grid_view_rounded,
                      label:
                          'More',
                      onSelected:
                          onSelected,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumNavigationItem
    extends StatefulWidget {
  const _PremiumNavigationItem({
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.onSelected,
  });

  final int index;
  final int selectedIndex;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  final ValueChanged<int>
      onSelected;

  @override
  State<_PremiumNavigationItem>
      createState() =>
          _PremiumNavigationItemState();
}

class _PremiumNavigationItemState
    extends State<
        _PremiumNavigationItem> {
  bool _pressed = false;

  bool get _isSelected {
    return widget.index ==
        widget.selectedIndex;
  }

  void _setPressed(
    bool value,
  ) {
    if (_pressed == value) {
      return;
    }

    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final selectedColor =
        colorScheme.primary;

    final unselectedColor =
        colorScheme
            .onSurfaceVariant;

    return Semantics(
      selected:
          _isSelected,
      button:
          true,
      label:
          widget.label,
      child:
          GestureDetector(
        behavior:
            HitTestBehavior.opaque,
        onTapDown: (
          _,
        ) {
          _setPressed(
            true,
          );
        },
        onTapCancel: () {
          _setPressed(
            false,
          );
        },
        onTapUp: (
          _,
        ) {
          _setPressed(
            false,
          );

          widget.onSelected(
            widget.index,
          );
        },
        child:
            AnimatedScale(
          scale:
              _pressed
                  ? 0.94
                  : 1,
          duration:
              const Duration(
            milliseconds:
                120,
          ),
          curve:
              Curves
                  .easeOutCubic,
          child:
              Padding(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal:
                  2,
              vertical:
                  2,
            ),
            child:
                Column(
              mainAxisSize:
                  MainAxisSize
                      .min,
              children: [
                AnimatedContainer(
                  duration:
                      const Duration(
                    milliseconds:
                        300,
                  ),
                  curve:
                      Curves
                          .easeOutCubic,
                  width:
                      _isSelected
                          ? 48
                          : 40,
                  height:
                      34,
                  decoration:
                      BoxDecoration(
                    color:
                        _isSelected
                            ? selectedColor
                                .withValues(
                                alpha:
                                    0.12,
                              )
                            : Colors
                                .transparent,
                    borderRadius:
                        BorderRadius
                            .circular(
                      17,
                    ),
                  ),
                  alignment:
                      Alignment.center,
                  child:
                      AnimatedSwitcher(
                    duration:
                        const Duration(
                      milliseconds:
                          220,
                    ),
                    switchInCurve:
                        Curves
                            .easeOutBack,
                    switchOutCurve:
                        Curves
                            .easeInCubic,
                    transitionBuilder:
                        (
                      child,
                      animation,
                    ) {
                      return FadeTransition(
                        opacity:
                            animation,
                        child:
                            ScaleTransition(
                          scale:
                              Tween<double>(
                            begin:
                                0.82,
                            end:
                                1,
                          ).animate(
                            animation,
                          ),
                          child:
                              child,
                        ),
                      );
                    },
                    child:
                        Icon(
                      _isSelected
                          ? widget
                              .selectedIcon
                          : widget
                              .icon,
                      key:
                          ValueKey(
                        _isSelected,
                      ),
                      size:
                          _isSelected
                              ? 24
                              : 23,
                      color:
                          _isSelected
                              ? selectedColor
                              : unselectedColor,
                    ),
                  ),
                ),

                const SizedBox(
                  height:
                      2,
                ),

                AnimatedDefaultTextStyle(
                  duration:
                      const Duration(
                    milliseconds:
                        220,
                  ),
                  curve:
                      Curves
                          .easeOutCubic,
                  style:
                      TextStyle(
                    color:
                        _isSelected
                            ? selectedColor
                            : unselectedColor,
                    fontSize:
                        11.5,
                    height:
                        1.2,
                    fontWeight:
                        _isSelected
                            ? FontWeight
                                .w700
                            : FontWeight
                                .w500,
                    letterSpacing:
                        -0.15,
                  ),
                  child:
                      Text(
                    widget.label,
                    maxLines:
                        1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceholderPage
    extends StatelessWidget {
  const _PlaceholderPage({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar:
          AppBar(
        title:
            Text(
          title,
        ),
      ),
      body:
          Center(
        child:
            Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              icon,
              size:
                  64,
              color:
                  Theme.of(
                context,
              )
                      .colorScheme
                      .primary,
            ),

            const SizedBox(
              height:
                  16,
            ),

            Text(
              '$title section coming next',
              style:
                  Theme.of(
                context,
              )
                      .textTheme
                      .titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}