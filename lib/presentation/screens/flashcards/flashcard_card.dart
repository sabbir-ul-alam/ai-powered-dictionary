import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/db/app_database.dart';
import '../word/word_detail_screen.dart';

class FlashcardCard extends ConsumerWidget {
  final Word word;
  final bool isFlipped;

  const FlashcardCard({
    super.key,
    required this.word,
    required this.isFlipped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metadataAsync =
    ref.watch(wordMetadataProvider(word.id));

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: isFlipped
              ? metadataAsync.when(
            loading: () =>
            const CircularProgressIndicator(),
            error: (_, __) =>
            const Text('Failed to load meaning'),
            data: (metadataJson) {
              if (metadataJson == null) {
                return const Text(
                  'No meaning available',
                  textAlign: TextAlign.center,
                );
              }

              final decoded =
              json.decode(metadataJson) as Map<String, dynamic>;

              final meaning =
              decoded['meaning'] as String?;
              final examples =
                  (decoded['examples'] as List<dynamic>?)
                      ?.whereType<String>()
                      .toList() ??
                      [];

              return Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  if (meaning != null) ...[
                    Text(
                      meaning,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    const SizedBox(height: 16),
                  ],
                  ...examples.map(
                        (e) => Padding(
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      child: Text(
                        '• $e',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            },
          )
              : Text(
            word.wordText,
            style: Theme.of(context)
                .textTheme
                .headlineMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
