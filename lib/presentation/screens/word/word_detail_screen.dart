import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/local/db/app_database.dart';
import '../../state/providers.dart';

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
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.word.wordText,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Details'),
        actions: _buildActions(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// -------------------------------------------------------------
              /// WORD (VIEW / EDIT)
              /// -------------------------------------------------------------
              _isEditing
                  ? TextFormField(
                controller: _controller,
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
                _controller.text,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),

              const SizedBox(height: 24),

              /// -------------------------------------------------------------
              /// PLACEHOLDER FOR FUTURE METADATA / AI
              /// -------------------------------------------------------------
              const Text(
                'More details coming soon…',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
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
          onPressed: _isSaving ? null : _saveEdit,
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
  /// EDIT LOGIC
  /// -------------------------------------------------------------------------
  void _cancelEdit() {
    setState(() {
      _controller.text = widget.word.wordText;
      _isEditing = false;
    });
  }

  Future<void> _saveEdit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      Word tempWord = Word(
      id: widget.word.id,
      wordText: _controller.text,
      languageCode: widget.word.languageCode,
      shortMeaning: widget.word.shortMeaning,
      createdAt: widget.word.createdAt,
      updatedAt: widget.word.createdAt,
      deletedAt: widget.word.deletedAt);

      await ref.read(wordRepositoryProvider).updateWord(
        word: tempWord
      );

      // Notify rest of the app
      ref.read(activeLanguageTriggerProvider.notifier).state++;

      setState(() {
        _isEditing = false;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  /// -------------------------------------------------------------------------
  /// DELETE LOGIC
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
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
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

    // Refresh list + count
    ref.read(activeLanguageTriggerProvider.notifier).state++;

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
