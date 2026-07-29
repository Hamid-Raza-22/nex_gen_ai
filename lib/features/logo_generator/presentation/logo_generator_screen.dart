import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/api/ai_client.dart';
import '../../history/data/history_repository.dart';

const _logoStyles = [
  ('Minimalist', 'clean, minimalist, flat design'),
  ('Modern', 'modern, sleek, gradient accents'),
  ('Vintage', 'vintage, retro, badge style'),
  ('Mascot', 'mascot, character-based, playful'),
  ('Abstract', 'abstract, geometric shapes'),
  ('Luxury', 'luxury, elegant, gold accents'),
];

const _sampleLogos = [
  'assets/img/logo-generator/design_1.png',
  'assets/img/logo-generator/design_2.png',
  'assets/img/logo-generator/design_3.png',
  'assets/img/logo-generator/design_4.png',
  'assets/img/logo-generator/design_5.png',
  'assets/img/logo-generator/design_6.png',
  'assets/img/logo-generator/design_7.png',
  'assets/img/logo-generator/design_8.png',
  'assets/img/logo-generator/design_9.png',
];

class LogoGeneratorScreen extends ConsumerStatefulWidget {
  const LogoGeneratorScreen({super.key});

  @override
  ConsumerState<LogoGeneratorScreen> createState() =>
      _LogoGeneratorScreenState();
}

class _LogoGeneratorScreenState extends ConsumerState<LogoGeneratorScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _styleIndex = 0;
  bool _loading = false;
  Uint8List? _resultBytes;
  String? _resultUrl;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _loading = true;
      _resultBytes = null;
      _resultUrl = null;
    });
    try {
      final style = _logoStyles[_styleIndex];
      final description = _descriptionController.text.trim();
      final prompt =
          'Professional logo design for a brand called "$name". Style: ${style.$2}. '
          '${description.isNotEmpty ? 'Brand description: $description. ' : ''}'
          'Vector-style, centered on a plain background, no text artifacts.';
      final result = await ref.read(aiClientProvider).generateImage(prompt);
      setState(() {
        _resultBytes =
            result.base64Data != null ? base64Decode(result.base64Data!) : null;
        _resultUrl = result.url;
      });
      await ref.read(historyEntriesProvider.notifier).record(
            HistoryEntry(
              type: HistoryType.logo,
              title: 'Logo: $name',
              snippet: style.$1,
              timestamp: DateTime.now(),
            ),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logo Generator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Brand name',
              hintText: 'e.g. NexgenAI',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              hintText: 'What does your brand do?',
            ),
          ),
          const SizedBox(height: 16),
          Text('Style', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _logoStyles.length; i++)
                ChoiceChip(
                  label: Text(_logoStyles[i].$1),
                  selected: _styleIndex == i,
                  selectedColor: AppColors.primary.withValues(alpha: 0.3),
                  onSelected: (_) => setState(() => _styleIndex = i),
                ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _loading ? null : _generate,
            icon: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome),
            label: Text(_loading ? 'Generating...' : 'Generate Logo'),
          ),
          if (_resultBytes != null || _resultUrl != null) ...[
            const SizedBox(height: 24),
            Text('Your logo', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _resultBytes != null
                  ? Image.memory(_resultBytes!)
                  : Image.network(_resultUrl!),
            ),
          ],
          const SizedBox(height: 24),
          Text('Inspiration', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: _sampleLogos.length,
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(_sampleLogos[index], fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
