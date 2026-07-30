import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';

/// Tailwind gradient used across the site: cyan-400 → purple-400 → pink-500
const kAccentGradient = LinearGradient(
  colors: [Color(0xFF22D3EE), Color(0xFFC084FC), Color(0xFFEC4899)],
);

/// Primary CTA gradient: cyan-500 → purple-500
const kCtaGradient = LinearGradient(
  colors: [Color(0xFF06B6D4), Color(0xFFA855F7)],
);

const kSectionPadding = EdgeInsets.fromLTRB(24, 48, 24, 8);

class SectionBadge extends StatelessWidget {
  const SectionBadge(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.dark.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.4)),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          letterSpacing: 2,
          color: AppColors.neonCyan,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    this.gradient = kAccentGradient,
    this.style,
  });

  final String text;
  final Gradient gradient;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

const kSectionTitleStyle = TextStyle(
  fontFamily: AppTheme.displayFont,
  fontSize: 28,
  height: 1.2,
  color: AppColors.lightest,
  fontWeight: FontWeight.w700,
);

const kSectionSubtitleStyle = TextStyle(
  fontSize: 14,
  height: 1.6,
  color: AppColors.light,
);

/// Standard section header: badge + title (with optional gradient line) + text.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.badge,
    required this.title,
    this.gradientPart,
    this.subtitle,
  });

  final String badge;
  final String title;
  final String? gradientPart;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionBadge(badge),
        const SizedBox(height: 14),
        Text(title, style: kSectionTitleStyle),
        if (gradientPart != null)
          GradientText(gradientPart!, style: kSectionTitleStyle),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Text(subtitle!, style: kSectionSubtitleStyle),
        ],
      ],
    );
  }
}

/// Rounded dark card used by most sections.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.dark.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? AppColors.mid.withValues(alpha: 0.4),
        ),
      ),
      child: child,
    );
  }
}
