import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/theme/app_colors.dart';
import '../../history/data/history_repository.dart';
import '../data/interior_repository.dart';

const _styles = [
  ('Modern', 'assets/img/ai-interior/modern.png'),
  ('Minimalist', 'assets/img/ai-interior/minimalist.png'),
  ('Bohemian', 'assets/img/ai-interior/bohemian.png'),
  ('Industrial', 'assets/img/ai-interior/industrial.png'),
  ('Rustic', 'assets/img/ai-interior/rustic.png'),
  ('Traditional', 'assets/img/ai-interior/traditional.png'),
];

const _roomTypes = [
  'Living Room',
  'Bedroom',
  'Kitchen',
  'Bathroom',
  'Office',
  'Dining Room',
];

class InteriorDesignScreen extends ConsumerStatefulWidget {
  const InteriorDesignScreen({super.key});

  @override
  ConsumerState<InteriorDesignScreen> createState() =>
      _InteriorDesignScreenState();
}

class _InteriorDesignScreenState extends ConsumerState<InteriorDesignScreen> {
  File? _image;
  int _styleIndex = 0;
  String _roomType = _roomTypes.first;
  bool _loading = false;
  String? _status;
  String? _resultUrl;

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 88,
    );
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _resultUrl = null;
      });
    }
  }

  void _showSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generate() async {
    final image = _image;
    if (image == null) return;
    setState(() {
      _loading = true;
      _resultUrl = null;
      _status = 'Uploading photo...';
    });
    try {
      final repo = ref.read(interiorRepositoryProvider);
      final media = await repo.uploadMedia(image);
      final imageUrl = (media['url'] ?? media['path'] ?? media['file']) as String?;
      if (imageUrl == null) {
        throw StateError('Upload did not return an image URL.');
      }

      setState(() => _status = 'Redesigning your room...');
      final style = _styles[_styleIndex].$1;
      final created = await repo.createPrediction(
        imageUrl: imageUrl,
        style: style,
        roomType: _roomType,
      );
      final finished = created.isDone
          ? created
          : await repo.waitForPrediction(created.id);

      if (finished.isFailed || finished.outputUrl == null) {
        throw StateError('Generation failed. Please try another photo.');
      }

      setState(() => _resultUrl = finished.outputUrl);
      await ref.read(historyEntriesProvider.notifier).record(
            HistoryEntry(
              type: HistoryType.interior,
              title: '$style $_roomType',
              snippet: 'Interior redesign',
              timestamp: DateTime.now(),
            ),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _status = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interior Design')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: _loading ? null : _showSourceSheet,
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.dark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.mid),
              ),
              clipBehavior: Clip.antiAlias,
              child: _image == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined,
                            size: 48, color: AppColors.light),
                        SizedBox(height: 12),
                        Text('Upload a photo of your room',
                            style: TextStyle(color: AppColors.light)),
                      ],
                    )
                  : Image.file(_image!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 20),
          Text('Room type', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final room in _roomTypes)
                ChoiceChip(
                  label: Text(room),
                  selected: _roomType == room,
                  selectedColor: AppColors.primary.withValues(alpha: 0.3),
                  onSelected: (_) => setState(() => _roomType = room),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Style', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _styles.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final selected = _styleIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _styleIndex = index),
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(_styles[index].$2,
                            fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _styles[index].$1,
                        style: TextStyle(
                          fontSize: 12,
                          color: selected ? AppColors.primary : AppColors.light,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _loading || _image == null ? null : _generate,
            icon: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome),
            label: Text(_status ?? 'Redesign Room'),
          ),
          if (_resultUrl != null) ...[
            const SizedBox(height: 24),
            Text('Result', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(_resultUrl!),
            ),
          ],
        ],
      ),
    );
  }
}
