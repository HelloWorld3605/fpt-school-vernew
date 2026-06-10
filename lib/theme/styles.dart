import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppStyles {
  AppStyles._();

  // Spacing Tokens
  static const double baseSpacing = 4.0;
  static const double stackSm = 8.0;
  static const double stackMd = 16.0;
  static const double stackLg = 24.0;
  static const double containerPadding = 20.0;
  static const double gutter = 16.0;

  // BorderRadius Tokens
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(4.0));
  static const BorderRadius radiusDefault = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(12.0));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(24.0));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(9999.0));

  // Typography Styles
  static TextStyle get display => GoogleFonts.plusJakartaSans(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 38 / 30,
        letterSpacing: -0.02 * 30,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineLg => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineMd => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyLg => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyMd => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.onSurface,
      );

  static TextStyle get labelLg => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        color: AppColors.onSurface,
      );

  static TextStyle get labelSm => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: AppColors.onSurface,
      );

  // Common UI styling helpers
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: radiusMd,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get orangeGradientDecoration => BoxDecoration(
        borderRadius: radiusMd,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryContainer, // #ff6b00
            AppColors.primary,          // #a04100
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33FF6B00), // rgba(255, 107, 0, 0.2)
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration get primaryGradientDecoration => BoxDecoration(
        borderRadius: radiusLg,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6B00), // #ff6b00
            Color(0xFFFF8C33), // #ff8c33
          ],
        ),
      );

  static double getAppBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top + kToolbarHeight;
  }
}
