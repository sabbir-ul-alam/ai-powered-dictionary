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
    final suggestionsAsync =
    ref.watch(wordSuggestionsProvider(_currentInput));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Word'),
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
            if (_currentInput.isNotEmpty)
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
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.separated(
                            itemCount: suggestions.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              return _SuggestionTile(
                                text: suggestions[index],
                                onTap: () {
                                  _controller.text =
                                  suggestions[index];
                                  _controller.selection =
                                      TextSelection.fromPosition(
                                        TextPosition(
                                          offset:
                                          _controller.text.length,
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
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
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
                  onPressed: _isSaving
                      ? null
                      : () => _saveWord(context),
                  child: _isSaving
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text('Save'),
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
      await ref.read(wordRepositoryProvider).addWord(
        wordText: _controller.text,
      );

      // Force refresh of Home providers
      ref.read(activeLanguageTriggerProvider.notifier).state++;

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Basic error handling for Phase 1
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add word'),
          ),
        );
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

  const _SuggestionTile({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12,
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
