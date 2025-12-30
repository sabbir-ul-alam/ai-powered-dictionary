import 'dart:convert';
import 'package:http/http.dart' as http;

/// ---------------------------------------------------------------------------
/// AI DICTIONARY SERVICE (DeepSeek – Direct API)
/// ---------------------------------------------------------------------------
///
/// Uses DeepSeek's OpenAI-compatible Chat Completions API.
/// Responsible ONLY for generating meaning + examples.
///
class AiDictionaryService {
  final String apiKey;

  /// DeepSeek base URL (OpenAI-compatible)
  static const String _baseUrl = 'https://api.deepseek.com/v1';

  /// Recommended model for dictionary usage
  static const String _model = 'deepseek-chat';

  AiDictionaryService({
    required this.apiKey,
  });

  Future<AiWordMetadata> generate({
    required String word,
    required String languageName,
  }) async {
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
Generate a simple dictionary meaning and 2 example sentences. Only the meaning should always be in English. Examples should always be in the same language as the word.

Example Language: $languageName
Meaning Language: English
Word: "$word"

Respond strictly in this JSON format:
{
  "meaning": "string",
  "examples": ["string", "string"]
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
      meaning: parsedJson['meaning'] as String,
      examples:
      (parsedJson['examples'] as List).whereType<String>().toList(),
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
  final String meaning;
  final List<String> examples;

  AiWordMetadata({
    required this.meaning,
    required this.examples,
  });
}
