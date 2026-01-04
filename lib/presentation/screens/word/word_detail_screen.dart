import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/db/app_database.dart';
import '../../state/providers.dart';

const primaryColor = Color(0xFF3B2EFF);
const lightGrey = Color(0xCFDFEDEA);
const textGrey = Color(0xFF6B7280);
const backgroundColor = Color(0xFFF7F7F7);

class WordDetailScreen extends ConsumerStatefulWidget {
  final Word word;

  const WordDetailScreen({super.key, required this.word});

  @override
  ConsumerState<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends ConsumerState<WordDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _wordCtrl;
  late final TextEditingController _meaningCtrl;
  late final TextEditingController _examplesCtrl;
  late final TextEditingController _pronunciationCtrl;
  late bool _isFavorite;

  late String? _partOfSpeech;
  bool _isEditing = false;
  bool _isSaving = false;
  bool _isGenerating = false;

  String? _originalMetadataJson;
  final List<_WordFormRow> _formRows = [];

  static const _posOptions = [
    'noun',
    'verb',
    'adjective',
    'adverb',
    'pronoun',
    'preposition',
    'conjunction',
    'interjection',
  ];

  @override
  void initState() {
    super.initState();
    _wordCtrl = TextEditingController(text: widget.word.wordText.toUpperCase());
    _meaningCtrl = TextEditingController();
    _examplesCtrl = TextEditingController();
    _pronunciationCtrl = TextEditingController();
    _isFavorite = widget.word.isFavorite;
  }

  @override
  void dispose() {
    _wordCtrl.dispose();
    _meaningCtrl.dispose();
    _examplesCtrl.dispose();
    _pronunciationCtrl.dispose();
    for (final row in _formRows) {
      row.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metadataAsync = ref.watch(wordMetadataProvider(widget.word.id));

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: Text('Word Detail'.toUpperCase()),
        centerTitle: true,
        titleTextStyle: TextStyle(color: textGrey),
        backgroundColor: backgroundColor,
        actions: _buildActions(),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: metadataAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('Failed to load word')),
            data: (json) {
              print(json);
              _ensureInitialised(json);
              // print('#############$_partOfSpeech#############');
              return ListView(

                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildMeaningCard(),
                  const SizedBox(height: 16),
                  _buildExampleCard(),
                  const SizedBox(height: 16),
                  _buildFormsCard(),
                  if (_isEditing) ...[
                    const SizedBox(height: 24),
                    _buildGenerateButton(),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ───────────────────────── HEADER ─────────────────────────

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          child: _isEditing
              ? Form(
            key: _formKey,
            child: TextFormField(
              controller: _wordCtrl,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              inputFormatters: [
                TextInputFormatter.withFunction((oldValue, newValue) {
                  return newValue.copyWith(
                    text: newValue.text.toUpperCase(),
                  );
                }),
              ],
            ),
          )
              : Center(
            child: Text(
              _wordCtrl.text.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildPartsOfSpeech(),
        const SizedBox(height: 8),
        _buildAudioButton(),
      ],
    );
  }

  Widget _buildPartsOfSpeech() {
    final text = _partOfSpeech != null ? _partOfSpeech!.toUpperCase():'';

    return _isEditing
        ? Column(
          children: [
            TextField(
              controller: _pronunciationCtrl,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(hintText: 'Pronunciation'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _partOfSpeech,
              items:
                  _posOptions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (v) => setState(() => _partOfSpeech = v),
            ),
          ],
        )
        : Text(
          text.isEmpty ? '——' : text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        );
  }

  Widget _buildAudioButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.volume_up),
      label: const Text('Play Audio'),
      style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
    );
  }

  // ───────────────────────── CARDS ─────────────────────────

  Widget _buildMeaningCard() {
    return _DetailCard(
      title: 'Meaning',
      child:
          _isEditing
              ? TextField(controller: _meaningCtrl, maxLines: null)
              : Text(
                _meaningCtrl.text.isEmpty
                    ? 'No meaning added'
                    : _meaningCtrl.text,
              ),
    );
  }

  Widget _buildExampleCard() {
    return _DetailCard(
      title: 'Example Sentence',
      child:
          _isEditing
              ? TextField(
                controller: _examplesCtrl,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'One example per line',
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    _examplesCtrl.text
                        .split('\n')
                        .where((e) => e.trim().isNotEmpty)
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              '"$e"',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
    );
  }

  Widget _buildFormsCard() {
    return _DetailCard(
      title: 'Grammatical Forms',
      child: Column(
        children: [
          if (_formRows.isEmpty)
            const Text(
              'No grammatical forms added',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ..._formRows.map((row) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child:
                        _isEditing
                            ? TextField(
                              controller: row.labelController,
                              decoration: const InputDecoration(
                                hintText: 'Form',
                              ),
                            )
                            : Text(
                              row.labelController.text,
                              style: const TextStyle(color: Colors.grey),
                            ),
                  ),
                  Expanded(
                    child:
                        _isEditing
                            ? TextField(
                              controller: row.valueController,
                              decoration: const InputDecoration(
                                hintText: 'Value',
                              ),
                            )
                            : Text(
                              row.valueController.text,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                  if (_isEditing)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _formRows.remove(row);
                          row.dispose();
                        });
                      },
                    ),
                ],
              ),
            );
          }),
          if (_isEditing)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add form'),
                onPressed: () {
                  setState(() {
                    _formRows.add(_WordFormRow.empty());
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return TextButton.icon(
      icon:
          _isGenerating
              ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : const Icon(Icons.auto_awesome),
      label: const Text('Regenerate with AI'),
      onPressed: _isGenerating ? null : _generateWithAi,
    );
  }

  // ───────────────────────── LOGIC ─────────────────────────

  List<Widget> _buildActions() {
    if (_isEditing) {
      return [
        IconButton(icon: const Icon(Icons.close), onPressed: _cancelEdit),
        IconButton(icon: const Icon(Icons.check), onPressed: _save),
      ];
    }
    return [
      IconButton(
        icon: Icon(
          _isFavorite ? Icons.bookmark : Icons.bookmark_outline,
          color: _isFavorite ? primaryColor : Colors.grey,
        ),
        onPressed: () async {
          await ref
              .read(wordRepositoryProvider)
              .setFavorite(id: widget.word.id, isFavorite: !_isFavorite);
          setState(() => _isFavorite = !_isFavorite);
          // ref.read(activeLanguageTriggerProvider.notifier)
          //     .state++;
        },
      ),
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => setState(() => _isEditing = true),
      ),
    ];
  }

  void _ensureInitialised(String? json) {
    if (_originalMetadataJson != null) return;
    _originalMetadataJson = json;
    if (json == null) return;

    final data = jsonDecode(json) as Map<String, dynamic>;
    _meaningCtrl.text = data['meaning'] ?? '';
    _partOfSpeech = data['partOfSpeech'];
    _examplesCtrl.text = (data['examples'] as List?)?.join('\n') ?? '';

    for (final f in (data['forms'] as List?) ?? []) {
      _formRows.add(_WordFormRow(label: f['label'], value: f['value']));
    }
  }

  void _cancelEdit() {
    _formRows.forEach((r) => r.dispose());
    _formRows.clear();
    _originalMetadataJson = null;
    setState(() => _isEditing = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final metadata = jsonEncode({
      'type': _partOfSpeech,
      'pronunciation': _pronunciationCtrl.text.trim(),
      'meaning': _meaningCtrl.text.trim(),
      'examples':
          _examplesCtrl.text
              .split('\n')
              .where((e) => e.trim().isNotEmpty)
              .toList(),
      'forms':
          _formRows
              .where(
                (r) =>
                    r.labelController.text.isNotEmpty ||
                    r.valueController.text.isNotEmpty,
              )
              .map(
                (r) => {
                  'label': r.labelController.text.trim(),
                  'value': r.valueController.text.trim(),
                },
              )
              .toList(),
    });

    await ref
        .read(wordMetadataDaoProvider)
        .upsertMetadataForWord(wordId: widget.word.id, metadataJson: metadata);

    ref.invalidate(wordMetadataProvider(widget.word.id));

    setState(() {
      _isEditing = false;
      _originalMetadataJson = metadata;
      _isSaving = false;
    });
  }

  Future<void> _generateWithAi() async {
    setState(() => _isGenerating = true);
    try {
      final lang =
          await ref.read(languageRepositoryProvider).getActiveLanguage();
      final r = await ref
          .read(aiDictionaryServiceProvider)
          .generate(word: _wordCtrl.text, languageName: lang!.displayName);

      if (_meaningCtrl.text.isEmpty) {
        _meaningCtrl.text = r.meaning;
      }
      if (_examplesCtrl.text.isEmpty) {
        _examplesCtrl.text = r.examples.join('\n');
      }
      _partOfSpeech ??= r.partOfSpeech;
      // if (_pronunciationCtrl.text.isEmpty) {
      //   _pronunciationCtrl.text = r.pronunciation ?? '';
      // }
      if (_formRows.isEmpty) {
        for (final f in r.forms) {
          _formRows.add(_WordFormRow(label: f.label, value: f.value));
        }
      }
    } finally {
      setState(() => _isGenerating = false);
    }
  }
}

// ───────────────────────── HELPERS ─────────────────────────

class _DetailCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _WordFormRow {
  final TextEditingController labelController;
  final TextEditingController valueController;

  _WordFormRow({required String label, required String value})
    : labelController = TextEditingController(text: label),
      valueController = TextEditingController(text: value);

  _WordFormRow.empty()
    : labelController = TextEditingController(),
      valueController = TextEditingController();

  void dispose() {
    labelController.dispose();
    valueController.dispose();
  }
}

/// TEMPORARY METADATA PROVIDER
final wordMetadataProvider = FutureProvider.family<String?, String>((
  ref,
  wordId,
) async {
  final dao = ref.watch(wordMetadataDaoProvider);
  final row = await dao.getByWordId(wordId);
  return row?.metadataJson;
});
