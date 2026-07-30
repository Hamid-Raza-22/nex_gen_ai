import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import 'section_shared.dart';

/// "Start Today" — final call-to-action banner.
class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kSectionPadding,
      child: FadeInReveal(
        child: SectionCard(
          borderColor: AppColors.neonCyan.withValues(alpha: 0.4),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionBadge('Start Today'),
              const SizedBox(height: 14),
              const Text('Ready to Build', style: kSectionTitleStyle),
              const GradientText('with AI?', style: kSectionTitleStyle),
              const SizedBox(height: 10),
              const Text(
                'Join thousands of creators who are already generating images, '
                'videos, shorts, and code with NexgenAI.',
                style: kSectionSubtitleStyle,
              ),
              const SizedBox(height: 20),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: kCtaGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      'Create Free Account',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  side: BorderSide(
                    color: AppColors.light.withValues(alpha: 0.5),
                  ),
                ),
                child: const Text(
                  'See All Features',
                  style: TextStyle(color: AppColors.lightest),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlogPost {
  const _BlogPost(this.title, this.excerpt);

  final String title;
  final String excerpt;
}

/// Fallback posts defined in the site bundle.
const _posts = [
  _BlogPost(
    'The Future of AI Content Generation',
    'Discover how AI is revolutionizing content creation for creators, '
        'marketers, and businesses.',
  ),
  _BlogPost(
    'How to Use AI for Interior Design',
    'Transform your space with AI-powered visualization tools that make '
        'design effortless.',
  ),
  _BlogPost(
    'Building SaaS with Angular & Tailwind',
    'Learn the best practices for structuring modern web apps with '
        'cutting-edge tech stacks.',
  ),
];

/// "Blog" — Latest Posts.
class BlogSection extends StatelessWidget {
  const BlogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kSectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FadeInReveal(
            child: SectionHeader(
              badge: 'Blog',
              title: 'Explore Our Latest',
              gradientPart: 'Insights & AI Innovations',
            ),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < _posts.length; i++)
            FadeInReveal(
              delay: Duration(milliseconds: 150 * (i + 1)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SectionCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: Image.asset(
                          'assets/img/blog-banner.png',
                          width: double.infinity,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _posts[i].title,
                              style: const TextStyle(
                                color: AppColors.lightest,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _posts[i].excerpt,
                              style: const TextStyle(
                                color: AppColors.light,
                                fontSize: 12.5,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Text(
                                  'READ MORE',
                                  style: TextStyle(
                                    color: AppColors.neonCyan,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.neonCyan,
                                  size: 13,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Center(
            child: FadeInReveal(
              delay: const Duration(milliseconds: 600),
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppColors.light.withValues(alpha: 0.5),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                ),
                child: const Text(
                  'View All Posts',
                  style: TextStyle(color: AppColors.lightest),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Contact Us" — Get A Quote form.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kSectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FadeInReveal(
            child: SectionHeader(
              badge: 'Contact Us',
              title: 'Get A Quote To Try It',
              gradientPart: 'For Free',
            ),
          ),
          const SizedBox(height: 20),
          FadeInReveal(
            delay: const Duration(milliseconds: 200),
            child: SectionCard(
              child: Column(
                children: [
                  const _ContactField(hint: 'Name'),
                  const _ContactField(hint: 'Email'),
                  const _ContactField(hint: 'Subject'),
                  const _ContactField(hint: 'Phone'),
                  const _ContactField(hint: 'Message', lines: 4),
                  const SizedBox(height: 6),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: kCtaGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: const Text(
                          'Send Message',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
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

class _ContactField extends StatelessWidget {
  const _ContactField({required this.hint, this.lines = 1});

  final String hint;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        minLines: lines,
        maxLines: lines,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }
}

/// Footer — logo and copyright.
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/img/logo.png', width: 28, height: 28),
              const SizedBox(width: 8),
              const Text(
                'NexgenAI',
                style: TextStyle(
                  fontFamily: AppTheme.displayFont,
                  fontSize: 18,
                  color: AppColors.lightest,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '© ${DateTime.now().year} NexgenAI. All rights reserved.',
            style: const TextStyle(color: AppColors.light, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}
