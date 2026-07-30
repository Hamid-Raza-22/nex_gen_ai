import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nex_gen_ai/core/api/api_exception.dart';

DioException _exception({
  required int statusCode,
  Object? data,
  DioExceptionType type = DioExceptionType.badResponse,
}) {
  final options = RequestOptions(path: '/login');
  return DioException(
    requestOptions: options,
    type: type,
    response: Response(
      requestOptions: options,
      statusCode: statusCode,
      data: data,
    ),
  );
}

void main() {
  group('ApiException.fromDioException', () {
    test('uses the server-provided message', () {
      final e = _exception(
        statusCode: 401,
        data: {'message': 'These credentials do not match our records.'},
      );
      final result = ApiException.fromDioException(e);
      expect(result.message, 'These credentials do not match our records.');
      expect(result.statusCode, 401);
    });

    test('parses Laravel field validation errors', () {
      final e = _exception(
        statusCode: 422,
        data: {
          'message': 'The given data was invalid.',
          'errors': {
            'email': ['The email has already been taken.'],
            'password': ['Too short.'],
          },
        },
      );
      final result = ApiException.fromDioException(e);
      expect(result.errors?['email'], ['The email has already been taken.']);
      expect(result.errors?['password'], ['Too short.']);
    });

    test('falls back to a friendly message per status code', () {
      expect(
        ApiException.fromDioException(_exception(statusCode: 500)).message,
        'Server error. Please try again later.',
      );
      expect(
        ApiException.fromDioException(_exception(statusCode: 404)).message,
        'Requested resource was not found.',
      );
      expect(
        ApiException.fromDioException(_exception(statusCode: 429)).message,
        'Too many requests. Please wait a moment.',
      );
    });

    test('reports connectivity problems', () {
      final e = DioException(
        requestOptions: RequestOptions(path: '/user'),
        type: DioExceptionType.connectionError,
      );
      expect(
        ApiException.fromDioException(e).message,
        'No internet connection. Check your network and try again.',
      );
    });
  });
}
