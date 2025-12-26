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
/// DATABASE PROVIDER
/// ---------------------------------------------------------------------------
///
/// Provides a single AppDatabase instance for the entire app lifecycle.
/// In a real production app, this would likely be scoped at app start.
///
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// ---------------------------------------------------------------------------
/// DAO PROVIDERS (Drift access objects)
/// ---------------------------------------------------------------------------
///
/// DAOs are thin SQL wrappers. They should NOT be used directly by UI.
/// Repositories sit on top of these.
///

final wordsDaoProvider = Provider<WordsDao>((ref) {
  final db = ref.watch(databaseProvider);
  return WordsDao(db);
});

final languagesDaoProvider = Provider<LanguagesDao>((ref) {
  final db = ref.watch(databaseProvider);
  return LanguagesDao(db);
});

final wordMetadataDaoProvider = Provider<WordMetadataDao>((ref) {
  final db = ref.watch(databaseProvider);
  return WordMetadataDao(db);
});

/// ---------------------------------------------------------------------------
/// PREFERENCES PROVIDER
/// ---------------------------------------------------------------------------
///
/// Handles lightweight local state such as active language.
/// Kept separate from database for simplicity and speed.
///

final preferencesRepositoryProvider =
Provider<PreferencesRepository>((ref) {
  return PreferencesRepository();
});

/// ---------------------------------------------------------------------------
/// REPOSITORY PROVIDERS (Domain abstraction)
/// ---------------------------------------------------------------------------
///
/// These are what the UI and use-cases talk to.
/// They hide Drift, SQL, and storage details completely.
///

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
/// This is a simple but powerful pattern:
/// - Whenever active language changes, we increment this value
/// - Any provider that watches this will automatically refresh
///
/// We do NOT store the language itself here.
/// The source of truth remains Preferences + LanguageRepository.
///

final activeLanguageTriggerProvider =
StateProvider<int>((ref) => 0);

/// ---------------------------------------------------------------------------
/// ACTIVE LANGUAGE PROVIDER
/// ---------------------------------------------------------------------------
///
/// Loads the currently active language from the repository.
/// Automatically refreshes when activeLanguageTriggerProvider changes.
///

final activeLanguageProvider =
FutureProvider((ref) async {
  // Watch trigger so this provider re-runs on language change
  ref.watch(activeLanguageTriggerProvider);

  final repo = ref.watch(languageRepositoryProvider);
  return repo.getActiveLanguage();
});

/// ---------------------------------------------------------------------------
/// WORD LIST PROVIDER (Language-scoped)
/// ---------------------------------------------------------------------------
///
/// Returns all words for the currently active language.
/// Automatically refreshes when:
/// - Language changes
/// - Words are added/updated/deleted (manual invalidation)
///

final wordListProvider =
FutureProvider((ref) async {
  ref.watch(activeLanguageTriggerProvider);

  final repo = ref.watch(wordRepositoryProvider);
  return repo.listWords();
});

/// ---------------------------------------------------------------------------
/// WORD COUNT PROVIDER (Language-scoped)
/// ---------------------------------------------------------------------------
///
/// Returns total number of learned words for active language.
/// Used for header badges, dictionary summary, etc.
///

final wordCountProvider =
FutureProvider<int>((ref) async {
  ref.watch(activeLanguageTriggerProvider);

  final repo = ref.watch(wordRepositoryProvider);
  return repo.getWordCount();
});

/// ---------------------------------------------------------------------------
/// WORD SUGGESTIONS PROVIDER
/// ---------------------------------------------------------------------------
///
/// This provider is parameterised by a search prefix.
/// Useful for "Add Word" modal suggestions.
///

final wordSuggestionsProvider =
FutureProvider.family<List<String>, String>((ref, prefix) async {
  final repo = ref.watch(wordRepositoryProvider);
  return repo.suggestWords(prefix);
});
