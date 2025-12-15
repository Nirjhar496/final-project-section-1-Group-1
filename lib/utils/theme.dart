import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFF6200EE);
const Color primaryVariantColor = Color(0xFF3700B3);
const Color secondaryColor = Color(0xFF03DAC6);
const Color secondaryVariantColor = Color(0xFF018786);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color surfaceColor = Color(0xFFFFFFFF);
const Color errorColor = Color(0xFFB00020);

const ColorScheme colorScheme = ColorScheme(
  primary: primaryColor,
  primaryContainer: primaryVariantColor,
  secondary: secondaryColor,
  secondaryContainer: secondaryVariantColor,
  surface: surfaceColor,
  error: errorColor,
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onSurface: Colors.black,
  onError: Colors.white,
  brightness: Brightness.light,
);

ThemeData buildTheme(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
      displayLarge: GoogleFonts.lato(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.lato(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      displaySmall: GoogleFonts.lato(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      headlineLarge: GoogleFonts.lato(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      headlineMedium: GoogleFonts.lato(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      headlineSmall: GoogleFonts.lato(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
      titleLarge: GoogleFonts.lato(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelLarge: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
      ),
      labelMedium: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.lato(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyLarge: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.lato(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[600],
      elevation: 8.0,
      showUnselectedLabels: true,
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: Colors.black,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        textStyle: GoogleFonts.lato(
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: GoogleFonts.lato(
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryColor),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
    ),
  );
}