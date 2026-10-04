import 'package:flutter/material.dart';

/// Route E-Commerce design tokens (from Figma).
class AppColors {
  static const Color primary = Color(0xFF004182);
  static const Color ink = Color(0xFF06004F);
  /// Secondary text: ink at 60%.
  static const Color inkMuted = Color(0x9906004F);
  /// Card, field and chip outlines: primary at 30%.
  static const Color outline = Color(0x4D004182);
  /// Strike-through old price: primary at 60%.
  static const Color oldPrice = Color(0x99004182);
  /// Categories rail and subtle fills: primary at 5%.
  static const Color tint = Color(0x0D004182);
  static const Color background = Color(0xFFFFFFFF);
  static const Color hint = Color(0xFF808080);
  static const Color placeholder = Color(0xFFF0F3F7);
  static const Color star = Color(0xFFFDD835);
  static const Color success = Color(0xFF02B935);
  static const Color danger = Color(0xFFCC1010);
  static const Color navBar = primary;

  // Legacy aliases used across the app.
  static const Color fieldBorder = outline;
  static const Color textPrimary = ink;
  static const Color textSecondary = inkMuted;
  static const Color border = outline;
  static const Color error = danger;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}
