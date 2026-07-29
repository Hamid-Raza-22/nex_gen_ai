import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<SecureStorage>(
  (ref) => SecureStorage(const FlutterSecureStorage()),
);

/// Wrapper around platform secure storage (Keychain / Keystore).
class SecureStorage {
  const SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';

  Future<String?> readToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (_) {
      // Storage unavailable (first launch after reinstall, tests, etc.)
      return null;
    }
  }

  Future<void> writeToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<void> deleteToken() => _storage.delete(key: _tokenKey);
}
