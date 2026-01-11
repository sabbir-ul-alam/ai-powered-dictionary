import 'package:apd/data/local/db/daos/word_learning_progress_dao.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/config/firebase_api_key_provider.dart';
import '../../data/local/db/app_database.dart';
import '../../data/local/db/daos/words_dao.dart';
import '../../data/local/db/daos/languages_dao.dart';
import '../../data/local/db/daos/word_metadata_dao.dart';

import '../../data/preferences/preferences_repository.dart';

import '../../data/repositories/word_repository_impl.dart';
import '../../data/repositories/language_repository_impl.dart';

import '../../domain/audio/audio_cache_service.dart';
import '../../domain/audio/pronunciation_player.dart';
import '../../domain/audio/tts_pronunciation_player.dart';
import '../../domain/config/api_key_provider.dart';
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

final wordsLearningDaoProvider = Provider<WordLearningProgressDao>((ref) {
  return WordLearningProgressDao(ref.watch(databaseProvider));
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
    ref.watch(wordsLearningDaoProvider),
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
  ref.watch(wordsStreamProvider);
  return ref.watch(wordRepositoryProvider).listWords(
    favoritesOnly: favoritesOnly,
  );
});

/// ---------------------------------------------------------------------------
/// WORD COUNT
/// ---------------------------------------------------------------------------

final wordCountProvider = FutureProvider<int>((ref) async {
  ref.watch(activeLanguageTriggerProvider);
  final query = ref.watch(wordSearchQueryProvider).trim();
  if (query.isEmpty) {
    return ref.watch(wordRepositoryProvider).getWordCount(null
      // favoritesOnly: true,
    );
  }
    return ref.watch(wordRepositoryProvider).getWordCount(
      query,
      // favoritesOnly: true,
    );
  });

final starredWordCountProvider = FutureProvider<int>((ref) async {
  ref.watch(activeLanguageTriggerProvider);
  // final favoritesOnly = ref.watch(favoritesOnlyProvider);
  final query = ref.watch(wordSearchQueryProvider).trim();
  if (query.isEmpty) {
    return ref.watch(wordRepositoryProvider).getWordCount(
      null,
      favoritesOnly: true,
    );

  }

  return ref.watch(wordRepositoryProvider).getWordCount(
    query,
    favoritesOnly: true,
  );
});
/// ---------------------------------------------------------------------------
/// WORD SUGGESTIONS (prefix; Add Word)
/// ---------------------------------------------------------------------------

final wordSuggestionsProvider =
FutureProvider.family<List<Word>, String>((ref, prefix) async {
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
final aiDictionaryServiceProvider = Provider<AiDictionaryService>((ref) {
  return AiDictionaryService(
    ref.watch(apiKeyProviderProvider),
  );
});



final wordEnrichmentServiceProvider =
Provider<WordEnrichmentService>((ref) {
  return WordEnrichmentService(
    aiService: ref.read(aiDictionaryServiceProvider),
    metadataDao: ref.read(wordMetadataDaoProvider),
    wordsDao: ref.read(wordsDaoProvider),

  );
});


final wordsStreamProvider = StreamProvider.autoDispose<List<Word>>((ref) {
  final dao = ref.watch(wordsDaoProvider);
  return dao.watchAllWords();
});

/// Flashcards dashboard stats
final learningStatsAllProvider = FutureProvider<LearningStats>((ref) async {
  ref.watch(activeLanguageTriggerProvider);
  final lang = await ref.watch(languageRepositoryProvider).getActiveLanguage();
  if (lang == null) return const LearningStats(total: 0, learned: 0);

  return ref.watch(wordsLearningDaoProvider).getStats(
    languageCode: lang.code,
    favoritesOnly: false,
  );
});

final learningStatsFavoritesProvider = FutureProvider<LearningStats>((ref) async {
  ref.watch(activeLanguageTriggerProvider);
  final lang = await ref.watch(languageRepositoryProvider).getActiveLanguage();
  if (lang == null) return const LearningStats(total: 0, learned: 0);

  return ref.watch(wordsLearningDaoProvider).getStats(
    languageCode: lang.code,
    favoritesOnly: true,
  );
});

final flashcardSessionWordIdsProvider =
FutureProvider.family<List<String>, FlashcardSessionFilter>((ref, filter) async {
  ref.watch(activeLanguageTriggerProvider);
  final lang = await ref.watch(languageRepositoryProvider).getActiveLanguage();
  if (lang == null) return const [];

  return ref.watch(wordsLearningDaoProvider).listWordIdsForSession(
    languageCode: lang.code,
    favoritesOnly: filter.favoritesOnly,
    unlearnedOnly: filter.unlearnedOnly,
  );
});

/// Session filter model
class FlashcardSessionFilter {
  final bool favoritesOnly;
  final bool unlearnedOnly;

  const FlashcardSessionFilter({
    required this.favoritesOnly,
    required this.unlearnedOnly,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FlashcardSessionFilter &&
              runtimeType == other.runtimeType &&
              favoritesOnly == other.favoritesOnly &&
              unlearnedOnly == other.unlearnedOnly;

  @override
  int get hashCode => favoritesOnly.hashCode ^ unlearnedOnly.hashCode;
}


final firebaseRemoteConfigProvider =
Provider<FirebaseRemoteConfig>((ref) {
  return FirebaseRemoteConfig.instance;
});

final apiKeyProviderProvider = Provider<ApiKeyProvider>((ref) {
  return FirebaseApiKeyProvider(
    ref.watch(firebaseRemoteConfigProvider),
  );
});

final audioCacheServiceProvider =
Provider<AudioCacheService>((ref) {
  return AudioCacheService();
});

final pronunciationPlayerProvider =
Provider<PronunciationPlayer>((ref) {
  return TtsPronunciationPlayer(
    ref.read(audioCacheServiceProvider),
  );
});

final currentIndexProvider = StateProvider<int>((ref) => 0);
