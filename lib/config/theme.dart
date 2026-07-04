import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color onSurface = Color(0xFF1A1C1A);
const Color surface = Color(0xFFFAF9F6);
const Color onSurfaceVariant = Color(0xFF434843);
const Color secondary = Color(0xFF4C6455);
const Color onSecondary = Color(0xFFFFFFFF);
const Color secondaryContainer = Color(0xFFCBE6D4);
const Color primary = Color(0xFF1A281E);
const Color inversePrimary = Color(0xFFBACBBC);
const Color outline = Color(0xFF737873);
const Color outlineVariant = Color(0xFFC3C8C1);
const Color surfaceTint = Color(0xFF526256);
const Color onPrimary = Color(0xFFFFFFFF);
const Color error = Color(0xFFBA1A1A);

ThemeData buildTheme() {
  final textTheme = TextTheme(
    displayLarge: GoogleFonts.ebGaramond(
      fontSize: 40,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.02,
      height: 48 / 40,
      color: primary,
    ),
    headlineLarge: GoogleFonts.ebGaramond(
      fontSize: 32,
      fontWeight: FontWeight.w500,
      height: 40 / 32,
    ),
    titleMedium: GoogleFonts.ebGaramond(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 28 / 20,
      color: onSurface,
    ),
    bodyLarge: GoogleFonts.hankenGrotesk(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 28 / 18,
    ),
    bodyMedium: GoogleFonts.hankenGrotesk(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
    ),
    labelSmall: GoogleFonts.hankenGrotesk(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 16 / 12,
    ),
    labelMedium: GoogleFonts.hankenGrotesk(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.05,
      height: 20 / 14,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: Color(0xFFFFFFFF),
      surface: surface,
      onSurface: onSurface,
      secondaryContainer: secondaryContainer,
      primaryContainer: Color(0xFF2F3E33),
      tertiary: Color(0xFF252522),
      onTertiary: Color(0xFFFFFFFF),
      outline: outline,
      outlineVariant: outlineVariant,
      surfaceTint: surfaceTint,
      inversePrimary: inversePrimary,
      inverseSurface: Color(0xFF2F312F),
      onInverseSurface: Color(0xFFF2F1EE),
    ),
    scaffoldBackgroundColor: surface,
    textTheme: textTheme,
    fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.hankenGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: primary,
          );
        }
        return GoogleFonts.hankenGrotesk(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: onSurfaceVariant,
        );
      }),
    ),
  );
}
