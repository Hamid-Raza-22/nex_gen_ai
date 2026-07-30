import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nex_gen_ai/core/storage/app_prefs.dart';
import 'package:nex_gen_ai/core/storage/secure_storage.dart';
import 'package:nex_gen_ai/features/history/data/history_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In-memory secure storage. The real plugin's platform channel never
/// completes under `flutter test`, so it must always be overridden.
class FakeSecureStorage extends SecureStorage {
  FakeSecureStorage({this.token}) : super(const FlutterSecureStorage());

  String? token;

  @override
  Future<String?> readToken() async => token;

  @override
  Future<void> writeToken(String token) async => this.token = token;

  @override
  Future<void> deleteToken() async => token = null;
}

/// Minimal in-memory stand-in for the Hive history box.
class FakeHistoryBox extends Fake implements Box<Map> {
  final _items = <Map>[];

  @override
  Iterable<Map> get values => _items;

  @override
  Future<int> add(Map value) async {
    _items.add(value);
    return _items.length - 1;
  }

  @override
  Future<int> clear() async {
    final count = _items.length;
    _items.clear();
    return count;
  }
}

/// Provider overrides needed for any widget test that boots the app.
Future<List<Override>> testOverrides({String? token}) async {
  SharedPreferences.setMockInitialValues({'onboarding_seen': true});
  final prefs = await SharedPreferences.getInstance();
  return [
    sharedPreferencesProvider.overrideWithValue(prefs),
    historyBoxProvider.overrideWithValue(FakeHistoryBox()),
    secureStorageProvider.overrideWithValue(FakeSecureStorage(token: token)),
  ];
}
