import 'package:flutter_tts/flutter_tts.dart';
import 'pronunciation_player.dart';

class TtsPronunciationPlayer implements PronunciationPlayer {
  final FlutterTts _tts = FlutterTts();

  TtsPronunciationPlayer() {
    _tts.setSpeechRate(0.45);
    _tts.setPitch(1.0);
  }

  @override
  Future<void> play({
    required String text,
    required String languageCode,
  }) async {
    await _tts.setLanguage(languageCode);
    await _tts.stop();
    await _tts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }
}
