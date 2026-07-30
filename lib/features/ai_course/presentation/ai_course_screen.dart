import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/api/ai_client.dart';
import '../../history/data/history_repository.dart';

const _levels = ['Beginner', 'Intermediate', 'Advanced'];

class AiCourseScreen extends ConsumerStatefulWidget {
  const AiCourseScreen({super.key});

  @override
  ConsumerState<AiCourseScreen> createState() => _AiCourseScreenState();
}

class _AiCourseScreenState extends ConsumerState<AiCourseScreen> {
  final _topicController = TextEditingController();
  String _level = _levels.first;
  int _lessons = 6;
  bool _loading = false;
  String? _outline;

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final topic = _topicController.text.trim();
    if (topic.isEmpty) return;
    setState(() {
      _loading = true;
      _outline = null;
    });
    try {
      final result = await ref.read(aiClientProvider).chatCompletion([
        {
          'role': 'system',
          'content': 'You are an expert curriculum designer. Produce clear, '
              'practical course outlines in markdown.'
        },
        {
          'role': 'user',
          'content':
              'Create a $_level-level course on "$topic" with exactly $_lessons '
                  'lessons. For each lesson give a title, 3-5 learning '
                  'objectives, key topics, and a practical exercise. Start with '
                  'a short course overview and prerequisites.'
        },
      ]);
      setState(() => _outline = result);
      await ref.read(historyEntriesProvider.notifier).record(
            HistoryEntry(
              type: HistoryType.course,
              title: 'Course: $topic',
              snippet: '$_level · $_lessons lessons',
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
      appBar: AppBar(title: const Text('AI Course')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _topicController,
            decoration: const InputDecoration(
              labelText: 'Course topic',
              hintText: 'e.g. Flutter app development',
            ),
          ),
          const SizedBox(height: 16),
          Text('Level', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final level in _levels)
                ChoiceChip(
                  label: Text(level),
                  selected: _level == level,
                  selectedColor: AppColors.primary.withValues(alpha: 0.3),
                  onSelected: (_) => setState(() => _level = level),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Lessons: $_lessons',
                  style: Theme.of(context).textTheme.titleSmall),
              Expanded(
                child: Slider(
                  value: _lessons.toDouble(),
                  min: 3,
                  max: 12,
                  divisions: 9,
                  label: '$_lessons',
                  onChanged: (v) => setState(() => _lessons = v.round()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _loading ? null : _generate,
            icon: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.school_outlined),
            label: Text(_loading ? 'Building course...' : 'Generate Course'),
          ),
          if (_outline != null) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Text('Course outline',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _outline!));
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
                  _outline!,
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
