import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nex_gen_ai/main.dart';

import 'helpers.dart';

void main() {
  testWidgets('App boots to splash then redirects to login when signed out',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: await testOverrides(),
        child: const NexGenAiApp(),
      ),
    );

    // Splash is shown while the stored session is being restored.
    expect(find.text('NexgenAI'), findsOneWidget);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('Login form validates email and password',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: await testOverrides(),
        child: const NexGenAiApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(
      find.text('Password must be at least 6 characters'),
      findsOneWidget,
    );
  });
}
