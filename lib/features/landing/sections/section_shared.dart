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

/// Simple reveal animation that triggers when the widget is first built.
class FadeInReveal extends StatefulWidget {
  const FadeInReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 1000),
    this.horizontalOffset = 0.35, // Right to left distance
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double horizontalOffset;

  @override
  State<FadeInReveal> createState() => _FadeInRevealState();
}

class _FadeInRevealState extends State<FadeInReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slide = Tween<Offset>(
      begin: Offset(widget.horizontalOffset, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  void _trigger() {
    if (_hasStarted || !mounted) return;
    setState(() => _hasStarted = true);
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _VisibilityTrigger(
      onVisible: _trigger,
      child: FadeTransition(
        opacity: _opacity,
        child: SlideTransition(position: _slide, child: widget.child),
      ),
    );
  }
}

/// A helper widget that triggers a callback when it becomes visible on screen.
class _VisibilityTrigger extends StatefulWidget {
  const _VisibilityTrigger({required this.child, required this.onVisible});

  final Widget child;
  final VoidCallback onVisible;

  @override
  State<_VisibilityTrigger> createState() => _VisibilityTriggerState();
}

class _VisibilityTriggerState extends State<_VisibilityTrigger> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  void _checkVisibility() {
    if (!mounted || _isVisible) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Trigger when the widget is within the bottom 15% of the screen
    if (position.dy < screenHeight * 0.85) {
      _isVisible = true;
      widget.onVisible();
    } else {
      // Re-check on next frame if not visible yet
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
