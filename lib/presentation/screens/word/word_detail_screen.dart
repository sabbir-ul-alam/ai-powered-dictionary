import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/local/db/app_database.dart';
import '../../state/providers.dart';
import 'dart:convert';


class WordDetailScreen extends ConsumerStatefulWidget {
   final Word word;


  const WordDetailScreen({
    super.key,
    required this.word
  });

  @override
  ConsumerState<WordDetailScreen> createState() =>
      _WordDetailScreenState();
}

class _WordDetailScreenState
    extends ConsumerState<WordDetailScreen> {
  late final TextEditingController _wordController;
  late final TextEditingController _meaningController;
  late final TextEditingController _examplesController;
  final _formKey = GlobalKey<FormState>();

  String? _originalMetadataJson;

  bool _isEditing = false;
  bool _isSaving = false;
  bool _isGenerating = false;


  @override
  void initState() {
    super.initState();
    // TEMP: seed metadata for testing
    // Future.microtask(() async {
    //   final dao = ref.read(wordMetadataDaoProvider);
    //
    //   await dao.upsertMetadataForWord(
    //     wordId: widget.word.id,
    //     metadataJson: jsonEncode({
    //       'meaning': 'to examine something carefully',
    //       'examples': [
    //         'She tested the new feature before release.',
    //         'The teacher tested the students.',
    //       ],
    //     }),
    //   );
    // });
    _wordController =
        TextEditingController(text: widget.word.wordText);
    _meaningController = TextEditingController();
    _examplesController = TextEditingController();
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _examplesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metadataAsync =
    ref.watch(wordMetadataProvider(widget.word.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Details'),
        actions: _buildActions(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
          /// -------------------------------------------------------------
          /// WORD TEXT (VIEW / EDIT)
          /// -------------------------------------------------------------
          Form(
          key: _formKey,
          child:
              _isEditing
                  ? TextFormField(
                controller: _wordController,
                autofocus: true,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Word cannot be empty';
                  }
                  return null;
                },
              )
                  : Text(
                _wordController.text,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),
          ),

              const SizedBox(height: 32),

              /// -------------------------------------------------------------
              /// MEANING & EXAMPLES (READ-ONLY)
              /// -------------------------------------------------------------
          metadataAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const _MetadataEmptyState(),
              data: (metadataJson) {
                if (metadataJson == null) {
                  return const _MetadataEmptyState();
                }
                _ensureControllersInitialised(metadataJson);


                // final parsed = _parseMetadata(metadataJson);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// MEANING
                    const _SectionTitle('Meaning'),
                    const SizedBox(height: 8),
                    _isEditing
                        ? TextField(
                      controller: _meaningController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText:
                        'Enter the meaning',
                        border: OutlineInputBorder(),
                      ),
                    )
                        : _meaningController.text.isEmpty
                        ? const _EmptyValue(
                        'No meaning added yet')
                        : Text(
                      _meaningController.text,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge,
                    ),

                    const SizedBox(height: 24),

                    /// EXAMPLES
                    const _SectionTitle('Examples'),
                    const SizedBox(height: 8),
                    _isEditing
                        ? TextField(
                      controller: _examplesController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText:
                        'One example per line',
                        border: OutlineInputBorder(),
                      ),
                    )
                        : _examplesController.text.isEmpty
                        ? const _EmptyValue(
                        'No examples added yet')
                        : Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: _examplesController.text
                          .split('\n')
                          .where(
                              (e) => e.trim().isNotEmpty)
                          .map(
                            (e) => Padding(
                          padding:
                          const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          child: Text('• $e'),
                        ),
                      )
                          .toList(),
                    ),
                  ],
                );
              },
          ),
            if (_isEditing)
              TextButton.icon(
                icon: _isGenerating
                    ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.auto_awesome),
                label: const Text('Generate with AI'),
                onPressed: _isGenerating ? null : _generateWithAi,
              ),


          ],
        ),
      ),
    );
  }
  ///-----------------------------------------
  /// Generate with AI
  /// -----------------------------------------
  Future<void> _generateWithAi() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final language =
      await ref.read(languageRepositoryProvider).getActiveLanguage();

      final aiResult =
      await ref.read(aiDictionaryServiceProvider).generate(
        word: _wordController.text,
        languageName: language!.displayName,
      );

      _meaningController.text = aiResult.meaning;
      _examplesController.text =
          aiResult.examples.join('\n');

      print(aiResult.toString());
    } catch (e) {
      if (mounted) {
        String error = e.toString();
        print('##############error####################');
        print(error);
        print('##############error####################');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // content: Text('Failed to generate meaning'),
            content: Text(error),

          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }


  /// -------------------------------------------------------------------------
  /// APP BAR ACTIONS
  /// -------------------------------------------------------------------------
  List<Widget> _buildActions(BuildContext context) {
    if (_isEditing) {
      return [
        IconButton(
          tooltip: 'Cancel',
          icon: const Icon(Icons.close),
          onPressed: _cancelEdit,
        ),
        IconButton(
          tooltip: 'Save',
          icon: const Icon(Icons.check),
          onPressed: _isSaving ? null : _saveAll,
        ),
      ];
    }

    return [
      IconButton(
        tooltip: 'Edit',
        icon: const Icon(Icons.edit),
        onPressed: () {
          setState(() {
            _isEditing = true;
          });
        },
      ),
      IconButton(
        tooltip: 'Delete',
        icon: const Icon(Icons.delete_outline),
        onPressed: () => _confirmDelete(context),
      ),
    ];
  }

  /// -------------------------------------------------------------------------
  /// CANCEL EDIT
  /// -------------------------------------------------------------------------
  void _cancelEdit() {
    _wordController.text = widget.word.wordText;

    if (_originalMetadataJson != null) {
      _applyMetadataToControllers(_originalMetadataJson!);
    } else {
      _meaningController.clear();
      _examplesController.clear();
    }

    setState(() {
      _isEditing = false;
    });
  }
  /// -------------------------------------------------------------------------
  /// SAVE WORD + METADATA
  /// -------------------------------------------------------------------------
  Future<void> _saveAll() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      /// Save word text
          Word tempWord = Word(
          id: widget.word.id,
          wordText: _wordController.text,
          languageCode: widget.word.languageCode,
          shortMeaning: widget.word.shortMeaning,
          createdAt: widget.word.createdAt,
          updatedAt: widget.word.createdAt,
          deletedAt: widget.word.deletedAt);
      await ref.read(wordRepositoryProvider).updateWord(
        word: tempWord
      );

      /// Save metadata
      final metadataJson = jsonEncode({
        'meaning': _meaningController.text.trim().isEmpty
            ? null
            : _meaningController.text.trim(),
        'examples': _examplesController.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
      });

      await ref
          .read(wordMetadataDaoProvider)
          .upsertMetadataForWord(
        wordId: widget.word.id,
        metadataJson: metadataJson,
      );

      ref.read(activeLanguageTriggerProvider.notifier).state++;

      setState(() {
        _isEditing = false;
        _originalMetadataJson = metadataJson;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
  // Future<void> _saveEdit() async {
  //   if (!_formKey.currentState!.validate()) return;
  //
  //   setState(() {
  //     _isSaving = true;
  //   });
  //
  //   try {
  //     Word tempWord = Word(
  //     id: widget.word.id,
  //     wordText: _controller.text,
  //     languageCode: widget.word.languageCode,
  //     shortMeaning: widget.word.shortMeaning,
  //     createdAt: widget.word.createdAt,
  //     updatedAt: widget.word.createdAt,
  //     deletedAt: widget.word.deletedAt);
  //
  //     await ref.read(wordRepositoryProvider).updateWord(
  //       word: tempWord
  //     );
  //
  //     // Notify rest of the app
  //     ref.read(activeLanguageTriggerProvider.notifier).state++;
  //
  //     setState(() {
  //       _isEditing = false;
  //     });
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isSaving = false;
  //       });
  //     }
  //   }
  // }

  /// -------------------------------------------------------------------------
  /// DELETE WORD
  /// -------------------------------------------------------------------------
  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete word'),
          content: const Text(
            'Are you sure you want to delete this word?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await ref
        .read(wordRepositoryProvider)
        .deleteWord(widget.word.id);

    ref.read(activeLanguageTriggerProvider.notifier).state++;

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
  /// -------------------------------------------------------------------------
  /// METADATA PARSER
  /// -------------------------------------------------------------------------
//   _ParsedMetadata _parseMetadata(String jsonString) {
//     try {
//       final decoded =
//       json.decode(jsonString) as Map<String, dynamic>;
//
//       return _ParsedMetadata(
//         meaning: decoded['meaning'] as String?,
//         examples: (decoded['examples'] as List<dynamic>?)
//             ?.whereType<String>()
//             .toList() ??
//             const [],
//       );
//     } catch (_) {
//       return const _ParsedMetadata.empty();
//     }
//   }
// }

  /// -------------------------------------------------------------------------
  /// METADATA INITIALISATION
  /// -------------------------------------------------------------------------
  void _ensureControllersInitialised(String? metadataJson) {
    if (_originalMetadataJson != null) return;

    _originalMetadataJson = metadataJson;

    if (metadataJson == null) return;

    _applyMetadataToControllers(metadataJson);
  }

  void _applyMetadataToControllers(String metadataJson) {
    try {
      final decoded =
      json.decode(metadataJson) as Map<String, dynamic>;

      _meaningController.text =
          decoded['meaning'] as String? ?? '';

      _examplesController.text =
          (decoded['examples'] as List<dynamic>?)
              ?.whereType<String>()
              .join('\n') ??
              '';
    } catch (_) {
      _meaningController.clear();
      _examplesController.clear();
    }
  }
}
/// ---------------------------------------------------------------------------
/// TEMPORARY METADATA PROVIDER
/// ---------------------------------------------------------------------------

final wordMetadataProvider =
FutureProvider.family<String?, String>((ref, wordId) async {
  final dao = ref.watch(wordMetadataDaoProvider);
  final row = await dao.getByWordId(wordId);
  return row?.metadataJson;
});

/// ---------------------------------------------------------------------------
/// LOCAL VIEW MODELS
/// ---------------------------------------------------------------------------

// class _ParsedMetadata {
//   final String? meaning;
//   final List<String> examples;
//
//   const _ParsedMetadata({
//     required this.meaning,
//     required this.examples,
//   });
//
//   const _ParsedMetadata.empty()
//       : meaning = null,
//         examples = const [];
// }

/// ---------------------------------------------------------------------------
/// UI HELPERS
/// ---------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _EmptyValue extends StatelessWidget {
  final String text;

  const _EmptyValue(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.grey,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

class _MetadataEmptyState extends StatelessWidget {
  const _MetadataEmptyState();

  @override
  Widget build(BuildContext context) {
    return const _EmptyValue(
      'No meaning or examples added yet',
    );
  }
}

