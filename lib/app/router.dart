import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/storage/app_prefs.dart';
import '../core/widgets/placeholder_screen.dart';
import '../features/ai_agents/presentation/agents_screen.dart';
import '../features/ai_assistants/data/personas.dart';
import '../features/ai_assistants/presentation/assistants_screen.dart';
import '../features/ai_chat/application/chat_controller.dart';
import '../features/ai_chat/presentation/chat_screen.dart';
import '../features/ai_course/presentation/ai_course_screen.dart';
import '../features/auth/application/auth_controller.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/billing/presentation/billing_screen.dart';
import '../features/content_generator/presentation/content_form_screen.dart';
import '../features/content_generator/presentation/content_generator_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/history/history_screen.dart';
import '../features/interior_design/presentation/interior_design_screen.dart';
import '../features/logo_generator/presentation/logo_generator_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
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
      final onboardingSeen = ref.read(appPrefsProvider).onboardingSeen;
      final location = state.matchedLocation;
      final inAuth = location.startsWith('/auth');
      final inSplash = location == '/splash';
      final inOnboarding = location == '/onboarding';

      return switch (status) {
        AuthStatus.unknown => inSplash ? null : '/splash',
        AuthStatus.unauthenticated when !onboardingSeen =>
          inOnboarding ? null : '/onboarding',
        AuthStatus.unauthenticated => inAuth ? null : '/auth/login',
        AuthStatus.authenticated =>
          (inAuth || inSplash || inOnboarding) ? '/' : null,
      };
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
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

      // Tools
      GoRoute(
        path: '/tools/ai-assistants',
        builder: (context, state) => const AssistantsScreen(),
      ),
      GoRoute(
        path: '/tools/logo-generator',
        builder: (context, state) => const LogoGeneratorScreen(),
      ),
      GoRoute(
        path: '/tools/interior-design',
        builder: (context, state) => const InteriorDesignScreen(),
      ),
      GoRoute(
        path: '/tools/content-generator',
        builder: (context, state) => const ContentGeneratorScreen(),
      ),
      GoRoute(
        path: '/tools/content-generator/:templateId',
        builder: (context, state) => ContentFormScreen(
          templateId: state.pathParameters['templateId']!,
        ),
      ),
      GoRoute(
        path: '/tools/ai-agents',
        builder: (context, state) => const AgentsScreen(),
      ),
      GoRoute(
        path: '/tools/ai-course',
        builder: (context, state) => const AiCourseScreen(),
      ),
      GoRoute(
        path: '/tools/short-generation',
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Short Generation'),
      ),

      // Chat sessions
      GoRoute(
        path: '/chat/:personaId',
        builder: (context, state) {
          final persona =
              personaById(state.pathParameters['personaId']!) ?? personas.first;
          return ChatScreen(
            config: ChatConfig(
              id: persona.id,
              title: persona.name,
              avatar: persona.image,
              subtitle: persona.role,
              systemPrompt: persona.systemPrompt,
              greeting: persona.greeting,
            ),
          );
        },
      ),
      GoRoute(
        path: '/agent-chat/:agentId',
        builder: (context, state) {
          final agent =
              agentById(state.pathParameters['agentId']!) ?? aiAgents.first;
          return ChatScreen(
            config: ChatConfig(
              id: agent.id,
              title: agent.title,
              avatar: agent.image,
              subtitle: agent.description,
              systemPrompt: agent.systemPrompt,
              greeting: agent.greeting,
            ),
          );
        },
      ),

      // Billing
      GoRoute(
        path: '/billing',
        builder: (context, state) => const BillingScreen(),
      ),
    ],
  );
});
