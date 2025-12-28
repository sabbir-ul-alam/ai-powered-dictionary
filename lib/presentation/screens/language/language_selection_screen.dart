import 'package:apd/data/local/db/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
   Language? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    final languagesAsync =
    ref.watch(languageRepositoryProvider).listLanguages();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Dictionary'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: FutureBuilder(
          future: languagesAsync,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No languages available'),
              );
            }

            final languages = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose a language dictionary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                /// -----------------------------------------------------------------
                /// LANGUAGE DROPDOWN
                /// -----------------------------------------------------------------
                DropdownButtonFormField<String>(
                  value: _selectedLanguage?.code,
                  hint: const Text('Select language'),
                  items: languages.map((lang) {
                    return DropdownMenuItem<String>(
                      value: lang.code,
                      child: Text(lang.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage =
                          languages.firstWhere((lang) => lang.code == value);
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),

                const Spacer(),

                /// -----------------------------------------------------------------
                /// CONTINUE BUTTON
                /// -----------------------------------------------------------------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedLanguage== null
                        ? null
                        : () async {
                      await _onContinuePressed(
                        context,
                        ref,
                      );
                    },
                    child: const Text('Continue'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _onContinuePressed(
      BuildContext context,
      WidgetRef ref,
      ) async {
    final lang = _selectedLanguage;
    if (lang == null) return;

    // Persist active language
    await ref
        .read(languageRepositoryProvider)
        .setActiveLanguage(lang);

    // Trigger reactive refresh
    ref.read(activeLanguageTriggerProvider.notifier).state++;

    // Navigate to Home
    // if (context.mounted) {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (_) => const HomeScreen(),
    //     ),
    //   );
    // }
  }
}
