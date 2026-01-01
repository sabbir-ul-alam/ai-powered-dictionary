import '../../data/local/db/app_database.dart';

abstract class WordRepository {
  /// -------------------------------------------------------------------------
  /// CREATE
  /// -------------------------------------------------------------------------
  /// Returns the generated wordId.
  Future<Word> addWord({
    required String text,
    String? shortMeaning,
  });

  Future<void> updateWord({
    required Word word
  });

  /// -------------------------------------------------------------------------
  /// REAL SEARCH (NEW)
  /// -------------------------------------------------------------------------
  /// Contains search returning full Word objects (id included).
  Future<List<Word>> searchWords(
      String query, {
        bool favoritesOnly = false,
      });
  Future<void> deleteWord(String id);

  Future<List<Word>> listWords({
    bool favoritesOnly = false,
  });

  Future<List<String>> suggestWords(String prefix);

  Future<int> getWordCount(
      String? query,{
    bool favoritesOnly = false,
  });

  Future<void> setFavorite({
    required String id,
    required bool isFavorite,
  });

}


