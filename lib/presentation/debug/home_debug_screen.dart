import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/providers.dart';

class HomeDebugScreen extends ConsumerWidget {
  const HomeDebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLanguageAsync = ref.watch(activeLanguageProvider);
    final wordsAsync = ref.watch(wordListProvider);
    final countAsync = ref.watch(wordCountProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home (Debug)')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ref.read(wordRepositoryProvider).addWord(
            wordText: 'test_${DateTime.now().millisecondsSinceEpoch}',
          );

          // Force refresh
          ref.read(activeLanguageTriggerProvider.notifier).state++;
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            activeLanguageAsync.when(
              data: (lang) => Text(
                'Active language: ${lang?.displayName ?? 'None'}',
                style: const TextStyle(fontSize: 18),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading language'),
            ),
            const SizedBox(height: 12),
            countAsync.when(
              data: (count) => Text('Word count: $count'),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading count'),
            ),
            const Divider(),
            Expanded(
              child: wordsAsync.when(
                data: (words) => ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (_, i) => ListTile(
                    title: Text(words[i].wordText),
                  ),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Error loading words'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
