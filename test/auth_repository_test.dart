import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nex_gen_ai/core/api/api_exception.dart';
import 'package:nex_gen_ai/features/auth/data/app_user.dart';
import 'package:nex_gen_ai/features/auth/data/auth_repository.dart';

/// Returns canned responses without hitting the network.
class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this.statusCode, this.body);

  final int statusCode;
  final Object body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      _encode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  static String _encode(Object body) =>
      body is String ? body : jsonEncode(body);

  @override
  void close({bool force = false}) {}
}

Dio _dio(int statusCode, Object body) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/'))
    ..httpClientAdapter = _StubAdapter(statusCode, body);
  return dio;
}

void main() {
  group('AuthRepository.login', () {
    test('returns the token from a "token" field', () async {
      final repo = AuthRepository(_dio(200, {'token': 'abc123'}));
      expect(
        await repo.login(email: 'a@b.com', password: 'secret'),
        'abc123',
      );
    });

    test('returns the token from an "access_token" field', () async {
      final repo = AuthRepository(_dio(200, {'access_token': 'xyz789'}));
      expect(
        await repo.login(email: 'a@b.com', password: 'secret'),
        'xyz789',
      );
    });

    test('throws ApiException when no token is present', () async {
      final repo = AuthRepository(_dio(200, {'ok': true}));
      expect(
        () => repo.login(email: 'a@b.com', password: 'secret'),
        throwsA(isA<ApiException>()),
      );
    });

    test('maps HTTP failures to ApiException', () async {
      final repo = AuthRepository(
        _dio(401, {'message': 'Invalid credentials'}),
      );
      await expectLater(
        () => repo.login(email: 'a@b.com', password: 'wrong'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            'Invalid credentials',
          ),
        ),
      );
    });
  });

  group('AuthRepository.getUser', () {
    test('parses a nested user payload', () async {
      final repo = AuthRepository(
        _dio(200, {
          'user': {
            'id': 7,
            'name': 'Ada Lovelace',
            'email': 'ada@example.com',
            'role': 'user',
            'credits': 250,
          },
        }),
      );
      final user = await repo.getUser();
      expect(user.id, 7);
      expect(user.name, 'Ada Lovelace');
      expect(user.credits, 250);
    });

    test('parses a flat user payload', () async {
      final repo = AuthRepository(
        _dio(200, {'id': 1, 'name': 'Bob', 'email': 'bob@example.com'}),
      );
      final user = await repo.getUser();
      expect(user.id, 1);
      expect(user.role, 'user');
    });
  });

  group('AppUser', () {
    test('tracks email verification state', () {
      const unverified = AppUser(id: 1, name: 'A', email: 'a@b.com');
      expect(unverified.isEmailVerified, isFalse);

      final verified = AppUser.fromJson({
        'id': 2,
        'name': 'B',
        'email': 'b@c.com',
        'email_verified_at': '2026-01-01T00:00:00.000Z',
      });
      expect(verified.isEmailVerified, isTrue);
    });
  });
}
