import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import 'section_shared.dart';

/// "Platform" — Your AI Lab Dashboard studio mockup.
class PlatformSection extends StatelessWidget {
  const PlatformSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kSectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            badge: 'Platform',
            title: 'Your AI Lab',
            gradientPart: 'Dashboard',
            subtitle:
                'A unified workspace for all your AI generation needs, clean, '
                'fast, and intuitive.',
          ),
          const SizedBox(height: 24),
          SectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Studio window title bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.darkest.withValues(alpha: 0.6),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.auto_awesome,
                          color: AppColors.neonCyan, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'NexgenAI Studio',
                        style: TextStyle(
                          fontFamily: AppTheme.displayFont,
                          fontSize: 13,
                          color: AppColors.lightest,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tabs
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final (i, tab) in const [
                              'Dashboard',
                              'Image Gen',
                              'Video Gen',
                              'Shorts Gen',
                              'Code Gen',
                            ].indexed)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _Tab(label: tab, selected: i == 0),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Stats
                      const Row(
                        children: [
                          Expanded(
                            child: _StudioStat(
                              label: 'Images Created',
                              value: '2,481',
                              color: AppColors.neonCyan,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _StudioStat(
                              label: 'Videos Generated',
                              value: '847',
                              color: Color(0xFFC084FC),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _StudioStat(
                              label: 'Code Snippets',
                              value: '1,203',
                              color: Color(0xFFEC4899),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Prompt box
                      const Text(
                        'Generate Something New',
                        style: TextStyle(
                          color: AppColors.lightest,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.darkest.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.mid.withValues(alpha: 0.4),
                          ),
                        ),
                        child: const Text(
                          'A cinematic sunset over a futuristic city...',
                          style: TextStyle(
                            color: AppColors.light,
                            fontSize: 12.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const _PromptChip('Image'),
                          const SizedBox(width: 6),
                          const _PromptChip('4K'),
                          const SizedBox(width: 6),
                          const _PromptChip('Cinematic'),
                          const Spacer(),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: kCtaGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 9),
                              child: Text(
                                'Generate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.25)
            : AppColors.darkest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected
              ? AppColors.primary
              : AppColors.mid.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          color: selected ? AppColors.lightest : AppColors.light,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

class _StudioStat extends StatelessWidget {
  const _StudioStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.darkest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mid.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: AppTheme.displayFont,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 9.5, color: AppColors.light),
          ),
        ],
      ),
    );
  }
}

class _PromptChip extends StatelessWidget {
  const _PromptChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.mid.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10.5, color: AppColors.lightest),
      ),
    );
  }
}
