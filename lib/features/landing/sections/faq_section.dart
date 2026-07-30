import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import 'section_shared.dart';

class _Faq {
  const _Faq(this.question, this.answer);

  final String question;
  final String answer;
}

const _faqs = [
  _Faq(
    'What is NexgenAI and how does it work?',
    'NexgenAI is an AI-powered platform that helps users generate content, '
        'videos, logos, interior designs, courses, and more. Simply choose a '
        'tool, customize your inputs, and let AI generate results instantly.',
  ),
  _Faq(
    'Do I need technical skills to use NexgenAI?',
    'No! NexgenAI is designed to be user-friendly and intuitive. Anyone can '
        'use it, regardless of technical expertise—just input your preferences '
        'and let AI do the work.',
  ),
  _Faq(
    'Is the AI-generated content unique?',
    'Yes! Our AI tools generate unique, high-quality outputs based on your '
        'input, ensuring original and customized results.',
  ),
  _Faq(
    'Can I use AI-generated logos, content for commercial purposes?',
    'Absolutely! All generated assets can be used for personal and commercial '
        'projects without any restrictions.',
  ),
];

/// "FAQs" — expandable question list.
class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kSectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FadeInReveal(
            child: SectionHeader(
              badge: 'FAQs',
              title: 'Your Questions,',
              gradientPart: 'Answered',
            ),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < _faqs.length; i++)
            FadeInReveal(
              delay: Duration(milliseconds: 100 * (i + 1)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.dark.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.mid.withValues(alpha: 0.4),
                      ),
                    ),
                    child: ExpansionTile(
                      shape: const RoundedRectangleBorder(),
                      iconColor: AppColors.neonCyan,
                      collapsedIconColor: AppColors.light,
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      childrenPadding:
                          const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      title: Text(
                        _faqs[i].question,
                        style: const TextStyle(
                          color: AppColors.lightest,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _faqs[i].answer,
                            style: const TextStyle(
                              color: AppColors.light,
                              fontSize: 12.5,
                              height: 1.55,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
