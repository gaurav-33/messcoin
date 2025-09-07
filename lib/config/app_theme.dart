import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.bgColor,
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.light(
        primary: AppColors.dark,
        secondary: AppColors.primaryColor,
        surface: AppColors.bgColor,
        onSurface: AppColors.dark,
        background: AppColors.bgColor,
        onBackground: AppColors.dark,
        error: AppColors.error,
        shadow: AppColors.darkShadowColor,
        onPrimary: AppColors.lightShadowColor,
        tertiary: AppColors.black,
        onTertiary: AppColors.lightDark
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightDark,
        size: 24,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColors.primaryColor.withOpacity(0.3),
        cursorColor: AppColors.primaryColor,
        selectionHandleColor: AppColors.primaryColor,
      ),
      dividerTheme: DividerThemeData(color: AppColors.darkShadowColor),

      
      datePickerTheme: DatePickerThemeData(
        headerBackgroundColor: AppColors.primaryColor,
        headerForegroundColor: Colors.white,
        backgroundColor: AppColors.bgColor,
        // Style for selected date
        dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryColor;
          }
          return null; // Use default
        }),
        dayForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white; // Text color for selected day
          }
          return AppColors.dark; // Text color for other days
        }),
        // Style for selected year in the year picker view
        yearBackgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryColor;
          }
          return null; // Use default
        }),
        yearForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return AppColors.dark;
        }),
        // General text styles
        dayStyle: const TextStyle(color: AppColors.dark),
        weekdayStyle: const TextStyle(color: AppColors.dark),
        headerHelpStyle: const TextStyle(color: Colors.white),
        headerHeadlineStyle: const TextStyle(color: Colors.white),
      ),


      textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.lightDark,
            shadows: [
              Shadow(
                color: AppColors.lightShadowColor,
                blurRadius: 10,
                offset: Offset(-2, -2),
              ),
              Shadow(
                color: AppColors.darkShadowColor,
                blurRadius: 10,
                offset: Offset(1, 1),
              ),
            ],
          ),
          headlineMedium: TextStyle(
            // color: AppColors.dark,
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: AppColors.lightDark,
            shadows: [
              Shadow(
                color: AppColors.lightShadowColor,
                blurRadius: 10,
                offset: Offset(-2, -2),
              ),
              Shadow(
                color: AppColors.darkShadowColor,
                blurRadius: 10,
                offset: Offset(1, 1),
              ),
            ],
          ),
          headlineSmall: TextStyle(
            // color: AppColors.dark,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: AppColors.lightDark,
          ),
          titleLarge: TextStyle(
            // color: AppColors.dark,
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
          ),
          titleMedium: TextStyle(
            // color: AppColors.dark,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
          ),
          bodyMedium: TextStyle(
            color: AppColors.dark,
            fontSize: 16,
          ),
          bodySmall: TextStyle(color: AppColors.dark, fontSize: 12)),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.darkBgColor,
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neutralLight,
        secondary: AppColors.darkPrimaryColor,
        surface: AppColors.darkBgColor,
        onSurface: AppColors.neutralLight,
        background: AppColors.darkBgColor,
        onBackground: AppColors.neutralLight,
        error: AppColors.error,
        shadow: AppColors.darkDarkShadowColor,
        onPrimary: AppColors.darkLightShadowColor,
        tertiary: AppColors.neutralLight,
        onTertiary: AppColors.neutralDark
      ),
      iconTheme: const IconThemeData(
        color: AppColors.neutralLight,
        size: 24,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColors.darkPrimaryColor.withOpacity(0.3),
        cursorColor: AppColors.darkPrimaryColor,
        selectionHandleColor: AppColors.darkPrimaryColor,
      ),
      dividerTheme: DividerThemeData(color: AppColors.darkDarkShadowColor),
      datePickerTheme: DatePickerThemeData(
        headerBackgroundColor: AppColors.darkPrimaryColor,
        headerForegroundColor: Colors.white,
        backgroundColor: AppColors.darkBgColor,
        dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.darkPrimaryColor;
          }
          return null;
        }),
        dayForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return AppColors.neutralLight;
        }),
        yearBackgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.darkPrimaryColor;
          }
          return null;
        }),
        yearForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return AppColors.neutralLight;
        }),
        dayStyle: const TextStyle(color: AppColors.neutralLight),
        weekdayStyle: const TextStyle(color: AppColors.neutralLight),
        headerHelpStyle: const TextStyle(color: Colors.white),
        headerHeadlineStyle: const TextStyle(color: Colors.white),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: AppColors.neutralLight,
          shadows: [
            Shadow(
              color: AppColors.darkLightShadowColor,
              blurRadius: 15,
              offset: Offset(-5, -5),
            ),
            Shadow(
              color: AppColors.darkDarkShadowColor,
              blurRadius: 15,
              offset: Offset(3, 3),
            ),
          ],
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: AppColors.neutralLight,
          shadows: [
            Shadow(
              color: AppColors.darkLightShadowColor,
              blurRadius: 15,
              offset: Offset(-3, -3),
            ),
            Shadow(
              color: AppColors.darkDarkShadowColor,
              blurRadius: 15,
              offset: Offset(3, 3),
            ),
          ],
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: AppColors.neutralLight,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: AppColors.darkPrimaryColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.darkPrimaryColor,
        ),
        bodyMedium: TextStyle(
          color: AppColors.neutralLight,
          fontSize: 16,
        ),
        bodySmall: TextStyle(
          color: AppColors.neutralLight,
          fontSize: 12,
        ),
      ),
    );
  }
}