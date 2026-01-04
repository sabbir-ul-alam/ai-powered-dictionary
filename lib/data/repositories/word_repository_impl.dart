import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/word_repository.dart';
import '../local/db/app_database.dart';
import '../local/db/daos/word_learning_progress_dao.dart';
import '../local/db/daos/words_dao.dart';
import '../preferences/preferences_repository.dart';

class WordRepositoryImpl implements WordRepository {
  final WordsDao wordsDao;
  final PreferencesRepository preferences;
  final WordLearningProgressDao progressDao;

  final _uuid = const Uuid();

  WordRepositoryImpl(
      this.wordsDao,
      this.progressDao,
      this.preferences);

  Future<String> _requireActiveLanguage() async {
    final lang = await preferences.getActiveLanguage();
    if (lang == null) {
      throw StateError('Active language not set');
    }
    return lang;
  }

  @override
  Future<Word> addWord({
    required String text,
    String? shortMeaning,
    String? partsOfSpeech
  }) async {

    final language = await _requireActiveLanguage();
    final now = DateTime.now().millisecondsSinceEpoch;
    final wordId = _uuid.v4();



    final newId = await wordsDao.insertOrReviveWord(
      WordsCompanion.insert(
        id: wordId,
        wordText: text.trim(),
        languageCode: language,
        shortMeaning: const Value.absent(),
        partsOfSpeech: const Value.absent(),
        createdAt: now,
        updatedAt: now,
        deletedAt: const Value(null),
      ),
    );

    print(newId);

    Word tmpWord = Word(
      id: newId,
      wordText: text.trim(),
      languageCode: language,
      createdAt: now,
      updatedAt: now,
      isFavorite: false,
    );
    // Ensure learning progress exists (default unlearned)
    await progressDao.ensureRowForWord(
      wordId: newId,
      createdAt: now,
      updatedAt: now,
    );

    return tmpWord;
  }

  @override
  Future<List<Word>> listWords({bool favoritesOnly = false}) async {
    final language = await _requireActiveLanguage();
    return wordsDao.listWords(language, favoritesOnly: favoritesOnly);
  }

  @override
  Future<List<String>> suggestWords(String prefix) async {
    final language = await _requireActiveLanguage();
    return wordsDao.suggestWords(language, prefix.trim());
  }

  @override
  Future<int> getWordCount(
      String? query,
      {bool favoritesOnly = false}) async {
    final language = await _requireActiveLanguage();
    return wordsDao.countWords(query, language,favoritesOnly: favoritesOnly);
  }

  @override
  Future<void> deleteWord(String id) async {
    await wordsDao.hardDeleteWord(id);
  }

  @override
  Future<List<Word>> searchWords(
      String query, {
        bool favoritesOnly = false,
      }) async {
    final language = await _requireActiveLanguage();
    return wordsDao.searchWords(language, query, favoritesOnly: favoritesOnly);
  }

  @override
  Future<void> updateWord({
    required Word word
  }) async {
    final language = await _requireActiveLanguage();
    final now = DateTime.now().millisecondsSinceEpoch;

    await wordsDao.updateWord(
      WordsCompanion(
        id: Value(word.id),
        wordText: Value(word.wordText.trim()),
        languageCode: Value(language),
        shortMeaning: Value(word.shortMeaning),
        partsOfSpeech: Value(word.partsOfSpeech),
        updatedAt: Value(now),
        createdAt: Value(word.createdAt)
      ),
    );
  }


  @override
  Future<void> setFavorite({
    required String id,
    required bool isFavorite,
  }) async {
    await wordsDao.setFavorite(id: id, isFavorite: isFavorite);
  }
}
