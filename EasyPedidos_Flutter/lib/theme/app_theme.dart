import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color background = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF333333);
  static const Color secondaryText = Color(0xFF666666);
  static const Color border = Color(0xFFEEEEEE);
  static const Color lightBackground = Color(0xFFF9F9F9);
  static const Color lightOrange = Color(0xFFFFF8F5);
  static const Color lightOrangeBorder = Color(0xFFFFE0D6);

  // Status colors as per prompt requirements
  static const Color statusEmPreparo = primaryOrange;
  static const Color statusPronto = Color(0xFF4CAF50);
  static const Color statusFaturado = Color(0xFF2196F3);
  static const Color statusDefault = Color(0xFF666666);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryOrange,
        primary: primaryOrange,
        surface: background,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.openSansTextTheme().copyWith(
        displayLarge: GoogleFonts.openSans(
          color: primaryText,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.openSans(
          color: primaryOrange,
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
        bodyLarge: GoogleFonts.openSans(
          color: primaryText,
        ),
        bodyMedium: GoogleFonts.openSans(
          color: secondaryText,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: primaryText,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: statusPronto,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
