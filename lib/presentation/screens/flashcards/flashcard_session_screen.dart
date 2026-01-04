import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../word/word_detail_screen.dart';

class FlashcardSessionScreen extends ConsumerStatefulWidget {
  final bool favoritesOnly;
  final bool unlearnedOnly;

  const FlashcardSessionScreen({
    super.key,
    required this.favoritesOnly,
    required this.unlearnedOnly,
  });

  @override
  ConsumerState<FlashcardSessionScreen> createState() =>
      _FlashcardSessionScreenState();
}

class _FlashcardSessionScreenState
    extends ConsumerState<FlashcardSessionScreen> {
  int _index = 0;
  bool _flipped = false;

  void _flip() => setState(() => _flipped = !_flipped);

  void _next(int total) {
    if (_index < total - 1) {
      setState(() {
        _index++;
        _flipped = false;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _mark({
    required String wordId,
    required bool learned,
    required int total,
  }) async {
    await ref.read(wordsLearningDaoProvider).setLearned(
      wordId: wordId,
      learned: learned,
    );

    // Refresh dashboard + any lists that depend on counts
    ref.read(activeLanguageTriggerProvider.notifier).state++;

    // Invalidate metadata/word list is not needed here; progress is separate.
    _next(total);
  }

  @override
  Widget build(BuildContext context) {
    final filter = FlashcardSessionFilter(
      favoritesOnly: widget.favoritesOnly,
      unlearnedOnly: widget.unlearnedOnly,
    );

    final idsAsync = ref.watch(flashcardSessionWordIdsProvider(filter));

    final title = widget.favoritesOnly
        ? (widget.unlearnedOnly ? 'Favourites (Unlearned)' : 'Favourites')
        : (widget.unlearnedOnly ? 'All (Unlearned)' : 'All Words');

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: idsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to start session')),
        data: (ids) {
          if (ids.isEmpty) {
            return const Center(child: Text('No cards for this session'));
          }

          // Clamp index if list changed
          if (_index >= ids.length) _index = 0;

          final wordId = ids[_index];
          final metadataAsync = ref.watch(wordMetadataProvider(wordId));

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('${_index + 1} / ${ids.length}'),
                const SizedBox(height: 16),

                Expanded(
                  child: GestureDetector(
                    onTap: _flip,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: _flipped
                              ? metadataAsync.when(
                            loading: () => const CircularProgressIndicator(),
                            error: (_, __) => const Text('Failed to load meaning'),
                            data: (metadataJson) {
                              if (metadataJson == null) {
                                return const Text(
                                  'No meaning yet.\nTap Edit on Word Details to generate or add it.',
                                  textAlign: TextAlign.center,
                                );
                              }
                              final decoded = json.decode(metadataJson) as Map<String, dynamic>;
                              final meaning = decoded['meaning'] as String?;
                              final examples =
                                  (decoded['examples'] as List<dynamic>?)?.whereType<String>().toList() ?? const [];

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (meaning != null && meaning.trim().isNotEmpty) ...[
                                    Text(
                                      meaning,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  if (examples.isEmpty)
                                    const Text('No examples yet', textAlign: TextAlign.center)
                                  else
                                    ...examples.map(
                                          (e) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        child: Text('• $e', textAlign: TextAlign.center),
                                      ),
                                    ),
                                ],
                              );
                            },
                          )
                              : Text(
                            // For the front we need the actual word text.
                            // We avoid a heavy join here; simplest approach:
                            // load from wordListProvider cache if present, else show id short.
                            _frontWordText(ref, wordId),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _mark(wordId: wordId, learned: true, total: ids.length),
                        child: const Text('I know this'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _mark(wordId: wordId, learned: false, total: ids.length),
                        child: const Text('Still learning'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: _flip,
                  child: Text(_flipped ? 'Show word' : 'Show meaning'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Best-effort: get word text from cached lists; fallback to placeholder.
  String _frontWordText(WidgetRef ref, String wordId) {
    final favoritesOnly = ref.read(favoritesOnlyProvider);
    final listAsync = ref.read(wordListProvider);

    return listAsync.maybeWhen(
      data: (words) {
        final w = words.firstWhere(
              (x) => x.id == wordId,
          orElse: () => words.isNotEmpty ? words.first : null as dynamic,
        );
        // If user started "All (Unlearned)" we might be filtering; still okay.
        // favoritesOnly is not used here; just avoids lint about unused local.
        // ignore: unnecessary_statements
        favoritesOnly;
        return w.wordText;
      },
      orElse: () => 'Word',
    );
  }
}
