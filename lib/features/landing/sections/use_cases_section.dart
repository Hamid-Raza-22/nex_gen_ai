import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import 'section_shared.dart';

class _UseCase {
  const _UseCase(
    this.emoji,
    this.title,
    this.description, {
    this.statValue,
    this.statLabel,
    this.popular = false,
  });

  final String emoji;
  final String title;
  final String description;
  final String? statValue;
  final String? statLabel;
  final bool popular;
}

const _useCases = [
  _UseCase(
    '🎨',
    'Content Creators',
    'Generate viral thumbnails, short-form videos, and social media graphics '
        'at scale — without touching a design tool.',
    statValue: '10×',
    statLabel: 'Faster Output',
    popular: true,
  ),
  _UseCase(
    '🏢',
    'Marketing Agencies',
    'Produce hundreds of ad creatives and copy variants in the time it used '
        'to take for one.',
    statValue: '95%',
    statLabel: 'Cost Reduction',
  ),
  _UseCase(
    '💻',
    'Developers',
    'Accelerate velocity with AI-generated boilerplates, snippets, and '
        'documentation.',
    statValue: '3×',
    statLabel: 'Dev Speed',
  ),
  _UseCase('🎓', 'Educators', 'Build full AI-powered courses in minutes.'),
  _UseCase(
    '🛍️',
    'E-Commerce',
    'Auto-generate product visuals and descriptions.',
  ),
  _UseCase(
    '🏠',
    'Interior Designers',
    'Present AI-rendered room concepts to clients.',
  ),
];

/// "Use Cases" — Powering Every Industry.
class UseCasesSection extends StatelessWidget {
  const UseCasesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kSectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            badge: 'Use Cases',
            title: 'Powering',
            gradientPart: 'Every Industry',
            subtitle:
                'From solo creators to Fortune 500s — NexgenAI removes '
                'creative bottlenecks for everyone.',
          ),
          const SizedBox(height: 24),
          for (final useCase in _useCases)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SectionCard(
                borderColor: useCase.popular
                    ? AppColors.neonCyan.withValues(alpha: 0.5)
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          useCase.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            useCase.title,
                            style: const TextStyle(
                              color: AppColors.lightest,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (useCase.popular)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              gradient: kCtaGradient,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Most Popular',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      useCase.description,
                      style: const TextStyle(
                        color: AppColors.light,
                        fontSize: 12.5,
                        height: 1.5,
                      ),
                    ),
                    if (useCase.statValue != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          GradientText(
                            useCase.statValue!,
                            style: const TextStyle(
                              fontFamily: AppTheme.displayFont,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            useCase.statLabel!,
                            style: const TextStyle(
                              color: AppColors.light,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
