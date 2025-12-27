import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../word/add_word_screen.dart';
import '../language/language_selection_screen.dart';
import '../word/word_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLanguageAsync = ref.watch(activeLanguageProvider);
    final wordListAsync = ref.watch(wordListProvider);
    final wordCountAsync = ref.watch(wordCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: activeLanguageAsync.when(
          data: (language) =>
              Text(language?.displayName ?? 'Dictionary'),
          loading: () => const Text('Loading…'),
          error: (_, __) => const Text('Dictionary'),
        ),
        actions: [
          IconButton(
            tooltip: 'Change language',
            icon: const Icon(Icons.language),
            onPressed: () {
              // Allow user to change dictionary explicitly
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LanguageSelectionScreen(),
                ),
              );
            },
          ),
        ],
      ),

      /// ---------------------------------------------------------------------
      /// ADD WORD BUTTON
      /// ---------------------------------------------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddWordScreen(),
            ),
          );

          // Refresh list + count after returning
          ref.read(activeLanguageTriggerProvider.notifier).state++;
        },
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------------------------------------------------------
            /// WORD COUNT
            /// ---------------------------------------------------------------
            wordCountAsync.when(
              data: (count) => Text(
                '$count words',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              loading: () => const SizedBox(
                height: 20,
                child: LinearProgressIndicator(),
              ),
              error: (_, __) => const Text('—'),
            ),

            const SizedBox(height: 12),
            const Divider(),

            /// ---------------------------------------------------------------
            /// WORD LIST
            /// ---------------------------------------------------------------
            Expanded(
              child: wordListAsync.when(
                data: (words) {
                  if (words.isEmpty) {
                    return const _EmptyState();
                  }

                  return ListView.separated(
                    itemCount: words.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final word = words[index];
                      return _WordListItem(
                        text: word.wordText,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WordDetailScreen(
                                word: word,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (_, __) => const Center(
                  child: Text('Failed to load words'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// WORD LIST ITEM
/// ---------------------------------------------------------------------------
///
/// Minimal list item for Phase 1.
/// Metadata, pronunciation, and actions come later.
///
class _WordListItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _WordListItem({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}


/// ---------------------------------------------------------------------------
/// EMPTY STATE
/// ---------------------------------------------------------------------------
///
/// Shown when no words exist for the selected language.
///
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.menu_book_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No words yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tap + to add your first word',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
