import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Tema Elegan & Minimalis: Hitam/Abu-abu Gelap (Zinc) & Aksentuasi Emas (Gold)
  static const Color primaryColor = Color(0xFF18181B); // Zinc 900 (Hitam Elegan)
  static const Color secondaryColor = Color(0xFFD4AF37); // Metallic Gold
  
  static const Color backgroundColor = Color(0xFFFAFAFA); // Neutral 50
  static const Color surfaceColor = Colors.white;
  
  // Semantic Colors
  static const Color errorColor = Color(0xFFDC2626); // Red 600
  static const Color successColor = Color(0xFF16A34A); // Green 600
  static const Color warningColor = Color(0xFFF59E0B); // Amber 500
  static const Color infoColor = Color(0xFF2563EB); // Blue 600
  
  // Text Colors
  static const Color textPrimary = Color(0xFF18181B); // Zinc 900
  static const Color textSecondary = Color(0xFF71717A); // Zinc 500

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();
    
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      textTheme: baseTextTheme.copyWith(
        titleLarge: baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: textPrimary),
        titleMedium: baseTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: textPrimary),
        titleSmall: baseTextTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: textPrimary),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: textPrimary),
        bodySmall: baseTextTheme.bodySmall?.copyWith(color: textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE4E4E7), width: 1), // Zinc 200
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD4D4D8)), // Zinc 300
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD4D4D8)), // Zinc 300
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: GoogleFonts.inter(color: textSecondary),
        hintStyle: GoogleFonts.inter(color: const Color(0xFFA1A1AA)), // Zinc 400
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE4E4E7), // Zinc 200
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF09090B), // Zinc 950
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: primaryColor,
        primary: const Color(0xFFFAFAFA), // Putih untuk elemen interaktif di dark mode
        secondary: secondaryColor,
        surface: const Color(0xFF18181B), // Zinc 900
        error: errorColor,
      ),
      textTheme: baseTextTheme,
      cardTheme: CardThemeData(
        color: const Color(0xFF18181B), // Zinc 900
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF27272A), width: 1), // Zinc 800
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: const Color(0xFF18181B),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF09090B),
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
