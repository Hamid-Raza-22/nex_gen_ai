import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/constants/endpoints.dart';

final interiorRepositoryProvider = Provider<InteriorRepository>(
  (ref) => InteriorRepository(ref.watch(dioProvider)),
);

class InteriorPrediction {
  const InteriorPrediction({required this.id, this.status, this.outputUrl});

  final String id;
  final String? status; // starting | processing | succeeded | failed
  final String? outputUrl;

  bool get isDone => status == 'succeeded' || outputUrl != null;
  bool get isFailed => status == 'failed' || status == 'canceled';

  factory InteriorPrediction.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] ?? json['prediction'] ?? json) as Map;
    final output = data['output'];
    return InteriorPrediction(
      id: '${data['id'] ?? data['prediction_id'] ?? ''}',
      status: data['status'] as String?,
      outputUrl: switch (output) {
        String s => s,
        List l when l.isNotEmpty => '${l.last}',
        _ => data['output_url'] as String?,
      },
    );
  }
}

class InteriorRepository {
  const InteriorRepository(this._dio);

  final Dio _dio;

  /// Uploads a room photo, returns the media URL/id used for prediction.
  Future<Map<String, dynamic>> uploadMedia(File image) async {
    try {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path),
        'type': 'interior',
      });
      final res =
          await _dio.post<Map<String, dynamic>>(Endpoints.medias, data: form);
      final data = res.data ?? const {};
      return (data['data'] as Map<String, dynamic>?) ?? data;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<InteriorPrediction> createPrediction({
    required String imageUrl,
    required String style,
    required String roomType,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        Endpoints.createInteriorPrediction,
        data: {'image': imageUrl, 'style': style, 'room_type': roomType},
      );
      return InteriorPrediction.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<InteriorPrediction> getPrediction(String id) async {
    try {
      final res = await _dio
          .get<Map<String, dynamic>>(Endpoints.getPrediction(id));
      return InteriorPrediction.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Polls until the prediction finishes (or times out after [maxAttempts]).
  Future<InteriorPrediction> waitForPrediction(
    String id, {
    int maxAttempts = 60,
  }) async {
    for (var i = 0; i < maxAttempts; i++) {
      final prediction = await getPrediction(id);
      if (prediction.isDone || prediction.isFailed) return prediction;
      await Future<void>.delayed(const Duration(seconds: 2));
    }
    throw const ApiException('Generation timed out. Please try again.');
  }
}
