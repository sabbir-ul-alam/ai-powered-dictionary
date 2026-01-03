import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../domain/config/api_key_provider.dart';

class FirebaseApiKeyProvider implements ApiKeyProvider {
  final FirebaseRemoteConfig _remoteConfig;
  String? _cachedKey;

  FirebaseApiKeyProvider(this._remoteConfig);

  @override
  Future<String> getAiApiKey() async {
    // Return cached key if already fetched
    if (_cachedKey != null) {
      return _cachedKey!;
    }

    await _remoteConfig.setDefaults({
      'AI_API_KEY': '',
    });

    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
      // Ignore fetch errors — use cached/default values
    }

    final key = _remoteConfig.getString('api_key_deep_Seek');

    if (key.isEmpty) {
      throw StateError(
        'AI API key missing. Please check Firebase Remote Config.',
      );
    }

    _cachedKey = key;
    return key;
  }
}


// class FirebaseApiKeyProvider implements ApiKeyProvider {
//   final FirebaseRemoteConfig _remoteConfig;
//
//   FirebaseApiKeyProvider(this._remoteConfig);
//
//   @override
//   Future<String> getAiApiKey() async {
//     await _remoteConfig.setConfigSettings(
//       RemoteConfigSettings(
//         fetchTimeout: const Duration(seconds: 5),
//         minimumFetchInterval: const Duration(hours: 1),
//       ),
//     );
//
//     await _remoteConfig.fetchAndActivate();
//
//     final key = _remoteConfig.getString('AI_API_KEY');
//
//     if (key.isEmpty) {
//       throw StateError('AI API key not found in Remote Config');
//     }
//
//     return key;
//   }
// }
