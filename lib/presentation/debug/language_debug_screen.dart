import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/providers.dart';
import 'home_debug_screen.dart';

class LanguageDebugScreen extends ConsumerWidget {
  const LanguageDebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Language (Debug)')),
      body: ListView(
        children: [
          _languageTile(context, ref, 'en', 'English'),
          _languageTile(context, ref, 'de', 'German'),
          _languageTile(context, ref, 'es', 'Spanish'),
        ],
      ),
    );
  }

  Widget _languageTile(
      BuildContext context,
      WidgetRef ref,
      String code,
      String label,
      ) {
    return ListTile(
      title: Text(label),
      onTap: () async {
        // Set active language
        await ref
            .read(languageRepositoryProvider)
            .setActiveLanguage(code);

        // Trigger refresh
        ref.read(activeLanguageTriggerProvider.notifier).state++;

        // Go to home debug screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const HomeDebugScreen(),
          ),
        );
      },
    );
  }
}
