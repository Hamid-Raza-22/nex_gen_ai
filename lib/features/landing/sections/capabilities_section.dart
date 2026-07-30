import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import 'section_shared.dart';

class _Capability {
  const _Capability(this.icon, this.title, this.description);

  final IconData icon;
  final String title;
  final String description;
}

/// Capability cards extracted from the site bundle.
const _capabilities = [
  _Capability(
    Icons.smart_toy_outlined,
    'AI Personal Assistant',
    'Your smart AI companion for productivity, automation, and instant assistance.',
  ),
  _Capability(
    Icons.movie_outlined,
    'AI Shorts Generator',
    'Create engaging, high-quality short videos in seconds with AI-powered editing.',
  ),
  _Capability(
    Icons.school_outlined,
    'AI Course Generator',
    'Effortlessly design and generate structured courses with AI-driven content.',
  ),
  _Capability(
    Icons.brush_outlined,
    'AI Logo Generator',
    'Generate unique, professional logos instantly for your brand or business.',
  ),
  _Capability(
    Icons.chair_outlined,
    'AI Interior Generator',
    'Transform spaces with AI-powered interior design ideas and 3D visualizations.',
  ),
  _Capability(
    Icons.article_outlined,
    'AI Content Generator',
    'Produce high-quality, SEO-optimized content for blogs, ads, and more with AI.',
  ),
  _Capability(
    Icons.mic_outlined,
    'AI Voice Agent',
    'Automate tasks and workflows with smart AI-powered virtual agents.',
  ),
];

/// "Capabilities" — Four Pillars of AI Generation.
class CapabilitiesSection extends StatelessWidget {
  const CapabilitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kSectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            badge: 'Capabilities',
            title: 'Four Pillars of',
            gradientPart: 'AI Generation',
            subtitle:
                'Explore our core AI generation engines, each purpose-built, '
                'production-ready, and endlessly powerful.',
          ),
          const SizedBox(height: 24),
          for (final capability in _capabilities)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SectionCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        gradient: kCtaGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        capability.icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capability.title,
                            style: const TextStyle(
                              color: AppColors.lightest,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            capability.description,
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
            ),
        ],
      ),
    );
  }
}
