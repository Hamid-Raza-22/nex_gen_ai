import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import 'section_shared.dart';

class _Reason {
  const _Reason(this.number, this.title, this.description);

  final String number;
  final String title;
  final String description;
}

const _reasons = [
  _Reason(
    '01',
    'AI-Powered Efficiency',
    'Our AI automates complex tasks like content creation, design, and video '
        'editing—so you focus on what truly matters.',
  ),
  _Reason(
    '02',
    'User-Friendly & Intuitive',
    'NexgenAI is designed for everyone, easy to use with just a few clicks.',
  ),
  _Reason(
    '03',
    'High-Quality Outputs',
    'From logos to courses, our AI ensures polished, high-quality results '
        'that fit your brand perfectly.',
  ),
];

/// "Why Choose Us" — Innovative AI Solutions Tailored for Your Success.
class WhyChooseSection extends StatelessWidget {
  const WhyChooseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kSectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            badge: 'Why Choose Us',
            title: 'Innovative AI Solutions',
            gradientPart: 'Tailored for Your Success',
            subtitle:
                'Experience cutting-edge AI tools designed to boost '
                'creativity, efficiency, and productivity.',
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/img/why-us.jpg',
              width: double.infinity,
              height: 190,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          for (final reason in _reasons)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientText(
                    reason.number,
                    style: const TextStyle(
                      fontFamily: AppTheme.displayFont,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reason.title,
                          style: const TextStyle(
                            color: AppColors.lightest,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reason.description,
                          style: const TextStyle(
                            color: AppColors.light,
                            fontSize: 12.5,
                            height: 1.5,
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
