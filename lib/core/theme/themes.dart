import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_activity_tracker/core/colors.dart';

String interFontFamily = "Inter";

abstract class AppTheme {
  static AppTheme of(BuildContext context) {
    return LightModeTheme();
  }

  TextStyle get title => typography.title;
  TextStyle get subtitle => typography.subtitle;
  TextStyle get bodyText => typography.bodyText;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends AppTheme {}

abstract class Typography {
  TextStyle get title;
  TextStyle get subtitle;
  TextStyle get bodyText;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final AppTheme theme;

  @override
  TextStyle get title => GoogleFonts.getFont(
        interFontFamily,
        color: AppColors.blackColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );

  @override
  TextStyle get subtitle => GoogleFonts.getFont(
        interFontFamily,
        color: const Color(0xFFA7A7A7),
        fontWeight: FontWeight.w600,
        fontSize: 18,
      );

  @override
  TextStyle get bodyText => GoogleFonts.getFont(
        interFontFamily,
        color: AppColors.blackColor,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily = interFontFamily,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}
