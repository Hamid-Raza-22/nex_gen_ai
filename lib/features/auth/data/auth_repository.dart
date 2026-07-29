import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/constants/endpoints.dart';
import 'app_user.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(dioProvider)),
);

class AuthRepository {
  const AuthRepository(this._dio);

  final Dio _dio;

  /// Logs in and returns the bearer token.
  Future<String> login({required String email, required String password}) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        Endpoints.login,
        data: {'email': email, 'password': password},
      );
      final data = res.data ?? const {};
      // Handle response structure where token is in 'data' field directly
      final token = data['token'] ?? data['access_token'] ?? data['data'];
      if (token is! String || token.isEmpty) {
        throw const ApiException('Unexpected response from server.');
      }
      return token;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }


  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        Endpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<AppUser> getUser() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(Endpoints.user);
      final data = res.data ?? const {};
      final userJson = data['user'] ?? data['data'] ?? data;
      return AppUser.fromJson(userJson as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post<void>(Endpoints.forgotPassword, data: {'email': email});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post<void>(Endpoints.logout);
    } on DioException {
      // Token is cleared locally regardless; ignore server-side failure.
    }
  }
}
