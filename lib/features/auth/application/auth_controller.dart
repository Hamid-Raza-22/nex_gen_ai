import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/dio_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/app_user.dart';
import '../data/auth_repository.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

class AuthState {
  const AuthState({required this.status, this.user});

  final AuthStatus status;
  final AppUser? user;

  static const unknown = AuthState(status: AuthStatus.unknown);
  static const unauthenticated = AuthState(status: AuthStatus.unauthenticated);

  AuthState copyWith({AuthStatus? status, AppUser? user}) =>
      AuthState(status: status ?? this.status, user: user ?? this.user);
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    AuthInterceptor.onUnauthorized = () {
      state = AuthState.unauthenticated;
    };
    _restoreSession();
    return AuthState.unknown;
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);
  SecureStorage get _storage => ref.read(secureStorageProvider);

  Future<void> _restoreSession() async {
    final token = await _storage.readToken();
    if (token == null || token.isEmpty) {
      state = AuthState.unauthenticated;
      return;
    }
    try {
      final user = await _repo.getUser();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (_) {
      // Invalid/expired token (401 already clears it via the interceptor).
      state = AuthState.unauthenticated;
    }
  }

  Future<void> login({required String email, required String password}) async {
    final token = await _repo.login(email: email, password: password);
    await _storage.writeToken(token);
    final user = await _repo.getUser();
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    await _repo.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    // Backend requires email verification before login; try auto-login and
    // fall back to the login screen if it is rejected.
    await login(email: email, password: password);
  }

  Future<void> logout() async {
    await _repo.logout();
    await _storage.deleteToken();
    state = AuthState.unauthenticated;
  }

  Future<void> refreshUser() async {
    if (state.status != AuthStatus.authenticated) return;
    final user = await _repo.getUser();
    state = state.copyWith(user: user);
  }
}
