import 'package:apd/presentation/screens/flashcards/flashcard_session_screen.dart';
import 'package:apd/presentation/screens/flashcards/flashcards_dashboard_screen.dart';
import 'package:apd/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import './screens/home/home_screen.dart';
import 'Util/bottom_bar.dart';
// import 'quiz_screen.dart';
// import 'profile_screen.dart';
// import 'bottom_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          FlashcardsDashboardScreen(),
          // ProfileScreen(),
        ],
      ),

      bottomNavigationBar: AppBottomBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
