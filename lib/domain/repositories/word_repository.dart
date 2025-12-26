import '../../data/local/db/app_database.dart';

abstract class WordRepository {
  Future<void> addWord({
    required String wordText,
  });

  Future<void> updateWord({
    required String id,
    required String wordText,
    String? shortMeaning,
  });

  Future<void> deleteWord(String id);

  Future<List<Word>> listWords();

  Future<List<String>> suggestWords(String prefix);

  Future<int> getWordCount();
}
