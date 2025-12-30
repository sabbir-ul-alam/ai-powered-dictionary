import 'dart:convert';

import '../../data/ai/ai_dictionary_service.dart';
import '../../data/local/db/daos/word_metadata_dao.dart';

class WordEnrichmentService {
  final AiDictionaryService aiService;
  final WordMetadataDao metadataDao;

  WordEnrichmentService({
    required this.aiService,
    required this.metadataDao,
  });

  Future<void> autoGenerateMetadata({
    required String wordId,
    required String wordText,
    required String languageName,
  }) async {
    final result = await aiService.generate(
      word: wordText,
      languageName: languageName,
    );

    print(result.toString());

    await metadataDao.upsertMetadataForWord(
      wordId: wordId,
      metadataJson: jsonEncode({
        'meaning': result.meaning,
        'examples': result.examples,
      }),
    );
  }
}
