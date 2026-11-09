import 'dart:ui';
import 'package:flutter/material.dart';

/// Liquid Glass Theme - Flutter implementation of the Liquid Glass design system
/// Based on the CSS implementation from the Liquid Glass skill
///
/// This provides:
/// 1. Glass surface decorations (tint, rim, border)
/// 2. Ambient backdrop mesh (violet/pink/cyan radial gradients)
/// 3. Multiple tiers: chip, panel, menu, modal
/// 4. Support for both light and dark themes

/// Glass tier enum - matches the Liquid Glass specification
enum GlassTier {
  /// CSS-only tier for small repeated elements (chips, pills, badges)
  chip,

  /// Full effect tier for cards, panels, topbars, FABs
  panel,

  /// Heavy blur + surface wash for dropdowns, popovers, context menus
  menu,

  /// Panel + opaque frost layer for dialogs
  modal,
}

/// Glass configuration for customizing the effect
class GlassConfig {
  final GlassTier tier;
  final double borderRadius;
  final bool isHovered;
  final Color? customTint;
  final Color? customBorder;
  final List<BoxShadow>? customShadows;

  const GlassConfig({
    this.tier = GlassTier.panel,
    this.borderRadius = 12.0,
    this.isHovered = false,
    this.customTint,
    this.customBorder,
    this.customShadows,
  });

  GlassConfig copyWith({
    GlassTier? tier,
    double? borderRadius,
    bool? isHovered,
    Color? customTint,
    Color? customBorder,
    List<BoxShadow>? customShadows,
  }) {
    return GlassConfig(
      tier: tier ?? this.tier,
      borderRadius: borderRadius ?? this.borderRadius,
      isHovered: isHovered ?? this.isHovered,
      customTint: customTint ?? this.customTint,
      customBorder: customBorder ?? this.customBorder,
      customShadows: customShadows ?? this.customShadows,
    );
  }
}

/// Light theme tokens - matching the CSS light theme
class _LightGlassTokens {
  // Tint: white → 70% gray, near-transparent (6% alpha)
  static const Color tintTop = Color(0x0F_FFFFFF);      // rgba(255, 255, 255, 0.06)
  static const Color tintBottom = Color(0x0F_B3B3B3);    // rgba(179, 179, 179, 0.06)
  static const Color tintTopHover = Color(0x1C_FFFFFF);  // rgba(255, 255, 255, 0.11)
  static const Color tintBottomHover = Color(0x1C_B3B3B3); // rgba(179, 179, 179, 0.11)

  // Rim: three inset highlights
  static const Color rimTop = Color(0x8C_FFFFFF);        // rgba(255, 255, 255, 0.55)
  static const Color rimHairline = Color(0x1F_FFFFFF);   // rgba(255, 255, 255, 0.12)
  static const Color rimBottom = Color(0x0F_FFFFFF);     // rgba(255, 255, 255, 0.06)

  static const Color border = Color(0x1F_1E212D);        // rgba(30, 33, 45, 0.12)
  static const List<BoxShadow> shadow = [
    BoxShadow(
      color: Color(0x1A_1E212D),  // rgba(30, 33, 45, 0.1)
      offset: Offset(0, 10),
      blurRadius: 30,
    ),
  ];

  // Menu tier
  static const Color menuSurface = Color(0xFFF6F7F9);
  static const List<BoxShadow> menuShadow = [
    BoxShadow(
      color: Color(0x24_14161E),  // rgba(20, 22, 30, 0.14)
      offset: Offset(0, 12),
      blurRadius: 32,
    ),
    BoxShadow(
      color: Color(0x12_14161E),  // rgba(20, 22, 30, 0.07)
      offset: Offset(0, 4),
      blurRadius: 10,
    ),
  ];

  // Modal tier
  static const Color modalTint = Color(0x70_FFFFFF);       // rgba(255, 255, 255, 0.44)
  static const Color scrim = Color(0x59_14161E);           // rgba(20, 22, 30, 0.35)

  // Page + ambient mesh
  static const Color pageBg = Color(0xFFE8EAEF);
  static const Color pageFg = Color(0xFF2B2F3A);
  static const Color meshViolet = Color(0x33_8B5CF6);      // rgba(139, 92, 246, 0.2)
  static const Color meshPink = Color(0x29_EC4899);        // rgba(236, 72, 153, 0.16)
  static const Color meshCyan = Color(0x24_06B6D4);        // rgba(6, 182, 212, 0.14)
  static const Color meshCornerTop = Color(0x0D_4F46E5);   // rgba(79, 70, 229, 0.05)
  static const Color meshCornerBottom = Color(0x0F_4338CA); // rgba(67, 56, 202, 0.06)
}

/// Dark theme tokens - matching the CSS dark theme
class _DarkGlassTokens {
  // Tint: same colorless glass
  static const Color tintTop = Color(0x0F_FFFFFF);      // rgba(255, 255, 255, 0.06)
  static const Color tintBottom = Color(0x0F_B3B3B3);    // rgba(179, 179, 179, 0.06)
  static const Color tintTopHover = Color(0x1C_FFFFFF);  // rgba(255, 255, 255, 0.11)
  static const Color tintBottomHover = Color(0x1C_B3B3B3); // rgba(179, 179, 179, 0.11)

  // Rim: brighter in dark
  static const Color rimTop = Color(0x80_FFFFFF);        // rgba(255, 255, 255, 0.5)
  static const Color rimHairline = Color(0x1A_FFFFFF);   // rgba(255, 255, 255, 0.1)
  static const Color rimBottom = Color(0x0F_FFFFFF);     // rgba(255, 255, 255, 0.06)

  static const Color border = Color(0x14_FFFFFF);        // rgba(255, 255, 255, 0.08)
  static const List<BoxShadow> shadow = [
    BoxShadow(
      color: Color(0x59_000000),  // rgba(0, 0, 0, 0.35)
      offset: Offset(0, 18),
      blurRadius: 40,
    ),
  ];

  // Menu tier
  static const Color menuSurface = Color(0xFF16161B);
  static const List<BoxShadow> menuShadow = [
    BoxShadow(
      color: Color(0x8C_000000),  // rgba(0, 0, 0, 0.55)
      offset: Offset(0, 16),
      blurRadius: 40,
    ),
    BoxShadow(
      color: Color(0x59_000000),  // rgba(0, 0, 0, 0.35)
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
  ];

  // Modal tier
  static const Color modalTint = Color(0x4D_000000);       // rgba(0, 0, 0, 0.3)
  static const Color scrim = Color(0x8C_000000);           // rgba(0, 0, 0, 0.55)

  // Page + ambient mesh (stronger glows)
  static const Color pageBg = Color(0xFF0A0A0C);
  static const Color pageFg = Color(0xFFEDEDF0);
  static const Color meshViolet = Color(0x42_8B5CF6);      // rgba(139, 92, 246, 0.26)
  static const Color meshPink = Color(0x33_EC4899);        // rgba(236, 72, 153, 0.2)
  static const Color meshCyan = Color(0x2E_06B6D4);        // rgba(6, 182, 212, 0.18)
  static const Color meshCornerTop = Color(0x24_6366F1);   // rgba(99, 102, 241, 0.14)
  static const Color meshCornerBottom = Color(0x4D_4F46E5); // rgba(79, 70, 229, 0.3)
}

/// Token provider based on theme brightness
class GlassTokens {
  final Brightness brightness;

  const GlassTokens._(this.brightness);

  factory GlassTokens.forBrightness(Brightness brightness) {
    return GlassTokens._(brightness);
  }

  // Get tokens for current theme based on brightness
  bool get _isLight => brightness == Brightness.light;

  // Tint
  Color get tintTop => _isLight ? _LightGlassTokens.tintTop : _DarkGlassTokens.tintTop;
  Color get tintBottom => _isLight ? _LightGlassTokens.tintBottom : _DarkGlassTokens.tintBottom;
  Color get tintTopHover => _isLight ? _LightGlassTokens.tintTopHover : _DarkGlassTokens.tintTopHover;
  Color get tintBottomHover => _isLight ? _LightGlassTokens.tintBottomHover : _DarkGlassTokens.tintBottomHover;

  // Rim
  Color get rimTop => _isLight ? _LightGlassTokens.rimTop : _DarkGlassTokens.rimTop;
  Color get rimHairline => _isLight ? _LightGlassTokens.rimHairline : _DarkGlassTokens.rimHairline;
  Color get rimBottom => _isLight ? _LightGlassTokens.rimBottom : _DarkGlassTokens.rimBottom;

  Color get border => _isLight ? _LightGlassTokens.border : _DarkGlassTokens.border;
  List<BoxShadow> get shadow => _isLight ? _LightGlassTokens.shadow : _DarkGlassTokens.shadow;

  // Menu
  Color get menuSurface => _isLight ? _LightGlassTokens.menuSurface : _DarkGlassTokens.menuSurface;
  List<BoxShadow> get menuShadow => _isLight ? _LightGlassTokens.menuShadow : _DarkGlassTokens.menuShadow;

  // Modal
  Color get modalTint => _isLight ? _LightGlassTokens.modalTint : _DarkGlassTokens.modalTint;
  Color get scrim => _isLight ? _LightGlassTokens.scrim : _DarkGlassTokens.scrim;

  // Page/Mesh
  Color get pageBg => _isLight ? _LightGlassTokens.pageBg : _DarkGlassTokens.pageBg;
  Color get pageFg => _isLight ? _LightGlassTokens.pageFg : _DarkGlassTokens.pageFg;
  Color get meshViolet => _isLight ? _LightGlassTokens.meshViolet : _DarkGlassTokens.meshViolet;
  Color get meshPink => _isLight ? _LightGlassTokens.meshPink : _DarkGlassTokens.meshPink;
  Color get meshCyan => _isLight ? _LightGlassTokens.meshCyan : _DarkGlassTokens.meshCyan;
  Color get meshCornerTop => _isLight ? _LightGlassTokens.meshCornerTop : _DarkGlassTokens.meshCornerTop;
  Color get meshCornerBottom => _isLight ? _LightGlassTokens.meshCornerBottom : _DarkGlassTokens.meshCornerBottom;
}

/// Main GlassDecoration class - creates the BoxDecoration for glass surfaces
class GlassDecoration {
  final GlassTokens tokens;
  final GlassConfig config;

  const GlassDecoration(this.tokens, this.config);

  /// Build the BoxDecoration for the glass surface
  BoxDecoration build() {
    final isHovered = config.isHovered;
    final tier = config.tier;
    final radius = config.borderRadius;
    final customTint = config.customTint;
    final customBorder = config.customBorder;
    final customShadows = config.customShadows;

    // Base gradient for tint
    final Gradient baseGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isHovered
          ? [tokens.tintTopHover, tokens.tintBottomHover]
          : [tokens.tintTop, tokens.tintBottom],
    );

    // Box shadows with rim highlights
    final List<BoxShadow> shadows = customShadows ?? [
      ...tokens.shadow,
      BoxShadow(
        color: tokens.rimTop,
        offset: const Offset(0, -1),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: tokens.rimHairline,
        offset: Offset.zero,
        blurRadius: 0,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: tokens.rimBottom,
        offset: const Offset(0, 1),
        blurRadius: 0,
        spreadRadius: 1,
      ),
    ];

    // Handle different tiers
    switch (tier) {
      case GlassTier.chip:
        return BoxDecoration(
          border: Border.all(
            color: customBorder ?? tokens.border,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(radius),
          gradient: customTint != null
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [customTint.withValues(alpha: 0.06), customTint.withValues(alpha: 0.06)],
                )
              : baseGradient,
          boxShadow: [
            BoxShadow(
              color: tokens.rimTop,
              offset: const Offset(0, -1),
              blurRadius: 0,
              spreadRadius: 1,
            ),
          ],
        );

      case GlassTier.panel:
        return BoxDecoration(
          border: Border.all(
            color: customBorder ?? tokens.border,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(radius),
          gradient: customTint != null
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isHovered
                      ? [customTint.withValues(alpha: 0.11), customTint.withValues(alpha: 0.11)]
                      : [customTint.withValues(alpha: 0.06), customTint.withValues(alpha: 0.06)],
                )
              : baseGradient,
          boxShadow: shadows,
        );

      case GlassTier.menu:
        // Menu: heavy blur with surface wash (55% opacity)
        final Color menuColor = Color.lerp(
          tokens.menuSurface,
          Colors.transparent,
          0.45,
        )!;
        return BoxDecoration(
          border: Border.all(
            color: customBorder ?? tokens.border,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(radius),
          color: customTint ?? menuColor,
          boxShadow: [
            ...tokens.menuShadow,
            BoxShadow(
              color: tokens.rimTop,
              offset: const Offset(0, -1),
              blurRadius: 0,
              spreadRadius: 1,
            ),
          ],
        );

      case GlassTier.modal:
        // Modal: opaque frost layer over tint
        return BoxDecoration(
          border: Border.all(
            color: customBorder ?? tokens.border,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              tokens.modalTint,
              tokens.modalTint,
              tokens.tintTop,
              tokens.tintBottom,
            ],
            stops: const [0.0, 0.3, 0.3, 1.0],
          ),
          boxShadow: shadows,
        );
    }
  }
}

/// Widget that applies a clean, minimalist card container (Slack inspired)
class LiquidGlass extends StatelessWidget {
  final Widget child;
  final GlassConfig config;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  const LiquidGlass({
    super.key,
    required this.child,
    this.config = const GlassConfig(),
    this.padding,
    this.margin,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color surfaceColor = backgroundColor ??
        (isDark ? const Color(0xFF222529) : const Color(0xFFFFFFFF));
    final Color borderColor = config.customBorder ??
        (isDark ? const Color(0xFF35373B) : const Color(0xFFEDEAED));

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(config.borderRadius),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: config.tier == GlassTier.chip || config.tier == GlassTier.panel
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
      ),
      child: child,
    );
  }
}

/// Minimalist backdrop widget (Slack inspired canvas)
class LiquidGlassBackdrop extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const LiquidGlassBackdrop({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color pageBg = backgroundColor ??
        (isDark ? const Color(0xFF1A1D21) : const Color(0xFFFEFBFF));

    return Container(
      color: pageBg,
      child: child,
    );
  }
}


/// Scrim widget for modals
class LiquidGlassScrim extends StatelessWidget {
  final Widget child;
  final Color? scrimColor;

  const LiquidGlassScrim({
    super.key,
    required this.child,
    this.scrimColor,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final tokens = GlassTokens.forBrightness(brightness);

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Scrim with blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: scrimColor ?? tokens.scrim,
              ),
            ),
          ),
          // Centered dialog
          Center(
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Pre-built glass widgets for common use cases
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isHovered;
  final GlassTier tier;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.isHovered = false,
    this.tier = GlassTier.panel,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      config: GlassConfig(
        tier: tier,
        isHovered: isHovered,
        borderRadius: tier == GlassTier.chip ? 9999 : 12.0,
      ),
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(tier == GlassTier.chip ? 9999 : 12.0),
              child: child,
            )
          : child,
    );
  }
}

class GlassChip extends StatelessWidget {
  final Widget label;
  final Widget? avatar;
  final VoidCallback? onTap;
  final bool isSelected;
  final Color? customTint;

  const GlassChip({
    super.key,
    required this.label,
    this.avatar,
    this.onTap,
    this.isSelected = false,
    this.customTint,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final tokens = GlassTokens.forBrightness(brightness);

    return LiquidGlass(
      config: GlassConfig(
        tier: GlassTier.chip,
        borderRadius: 9999,
        customTint: customTint ?? (isSelected ? tokens.rimTop : null),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(9999),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (avatar != null) ...[avatar!, const SizedBox(width: 6)],
                  label,
                ],
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (avatar != null) ...[avatar!, const SizedBox(width: 6)],
                label,
              ],
            ),
    );
  }
}

class GlassFAB extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double size;

  const GlassFAB({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final Color fabColor = backgroundColor ?? Theme.of(context).colorScheme.primary;

    return LiquidGlass(
      config: GlassConfig(
        tier: GlassTier.panel,
        borderRadius: size / 2,
        customTint: fabColor,
        customBorder: fabColor.withValues(alpha: 0.5),
      ),
      backgroundColor: fabColor,
      padding: EdgeInsets.zero,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(size / 2),
          child: SizedBox(
            width: size,
            height: size,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class GlassMenu extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const GlassMenu({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      config: const GlassConfig(
        tier: GlassTier.menu,
        borderRadius: 12.0,
      ),
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: child,
    );
  }
}

class GlassModal extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;

  const GlassModal({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlassScrim(
      child: LiquidGlass(
        config: const GlassConfig(
          tier: GlassTier.modal,
          borderRadius: 20.0,
        ),
        padding: padding ?? const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? 400,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Extension for easy glass widget creation
extension GlassWidgetExtension on Widget {
  /// Wrap widget in a glass panel
  Widget glass({
    GlassTier tier = GlassTier.panel,
    double borderRadius = 12.0,
    bool isHovered = false,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return LiquidGlass(
      config: GlassConfig(
        tier: tier,
        borderRadius: borderRadius,
        isHovered: isHovered,
      ),
      padding: padding,
      margin: margin,
      child: this,
    );
  }

  /// Wrap widget in a glass chip
  Widget glassChip({
    bool isSelected = false,
    Color? customTint,
    EdgeInsetsGeometry? padding,
  }) {
    return LiquidGlass(
      config: GlassConfig(
        tier: GlassTier.chip,
        borderRadius: 9999,
        customTint: customTint ?? (isSelected ? const Color(0x8C_FFFFFF) : null),
      ),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: this,
    );
  }
}