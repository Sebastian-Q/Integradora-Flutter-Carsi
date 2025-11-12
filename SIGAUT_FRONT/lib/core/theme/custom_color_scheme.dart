import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  /// BackGround
  Color get primaryBackground => brightness == Brightness.light
      ? const Color(0xFF1A5ED7)
      : const Color(0xFF0D47A1);

  Color get primaryBackground20 => brightness == Brightness.light
      ? const Color(0x201A5ED7)
      : const Color(0xFF0A2E56);

  Color get segundoBackground => brightness == Brightness.light
      ? const Color(0xFFE0E7F5)
      : const Color(0xFF2C3E50);

  Color get quinaryBackground => brightness == Brightness.light
      ? const Color(0xFFF8F8F8)
      : const Color(0xFF1E1E1E);

  Color get cuartoBackground => brightness == Brightness.light
      ? const Color(0xFFFFFFFF)
      : const Color(0xFF2C3E50);


  Color get quintoBackground => brightness == Brightness.light
      ? const Color(0xFFEBF6F2)
      : const Color(0xFFEBF6F2);

  /// Border
  Color get primeroBorder => brightness == Brightness.light
      ? const Color(0xFF079D49)
      : const Color(0xFF079D49);

  Color get segundoBorder => brightness == Brightness.light
      ? const Color(0xFF1A5ED7)
      : const Color(0xFF1A5ED7);

  Color get terceroBorder => brightness == Brightness.light
      ? const Color(0xFFFA0C0C)
      : const Color(0xFFFA0C0C);

  Color get cuartoBorder => brightness == Brightness.light
      ? const Color(0xFFDEDEDE)
      : const Color(0xFFFFFFFF);

  Color get quintoBorder => brightness == Brightness.light
      ? const Color(0xFFCBD4E1)
      : const Color(0xFF4E5D6A);

  /// TEXT
  Color get primeroText => brightness == Brightness.light
      ? const Color(0xFF475569)
      : const Color(0xFFE0E0E0);

  Color get segundoText => brightness == Brightness.light
      ? const Color(0xFFFA4420)
      : const Color(0xFFEF9A9A);

  Color get terceroText => brightness == Brightness.light
      ? const Color(0xFF1C3E7A)
      : const Color(0xFFE0E0E0);

  Color get cuartoText => brightness == Brightness.light
      ? const Color(0xFFFFFFFF)
      : const Color(0xFFFFFFFF);

  Color get quintoText => brightness == Brightness.light
      ? const Color(0xFF1C3E7A)
      : const Color(0xFFE0E0E0);

  Color get sextoText => brightness == Brightness.light
      ? const Color(0xFF94A3B8)
      : const Color(0xFF94A3B8);

  Color get septimoText => brightness == Brightness.light
      ? const Color(0xFF4C535E)
      : const Color(0xFF4C535E);

  Color get octavoText => brightness == Brightness.light
      ? const Color(0xFF1A5ED7)
      : const Color(0xFF1A5ED7);

  Color get novenoText => brightness == Brightness.light
      ? const Color(0xFF079D49)
      : const Color(0xFF079D49);

  Color get decimoText => brightness == Brightness.light
      ? const Color(0xFF1A5ED7)
      : const Color(0xFFBBDEFB);


  /// BUTTON
  Color get primaryInputColor => brightness == Brightness.light
      ? const Color(0xFF1A5ED7)
      : const Color(0xFFBBDEFB);

  Color get secondaryBgButton => brightness == Brightness.light
      ? const Color(0xFFFA4420)
      : const Color(0xFFB71C1C);

  Color get senaryBgButton => brightness == Brightness.light
      ? const Color(0xFF02BE54)
      : const Color(0xFF00A152);

  /// ICONS
  Color get primeroIcon => const Color(0xFFFFFFFF);

  Color get segundoIcon => brightness == Brightness.light
      ? const Color(0xFFFA4420)
      : const Color(0xFFFA4420);

  Color get terceroIcon => brightness == Brightness.light
      ? const Color(0xFF1A5ED7)
      : const Color(0xFFBBDEFB);

  Color get cuartoIcon => brightness == Brightness.light
      ? const Color(0xFF1C3E7A)
      : const Color(0xFF1C3E7A);

  Color get quinaryIcon => brightness == Brightness.light
      ? const Color(0xFF475569)
      : const Color(0xFFE0E0E0);

  Color get sextoIcon => brightness == Brightness.light
      ? const Color(0xFF94A3B8)
      : const Color(0xFF94A3B8);

  Color get septimoIcon => brightness == Brightness.light
      ? const Color(0xFF94A3B8)
      : const Color(0xFF94A3B8);

  Color get octavoIcon => brightness == Brightness.light
      ? const Color(0xFFD19A05)
      : const Color(0xFFFFA000);

  Color get novenoIcon => brightness == Brightness.light
      ? const Color(0xFFFFFFFF)
      : const Color(0xFFFFFFFF);

  ///CARDS
  Color get success => brightness == Brightness.light
      ? const Color(0xFF00BD76)
      : const Color(0xFF2E7D32);

  Color get primaryBtnText => brightness == Brightness.light
      ? const Color(0xFFFFFFFF)
      : const Color(0xFFFFFFFF);

  Color get primaryBgButton => brightness == Brightness.light
      ? const Color(0xFF1A5ED7)
      : const Color(0xFF0D47A1);
}