import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/app_logo.dart';
import '../auth/application/auth_controller.dart';

class _Feature {
  const _Feature(this.title, this.subtitle, this.image, this.route);

  final String title;
  final String subtitle;
  final String image;
  final String route;
}

const _features = [
  _Feature(
    'AI Assistants',
    'Chat with expert personas',
    AppAssets.featureAssistant,
    '/tools/ai-assistants',
  ),
  _Feature(
    'Logo Generator',
    'Design logos from a prompt',
    AppAssets.featureLogoGen,
    '/tools/logo-generator',
  ),
  _Feature(
    'Interior Design',
    'Restyle any room with AI',
    AppAssets.featureInterior,
    '/tools/interior-design',
  ),
  _Feature(
    'Content Generator',
    'Blogs, emails & scripts',
    AppAssets.featureContentGen,
    '/tools/content-generator',
  ),
  _Feature(
    'AI Agents',
    'Voice agents & practice',
    AppAssets.featureAgents,
    '/tools/ai-agents',
  ),
  _Feature(
    'AI Course',
    'Generate full courses',
    AppAssets.featureCourse,
    '/tools/ai-course',
  ),
];

class _CreditsBanner extends StatelessWidget {
  const _CreditsBanner({required this.credits});

  final num? credits;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.bolt, color: AppColors.neonCyan),
        title: Text(
          credits != null ? '$credits credits left' : 'Your plan',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: const Text(
          'Tap to view plans and transactions',
          style: TextStyle(color: AppColors.light, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.mid),
        onTap: () => context.push('/billing'),
      ),
    );
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const AppLogo(),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Hello, ${user?.name.split(' ').first ?? 'Creator'} 👋',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'What will you create today?',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.light),
          ),
          const SizedBox(height: 16),
          _CreditsBanner(credits: user?.credits),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemCount: _features.length,
            itemBuilder: (context, index) {
              final feature = _features[index];
              return _FeatureCard(feature: feature);
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(feature.route),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Ink.image(
                image: AssetImage(feature.image),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    feature.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.light),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
