import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import 'audio_cache_service.dart';
import 'pronunciation_player.dart';

class TtsPronunciationPlayer implements PronunciationPlayer {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();
  final AudioCacheService _cache;

  TtsPronunciationPlayer(this._cache) {
    _tts.setSpeechRate(0.45);
    _tts.setPitch(1.0);
  }

  @override
  Future<void> play({
    required String text,
    required String languageCode,
  }) async {
    final File file = await _cache.getAudioFile(
      word: text,
      languageCode: languageCode,
    );
    print("Path: ${file.path}");
    print("Exists: ${await file.exists()}");
    // print("Length: ${await file.length()}");


    // If cached audio exists → play immediately
    if (await file.exists()) {
      print('file exists');
      await _player.setFilePath(file.path);
      await _player.play();
      return;
    }

    // Generate audio using TTS
    await _tts.setLanguage(languageCode);

    final result =
    await _tts.synthesizeToFile(text, file.path, true);

    print(result);

    if (result == 1 && await file.exists()) {

      await _player.setFilePath(file.path);
      await _player.play();
    } else {
      throw Exception('Failed to generate pronunciation audio for "$text" in  "$languageCode"');
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }
}
