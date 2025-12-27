import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/db/app_database.dart';
import '../../data/local/db/daos/words_dao.dart';
import '../../data/local/db/daos/languages_dao.dart';
import '../../data/local/db/daos/word_metadata_dao.dart';

import '../../data/preferences/preferences_repository.dart';

import '../../data/repositories/word_repository_impl.dart';
import '../../data/repositories/language_repository_impl.dart';

import '../../domain/repositories/word_repository.dart';
import '../../domain/repositories/language_repository.dart';

/// ---------------------------------------------------------------------------
/// DATABASE
/// ---------------------------------------------------------------------------

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// ---------------------------------------------------------------------------
/// DAOs
/// ---------------------------------------------------------------------------

final wordsDaoProvider = Provider<WordsDao>((ref) {
  return WordsDao(ref.watch(databaseProvider));
});

final languagesDaoProvider = Provider<LanguagesDao>((ref) {
  return LanguagesDao(ref.watch(databaseProvider));
});

final wordMetadataDaoProvider = Provider<WordMetadataDao>((ref) {
  return WordMetadataDao(ref.watch(databaseProvider));
});

/// ---------------------------------------------------------------------------
/// PREFERENCES
/// ---------------------------------------------------------------------------

final preferencesRepositoryProvider =
Provider<PreferencesRepository>((ref) {
  return PreferencesRepository();
});

/// ---------------------------------------------------------------------------
/// REPOSITORIES
/// ---------------------------------------------------------------------------

final languageRepositoryProvider =
Provider<LanguageRepository>((ref) {
  return LanguageRepositoryImpl(
    ref.watch(languagesDaoProvider),
    ref.watch(preferencesRepositoryProvider),
  );
});

final wordRepositoryProvider =
Provider<WordRepository>((ref) {
  return WordRepositoryImpl(
    ref.watch(wordsDaoProvider),
    ref.watch(preferencesRepositoryProvider),
  );
});

/// ---------------------------------------------------------------------------
/// ACTIVE LANGUAGE TRIGGER
/// ---------------------------------------------------------------------------
///
/// Any language or word mutation must bump this.
///

final activeLanguageTriggerProvider =
StateProvider<int>((ref) => 0);

/// ---------------------------------------------------------------------------
/// ACTIVE LANGUAGE
/// ---------------------------------------------------------------------------

final activeLanguageProvider =
FutureProvider((ref) async {
  ref.watch(activeLanguageTriggerProvider);
  return ref.watch(languageRepositoryProvider).getActiveLanguage();
});

/// ---------------------------------------------------------------------------
/// WORD LIST
/// ---------------------------------------------------------------------------

final wordListProvider =
FutureProvider((ref) async {
  ref.watch(activeLanguageTriggerProvider);
  return ref.watch(wordRepositoryProvider).listWords();
});

/// ---------------------------------------------------------------------------
/// WORD COUNT
/// ---------------------------------------------------------------------------

final wordCountProvider =
FutureProvider<int>((ref) async {
  ref.watch(activeLanguageTriggerProvider);
  return ref.watch(wordRepositoryProvider).getWordCount();
});

/// ---------------------------------------------------------------------------
/// WORD SUGGESTIONS (FIXED)
/// ---------------------------------------------------------------------------
///
/// Suggestions depend on:
/// - active language
/// - current input prefix
///
/// We also guard against empty prefixes.
///

final wordSuggestionsProvider =
FutureProvider.family<List<String>, String>((ref, prefix) async {
  // 🔑 Make suggestions language-aware
  ref.watch(activeLanguageTriggerProvider);

  // Guard: don't query for empty input
  if (prefix.trim().isEmpty) {
    return const [];
  }

  return ref
      .watch(wordRepositoryProvider)
      .suggestWords(prefix.trim());
});
