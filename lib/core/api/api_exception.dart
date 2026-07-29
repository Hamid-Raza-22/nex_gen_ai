import 'package:dio/dio.dart';

/// Normalized API error surfaced to the UI layer.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.errors});

  final String message;
  final int? statusCode;

  /// Laravel-style field validation errors: {"email": ["taken"], ...}
  final Map<String, List<String>>? errors;

  factory ApiException.fromDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    String message;
    Map<String, List<String>>? errors;

    if (data is Map<String, dynamic>) {
      message = (data['message'] as String?) ??
          (data['error'] as String?) ??
          _defaultMessage(e, statusCode);
      final rawErrors = data['errors'];
      if (rawErrors is Map<String, dynamic>) {
        errors = rawErrors.map(
          (key, value) => MapEntry(
            key,
            value is List ? value.map((v) => v.toString()).toList() : ['$value'],
          ),
        );
      }
    } else {
      message = _defaultMessage(e, statusCode);
    }

    return ApiException(message, statusCode: statusCode, errors: errors);
  }

  static String _defaultMessage(DioException e, int? statusCode) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'Connection timed out. Please try again.',
      DioExceptionType.connectionError =>
        'No internet connection. Check your network and try again.',
      _ => switch (statusCode) {
          401 => 'Session expired. Please sign in again.',
          403 => 'You do not have permission to do that.',
          404 => 'Requested resource was not found.',
          422 => 'Some fields are invalid.',
          429 => 'Too many requests. Please wait a moment.',
          final s? when s >= 500 => 'Server error. Please try again later.',
          _ => 'Something went wrong. Please try again.',
        },
    };
  }

  @override
  String toString() => message;
}
