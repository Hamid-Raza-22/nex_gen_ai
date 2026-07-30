import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import 'section_shared.dart';

class _CompareRow {
  const _CompareRow(this.title, this.detail);

  final String title;
  final String detail;
}

const _traditionalRows = [
  _CompareRow('Image Creation', 'Hours of work · \$50–\$500+ per asset'),
  _CompareRow('Video Production', 'Full editing suite · days of editing'),
  _CompareRow('Code Generation', 'Senior dev hours · steep learning curve'),
  _CompareRow('Logo & Branding', 'Design agency · weeks of revisions'),
  _CompareRow('Content Writing', '1–3 day turnaround · expensive copywriter'),
  _CompareRow('Interior Visualization', '3D artist · \$200–\$2,000 per render'),
];

const _aiRows = [
  _CompareRow('Image Creation', 'Seconds · unlimited generations included'),
  _CompareRow('Video Production', 'Text-to-video in seconds · no editing needed'),
  _CompareRow('Code Generation', 'Production-ready code · instantly generated'),
  _CompareRow('Logo & Branding', '100+ unique logos · one click away'),
  _CompareRow('Content Writing', 'SEO-optimized copy · ready in seconds'),
  _CompareRow('Interior Visualization', 'Photorealistic renders · any room, any style'),
];

/// "Why Us" — Traditional vs AI-Powered comparison.
class WhyUsSection extends StatelessWidget {
  const WhyUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kSectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FadeInReveal(
            child: SectionBadge('Why Us'),
          ),
          const SizedBox(height: 14),
          const FadeInReveal(
            delay: Duration(milliseconds: 100),
            child: Text('Traditional vs', style: kSectionTitleStyle),
          ),
          FadeInReveal(
            delay: const Duration(milliseconds: 200),
            child: Row(
              children: const [
                GradientText('AI-Powered', style: kSectionTitleStyle),
                Text(' Creation', style: kSectionTitleStyle),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const FadeInReveal(
            delay: Duration(milliseconds: 300),
            child: Text(
              'See exactly how NexgenAI transforms your creative workflow with '
              'speed, precision, and scale.',
              style: kSectionSubtitleStyle,
            ),
          ),
          const SizedBox(height: 20),
          FadeInReveal(
            delay: const Duration(milliseconds: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _WhyStat(value: '100×', label: 'Faster output'),
                _WhyStat(value: '95%', label: 'Cost reduction'),
                _WhyStat(value: '∞', label: 'Scale potential'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FadeInReveal(
            delay: const Duration(milliseconds: 500),
            child: _CompareCard(
              title: 'Traditional Approach',
              subtitle: 'Manual, slow, expensive',
              rows: _traditionalRows,
              positive: false,
            ),
          ),
          const SizedBox(height: 16),
          FadeInReveal(
            delay: const Duration(milliseconds: 600),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: kCtaGradient,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'VS',
                  style: TextStyle(
                    fontFamily: AppTheme.displayFont,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeInReveal(
            delay: const Duration(milliseconds: 700),
            child: _CompareCard(
              title: 'NexgenAI Platform',
              subtitle: 'Instant, scalable, affordable',
              rows: _aiRows,
              positive: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyStat extends StatelessWidget {
  const _WhyStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradientText(
          value,
          style: const TextStyle(
            fontFamily: AppTheme.displayFont,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.light),
        ),
      ],
    );
  }
}

class _CompareCard extends StatelessWidget {
  const _CompareCard({
    required this.title,
    required this.subtitle,
    required this.rows,
    required this.positive,
  });

  final String title;
  final String subtitle;
  final List<_CompareRow> rows;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final accent = positive ? const Color(0xFF28C840) : AppColors.error;

    return SectionCard(
      borderColor: accent.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: positive ? AppColors.neonCyan : AppColors.lightest,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.light, fontSize: 12),
          ),
          const SizedBox(height: 12),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    positive ? '✓' : '✕',
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row.title,
                          style: const TextStyle(
                            color: AppColors.lightest,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          row.detail,
                          style: const TextStyle(
                            color: AppColors.light,
                            fontSize: 11.5,
                          ),
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
