import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import 'section_shared.dart';

/// "About Us" — heading, animated terminal card, metrics and feature bullets.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kSectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FadeInReveal(
            child: SectionHeader(
              badge: 'About Us',
              title: 'The Engine Behind',
              gradientPart: 'Intelligent Creation',
              subtitle:
                  'We build AI infrastructure that converts raw ideas into '
                  'polished, production-ready assets with zero friction.',
            ),
          ),
          const SizedBox(height: 24),
          const FadeInReveal(
            delay: Duration(milliseconds: 200),
            child: _TerminalCard(),
          ),
          const SizedBox(height: 20),
          FadeInReveal(
            delay: const Duration(milliseconds: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _Metric(value: '99ms', label: 'Avg Latency'),
                _Metric(value: '4.2B', label: 'Parameters'),
                _Metric(value: '99.8%', label: 'Uptime'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: const [
              FadeInReveal(
                delay: Duration(milliseconds: 500),
                child: _FeatureBullet('⚡', 'Real-Time AI Inference'),
              ),
              FadeInReveal(
                delay: Duration(milliseconds: 600),
                child: _FeatureBullet('🧠', 'Multi-Modal Foundation Models'),
              ),
              FadeInReveal(
                delay: Duration(milliseconds: 700),
                child: _FeatureBullet('🔐', 'Enterprise-Grade Security'),
              ),
              FadeInReveal(
                delay: Duration(milliseconds: 800),
                child: _FeatureBullet('🌐', 'Global Edge Delivery'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TerminalCard extends StatelessWidget {
  const _TerminalCard();

  @override
  Widget build(BuildContext context) {
    const mono = TextStyle(
      fontFamily: AppTheme.displayFont,
      fontSize: 12.5,
      height: 1.7,
      color: AppColors.lightest,
    );

    TextSpan prompt(String cmd, String args) => TextSpan(children: [
          const TextSpan(
            text: r'$ ',
            style: TextStyle(color: AppColors.neonCyan),
          ),
          TextSpan(text: cmd),
          TextSpan(
            text: args,
            style: const TextStyle(color: Color(0xFFC084FC)),
          ),
        ]);

    TextSpan output(String text, String metric, Color color) =>
        TextSpan(children: [
          TextSpan(
            text: text,
            style: const TextStyle(color: AppColors.light),
          ),
          TextSpan(
            text: metric,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ]);

    return SectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Window title bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.darkest.withValues(alpha: 0.6),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                _dot(const Color(0xFFFF5F57)),
                const SizedBox(width: 6),
                _dot(const Color(0xFFFEBC2E)),
                const SizedBox(width: 6),
                _dot(const Color(0xFF28C840)),
                const SizedBox(width: 12),
                const Text(
                  'nexgenai_core.sys',
                  style: TextStyle(
                    fontFamily: AppTheme.displayFont,
                    fontSize: 12,
                    color: AppColors.light,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(prompt('init ', '--model gpt-vision-xl'), style: mono),
                Text.rich(
                  output('✓ Model loaded  ', '4.2B params', AppColors.neonCyan),
                  style: mono,
                ),
                Text.rich(
                  prompt('generate ', '--type image --res 4K'),
                  style: mono,
                ),
                Text.rich(
                  output('✓ Rendering... ', '99ms', const Color(0xFFC084FC)),
                  style: mono,
                ),
                Text.rich(
                  prompt('export ', '--format webp --optimize'),
                  style: mono,
                ),
                Text.rich(
                  output('✓ Output ready  ', '2.3 MB', const Color(0xFFEC4899)),
                  style: mono,
                ),
                const _BlinkingCursor(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _dot(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          r'$ ',
          style: TextStyle(
            fontFamily: AppTheme.displayFont,
            fontSize: 12.5,
            color: AppColors.neonCyan,
          ),
        ),
        FadeTransition(
          opacity: _controller,
          child: const Text(
            '_',
            style: TextStyle(
              fontFamily: AppTheme.displayFont,
              fontSize: 12.5,
              color: AppColors.lightest,
            ),
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});

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
            fontSize: 22,
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

class _FeatureBullet extends StatelessWidget {
  const _FeatureBullet(this.emoji, this.title);

  final String emoji;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SectionCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.lightest,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
