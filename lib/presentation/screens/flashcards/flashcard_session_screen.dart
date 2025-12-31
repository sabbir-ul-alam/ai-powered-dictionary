import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../word/word_detail_screen.dart';
import '../../../data/local/db/app_database.dart';
import 'flashcard_card.dart';

class FlashcardSessionScreen extends ConsumerStatefulWidget {
  final bool favoritesOnly;

  const FlashcardSessionScreen({
    super.key,
    required this.favoritesOnly,
  });

  @override
  ConsumerState<FlashcardSessionScreen> createState() =>
      _FlashcardSessionScreenState();
}

class _FlashcardSessionScreenState
    extends ConsumerState<FlashcardSessionScreen> {
  int _currentIndex = 0;
  bool _isFlipped = false;

  late List<Word> _words;

  @override
  void initState() {
    super.initState();
    _words = [];
  }

  void _nextCard() {
    if (_currentIndex < _words.length - 1) {
      setState(() {
        _currentIndex++;
        _isFlipped = false;
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isFlipped = false;
      });
    }
  }

  void _toggleFlip() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wordsAsync = ref.watch(wordListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.favoritesOnly
              ? 'Favourite Flashcards'
              : 'Flashcards',
        ),
      ),
      body: wordsAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
        const Center(child: Text('Failed to load flashcards')),
        data: (words) {
          // Filter favourites here instead of touching provider state
          _words = widget.favoritesOnly
              ? words.where((w) => w.isFavorite).toList()
              : words;

          if (_words.isEmpty) {
            return const Center(
              child: Text('No words available for flashcards'),
            );
          }

          // Shuffle once per session
          if (_currentIndex == 0) {
            _words = List<Word>.from(_words)..shuffle(Random());
          }

          final word = _words[_currentIndex];

          return Column(
            children: [
              const SizedBox(height: 24),

              Text(
                '${_currentIndex + 1} / ${_words.length}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              Expanded(
                child: GestureDetector(
                  onTap: _toggleFlip,
                  child: FlashcardCard(
                    word: word,
                    isFlipped: _isFlipped,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _previousCard,
                  ),
                  ElevatedButton(
                    onPressed: _toggleFlip,
                    child: Text(_isFlipped ? 'Show Word' : 'Show Meaning'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: _nextCard,
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
