import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/config/api_key_provider.dart';

/// ---------------------------------------------------------------------------
/// AI DICTIONARY SERVICE (DeepSeek – Direct API)
/// ---------------------------------------------------------------------------
///
/// Uses DeepSeek's OpenAI-compatible Chat Completions API.
/// Responsible ONLY for generating meaning + examples.
///
class AiDictionaryService {
  final ApiKeyProvider apiKeyProvider;

  /// DeepSeek base URL (OpenAI-compatible)
  static const String _baseUrl = 'https://api.deepseek.com/v1';

  /// Recommended model for dictionary usage
  static const String _model = 'deepseek-chat';

  AiDictionaryService(this.apiKeyProvider);


  Future<AiWordMetadata> generate({
    required String word,
    required String languageName,
  }) async {
    final apiKey = await apiKeyProvider.getAiApiKey();

    final uri = Uri.parse('$_baseUrl/chat/completions');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'temperature': 1.3,
        'messages': [
          {
            'role': 'system',
            'content':
            'You are a dictionary assistant. '
                'You must respond with valid JSON only. '
                'Do not include explanations or markdown.'
          },
          {
            'role': 'user',
            'content': '''
Give dictionary details for the "$word" in $languageName. Correct the word spelling. Only the meaning should always be in English.
Examples should always be in the same language as the word. Return '' for a field if the value for that field is not available.
Return ONLY valid JSON in this format:
{
  "word": "correct_spelling_string",
  "meaning": "string",
  "examples": ["string", "string"],
  "partOfSpeech": "string",
  "forms": [
    { "label": "gender", "value": "string" },

  ]
}
'''
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'DeepSeek API failed (${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    final content =
    decoded['choices']?[0]?['message']?['content'];

    if (content == null || content is! String) {
      throw Exception('Invalid DeepSeek response format');
    }

    // Defensive JSON parsing (models sometimes add whitespace)
    final parsedJson = _extractJson(content);

    return AiWordMetadata(
        aiWordSpelling: parsedJson['word'] as String ?? '',
        meaning: parsedJson['meaning'] as String ?? '',
        examples:
        (parsedJson['examples'] as List).whereType<String>().toList() ?? [],
        partOfSpeech: parsedJson['partOfSpeech'] ?? '',
        // pronunciation: parsedJson['pronunciation'] ??'',
        forms:
        (parsedJson['forms'] as List?)?.map((e) => AiWordForm(
          label: e['label'] ?? '',
          value: e['value'] ?? '',
        ))
        .toList() ??
        []
    );
  }

  /// -------------------------------------------------------------------------
  /// JSON EXTRACTION (ROBUST)
  /// -------------------------------------------------------------------------
  ///
  /// Handles cases where model accidentally adds text before/after JSON.
  ///
  Map<String, dynamic> _extractJson(String content) {
    try {
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      final start = content.indexOf('{');
      final end = content.lastIndexOf('}');
      if (start == -1 || end == -1) {
        throw Exception('No JSON object found in AI response');
      }
      final jsonString = content.substring(start, end + 1);
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
  }
}

/// ---------------------------------------------------------------------------
/// AI RESULT MODEL
/// ---------------------------------------------------------------------------

class AiWordMetadata {
  final String aiWordSpelling;
  final String meaning;
  final List<String> examples;
  final String? partOfSpeech;
  final List<AiWordForm> forms;

  AiWordMetadata({
    required this.aiWordSpelling,
    required this.meaning,
    required this.examples,
    this.partOfSpeech,
    required this.forms,
  });

  Map<String, dynamic> toJson() => {
    'word': aiWordSpelling,
    'meaning': meaning,
    'examples': examples,
    'partOfSpeech': partOfSpeech,
    'forms': forms.map((f) => f.toJson()).toList(),
  };
}


class AiWordForm {
  final String label;
  final String value;

  AiWordForm({
    required this.label,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
    'label': label,
    'value': value,
  };
}
