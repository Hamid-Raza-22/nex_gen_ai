import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Overridden in main() with the real instance before the app starts.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Override in main()'),
);

final appPrefsProvider = Provider<AppPrefs>(
  (ref) => AppPrefs(ref.watch(sharedPreferencesProvider)),
);

class AppPrefs {
  const AppPrefs(this._prefs);

  final SharedPreferences _prefs;

  static const _onboardingKey = 'onboarding_seen';

  bool get onboardingSeen => _prefs.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingSeen() => _prefs.setBool(_onboardingKey, true);
}
