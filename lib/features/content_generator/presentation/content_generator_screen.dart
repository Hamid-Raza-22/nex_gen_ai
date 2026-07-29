import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../data/content_templates.dart';

class ContentGeneratorScreen extends StatelessWidget {
  const ContentGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Generator')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: contentTemplates.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final template = contentTemplates[index];
          return Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              leading: CircleAvatar(
                backgroundColor: AppColors.mid.withValues(alpha: 0.3),
                child: Icon(template.icon, color: AppColors.neonCyan),
              ),
              title: Text(template.title),
              subtitle: Text(
                template.description,
                style: const TextStyle(color: AppColors.light, fontSize: 12),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppColors.mid),
              onTap: () =>
                  context.push('/tools/content-generator/${template.id}'),
            ),
          );
        },
      ),
    );
  }
}
