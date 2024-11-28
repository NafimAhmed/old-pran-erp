import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/core/theme/color_scheme.dart';
import 'package:pran_rfl_erp/core/theme/primary_colors.dart';
import 'package:pran_rfl_erp/core/theme/text_theme.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    textTheme: textTheme,
    primaryColor: appTheme.white,
    scaffoldBackgroundColor: Colors.blueGrey[50],
    brightness: Brightness.light,
    colorScheme: ColorSchemes.colorSchemeLight,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        shadowColor: appTheme.primary.withOpacity(0.5),
        backgroundColor: appTheme.primary,
        disabledBackgroundColor: Colors.grey,
        textStyle: textTheme.bodyMedium!.copyWith(
          color: appTheme.white,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: textTheme.bodyMedium!.copyWith(color: Colors.grey),

      // contentPadding: const EdgeInsets.symmetric(
      //   horizontal: 10,
      //   vertical: 10,
      // ),
      labelStyle: textTheme.bodyMedium!.copyWith(color: appTheme.primary),
      floatingLabelStyle: textTheme.bodyMedium!.copyWith(color: Colors.black),

      // When input field is not focused and not showing errors
      border: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: appTheme.primary, // Default border color
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      // When input field is focused
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: appTheme.primary, // Highlight color when focused
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      // When input field is enabled but not focused
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: appTheme.primary.withOpacity(
              0.7), // Slightly lighter when enabled but not focused
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      // When input field has an error
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.red, // Border color when there's an error
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      // When the input field is focused and has an error
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.red, // Same as error color but for focused state
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      // When input field is disabled
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.grey, // Border color when the field is disabled
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
  static final ThemeData darkTheme = ThemeData(
    textTheme: textTheme,
    primaryColor: appTheme.white,
    scaffoldBackgroundColor: appTheme.white,
    brightness: Brightness.light,
    colorScheme: ColorSchemes.colorSchemeLight,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        shadowColor: appTheme.primary.withOpacity(0.5),
        backgroundColor: appTheme.primary,
        disabledBackgroundColor: Colors.grey,
        textStyle: textTheme.bodyMedium!.copyWith(
          color: appTheme.white,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: textTheme.bodyMedium!.copyWith(color: Colors.grey),

      // contentPadding: const EdgeInsets.symmetric(
      //   horizontal: 10,
      //   vertical: 10,
      // ),
      labelStyle: textTheme.bodyMedium!.copyWith(color: appTheme.primary),
      floatingLabelStyle: textTheme.bodyMedium!.copyWith(color: Colors.black),

      // When input field is not focused and not showing errors
      border: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: appTheme.primary, // Default border color
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      // When input field is focused
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: appTheme.primary, // Highlight color when focused
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      // When input field is enabled but not focused
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: appTheme.primary.withOpacity(
              0.7), // Slightly lighter when enabled but not focused
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      // When input field has an error
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.red, // Border color when there's an error
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      // When the input field is focused and has an error
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.red, // Same as error color but for focused state
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      // When input field is disabled
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.grey, // Border color when the field is disabled
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

PrimaryColors get appTheme => PrimaryColors();
TextTheme get textTheme => TextThemes.textTheme();
