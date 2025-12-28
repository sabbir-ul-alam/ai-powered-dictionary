import 'dart:convert';

import 'package:http/http.dart' as http;

/// ---------------------------------------------------------------------------
/// AI DICTIONARY SERVICE (GEMINI)
/// ---------------------------------------------------------------------------
///
/// Generates meaning + examples using Google Gemini.
/// UI-agnostic and DB-agnostic.
///
class AiDictionaryService {
  final String apiKey;
  final String endpoint;

  AiDictionaryService({
    // this.apiKey = 'AIzaSyCkA8gnSR4vpdNI83FbWW-VoUfa__HDw0M',
    this.endpoint =
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent',
  });

  Future<AiWordMetadata> generate({
    required String word,
    required String languageName,
  }) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        // 'x-goog-api-key':'AIzaSyCkA8gnSR4vpdNI83FbWW-VoUfa__HDw0M'
      },
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {
                "text": "You are a dictionary assistant. Respond ONLY with valid JSON. Do not add explanations or markdown.Generate a simple dictionary meaning and 2 example sentences.Language:$languageName. Word: $word. Return JSON in this exact format:{\"meaning\": \"string\", \"examples\": [\"string\", \"string\"]"
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.3,
          "maxOutputTokens": 1024
        }
      })
    );

    if (response.statusCode != 200) {
      throw Exception(
        'AI generation failed (${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    print('########Decoded#####');
    print(decoded);

    // Gemini response format
    final rawText = decoded['candidates'][0]['content']['parts'][0]['text'];

    // Defensive cleanup (Gemini sometimes adds whitespace)
    final cleaned = rawText.trim();

    final parsed = jsonDecode(cleaned);

    return AiWordMetadata(
      meaning: parsed['meaning'] as String,
      examples:
      (parsed['examples'] as List).whereType<String>().toList(),
    );
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
