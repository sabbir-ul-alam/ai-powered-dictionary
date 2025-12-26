import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/word_repository.dart';
import '../local/db/app_database.dart';
import '../local/db/daos/words_dao.dart';
import '../preferences/preferences_repository.dart';

class WordRepositoryImpl implements WordRepository {
  final WordsDao wordsDao;
  final PreferencesRepository preferences;
  final _uuid = const Uuid();

  WordRepositoryImpl(this.wordsDao, this.preferences);

  Future<String> _requireActiveLanguage() async {
    final lang = await preferences.getActiveLanguage();
    if (lang == null) {
      throw StateError('Active language not set');
    }
    return lang;
  }

  @override
  Future<void> addWord({
    required String wordText,
  }) async {
    final language = await _requireActiveLanguage();
    final now = DateTime.now().millisecondsSinceEpoch;

    await wordsDao.insertWord(
      WordsCompanion.insert(
        id: _uuid.v4(),
        wordText: wordText.trim(),
        languageCode: language,
        shortMeaning: Value.absent(),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  @override
  Future<List<Word>> listWords() async {
    final language = await _requireActiveLanguage();
    return wordsDao.listWords(language);
  }

  @override
  Future<List<String>> suggestWords(String prefix) async {
    final language = await _requireActiveLanguage();
    return wordsDao.suggestWords(language, prefix.trim());
  }

  @override
  Future<int> getWordCount() async {
    final language = await _requireActiveLanguage();
    return wordsDao.countWords(language);
  }

  @override
  Future<void> deleteWord(String id) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await wordsDao.softDeleteWord(id, now);
  }

  @override
  Future<void> updateWord({
    required String id,
    required String wordText,
    String? shortMeaning,
  }) async {
    final language = await _requireActiveLanguage();
    final now = DateTime.now().millisecondsSinceEpoch;

    await wordsDao.updateWord(
      WordsCompanion(
        id: Value(id),
        wordText: Value(wordText.trim()),
        languageCode: Value(language),
        shortMeaning: Value(shortMeaning),
        updatedAt: Value(now),
      ),
    );
  }
}
