import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../language/language_selection_screen.dart';
import '../word/add_word_screen.dart';
import '../word/word_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Debounce to avoid spamming providers/DB on every keystroke
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      ref.read(wordSearchQueryProvider.notifier).state = value;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(wordSearchQueryProvider.notifier).state = '';
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final activeLanguageAsync = ref.watch(activeLanguageProvider);
    final wordCountAsync = ref.watch(wordCountProvider);

    // Decide whether we are in "search mode"
    final searchQuery = ref.watch(wordSearchQueryProvider);
    final isSearching = searchQuery.trim().isNotEmpty;

    // Use either full list or search results depending on query
    final wordsAsync = isSearching
        ? ref.watch(wordSearchResultsProvider)
        : ref.watch(wordListProvider);

    return Scaffold(
      appBar: AppBar(
        title: activeLanguageAsync.when(
          data: (language) => Text(language?.displayName ?? 'Dictionary'),
          loading: () => const Text('Loading…'),
          error: (_, __) => const Text('Dictionary'),
        ),
        actions: [
          IconButton(
            tooltip: 'Change language',
            icon: const Icon(Icons.language),
            onPressed: () {
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
      /// ADD WORD
      /// ---------------------------------------------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddWordScreen(),
            ),
          );

          // Refresh list/count (and any search results if active)
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
            /// SEARCH BAR
            /// ---------------------------------------------------------------
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search words',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                  tooltip: 'Clear',
                  icon: const Icon(Icons.close),
                  onPressed: _clearSearch,
                ),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// ---------------------------------------------------------------
            /// WORD COUNT (total for active language)
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
            /// WORD LIST OR SEARCH RESULTS
            /// ---------------------------------------------------------------
            Expanded(
              child: wordsAsync.when(
                data: (words) {
                  // wordSearchResultsProvider returns List<String> right now (prefix suggestions),
                  // while wordListProvider returns List<Word>.
                  //
                  // To keep Phase 1 stable, we handle both types safely here.
                  //
                  // If you implement real repository.searchWords() returning List<Word>,
                  // then this becomes a single path.
                  if (words is List<String>) {
                    if (words.isEmpty) {
                      return _SearchEmptyState(query: searchQuery.trim());
                    }
                    return ListView.separated(
                      itemCount: words.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final word = words[index];
                        return _WordListItem(
                          text: word.wordText,
                          onTap: () {
                            // We cannot open detail reliably from just the text,
                            // because we need wordId.
                            //
                            // Best practice: implement repository.searchWords()
                            // that returns Word objects including id.
                            //
                            // For now, keep it simple: fill search box with exact suggestion.
                            _searchController.text = word.wordText;
                            _searchController.selection = TextSelection.fromPosition(
                              TextPosition(offset: _searchController.text.length),
                            );
                            ref.read(wordSearchQueryProvider.notifier).state = word.wordText;
                          },
                        );
                      },
                    );
                  }

                  // Normal path: list of Word rows
                  if (words is List && words.isEmpty) {
                    return const _EmptyState();
                  }

                  if (words is! List) {
                    return const Center(child: Text('Unexpected data'));
                  }

                  // Safe cast: words from wordListProvider are List<Word>
                  final wordRows = words;

                  return ListView.separated(
                    itemCount: wordRows.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final word = wordRows[index];

                      return _WordListItem(
                        text: word.wordText,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WordDetailScreen(
                                word: word,
                              ),
                            ),
                          );


// ✅ SAFETY CHECK
                          if (!mounted) return;

                          ref.read(activeLanguageTriggerProvider.notifier).state++;

                          // If user edited/deleted, refresh list and count
                          ref.read(activeLanguageTriggerProvider.notifier).state++;
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
/// EMPTY STATE (no words in dictionary)
/// ---------------------------------------------------------------------------

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

/// ---------------------------------------------------------------------------
/// SEARCH EMPTY STATE
/// ---------------------------------------------------------------------------

class _SearchEmptyState extends StatelessWidget {
  final String query;

  const _SearchEmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No results for "$query"',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
