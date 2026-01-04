import 'dart:convert';

import 'package:apd/data/local/db/app_database.dart';
import 'package:apd/data/local/db/daos/words_dao.dart';
import 'package:drift/drift.dart';

import '../../data/ai/ai_dictionary_service.dart';
import '../../data/local/db/daos/word_metadata_dao.dart';

class WordEnrichmentService {
  final AiDictionaryService aiService;
  final WordMetadataDao metadataDao;
  final WordsDao wordsDao;

  WordEnrichmentService({
    required this.aiService,
    required this.metadataDao,
    required this.wordsDao,
  });

  Future<void> autoGenerateMetadata({
    required Word word,
    required String languageName,
  }) async {
    final result = await aiService.generate(
      word: word.wordText,
      languageName: languageName,
    );

    print('from autoGenerateMetadata: $result');

    Word updatedWord = word.copyWith(
        wordText: result.aiWordSpelling,
        partsOfSpeech:Value(result.partOfSpeech),
        shortMeaning: Value(result.meaning));
    await wordsDao.updateWord(updatedWord.toCompanion(true));

    await metadataDao.upsertMetadataForWord(
      wordId: word.id,
      metadataJson: jsonEncode({
        'word': result.aiWordSpelling,
        'meaning': result.meaning,
        'partOfSpeech': result.partOfSpeech,
        'examples': result.examples,
        'forms': result.forms.map((f) {
          return f.toJson();
        }).toList(),
      }),
    );
  }
}
