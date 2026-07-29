import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Temporary stub for feature screens scheduled in later phases.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 56, color: AppColors.mid),
            const SizedBox(height: 16),
            Text(
              '$title is coming soon',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
