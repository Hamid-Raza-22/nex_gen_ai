import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/api/ai_client.dart';
import '../../history/data/history_repository.dart';
import '../data/content_templates.dart';

class ContentFormScreen extends ConsumerStatefulWidget {
  const ContentFormScreen({super.key, required this.templateId});

  final String templateId;

  @override
  ConsumerState<ContentFormScreen> createState() => _ContentFormScreenState();
}

class _ContentFormScreenState extends ConsumerState<ContentFormScreen> {
  final _inputController = TextEditingController();
  String _tone = contentTones.first;
  bool _loading = false;
  String? _result;

  ContentTemplate get _template => contentTemplates.firstWhere(
        (t) => t.id == widget.templateId,
        orElse: () => contentTemplates.first,
      );

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;
    setState(() {
      _loading = true;
      _result = null;
    });
    try {
      final prompt = _template.promptBuilder(input, _tone);
      final result = await ref.read(aiClientProvider).chatCompletion([
        {
          'role': 'system',
          'content': 'You are an expert copywriter. Output only the requested '
              'content in markdown, no preamble.'
        },
        {'role': 'user', 'content': prompt},
      ]);
      setState(() => _result = result);
      await ref.read(historyEntriesProvider.notifier).record(
            HistoryEntry(
              type: HistoryType.content,
              title: _template.title,
              snippet: input,
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
    final template = _template;

    return Scaffold(
      appBar: AppBar(title: Text(template.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(template.inputLabel,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          TextField(
            controller: _inputController,
            minLines: 3,
            maxLines: 8,
            decoration: InputDecoration(hintText: template.inputHint),
          ),
          const SizedBox(height: 16),
          Text('Tone', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final tone in contentTones)
                ChoiceChip(
                  label: Text(tone),
                  selected: _tone == tone,
                  selectedColor: AppColors.primary.withValues(alpha: 0.3),
                  onSelected: (_) => setState(() => _tone = tone),
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
            label: Text(_loading ? 'Generating...' : 'Generate'),
          ),
          if (_result != null) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Text('Result', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _result!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  _result!,
                  style: const TextStyle(height: 1.5),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
