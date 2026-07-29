import 'package:flutter/material.dart';

class ContentTemplate {
  const ContentTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.inputLabel,
    required this.inputHint,
    required this.promptBuilder,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String inputLabel;
  final String inputHint;
  final String Function(String input, String tone) promptBuilder;
}

const contentTones = ['Professional', 'Casual', 'Friendly', 'Persuasive', 'Witty'];

final contentTemplates = [
  ContentTemplate(
    id: 'blog-post',
    title: 'Blog Post',
    description: 'Full blog article with headings and SEO-friendly structure',
    icon: Icons.article_outlined,
    inputLabel: 'Blog topic',
    inputHint: 'e.g. 10 ways AI is changing interior design',
    promptBuilder: (input, tone) =>
        'Write a complete, well-structured blog post about: "$input". '
        'Tone: $tone. Include a title, introduction, subheadings, and conclusion. '
        'Use markdown formatting.',
  ),
  ContentTemplate(
    id: 'email',
    title: 'Email',
    description: 'Professional emails and replies',
    icon: Icons.mail_outline,
    inputLabel: 'What is the email about?',
    inputHint: 'e.g. Follow up with a client about an overdue invoice',
    promptBuilder: (input, tone) =>
        'Write an email for the following situation: "$input". Tone: $tone. '
        'Include a subject line.',
  ),
  ContentTemplate(
    id: 'youtube-script',
    title: 'YouTube Script',
    description: 'Video scripts with hooks and CTAs',
    icon: Icons.play_circle_outline,
    inputLabel: 'Video topic',
    inputHint: 'e.g. Reviewing the top 5 budget smartphones of the year',
    promptBuilder: (input, tone) =>
        'Write a YouTube video script about: "$input". Tone: $tone. Structure: '
        'hook (first 15 seconds), intro, main sections, outro with call to action.',
  ),
  ContentTemplate(
    id: 'social-post',
    title: 'Social Media Post',
    description: 'Posts for Instagram, X, LinkedIn with hashtags',
    icon: Icons.tag,
    inputLabel: 'Post topic',
    inputHint: 'e.g. Announcing our new AI-powered mobile app',
    promptBuilder: (input, tone) =>
        'Write 3 social media post variations (Instagram, X/Twitter, LinkedIn) '
        'about: "$input". Tone: $tone. Include relevant hashtags.',
  ),
  ContentTemplate(
    id: 'product-description',
    title: 'Product Description',
    description: 'Compelling e-commerce product copy',
    icon: Icons.shopping_bag_outlined,
    inputLabel: 'Product details',
    inputHint: 'e.g. Wireless earbuds with 30h battery and noise cancelling',
    promptBuilder: (input, tone) =>
        'Write a persuasive product description for: "$input". Tone: $tone. '
        'Include a headline, key benefits as bullets, and a closing line.',
  ),
  ContentTemplate(
    id: 'grammar-fix',
    title: 'Grammar Fixer',
    description: 'Fix grammar and improve any text',
    icon: Icons.spellcheck,
    inputLabel: 'Text to fix',
    inputHint: 'Paste the text you want corrected...',
    promptBuilder: (input, tone) =>
        'Fix all grammar, spelling and punctuation errors in the following text. '
        'Keep the original meaning and a $tone tone. Return the corrected text '
        'first, then list the key corrections:\n\n$input',
  ),
];
