import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import 'section_shared.dart';

class _Plan {
  const _Plan(
    this.name,
    this.amount,
    this.description,
    this.words,
    this.tokens, {
    this.highlighted = false,
  });

  final String name;
  final int amount;
  final String description;
  final String words;
  final String tokens;
  final bool highlighted;
}

/// Fallback packages defined in the site bundle.
const _plans = [
  _Plan('Basic', 15, 'Perfect plan for starters.', '10,000', '50'),
  _Plan(
    'Pro',
    49,
    'Advanced features for pros.',
    '50,000',
    '200',
    highlighted: true,
  ),
  _Plan('Agency', 99, 'Everything you need for an agency.', '250,000', '1,000'),
];

/// "Pricing" — Choose a Package.
class PricingSection extends StatelessWidget {
  const PricingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kSectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FadeInReveal(
            child: SectionHeader(
              badge: 'Pricing',
              title: 'Choose a',
              gradientPart: 'Package',
            ),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < _plans.length; i++)
            FadeInReveal(
              delay: Duration(milliseconds: 150 * (i + 1)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SectionCard(
                  borderColor: _plans[i].highlighted
                      ? AppColors.neonCyan.withValues(alpha: 0.6)
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _plans[i].name,
                              style: const TextStyle(
                                color: AppColors.lightest,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          GradientText(
                            '\$${_plans[i].amount}',
                            style: const TextStyle(
                              fontFamily: AppTheme.displayFont,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 4, top: 8),
                            child: Text(
                              'per month',
                              style: TextStyle(
                                color: AppColors.light,
                                fontSize: 10.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _plans[i].description,
                        style: const TextStyle(
                          color: AppColors.light,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _PlanFeature('${_plans[i].words} words'),
                      _PlanFeature('${_plans[i].tokens} image tokens'),
                      const SizedBox(height: 14),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: _plans[i].highlighted ? kCtaGradient : null,
                          borderRadius: BorderRadius.circular(12),
                          border: _plans[i].highlighted
                              ? null
                              : Border.all(
                                  color: AppColors.light.withValues(alpha: 0.5),
                                ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(46),
                            ),
                            child: Text(
                              'Buy Now',
                              style: TextStyle(
                                color: _plans[i].highlighted
                                    ? Colors.white
                                    : AppColors.lightest,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
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

class _PlanFeature extends StatelessWidget {
  const _PlanFeature(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Text(
            '✓',
            style: TextStyle(
              color: Color(0xFF28C840),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: AppColors.lightest, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
