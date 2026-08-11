import 'package:flutter/material.dart';

import 'dream_interpretation_screen.dart';
import 'duas_adhkar_screen.dart';
import 'home_screen.dart';
import 'more_screen.dart';
import 'prayer_screen.dart';
import 'quran_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDreamInterpretation() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            const DreamInterpretationScreen(),
      ),
    );
  }

  void _openDuasAdhkar() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            const DuasAdhkarScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        onNavigateToTab:
            _onDestinationSelected,
        onOpenDreamInterpretation:
            _openDreamInterpretation,
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
        onOpenDreamInterpretation:
            _openDreamInterpretation,
        onOpenDuas:
            _openDuasAdhkar,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected:
            _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon:
                Icon(Icons.home_outlined),
            selectedIcon:
                Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.menu_book_outlined,
            ),
            selectedIcon: Icon(
              Icons.menu_book,
            ),
            label: 'Qur’an',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.mosque_outlined,
            ),
            selectedIcon: Icon(
              Icons.mosque,
            ),
            label: 'Prayer',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.library_books_outlined,
            ),
            selectedIcon: Icon(
              Icons.library_books,
            ),
            label: 'Hadith',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.grid_view_outlined,
            ),
            selectedIcon: Icon(
              Icons.grid_view,
            ),
            label: 'More',
          ),
        ],
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              '$title section coming next',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}