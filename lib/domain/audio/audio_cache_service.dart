import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AudioCacheService {
  Future<File> getAudioFile({
    required String word,
    required String languageCode,
  }) async {
    final dir = await _audioDir();
    final safeWord =
    word.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');

    return File('${dir.path}/${languageCode}_$safeWord.wav');
  }



  Future<Directory> _audioDir() async {
    final baseDir = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${baseDir.path}/audio_cache');
    if (!audioDir.existsSync()) {
      audioDir.createSync(recursive: true);
    }
    return audioDir;
  }



  Future<bool> exists({
    required String word,
    required String languageCode,
  }) async {
    final file = await getAudioFile(
      word: word,
      languageCode: languageCode,
    );
    return file.exists();
  }
}
