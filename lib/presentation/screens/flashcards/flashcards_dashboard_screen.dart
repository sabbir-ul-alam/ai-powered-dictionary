import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import 'flashcard_session_screen.dart';

class FlashcardsDashboardScreen extends ConsumerWidget {
  const FlashcardsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allStatsAsync = ref.watch(learningStatsAllProvider);
    final favStatsAsync = ref.watch(learningStatsFavoritesProvider);

    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF7F7F7),
        title: const Text('Flashcards'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            allStatsAsync.when(
              loading: () => const _TopScoreCardSkeleton(),
              error: (_, __) => const _TopScoreCardError(),
              data: (all) => _TopScoreCard(
                learned: all.learned,
                total: all.total,
              ),
            ),
            const SizedBox(height: 16),

            allStatsAsync.when(
              loading: () => const _CategoryCardSkeleton(),
              error: (_, __) => const _CategoryCardError(title: 'All Words'),
              data: (stats) => _CategoryCard(
                title: 'All Words',
                learned: stats.learned,
                unlearned: stats.unlearned,
                onStartAll: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FlashcardSessionScreen(
                        favoritesOnly: false,
                        unlearnedOnly: false,
                      ),
                    ),
                  );
                },
                onStartUnlearned: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FlashcardSessionScreen(
                        favoritesOnly: false,
                        unlearnedOnly: true,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            favStatsAsync.when(
              loading: () => const _CategoryCardSkeleton(),
              error: (_, __) => const _CategoryCardError(title: 'Favourites'),
              data: (stats) => _CategoryCard(
                title: 'Favourites',
                learned: stats.learned,
                unlearned: stats.unlearned,
                onStartAll: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FlashcardSessionScreen(
                        favoritesOnly: true,
                        unlearnedOnly: false,
                      ),
                    ),
                  );
                },
                onStartUnlearned: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FlashcardSessionScreen(
                        favoritesOnly: true,
                        unlearnedOnly: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopScoreCard extends StatelessWidget {
  final int learned;
  final int total;

  const _TopScoreCard({
    required this.learned,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final text = 'Learned $learned / $total words';

    return Card(
      color: Color(0xFFF7F7F7),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Icon(Icons.style),
          ],
        ),
      ),
    );
  }
}

class _TopScoreCardSkeleton extends StatelessWidget {
  const _TopScoreCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Color(0xFFF7F7F7),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(height: 24),
      ),
    );
  }
}

class _TopScoreCardError extends StatelessWidget {
  const _TopScoreCardError();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Failed to load score'),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final int learned;
  final int unlearned;
  final VoidCallback onStartAll;
  final VoidCallback onStartUnlearned;

  const _CategoryCard({
    required this.title,
    required this.learned,
    required this.unlearned,
    required this.onStartAll,
    required this.onStartUnlearned,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFF7F7F7),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Learned: $learned'),
            Text('Unlearned: $unlearned'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onStartAll,
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B2EFF),
                      elevation: 3
                    ),
                    child: const Text('Start All',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onStartUnlearned,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3B2EFF),
                        elevation: 3

                    ),
                    child: const Text('Start Unlearned',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCardSkeleton extends StatelessWidget {
  const _CategoryCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(height: 110),
      ),
    );
  }
}

class _CategoryCardError extends StatelessWidget {
  final String title;

  const _CategoryCardError({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Failed to load $title stats'),
      ),
    );
  }
}
