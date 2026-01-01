import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/db/app_database.dart';
import '../../state/providers.dart';
import '../flashcards/flashcard_session_screen.dart';
import '../language/language_selection_screen.dart';
import '../word/add_word_screen.dart';
import '../word/word_detail_screen.dart';

const primaryColor = Color(0xFF3B2EFF);
const lightGrey = Color(0xCFDFEDEA);
const textGrey = Color(0xFF6B7280);
const backgroundColor = Color(0xFFF7F7F7);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _searchController = TextEditingController();
  Timer? _debounce;
  int _currentIndex = 0;


  @override
  void dispose() {
    _debounce?.cancel();
    // _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Debounce to avoid spamming providers/DB on every keystroke
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      ref.read(wordSearchQueryProvider.notifier).state = value;
    });
  }
  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // IMPORTANT:
    // Do NOT navigate yet unless you already have routes.
    // This is visual state only for now.
  }


  void _clearSearch() {
    _searchController.clear();
    ref.read(wordSearchQueryProvider.notifier).state = '';
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final activeLanguageAsync = ref.watch(activeLanguageProvider);
    final allWordCountAsync = ref.watch(wordCountProvider);
    final starredWordCountAsync = ref.watch(starredWordCountProvider);

    final favoritesOnly = ref.watch(favoritesOnlyProvider);
    // Decide whether we are in "search mode"
    final searchQuery = ref.watch(wordSearchQueryProvider);
    _searchController.text = searchQuery;
    final isSearching = searchQuery.trim().isNotEmpty;

    // Use either full list or search results depending on query
    final wordsAsync =
        isSearching
            ? ref.watch(wordSearchResultsProvider)
            : ref.watch(wordListProvider);

    // int? all = wordCountAsync.value;

    return Scaffold(
      backgroundColor: backgroundColor,

      bottomNavigationBar: AppBottomBar(
        currentIndex: _currentIndex, // existing state
        onTap: _onNavItemTapped,      // existing handler
      ),

      //     // Row(
      //     //   children: [
      //     //     ElevatedButton.icon(
      //     //       icon: const Icon(Icons.style),
      //     //       label: const Text('Flashcards'),
      //     //       onPressed: () {
      //     //         Navigator.of(context).push(
      //     //           MaterialPageRoute(
      //     //             builder: (_) =>
      //     //             const FlashcardSessionScreen(
      //     //               favoritesOnly: false,
      //     //             ),
      //     //           ),
      //     //         );
      //     //       },
      //     //     ),
      //     //     const SizedBox(width: 8),
      //     //     ElevatedButton.icon(
      //     //       icon: const Icon(Icons.star),
      //     //       label: const Text('Favourites'),
      //     //       onPressed: () {
      //     //         Navigator.of(context).push(
      //     //           MaterialPageRoute(
      //     //             builder: (_) =>
      //     //             const FlashcardSessionScreen(
      //     //               favoritesOnly: true,
      //     //             ),
      //     //           ),
      //     //         );
      //     //       },
      //     //     ),
      //     //   ],
      //     // ),
      //
      //   ],
      // ),

      /// ---------------------------------------------------------------------
      /// ADD WORD
      /// ---------------------------------------------------------------------
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddWordScreen()));

          // Refresh list/count (and any search results if active)
          ref.read(activeLanguageTriggerProvider.notifier).state++;
        },
        child: const Icon(Icons.add, size: 28, color: backgroundColor),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,



      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _HeaderBar(activeLanguageAsync: activeLanguageAsync),
              const SizedBox(height: 20),

              /// ---------------------------------------------------------------
              /// SEARCH BAR
              /// ---------------------------------------------------------------
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),

                child: TextField(
                  textAlignVertical: TextAlignVertical(y: .5),
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search words',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchController.text.isEmpty
                            ? null
                            : IconButton(
                              tooltip: 'Clear',
                              icon: const Icon(Icons.close),
                              onPressed: _clearSearch,
                            ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              // const Divider(),
              /// All / Favourites toggle
              Row(
                children: [
                  ChoiceChip(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    shape: RoundedSuperellipseBorder(
                      side: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    showCheckmark: false,
                    selectedColor: primaryColor,
                    backgroundColor: Colors.grey[200],
                    label: Text(
                      'All (${allWordCountAsync.value})',
                      style: TextStyle(
                        color: !favoritesOnly ? Colors.white : textGrey,
                      ),
                    ),
                    selected: !favoritesOnly,
                    onSelected: (_) {
                      ref.read(favoritesOnlyProvider.notifier).state = false;
                      ref.read(activeLanguageTriggerProvider.notifier).state++;
                    },
                  ),

                  const SizedBox(width: 12),

                  ChoiceChip(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),

                    shape: RoundedSuperellipseBorder(
                      side: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.grey[200],
                    selectedColor: primaryColor,
                    showCheckmark: false,
                    label: Text(
                      'Starred (${starredWordCountAsync.value})',
                      style: TextStyle(
                        color: favoritesOnly ? Colors.white : textGrey,
                      ),
                    ),
                    selected: favoritesOnly,
                    onSelected: (_) {
                      ref.read(favoritesOnlyProvider.notifier).state = true;
                      ref.read(activeLanguageTriggerProvider.notifier).state++;
                    },
                  ),
                  const Spacer(),

                  // wordCountAsync.when(
                  //   data: (c) => Text('$c'),
                  //   loading:
                  //       () => const SizedBox(
                  //         height: 16,
                  //         width: 16,
                  //         child: CircularProgressIndicator(strokeWidth: 2),
                  //       ),
                  //   error: (_, __) => const Text('—'),
                  // ),
                ],
              ),

              const SizedBox(height: 12),
              // const Divider(),

              /// ---------------------------------------------------------------
              /// WORD LIST OR SEARCH RESULTS
              /// ---------------------------------------------------------------
              Expanded(
                child: wordsAsync.when(
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error:
                      (_, __) =>
                          const Center(child: Text('Failed to load words')),
                  data: (words) {
                    if (words.isEmpty) {
                      if (isSearching) {
                        return _SearchEmptyState(query: searchQuery.trim());
                      }
                      return const _EmptyState();
                    }
                    return ListView.separated(
                      itemCount: words.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 1),
                      itemBuilder: (context, index) {
                        final word = words[index];
                        return _WordListItem(
                          text: word.wordText,
                          meaning: word.shortMeaning,
                          isFavorite: word.isFavorite,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => WordDetailScreen(word: word),
                              ),
                            );
                            if (!mounted) return;
                            ref
                                .read(activeLanguageTriggerProvider.notifier)
                                .state++;
                          },
                          onToggleFavorite: () async {
                            await ref
                                .read(wordRepositoryProvider)
                                .setFavorite(
                                  id: word.id,
                                  isFavorite: !word.isFavorite,
                                );
                            ref
                                .read(activeLanguageTriggerProvider.notifier)
                                .state++;
                          },

                          // onTap: () {
                          //   // We cannot open detail reliably from just the text,
                          //   // because we need wordId.
                          //   //
                          //   // Best practice: implement repository.searchWords()
                          //   // that returns Word objects including id.
                          //   //
                          //   // For now, keep it simple: fill search box with exact suggestion.
                          //   _searchController.text = word.wordText;
                          //   _searchController.selection = TextSelection.fromPosition(
                          //     TextPosition(offset: _searchController.text.length),
                          //   );
                          //   ref.read(wordSearchQueryProvider.notifier).state = word.wordText;
                          // },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// WORD LIST ITEM
/// ---------------------------------------------------------------------------

class _HeaderBar extends StatelessWidget {
  final AsyncValue<Language?> activeLanguageAsync;

  const _HeaderBar({required this.activeLanguageAsync});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const LanguageSelectionScreen(),
              ),
            );
          },
          child: Row(
            children: [
              // activeLanguageAsync.when(
              //         data: (language) => Text(language!.displayName),
              //         loading: () => const Text('Loading…'),
              //         error: (_, __) => const Text('Dictionary'),
              //       ),
              Text(
                activeLanguageAsync.when(
                  data: (language) => language!.displayName,
                  loading: () => 'Loading…',
                  error: (_, __) => 'Dictionary',
                ),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            // existing settings logic
          },
        ),
      ],
    );
  }
}


class AppBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: Icons.quiz_outlined,
            label: 'Quiz',
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: 'Profile',
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
            color: isActive ? primaryColor : const Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? primaryColor : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}



class _WordListItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final String? meaning;

  const _WordListItem({
    required this.text,
    required this.meaning,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(left: 15, right:15, top:  5, bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 4,
              spreadRadius: .2,
              offset: const Offset(1, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    text.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.bookmark : Icons.bookmark_outline,
                    color: isFavorite ? primaryColor :Colors.grey,
                  ),
                  onPressed: onToggleFavorite,
                ),
              ],
            ),
            // const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
              // word.partOfSpeech,
                text.toLowerCase(),
              style: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w600,
              ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              meaning ?? '',
              style: const TextStyle(
                fontSize: 15,
                color: textGrey,
                height: 1.5,
              ),
            ),
          ],
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
          Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No words yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
