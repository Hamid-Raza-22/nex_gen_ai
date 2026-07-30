import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import 'sections/about_section.dart';
import 'sections/capabilities_section.dart';
import 'sections/closing_sections.dart';
import 'sections/faq_section.dart';
import 'sections/platform_section.dart';
import 'sections/pricing_section.dart';
import 'sections/process_section.dart';
import 'sections/section_shared.dart';
import 'sections/testimonials_section.dart';
import 'sections/use_cases_section.dart';
import 'sections/why_choose_section.dart';
import 'sections/why_us_section.dart';

/// Landing screen — a faithful mobile recreation of the brainvoai.com
/// (NexgenAI) hero section. All copy, colors and layout were extracted from
/// the production web bundle.
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  
  final GlobalKey _capabilitiesKey = GlobalKey();
  final GlobalKey _processKey = GlobalKey();
  final GlobalKey _pricingKey = GlobalKey();
  final GlobalKey _blogKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToSection(String item) {
    GlobalKey? key;
    switch (item) {
      case 'Capabilities':
        key = _capabilitiesKey;
        break;
      case 'How It Works':
        key = _processKey;
        break;
      case 'Pricing':
        key = _pricingKey;
        break;
      case 'Blog':
        key = _blogKey;
        break;
      case 'FAQs':
        key = _faqKey;
        break;
      case 'Contact Us':
        key = _contactKey;
        break;
    }

    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkest,
      endDrawer: _NavDrawer(onNavItemTap: _scrollToSection),
      body: Stack(
        children: [
          _AnimatedOrbs(scrollController: _scrollController),
          SafeArea(
            child: Column(
              children: [
                const _TopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(height: 24),
                              FadeInReveal(
                                horizontalOffset: 0.1,
                                child: _HeroBadge(),
                              ),
                              SizedBox(height: 20),
                              FadeInReveal(
                                delay: Duration(milliseconds: 200),
                                child: _HeroHeadline(),
                              ),
                              SizedBox(height: 16),
                              FadeInReveal(
                                delay: Duration(milliseconds: 400),
                                child: _HeroDescription(),
                              ),
                              SizedBox(height: 28),
                              FadeInReveal(
                                delay: Duration(milliseconds: 600),
                                child: _CtaButtons(),
                              ),
                              SizedBox(height: 32),
                              FadeInReveal(
                                delay: Duration(milliseconds: 800),
                                child: _StatsRow(),
                              ),
                              SizedBox(height: 40),
                              FadeInReveal(
                                delay: Duration(milliseconds: 1000),
                                child: _HeroVisual(),
                              ),
                            ],
                          ),
                        ),
                        // Page sections (same order as the website)
                        const AboutSection(),
                        CapabilitiesSection(key: _capabilitiesKey),
                        ProcessSection(key: _processKey),
                        const PlatformSection(),
                        const WhyUsSection(),
                        const WhyChooseSection(),
                        const UseCasesSection(),
                        const TestimonialsSection(),
                        FaqSection(key: _faqKey),
                        PricingSection(key: _pricingKey),
                        const CtaSection(),
                        BlogSection(key: _blogKey),
                        ContactSection(key: _contactKey),
                        const FooterSection(),
                      ],
                    ),
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

// ─── Top bar ────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Image.asset('assets/img/logo.png', width: 34, height: 34),
          const SizedBox(width: 10),
          const Text(
            'NexgenAI',
            style: TextStyle(
              fontFamily: AppTheme.displayFont,
              fontSize: 22,
              color: AppColors.lightest,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: AppColors.dark.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.mid.withValues(alpha: 0.5),
              ),
            ),
            child: IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(Icons.menu, color: AppColors.lightest),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Navigation drawer (mobile menu) ────────────────────────────────────────

/// Menu entries extracted from the website's landing page sections.
const _navItems = [
  'Capabilities',
  'How It Works',
  'Pricing',
  'Blog',
  'FAQs',
  'Contact Us',
];

class _NavDrawer extends StatelessWidget {
  const _NavDrawer({required this.onNavItemTap});

  final void Function(String) onNavItemTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.dark,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Image.asset('assets/img/logo.png', width: 30, height: 30),
                  const SizedBox(width: 10),
                  const Text(
                    'NexgenAI',
                    style: TextStyle(
                      fontFamily: AppTheme.displayFont,
                      fontSize: 20,
                      color: AppColors.lightest,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.light),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            for (final item in _navItems)
              ListTile(
                title: Text(
                  item,
                  style: const TextStyle(
                    color: AppColors.lightest,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.mid,
                  size: 20,
                ),
                onTap: () {
                  Navigator.pop(context);
                  onNavItemTap(item);
                },
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    onPressed: () => context.go('/auth/login'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: BorderSide(
                        color: AppColors.light.withValues(alpha: 0.6),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: AppColors.lightest),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: kCtaGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: FilledButton(
                      onPressed: () => context.go('/auth/register'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text(
                        'Get Started Free',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hero badge ─────────────────────────────────────────────────────────────

class _HeroBadge extends StatefulWidget {
  const _HeroBadge();

  @override
  State<_HeroBadge> createState() => _HeroBadgeState();
}

class _HeroBadgeState extends State<_HeroBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.dark.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: Tween(begin: 0.35, end: 1.0).animate(_pulse),
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.neonCyan,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.neonCyan, blurRadius: 8),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Powering the Future with AI',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.lightest,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Headline with rotating gradient word ───────────────────────────────────

/// Rotating words extracted from the site bundle.
const _rotatingWords = ['Images', 'Videos', 'Shorts', 'Code Snippets'];

class _HeroHeadline extends StatefulWidget {
  const _HeroHeadline();

  @override
  State<_HeroHeadline> createState() => _HeroHeadlineState();
}

class _HeroHeadlineState extends State<_HeroHeadline> {
  Timer? _timer;
  int _wordIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 2400), (_) {
      setState(() => _wordIndex = (_wordIndex + 1) % _rotatingWords.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const headlineStyle = TextStyle(
      fontFamily: AppTheme.displayFont,
      fontSize: 38,
      height: 1.15,
      color: AppColors.lightest,
      fontWeight: FontWeight.w700,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Generate Next-Level', style: headlineStyle),
        SizedBox(
          height: 46,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: GradientText(
              _rotatingWords[_wordIndex],
              key: ValueKey(_wordIndex),
              style: headlineStyle,
            ),
          ),
        ),
        const Text('with Intelligence', style: headlineStyle),
      ],
    );
  }
}

// ─── Description ────────────────────────────────────────────────────────────

class _HeroDescription extends StatelessWidget {
  const _HeroDescription();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Transform imagination into reality with cutting-edge AI generation. '
      'Create stunning visuals, viral shorts, intelligent code, and powerful '
      'branding — all from one advanced AI ecosystem.',
      style: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: AppColors.light,
      ),
    );
  }
}

// ─── CTA buttons ────────────────────────────────────────────────────────────

class _CtaButtons extends StatelessWidget {
  const _CtaButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: kCtaGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: FilledButton(
              onPressed: () => context.go('/auth/register'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Get Started Free',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              side: BorderSide(
                color: AppColors.light.withValues(alpha: 0.6),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Explore Features',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: AppColors.lightest,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Statistics row ─────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StatItem(value: '14+', label: 'AI Engines', color: AppColors.neonCyan),
        _StatItem(
          value: '10k+',
          label: 'Generations',
          color: Color(0xFFC084FC),
        ),
        _StatItem(
          value: '99%',
          label: 'User Satisfaction',
          color: Color(0xFFEC4899),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: AppTheme.displayFont,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: color,
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

// ─── Hero visual: bot image, glow, floating feature chips ──────────────────

class _HeroVisual extends StatefulWidget {
  const _HeroVisual();

  @override
  State<_HeroVisual> createState() => _HeroVisualState();
}

class _HeroVisualState extends State<_HeroVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat();

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final imageSize = math.min(width * 0.98, 360.0);

        return SizedBox(
          height: imageSize + 70,
          child: AnimatedBuilder(
            animation: _float,
            builder: (context, _) {
              final t = _float.value * 2 * math.pi;
              double dy(double phase) => math.sin(t + phase) * 6;

              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Glow behind the bot image
                  Container(
                    width: imageSize * 0.9,
                    height: imageSize * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonCyan.withValues(alpha: 0.18),
                          blurRadius: 90,
                          spreadRadius: 30,
                        ),
                        BoxShadow(
                          color: AppColors.neonPurple.withValues(alpha: 0.15),
                          blurRadius: 90,
                          spreadRadius: 20,
                          offset: const Offset(30, 20),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/img/bot.webp',
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8 + dy(0),
                    left: 0,
                    child: const _FeatureChip('✨ Image Generation'),
                  ),
                  Positioned(
                    top: imageSize * 0.28 + dy(1.2),
                    right: 0,
                    child: const _FeatureChip('🎬 Video Generation'),
                  ),
                  Positioned(
                    bottom: imageSize * 0.32 + dy(2.4),
                    left: 4,
                    child: const _FeatureChip('💻 Code Generation'),
                  ),
                  Positioned(
                    bottom: 40 + dy(3.6),
                    right: 8,
                    child: const _FeatureChip('🚀 Shorts Generation'),
                  ),
                  Positioned(
                    bottom: 0 + dy(4.8),
                    left: width * 0.28,
                    child: const _FeatureChip('🎨 Logo Generation'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.dark.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.mid.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11.5,
          color: AppColors.lightest,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ─── Animated background orbs ───────────────────────────────────────────────

class _AnimatedOrbs extends StatefulWidget {
  const _AnimatedOrbs({required this.scrollController});

  final ScrollController scrollController;

  @override
  State<_AnimatedOrbs> createState() => _AnimatedOrbsState();
}

class _AnimatedOrbsState extends State<_AnimatedOrbs>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AnimatedBuilder(
      animation: Listenable.merge([_controller, widget.scrollController]),
      builder: (context, _) {
        final scrollOffset = widget.scrollController.hasClients
            ? widget.scrollController.offset
            : 0.0;
        final pulse = 0.75 + _controller.value * 0.25;

        return Stack(
          children: [
            _orb(
              top: -60 - (scrollOffset * 0.2),
              left: -70,
              diameter: 260 * pulse,
              color: AppColors.neonCyan.withValues(alpha: 0.10),
            ),
            _orb(
              top: (size.height * 0.35) - (scrollOffset * 0.4),
              right: -90,
              diameter: 300 * (1.05 - _controller.value * 0.2),
              color: AppColors.neonPurple.withValues(alpha: 0.10),
            ),
            _orb(
              bottom: -80 + (scrollOffset * 0.1),
              left: size.width * 0.2,
              diameter: 280 * pulse,
              color: AppColors.neonPink.withValues(alpha: 0.08),
            ),
          ],
        );
      },
    );
  }

  Widget _orb({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required double diameter,
    required Color color,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    );
  }
}
