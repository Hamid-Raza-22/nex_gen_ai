import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import 'section_shared.dart';

class _Step {
  const _Step(this.number, this.title, this.description);

  final String number;
  final String title;
  final String description;
}

const _steps = [
  _Step(
    '01',
    'Describe Your Vision',
    'Type a simple prompt or choose from our guided templates. No technical '
        'skills required, just your idea.',
  ),
  _Step(
    '02',
    'AI Generates Instantly',
    'Our advanced AI models process your input and generate high-quality '
        'images, videos, shorts, or code in seconds.',
  ),
  _Step(
    '03',
    'Download & Deploy',
    'Preview, refine, and export your creations in full resolution, ready '
        'for commercial use immediately.',
  ),
];

/// "Process" — How It Works, three steps.
class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kSectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FadeInReveal(
            child: SectionHeader(
              badge: 'Process',
              title: 'How It Works',
              subtitle: 'From prompt to production in three simple steps.',
            ),
          ),
          const SizedBox(height: 24),
          for (int i = 0; i < _steps.length; i++)
            FadeInReveal(
              delay: Duration(milliseconds: 150 * (i + 1)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SectionCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        _steps[i].number,
                        style: const TextStyle(
                          fontFamily: AppTheme.displayFont,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _steps[i].title,
                              style: const TextStyle(
                                color: AppColors.lightest,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _steps[i].description,
                              style: const TextStyle(
                                color: AppColors.light,
                                fontSize: 13,
                                height: 1.55,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
