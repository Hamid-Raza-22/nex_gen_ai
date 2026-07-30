import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import 'section_shared.dart';

class _Testimonial {
  const _Testimonial(this.quote, this.name, this.designation, this.image);

  final String quote;
  final String name;
  final String designation;
  final String image;
}

const _testimonials = [
  _Testimonial(
    'NexgenAI has revolutionized content creation process! The AI Content '
        'Generator saves me hours, producing SEO-friendly content effortlessly.',
    'Sarah Mitchell',
    'Digital Marketer',
    'assets/img/female-img.png',
  ),
  _Testimonial(
    'The AI Interior Generator is a game-changer! I can visualize multiple '
        'design styles instantly, making it easier to present ideas to my clients.',
    'James Carter',
    'Interior Designer',
    'assets/img/male-img.jpg',
  ),
  _Testimonial(
    'I love the AI Shorts Generator! It creates high-quality, '
        'attention-grabbing videos in seconds, helping me grow my audience faster.',
    'Lisa Adams',
    'YouTube Creator',
    'assets/img/female-img.png',
  ),
  _Testimonial(
    "The AI Logo Maker helped me create a professional brand identity without "
        "the hassle. It's fast, easy, and delivers outstanding results.",
    'Robert Hayes',
    'Business Owner',
    'assets/img/male-img.jpg',
  ),
];

/// "Testimonials" — swipeable quote cards.
class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  final _controller = PageController(viewportFraction: 0.92);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SectionHeader(
              badge: 'Testimonials',
              title: 'Real Stories,',
              gradientPart: 'Real Impact',
              subtitle:
                  'NexgenAI is transforming the way creators, businesses, and '
                  'professionals work with AI.',
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 210,
            child: PageView.builder(
              controller: _controller,
              itemCount: _testimonials.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, index) {
                final item = _testimonials[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.format_quote,
                          color: AppColors.neonCyan,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            item.quote,
                            style: const TextStyle(
                              color: AppColors.lightest,
                              fontSize: 12.5,
                              height: 1.55,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: AssetImage(item.image),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    color: AppColors.lightest,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.5,
                                  ),
                                ),
                                Text(
                                  item.designation,
                                  style: const TextStyle(
                                    color: AppColors.light,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _testimonials.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _page ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: i == _page ? AppColors.neonCyan : AppColors.mid,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
