import 'package:flutter/material.dart';

/// App Colors - Velvet Compass Palette for JustUS
/// Calibrated to user-selected reference palette:
/// #191919 (Obsidian Charcoal), #391C32 (Velvet Plum),
/// #691C54 (Mulberry Wine), #A44D78 (Rose Mauve)

class AppColors {
  // --- Core Stealth Palette Tokens ---
  static const Color obsidianVoid = Color(0xFF121212);     // #121212 - True Dark Void / Canvas
  static const Color obsidianCharcoal = obsidianVoid;      // Backwards-compatible alias
  static const Color toneOfDarkGrey = Color(0xFF1E1E1E);   // #1E1E1E - Neutral Dark Grey for cards & surfaces
  static const Color toneOfBlack = Color(0xFF181818);      // #181818 - Tone of Black for floating input pill
  static const Color dialogDark = Color(0xFF222222);       // #222222 - Solid opaque dark grey for dialogs
  static const Color receivedBubble = Color(0xFF242424);   // #242424 - Sleek dark grey bubble
  static const Color sentBubble = Color(0xFF5E1D49);       // #5E1D49 - Refined mulberry wine sent bubble
  static const Color actionFab = Color(0xFF6E1C53);        // #6E1C53 - Floating circular action button (mic/send)
  static const Color borderSubtle = Color(0xFF2A2A2A);     // #2A2A2A - Subtle neutral dark borders
  static const Color neutralGreyMuted = Color(0xFF8E8E93); // #8E8E93 - Clean neutral gray for headers/labels

  // --- Targeted Wine & Mauve Accent Swatches (Restricted Micro-Usage) ---
  static const Color velvetPlum = Color(0xFF391C32);       // #391C32 - Deep plum swatch
  static const Color mulberryWine = Color(0xFF6E1C53);     // #6E1C53 - Wine accent for buttons & sent bubble
  static const Color roseMauve = Color(0xFFA44D78);        // #A44D78 - Glowing double ticks & sensor pips
  static const Color roseMauveGlow = Color(0x33A44D78);    // 20% Ambient Rose Glow
  static const Color roseMauveSubtle = Color(0x1AA44D78);  // 10% Rose Shimmer
  static const Color titaniumText = Color(0xFFE5E0E3);     // #E5E0E3 - Soft Titanium Numerals / Body text
  static const Color mutedMauve = neutralGreyMuted;        // Clean neutral grey for timestamps / labels

  // Backward-compatible Brand Tokens
  static const Color aubergine = mulberryWine;             // Primary Accent
  static const Color deepPlum = toneOfDarkGrey;            // Dark Card Base
  static const Color plumShadow = Color(0xFF161616);
  static const Color purpleHaze = Color(0xFF2A2A2A);
  static const Color lavenderMist = roseMauve;
  static const Color channelBlue = roseMauve;
  static const Color carbon = obsidianVoid;
  static const Color charcoal = Color(0xFFD1D1D6);         // Clean secondary text
  static const Color midGray = neutralGreyMuted;           // Timestamps / Muted labels
  static const Color fog = Color(0xFF2A2A2A);              // Hairline borders
  static const Color softWhite = obsidianVoid;
  static const Color pureWhite = Color(0xFFFFFFFF);        // High-contrast headings

  // Primary brand colors
  static const Color primary = mulberryWine;
  static const Color primaryLight = roseMauve;
  static const Color primaryDark = Color(0xFF4A103A);
  static const Color primaryContainer = toneOfDarkGrey;

  // Secondary colors
  static const Color secondary = roseMauve;
  static const Color secondaryLight = Color(0xFFBF6492);
  static const Color secondaryDark = Color(0xFF84385E);

  // Accent colors
  static const Color accent = roseMauve;
  static const Color accentLight = Color(0xFFC77C9E);
  static const Color accentDark = mulberryWine;

  // Cyan/Teal (reserved for telemetry/calibration if needed)
  static const Color cyan = Color(0xFF06B6D4);
  static const Color cyanLight = Color(0xFF22D3EE);
  static const Color cyanDark = Color(0xFF0891B2);

  // Semantic colors
  static const Color success = Color(0xFF2BAC76);          // Online status / sensor calibrated
  static const Color warning = Color(0xFFE8912D);          // Amber warning
  static const Color error = Color(0xFFE01E5A);            // Danger / Purge red
  static const Color info = roseMauve;

  // Delivery status colors
  static const Color statusPending = midGray;
  static const Color statusSent = midGray;
  static const Color statusDelivered = midGray;
  static const Color statusRead = roseMauve;               // Rose Mauve glowing read receipt double ticks!

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
  static const Color backgroundLight = obsidianVoid;       // #121212
  static const Color surfaceLight = toneOfDarkGrey;        // #1E1E1E - Dark Grey Cards
  static const Color backgroundDark = obsidianVoid;        // #121212 - True Dark Canvas
  static const Color surfaceDark = toneOfDarkGrey;         // #1E1E1E - Tone of Dark Grey for Cards

  // Text colors
  static const Color textPrimaryLight = titaniumText;
  static const Color textSecondaryLight = charcoal;
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = neutralGreyMuted;

  // Border colors
  static const Color borderLight = borderSubtle;           // #2A2A2A
  static const Color borderDark = borderSubtle;            // #2A2A2A - Subtle neutral border

  // Shadow colors
  static const Color shadowLight = Color(0x14000000);
  static const Color shadowDark = Color(0x40000000);

  // Avatar placeholder colors
  static const List<Color> avatarColors = [
    Color(0xFF691C54), // Mulberry Wine
    Color(0xFFA44D78), // Rose Mauve
    Color(0xFF4F46E5), // Indigo
    Color(0xFF8B5CF6), // Violet
    Color(0xFFEC4899), // Pink
    Color(0xFF06B6D4), // Cyan
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
  ];

  // Get color scheme for light theme (high-contrast stealth dark to prevent night glare)
  static ColorScheme get lightColorScheme => getDarkColorScheme(Brightness.light);

  // Get color scheme for dark theme
  static ColorScheme get darkColorScheme => getDarkColorScheme(Brightness.dark);

  static ColorScheme getDarkColorScheme(Brightness brightness) => ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primaryContainer,
        onPrimaryContainer: Colors.white,
        secondary: secondary,
        onSecondary: Colors.white,
        secondaryContainer: toneOfDarkGrey,
        onSecondaryContainer: textPrimaryDark,
        tertiary: accent,
        onTertiary: Colors.white,
        tertiaryContainer: toneOfDarkGrey,
        onTertiaryContainer: Colors.white,
        error: error,
        onError: Colors.white,
        errorContainer: const Color(0xFF4A1020),
        onErrorContainer: const Color(0xFFFF8FA3),
        surface: surfaceDark,
        onSurface: textPrimaryDark,
        surfaceContainerHighest: const Color(0xFF242424),
        onSurfaceVariant: textSecondaryDark,
        outline: borderDark,
        outlineVariant: Color(0x26A44D78),
        shadow: shadowDark,
        scrim: Color(0x8C000000),
        inverseSurface: surfaceLight,
        onInverseSurface: textPrimaryLight,
        inversePrimary: primaryLight,
      );

  // Get avatar color for user ID
  static Color getAvatarColor(int userId) {
    return avatarColors[userId % avatarColors.length];
  }
}