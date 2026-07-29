import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_exception.dart';

/// OpenAI-compatible AI gateway configuration.
///
/// SECURITY: AI provider keys must NEVER ship inside the app binary. Point
/// AI_BASE_URL at a server-side proxy that injects credentials. The optional
/// AI_API_KEY define exists for local development only.
abstract final class AiConfig {
  static const baseUrl = String.fromEnvironment('AI_BASE_URL');
  static const apiKey = String.fromEnvironment('AI_API_KEY');
  static const chatModel =
      String.fromEnvironment('AI_CHAT_MODEL', defaultValue: 'gpt-4o-mini');
  static const imageModel =
      String.fromEnvironment('AI_IMAGE_MODEL', defaultValue: 'dall-e-3');

  static bool get isConfigured => baseUrl.isNotEmpty;
}

final aiClientProvider = Provider<AiClient>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(minutes: 3),
      headers: {
        'Content-Type': 'application/json',
        if (AiConfig.apiKey.isNotEmpty)
          'Authorization': 'Bearer ${AiConfig.apiKey}',
      },
    ),
  );
  return AiClient(dio);
});

class AiNotConfiguredException implements Exception {
  const AiNotConfiguredException();

  @override
  String toString() =>
      'AI generation is not configured yet. Set AI_BASE_URL via --dart-define '
      'to point at your AI proxy.';
}

class AiClient {
  const AiClient(this._dio);

  final Dio _dio;

  /// Sends an OpenAI-compatible chat completion request.
  /// [messages] entries: {"role": "system|user|assistant", "content": "..."}
  Future<String> chatCompletion(List<Map<String, String>> messages) async {
    if (!AiConfig.isConfigured) throw const AiNotConfiguredException();
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        'chat/completions',
        data: {'model': AiConfig.chatModel, 'messages': messages},
      );
      final content =
          res.data?['choices']?[0]?['message']?['content'] as String?;
      if (content == null) {
        throw const ApiException('Empty response from AI service.');
      }
      return content;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Streams an OpenAI-compatible chat completion (SSE). Yields content deltas.
  Stream<String> chatCompletionStream(
    List<Map<String, String>> messages,
  ) async* {
    if (!AiConfig.isConfigured) throw const AiNotConfiguredException();
    try {
      final res = await _dio.post<ResponseBody>(
        'chat/completions',
        data: {
          'model': AiConfig.chatModel,
          'messages': messages,
          'stream': true,
        },
        options: Options(responseType: ResponseType.stream),
      );

      var buffer = '';
      await for (final chunk in res.data!.stream) {
        buffer += utf8.decode(chunk, allowMalformed: true);
        while (true) {
          final newlineIndex = buffer.indexOf('\n');
          if (newlineIndex == -1) break;
          final line = buffer.substring(0, newlineIndex).trim();
          buffer = buffer.substring(newlineIndex + 1);
          if (!line.startsWith('data:')) continue;
          final payload = line.substring(5).trim();
          if (payload == '[DONE]') return;
          final json = jsonDecode(payload) as Map<String, dynamic>;
          final delta =
              json['choices']?[0]?['delta']?['content'] as String?;
          if (delta != null && delta.isNotEmpty) yield delta;
        }
      }
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Generates an image and returns its URL or a base64 data payload.
  Future<AiImageResult> generateImage(String prompt) async {
    if (!AiConfig.isConfigured) throw const AiNotConfiguredException();
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        'images/generations',
        data: {
          'model': AiConfig.imageModel,
          'prompt': prompt,
          'n': 1,
          'response_format': 'b64_json',
        },
      );
      final item = res.data?['data']?[0] as Map<String, dynamic>?;
      final b64 = item?['b64_json'] as String?;
      final url = item?['url'] as String?;
      if (b64 == null && url == null) {
        throw const ApiException('Empty response from image service.');
      }
      return AiImageResult(base64Data: b64, url: url);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

class AiImageResult {
  const AiImageResult({this.base64Data, this.url});

  final String? base64Data;
  final String? url;
}
