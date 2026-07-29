import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_awesome, color: AppColors.primary, size: size),
        const SizedBox(width: 8),
        Text(
          'NexgenAI',
          style: TextStyle(
            fontFamily: AppTheme.displayFont,
            fontSize: size * 0.75,
            color: AppColors.lightest,
          ),
        ),
      ],
    );
  }
}
