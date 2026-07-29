import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nex_gen_ai/core/storage/secure_storage.dart';
import 'package:nex_gen_ai/main.dart';

class FakeSecureStorage extends SecureStorage {
  FakeSecureStorage() : super(const FlutterSecureStorage());

  String? token;

  @override
  Future<String?> readToken() async => token;

  @override
  Future<void> writeToken(String token) async => this.token = token;

  @override
  Future<void> deleteToken() async => token = null;
}

void main() {
  testWidgets('App boots to splash and redirects to login when signed out',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          secureStorageProvider.overrideWithValue(FakeSecureStorage()),
        ],
        child: const NexGenAiApp(),
      ),
    );

    // Splash is shown while the session is being restored.
    expect(find.text('NexgenAI'), findsOneWidget);

    // With no stored token the router redirects to the login screen.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
