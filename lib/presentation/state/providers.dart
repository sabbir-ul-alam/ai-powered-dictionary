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
import '../../data/ai/ai_dictionary_service.dart';
import '../../domain/services/word_enrichment_service.dart';

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

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepository();
});

/// ---------------------------------------------------------------------------
/// REPOSITORIES
/// ---------------------------------------------------------------------------

final languageRepositoryProvider = Provider<LanguageRepository>((ref) {
  return LanguageRepositoryImpl(
    ref.watch(languagesDaoProvider),
    ref.watch(preferencesRepositoryProvider),
  );
});

final wordRepositoryProvider = Provider<WordRepository>((ref) {
  return WordRepositoryImpl(
    ref.watch(wordsDaoProvider),
    ref.watch(preferencesRepositoryProvider),
  );
});

/// ---------------------------------------------------------------------------
/// ACTIVE LANGUAGE TRIGGER
/// ---------------------------------------------------------------------------

final activeLanguageTriggerProvider = StateProvider<int>((ref) => 0);

/// ---------------------------------------------------------------------------
/// ACTIVE LANGUAGE
/// ---------------------------------------------------------------------------

final activeLanguageProvider = FutureProvider((ref) async {
  ref.watch(activeLanguageTriggerProvider);
  return ref.watch(languageRepositoryProvider).getActiveLanguage();
});

/// ---------------------------------------------------------------------------
/// WORD LIST
/// ---------------------------------------------------------------------------

final wordListProvider = FutureProvider<List<Word>>((ref) async {
  ref.watch(activeLanguageTriggerProvider);
  final favoritesOnly = ref.watch(favoritesOnlyProvider);
  return ref.watch(wordRepositoryProvider).listWords(
    favoritesOnly: favoritesOnly,
  );
});

/// ---------------------------------------------------------------------------
/// WORD COUNT
/// ---------------------------------------------------------------------------

final wordCountProvider = FutureProvider<int>((ref) async {
  ref.watch(activeLanguageTriggerProvider);
  final favoritesOnly = ref.watch(favoritesOnlyProvider);
  return ref.watch(wordRepositoryProvider).getWordCount(
    favoritesOnly: favoritesOnly,
  );
});

/// ---------------------------------------------------------------------------
/// WORD SUGGESTIONS (prefix; Add Word)
/// ---------------------------------------------------------------------------

final wordSuggestionsProvider =
FutureProvider.family<List<String>, String>((ref, prefix) async {
  ref.watch(activeLanguageTriggerProvider);

  final p = prefix.trim();
  if (p.isEmpty) return const [];

  return ref.watch(wordRepositoryProvider).suggestWords(p);
});

/// ---------------------------------------------------------------------------
/// SEARCH (contains; Home)
/// ---------------------------------------------------------------------------

final wordSearchQueryProvider = StateProvider<String>((ref) => '');

final wordSearchResultsProvider = FutureProvider<List<Word>>((ref) async {
  ref.watch(activeLanguageTriggerProvider);
  final favoritesOnly = ref.watch(favoritesOnlyProvider);
  final query = ref.watch(wordSearchQueryProvider).trim();
  if (query.isEmpty) return const <Word>[];
  return ref.watch(wordRepositoryProvider).searchWords(
    query,
    favoritesOnly: favoritesOnly,
  );
});

/// NEW: favourites filter state (HomeScreen toggles this)
final favoritesOnlyProvider = StateProvider<bool>((ref) => false);


/// ---------------------------------------------------------------------------
/// MetaData (AI / USER / SYSTEM)
/// ---------------------------------------------------------------------------
final aiDictionaryServiceProvider =
Provider<AiDictionaryService>((ref) {
  //Inject properly later (env, secrets manager, etc.)
  return AiDictionaryService(
    apiKey: '',
  );
});


final wordEnrichmentServiceProvider =
Provider<WordEnrichmentService>((ref) {
  return WordEnrichmentService(
    aiService: ref.read(aiDictionaryServiceProvider),
    metadataDao: ref.read(wordMetadataDaoProvider),
  );
});
