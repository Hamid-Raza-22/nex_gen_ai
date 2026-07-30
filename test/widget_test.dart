import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nex_gen_ai/app/router.dart';
import 'package:nex_gen_ai/main.dart';

import 'helpers.dart';

void main() {
  testWidgets('App opens on the landing screen with all hero elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: await testOverrides(),
        child: const NexGenAiApp(),
      ),
    );
    await tester.pump();

    // Top bar
    expect(find.text('NexgenAI'), findsOneWidget);

    // Hero content extracted from the website
    expect(find.text('Powering the Future with AI'), findsOneWidget);
    expect(find.text('Generate Next-Level'), findsOneWidget);
    expect(find.text('with Intelligence'), findsOneWidget);
    expect(find.text('Get Started Free'), findsOneWidget);
    expect(find.text('Explore Features'), findsOneWidget);

    // Statistics
    expect(find.text('4+'), findsOneWidget);
    expect(find.text('AI Engines'), findsOneWidget);
    expect(find.text('10k+'), findsOneWidget);
    expect(find.text('Generations'), findsOneWidget);
    expect(find.text('99%'), findsOneWidget);
    expect(find.text('User Satisfaction'), findsOneWidget);
  });

  testWidgets('Login form validates email and password',
      (WidgetTester tester) async {
    final container = ProviderContainer(overrides: await testOverrides());
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const NexGenAiApp(),
      ),
    );
    await tester.pump();

    container.read(routerProvider).go('/auth/login');
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
