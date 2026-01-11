import 'package:apd/presentation/screens/flashcards/flashcards_dashboard_screen.dart';
import 'package:apd/presentation/screens/home/home_screen.dart';
import 'package:apd/presentation/state/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Util/bottom_bar.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomeScreen(),
          FlashcardsDashboardScreen(),
          // ProfileScreen(),
        ],
      ),

      bottomNavigationBar: AppBottomBar(
        // currentIndex: _currentIndex,
        // onTap: _onTabTapped,
        currentIndex: currentIndex,
        onTap: (index) => ref.read(currentIndexProvider.notifier).state = index,
      ),
    );
  }
}
