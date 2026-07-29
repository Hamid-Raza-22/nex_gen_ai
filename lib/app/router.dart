import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/placeholder_screen.dart';
import '../features/auth/application/auth_controller.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/history/history_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';
import 'shell/shell_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ValueNotifier(0);
  ref.listen(authControllerProvider, (_, _) => refreshNotifier.value++);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final status = ref.read(authControllerProvider).status;
      final location = state.matchedLocation;
      final inAuth = location.startsWith('/auth');
      final inSplash = location == '/splash';

      return switch (status) {
        AuthStatus.unknown => inSplash ? null : '/splash',
        AuthStatus.unauthenticated => inAuth ? null : '/auth/login',
        AuthStatus.authenticated => (inAuth || inSplash) ? '/' : null,
      };
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ShellScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      // Phase 3 feature stubs
      GoRoute(
        path: '/tools/ai-assistants',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'AI Assistants'),
      ),
      GoRoute(
        path: '/tools/logo-generator',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Logo Generator'),
      ),
      GoRoute(
        path: '/tools/interior-design',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Interior Design'),
      ),
      GoRoute(
        path: '/tools/content-generator',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Content Generator'),
      ),
      GoRoute(
        path: '/tools/ai-agents',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'AI Agents'),
      ),
      GoRoute(
        path: '/tools/ai-course',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'AI Course'),
      ),
    ],
  );
});
