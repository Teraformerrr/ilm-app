import 'package:flutter/material.dart';

class ProfileOnboardingResult {
  const ProfileOnboardingResult({
    required this.name,
    required this.age,
    required this.gender,
  });

  final String name;
  final int age;
  final String? gender;
}

class ProfileOnboardingScreen extends StatefulWidget {
  const ProfileOnboardingScreen({
    required this.onCompleted,
    super.key,
  });

  final Future<void> Function(
    ProfileOnboardingResult result,
  ) onCompleted;

  @override
  State<ProfileOnboardingScreen> createState() =>
      _ProfileOnboardingScreenState();
}

class _ProfileOnboardingScreenState
    extends State<ProfileOnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController =
      PageController();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _ageController =
      TextEditingController();

  late final AnimationController _entranceController;

  late final Animation<double> _fadeAnimation;

  late final Animation<Offset> _slideAnimation;

  int _currentPage = 0;

  String? _selectedGender;

  bool _isSubmitting = false;

  static const int _pageCount = 4;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 650,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(
        0,
        0.08,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _entranceController.dispose();

    super.dispose();
  }

  Future<void> _animatePageEntrance() async {
    _entranceController.reset();

    await _entranceController.forward();
  }

  Future<void> _goToPage(
    int page,
  ) async {
    if (page < 0 ||
        page >= _pageCount) {
      return;
    }

    FocusScope.of(context).unfocus();

    await _pageController.animateToPage(
      page,
      duration: const Duration(
        milliseconds: 520,
      ),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _nextFromName() async {
    final name =
        _nameController.text.trim();

    if (name.length < 2) {
      _showMessage(
        'Please enter your name.',
      );

      return;
    }

    await _goToPage(1);
  }

  Future<void> _nextFromAge() async {
    final age = int.tryParse(
      _ageController.text.trim(),
    );

    if (age == null ||
        age < 5 ||
        age > 120) {
      _showMessage(
        'Please enter a valid age.',
      );

      return;
    }

    await _goToPage(2);
  }

  Future<void> _nextFromGender() async {
    await _goToPage(3);
  }

  Future<void> _completeProfile() async {
    if (_isSubmitting) {
      return;
    }

    final name =
        _nameController.text.trim();

    final age = int.tryParse(
      _ageController.text.trim(),
    );

    if (name.isEmpty ||
        age == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await widget.onCompleted(
      ProfileOnboardingResult(
        name: name,
        age: age,
        gender:
            _selectedGender,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
      ),
    );
  }

  String get _firstName {
    final name =
        _nameController.text.trim();

    if (name.isEmpty) {
      return '';
    }

    return name
        .split(RegExp(r'\s+'))
        .first;
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Scaffold(
      backgroundColor:
          colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                24,
                18,
                24,
                6,
              ),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      tooltip: 'Back',
                      onPressed: () {
                        _goToPage(
                          _currentPage - 1,
                        );
                      },
                      icon: const Icon(
                        Icons
                            .arrow_back_ios_new_rounded,
                      ),
                    )
                  else
                    const SizedBox(
                      width: 48,
                    ),

                  const Spacer(),

                  _ProgressIndicator(
                    currentPage:
                        _currentPage,
                    totalPages:
                        _pageCount,
                  ),

                  const Spacer(),

                  const SizedBox(
                    width: 48,
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView(
                controller:
                    _pageController,
                physics:
                    const NeverScrollableScrollPhysics(),
                onPageChanged:
                    (page) {
                  setState(() {
                    _currentPage =
                        page;
                  });

                  _animatePageEntrance();
                },
                children: [
                  _AnimatedPage(
                    fadeAnimation:
                        _fadeAnimation,
                    slideAnimation:
                        _slideAnimation,
                    child: _NamePage(
                      controller:
                          _nameController,
                      onContinue:
                          _nextFromName,
                    ),
                  ),

                  _AnimatedPage(
                    fadeAnimation:
                        _fadeAnimation,
                    slideAnimation:
                        _slideAnimation,
                    child: _AgePage(
                      name:
                          _firstName,
                      controller:
                          _ageController,
                      onContinue:
                          _nextFromAge,
                    ),
                  ),

                  _AnimatedPage(
                    fadeAnimation:
                        _fadeAnimation,
                    slideAnimation:
                        _slideAnimation,
                    child: _GenderPage(
                      name:
                          _firstName,
                      selectedGender:
                          _selectedGender,
                      onChanged:
                          (gender) {
                        setState(() {
                          _selectedGender =
                              gender;
                        });
                      },
                      onContinue:
                          _nextFromGender,
                    ),
                  ),

                  _AnimatedPage(
                    fadeAnimation:
                        _fadeAnimation,
                    slideAnimation:
                        _slideAnimation,
                    child: _CompletionPage(
                      name:
                          _firstName,
                      isSubmitting:
                          _isSubmitting,
                      onContinue:
                          _completeProfile,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedPage extends StatelessWidget {
  const _AnimatedPage({
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.child,
  });

  final Animation<double>
      fadeAnimation;

  final Animation<Offset>
      slideAnimation;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity:
          fadeAnimation,
      child: SlideTransition(
        position:
            slideAnimation,
        child: child,
      ),
    );
  }
}

class _NamePage extends StatelessWidget {
  const _NamePage({
    required this.controller,
    required this.onContinue,
  });

  final TextEditingController controller;

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _OnboardingPageShell(
      icon:
          Icons.person_outline_rounded,
      eyebrow:
          'LET’S MAKE ILM YOURS',
      title:
          'What should we call you?',
      subtitle:
          'Your name stays on this device and helps ILM feel more personal.',
      child: Column(
        children: [
          TextField(
            controller:
                controller,
            autofocus: true,
            textCapitalization:
                TextCapitalization.words,
            textInputAction:
                TextInputAction.next,
            onSubmitted:
                (_) => onContinue(),
            style:
                Theme.of(context)
                    .textTheme
                    .titleLarge,
            decoration:
                InputDecoration(
              hintText:
                  'Your name',
              prefixIcon:
                  const Icon(
                Icons
                    .person_rounded,
              ),
              filled: true,
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                borderSide:
                    BorderSide.none,
              ),
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          _PrimaryButton(
            label: 'Continue',
            onPressed:
                onContinue,
          ),
        ],
      ),
    );
  }
}

class _AgePage extends StatelessWidget {
  const _AgePage({
    required this.name,
    required this.controller,
    required this.onContinue,
  });

  final String name;

  final TextEditingController controller;

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _OnboardingPageShell(
      icon:
          Icons.cake_outlined,
      eyebrow:
          'A LITTLE ABOUT YOU',
      title: name.isEmpty
          ? 'How old are you?'
          : 'Nice to meet you, $name.',
      subtitle:
          'Your age can help us tailor parts of the experience appropriately.',
      child: Column(
        children: [
          TextField(
            controller:
                controller,
            keyboardType:
                TextInputType.number,
            textInputAction:
                TextInputAction.next,
            onSubmitted:
                (_) => onContinue(),
            style:
                Theme.of(context)
                    .textTheme
                    .titleLarge,
            decoration:
                InputDecoration(
              hintText: 'Age',
              suffixText: 'years',
              prefixIcon:
                  const Icon(
                Icons
                    .calendar_today_rounded,
              ),
              filled: true,
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                borderSide:
                    BorderSide.none,
              ),
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          _PrimaryButton(
            label: 'Continue',
            onPressed:
                onContinue,
          ),
        ],
      ),
    );
  }
}

class _GenderPage extends StatelessWidget {
  const _GenderPage({
    required this.name,
    required this.selectedGender,
    required this.onChanged,
    required this.onContinue,
  });

  final String name;
  final String? selectedGender;

  final ValueChanged<String?>
      onChanged;

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _OnboardingPageShell(
      icon:
          Icons.people_outline_rounded,
      eyebrow:
          'PERSONALIZE YOUR EXPERIENCE',
      title: name.isEmpty
          ? 'How would you like to identify?'
          : 'One more thing, $name.',
      subtitle:
          'This is optional. You can change it later from Settings.',
      child: Column(
        children: [
          _GenderOption(
            icon:
                Icons.male_rounded,
            label: 'Male',
            value: 'male',
            selected:
                selectedGender ==
                    'male',
            onTap: () {
              onChanged(
                'male',
              );
            },
          ),

          const SizedBox(
            height: 12,
          ),

          _GenderOption(
            icon:
                Icons.female_rounded,
            label: 'Female',
            value: 'female',
            selected:
                selectedGender ==
                    'female',
            onTap: () {
              onChanged(
                'female',
              );
            },
          ),

          const SizedBox(
            height: 12,
          ),

          _GenderOption(
            icon:
                Icons
                    .remove_circle_outline_rounded,
            label:
                'Prefer not to say',
            value: 'prefer_not_to_say',
            selected:
                selectedGender ==
                    'prefer_not_to_say',
            onTap: () {
              onChanged(
                'prefer_not_to_say',
              );
            },
          ),

          const SizedBox(
            height: 24,
          ),

          _PrimaryButton(
            label: 'Continue',
            onPressed:
                onContinue,
          ),
        ],
      ),
    );
  }
}

class _CompletionPage extends StatelessWidget {
  const _CompletionPage({
    required this.name,
    required this.isSubmitting,
    required this.onContinue,
  });

  final String name;
  final bool isSubmitting;

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final firstName =
        name.isEmpty
            ? 'there'
            : name;

    return _OnboardingPageShell(
      icon:
          Icons.auto_awesome_rounded,
      eyebrow:
          'YOU’RE READY',
      title:
          'Welcome, $firstName.',
      subtitle:
          'Your ILM experience is ready. May it be a source of beneficial knowledge and reflection.',
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(
              22,
            ),
            decoration:
                BoxDecoration(
              color:
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withValues(
                        alpha: 0.42,
                      ),
              borderRadius:
                  BorderRadius.circular(
                24,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons
                      .check_circle_rounded,
                  size: 42,
                  color:
                      Theme.of(context)
                          .colorScheme
                          .primary,
                ),

                const SizedBox(
                  height: 12,
                ),

                Text(
                  'Everything is set.',
                  style:
                      Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          _PrimaryButton(
            label:
                'Enter ILM',
            loading:
                isSubmitting,
            onPressed:
                isSubmitting
                    ? null
                    : onContinue,
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageShell
    extends StatelessWidget {
  const _OnboardingPageShell({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return SingleChildScrollView(
      padding:
          const EdgeInsets.fromLTRB(
        28,
        52,
        28,
        32,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration:
                BoxDecoration(
              color:
                  colorScheme
                      .primaryContainer,
              borderRadius:
                  BorderRadius.circular(
                22,
              ),
            ),
            child: Icon(
              icon,
              size: 32,
              color:
                  colorScheme.primary,
            ),
          ),

          const SizedBox(
            height: 34,
          ),

          Text(
            eyebrow,
            style:
                theme
                    .textTheme
                    .labelMedium
                    ?.copyWith(
              color:
                  colorScheme.primary,
              fontWeight:
                  FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          Text(
            title,
            style:
                theme
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
              fontWeight:
                  FontWeight.w700,
              letterSpacing: -0.8,
              height: 1.15,
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          Text(
            subtitle,
            style:
                theme
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
              color:
                  colorScheme
                      .onSurfaceVariant,
              height: 1.55,
            ),
          ),

          const SizedBox(
            height: 42,
          ),

          child,
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.icon,
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration:
          const Duration(
        milliseconds: 240,
      ),
      curve:
          Curves.easeOutCubic,
      decoration:
          BoxDecoration(
        color: selected
            ? colorScheme
                .primaryContainer
            : colorScheme
                .surfaceContainerLow,
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: selected
              ? colorScheme.primary
              : colorScheme.outlineVariant,
          width:
              selected ? 1.5 : 1,
        ),
      ),
      child: Material(
        color:
            Colors.transparent,
        child: InkWell(
          borderRadius:
              BorderRadius.circular(
            20,
          ),
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.all(
              18,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected
                      ? colorScheme
                          .primary
                      : colorScheme
                          .onSurfaceVariant,
                ),

                const SizedBox(
                  width: 16,
                ),

                Expanded(
                  child: Text(
                    label,
                    style:
                        Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                  ),
                ),

                AnimatedSwitcher(
                  duration:
                      const Duration(
                    milliseconds: 200,
                  ),
                  child: selected
                      ? Icon(
                          Icons
                              .check_circle_rounded,
                          key:
                              const ValueKey(
                            'selected',
                          ),
                          color:
                              colorScheme
                                  .primary,
                        )
                      : Icon(
                          Icons
                              .circle_outlined,
                          key:
                              const ValueKey(
                            'not-selected',
                          ),
                          color:
                              colorScheme
                                  .outline,
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

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          double.infinity,
      height: 58,
      child:
          FilledButton(
        onPressed:
            onPressed,
        style:
            FilledButton.styleFrom(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              18,
            ),
          ),
          elevation: 0,
        ),
        child: AnimatedSwitcher(
          duration:
              const Duration(
            milliseconds: 200,
          ),
          child: loading
              ? const SizedBox(
                  key:
                      ValueKey(
                    'loading',
                  ),
                  width: 22,
                  height: 22,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  key:
                      const ValueKey(
                    'label',
                  ),
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                  children: [
                    Text(
                      label,
                      style:
                          Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color:
                                    Theme.of(
                                  context,
                                )
                                        .colorScheme
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
                          Theme.of(
                        context,
                      )
                              .colorScheme
                              .onPrimary,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ProgressIndicator
    extends StatelessWidget {
  const _ProgressIndicator({
    required this.currentPage,
    required this.totalPages,
  });

  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children:
          List.generate(
        totalPages,
        (index) {
          final selected =
              index ==
                  currentPage;

          return AnimatedContainer(
            duration:
                const Duration(
              milliseconds: 280,
            ),
            curve:
                Curves.easeOutCubic,
            width:
                selected
                    ? 28
                    : 7,
            height: 7,
            margin:
                const EdgeInsets.symmetric(
              horizontal: 3,
            ),
            decoration:
                BoxDecoration(
              color: selected
                  ? colorScheme.primary
                  : colorScheme
                      .outlineVariant,
              borderRadius:
                  BorderRadius.circular(
                999,
              ),
            ),
          );
        },
      ),
    );
  }
}