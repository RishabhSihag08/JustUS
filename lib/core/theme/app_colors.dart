import 'package:flutter/material.dart';

/// App Colors - Glassmorphism-compatible palette for JustUS
/// Deep purples, translucent whites, error reds, blue ticks

class AppColors {
  // Slack Brand Tokens from DESIGN.md
  static const Color aubergine = Color(0xFF611F69);        // #611f69 - Primary CTA / Brand Accent
  static const Color deepPlum = Color(0xFF481A54);         // #481a54 - Dark header / Hero background
  static const Color plumShadow = Color(0xFF3D0157);       // #3d0157
  static const Color purpleHaze = Color(0xFFF9F0FF);       // #f9f0ff - Lilac wash / Sent message
  static const Color lavenderMist = Color(0xFFEAC8FE);     // #eac8fe - Subtle border / pill
  static const Color channelBlue = Color(0xFF1264A3);      // #1264a3 - Slack channel blue
  static const Color carbon = Color(0xFF1D1C1D);           // #1d1c1d - Slack primary text
  static const Color charcoal = Color(0xFF454245);         // #454245 - Secondary text
  static const Color midGray = Color(0xFF696969);          // #696969 - Timestamps / muted
  static const Color fog = Color(0xFFEDEAED);              // #edeaed - Hairline borders / dividers
  static const Color softWhite = Color(0xFFFEFBFF);        // #fefbff - Light canvas
  static const Color pureWhite = Color(0xFFFFFFFF);        // #ffffff - Surfaces / cards

  // Primary brand colors (Slack Aubergine)
  static const Color primary = aubergine;                  // #611F69
  static const Color primaryLight = Color(0xFF7A2784);
  static const Color primaryDark = deepPlum;               // #481A54
  static const Color primaryContainer = purpleHaze;        // #F9F0FF

  // Secondary colors
  static const Color secondary = channelBlue;              // #1264A3
  static const Color secondaryLight = Color(0xFF2F8AB7);
  static const Color secondaryDark = Color(0xFF0B4C8C);

  // Accent colors
  static const Color accent = Color(0xFF730394);           // Iris
  static const Color accentLight = lavenderMist;
  static const Color accentDark = plumShadow;

  // Cyan/Teal
  static const Color cyan = Color(0xFF06B6D4);
  static const Color cyanLight = Color(0xFF22D3EE);
  static const Color cyanDark = Color(0xFF0891B2);

  // Semantic colors
  static const Color success = Color(0xFF2BAC76);          // Slack Green (online status)
  static const Color warning = Color(0xFFE8912D);          // Slack Amber
  static const Color error = Color(0xFFE01E5A);            // Slack Red
  static const Color info = channelBlue;

  // Delivery status colors
  static const Color statusPending = midGray;
  static const Color statusSent = midGray;
  static const Color statusDelivered = midGray;
  static const Color statusRead = channelBlue;

  // Glass surface colors (kept for backwards compatibility)
  static const Color glassWhite = Color(0xFFFFFFFF);
  static const Color glassWhite10 = Color(0x1AFFFFFF);
  static const Color glassWhite20 = Color(0x33FFFFFF);
  static const Color glassWhite30 = Color(0x4DFFFFFF);
  static const Color glassWhite50 = Color(0x80FFFFFF);

  // Dark glass surface colors
  static const Color glassBlack = Color(0xFF000000);
  static const Color glassBlack10 = Color(0x1A000000);
  static const Color glassBlack20 = Color(0x33000000);
  static const Color glassBlack30 = Color(0x4D000000);
  static const Color glassBlack50 = Color(0x80000000);

  // Background colors
  static const Color backgroundLight = softWhite;          // #FEFBFF
  static const Color surfaceLight = pureWhite;             // #FFFFFF
  static const Color backgroundDark = Color(0xFF1A1D21);   // Slack Dark Canvas
  static const Color surfaceDark = Color(0xFF222529);      // Slack Dark Card

  // Text colors
  static const Color textPrimaryLight = carbon;            // #1D1C1D
  static const Color textSecondaryLight = charcoal;        // #454245
  static const Color textPrimaryDark = Color(0xFFF8F8F8);
  static const Color textSecondaryDark = Color(0xFFABABAD);

  // Border colors
  static const Color borderLight = fog;                    // #EDEAED
  static const Color borderDark = Color(0xFF35373B);       // Slack Dark Border

  // Shadow colors
  static const Color shadowLight = Color(0x14000000);
  static const Color shadowDark = Color(0x40000000);

  // Avatar placeholder colors
  static const List<Color> avatarColors = [
    Color(0xFF4F46E5), // Indigo
    Color(0xFF8B5CF6), // Violet
    Color(0xFFEC4899), // Pink
    Color(0xFF06B6D4), // Cyan
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF6366F1), // Indigo 500
  ];

  // Get color scheme for light theme
  static ColorScheme get lightColorScheme => ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primaryContainer,
        onPrimaryContainer: primaryDark,
        secondary: secondary,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFF3E8FF),
        onSecondaryContainer: secondaryDark,
        tertiary: accent,
        onTertiary: Colors.white,
        tertiaryContainer: Color(0xFFFCE7F3),
        onTertiaryContainer: accentDark,
        error: error,
        onError: Colors.white,
        errorContainer: Color(0xFFFEF2F2),
        onErrorContainer: Color(0xFF991B1B),
        surface: surfaceLight,
        onSurface: textPrimaryLight,
        surfaceContainerHighest: Color(0xFFF3F4F6),
        onSurfaceVariant: textSecondaryLight,
        outline: borderLight,
        outlineVariant: Color(0x331E212D),
        shadow: shadowLight,
        scrim: Color(0x5914161E),
        inverseSurface: surfaceDark,
        onInverseSurface: textPrimaryDark,
        inversePrimary: primaryLight,
      );

  // Get color scheme for dark theme
  static ColorScheme get darkColorScheme => ColorScheme(
        brightness: Brightness.dark,
        primary: primaryLight,
        onPrimary: Colors.black,
        primaryContainer: primaryDark,
        onPrimaryContainer: primaryContainer,
        secondary: secondaryLight,
        onSecondary: Colors.black,
        secondaryContainer: secondaryDark,
        onSecondaryContainer: Color(0xFFF3E8FF),
        tertiary: accentLight,
        onTertiary: Colors.black,
        tertiaryContainer: accentDark,
        onTertiaryContainer: Color(0xFFFCE7F3),
        error: Color(0xFFF87171),
        onError: Colors.black,
        errorContainer: Color(0xFF991B1B),
        onErrorContainer: Color(0xFFFEF2F2),
        surface: surfaceDark,
        onSurface: textPrimaryDark,
        surfaceContainerHighest: Color(0xFF1F1F23),
        onSurfaceVariant: textSecondaryDark,
        outline: borderDark,
        outlineVariant: Color(0x14FFFFFF),
        shadow: shadowDark,
        scrim: Color(0x8C000000),
        inverseSurface: surfaceLight,
        onInverseSurface: textPrimaryLight,
        inversePrimary: primary,
      );

  // Get avatar color for user ID
  static Color getAvatarColor(int userId) {
    return avatarColors[userId % avatarColors.length];
  }
}