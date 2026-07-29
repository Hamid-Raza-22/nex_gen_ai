import 'package:flutter/material.dart';

/// Brand palette extracted from brainvoai.com (NexgenAI) design tokens.
abstract final class AppColors {
  // Base "AI lab" scale
  static const darkest = Color(0xFF0D1B2A);
  static const dark = Color(0xFF1B263B);
  static const mid = Color(0xFF415A77);
  static const light = Color(0xFF778DA9);
  static const lightest = Color(0xFFE0E1DD);

  // Brand
  static const primary = Color(0xFFE72D63);
  static const secondary = Color(0xFF434343);

  // Neon accents
  static const neonCyan = Color(0xFF00F3FF);
  static const neonPurple = Color(0xFFBC13FE);
  static const neonPink = Color(0xFFFF007F);
  static const neonBlue = Color(0xFF0044FF);

  // Semantic
  static const error = Color(0xFFE0554F);
  static const success = Color(0xFF3DDC97);

  static const glow = Color(0x59415A77); // rgba(65,90,119,.35)
}
