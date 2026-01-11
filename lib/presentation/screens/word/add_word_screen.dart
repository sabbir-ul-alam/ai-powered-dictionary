import 'dart:async';

import 'package:apd/presentation/screens/word/word_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';

class AddWordScreen extends ConsumerStatefulWidget {
  const AddWordScreen({super.key});

  @override
  ConsumerState<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends ConsumerState<AddWordScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _currentInput = '';
  bool _isSaving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suggestionsAsync = ref.watch(wordSuggestionsProvider(_currentInput));

    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF7F7F7),
        title: const Text('Add Word'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ---------------------------------------------------------------
            /// WORD INPUT
            /// ---------------------------------------------------------------
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Word',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a word';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _currentInput = value.trim();
                  });
                },
                onFieldSubmitted: (_) => _saveWord(context),
              ),
            ),

            const SizedBox(height: 16),

            /// ---------------------------------------------------------------
            /// SUGGESTIONS
            /// ---------------------------------------------------------------
            // if (_currentInput.isNotEmpty)
            Expanded(
              child: suggestionsAsync.when(
                data: (suggestions) {
                  if (suggestions.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Existing words',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          // fontWeight: FontWeight.w100,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.separated(
                          itemCount: suggestions.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 6),
                          itemBuilder: (context, index) {
                            return _SuggestionTile(
                              text: suggestions[index].wordText,
                              onTap: () async {
                                _controller.text = suggestions[index].wordText;
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => WordDetailScreen(word: suggestions[index]),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            /// ---------------------------------------------------------------
            /// SAVE BUTTON
            /// ---------------------------------------------------------------
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B2EFF),
                    disabledBackgroundColor: Color(0xFFD1D1D5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                    alignment: Alignment.center,
                  ),

                  onPressed:
                      _currentInput.isEmpty ? null : () => _saveWord(context),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveWord(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final word = await ref
          .read(wordRepositoryProvider)
          .addWord(text: _controller.text.trim());

      print('After add word call$word');

      final language =
          await ref.read(languageRepositoryProvider).getActiveLanguage();

      // Fire-and-forget, but NOT tied to widget lifecycle
      unawaited(
        ref
            .read(wordEnrichmentServiceProvider)
            .autoGenerateMetadata(
              word: word,
              languageName: language!.displayName,
            ),
      );
      // _controller.clear();
      // setState(() {
      //   _currentInput = '';
      // });

      // Force refresh of Home providers
      ref.read(activeLanguageTriggerProvider.notifier).state++;

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
      // Basic error handling for Phase 1
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to add word')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}

/// ---------------------------------------------------------------------------
/// SUGGESTION TILE
/// ---------------------------------------------------------------------------
///
/// Simple reusable widget for showing existing words.
///
class _SuggestionTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SuggestionTile({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFF7F7F7),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            Icon(Icons.north_east_outlined, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
