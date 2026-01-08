abstract class PronunciationPlayer {
  Future<void> play({
    required String text,
    required String languageCode,
  });

  Future<void> stop();
}
