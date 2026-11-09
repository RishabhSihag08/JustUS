import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pin_pad_state.dart';
import 'pin_pad_notifier.dart';
import '../../core/theme/glass_theme.dart';
import '../../core/theme/app_colors.dart';

/// PIN Pad Screen - Launch screen with dual-PIN entry fitted cleanly to any screen
class PinPadScreen extends ConsumerStatefulWidget {
  const PinPadScreen({super.key});

  @override
  ConsumerState<PinPadScreen> createState() => _PinPadScreenState();
}

class _PinPadScreenState extends ConsumerState<PinPadScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -10.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -10.0, end: 10.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 10.0, end: -10.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -10.0, end: 10.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 10.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
    ]).animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinPadState = ref.watch(pinPadNotifierProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Trigger shake animation on error
    ref.listen<PinPadState>(pinPadNotifierProvider, (previous, next) {
      if (next is PinPadError && next.isShaking) {
        _shakeController.forward(from: 0);
      }
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: LiquidGlassBackdrop(
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxHeight < 680;

                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: isCompact ? 10 : 16,
                      ),
                      child: AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_shakeAnimation.value, 0),
                            child: child,
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // App Logo/Title
                            _buildHeader(theme, colorScheme, isCompact),

                            // PIN Indicator Dots
                            _buildPinIndicator(pinPadState, theme, colorScheme),

                            // Error Message (only when present)
                            if (pinPadState is PinPadError)
                              _buildErrorMessage(pinPadState, theme, colorScheme),

                            // Lockout Timer (only when present)
                            if (pinPadState is PinPadLocked)
                              _buildLockoutTimer(pinPadState, theme, colorScheme),

                            // Number Pad
                            _buildNumberPad(pinPadState, theme, colorScheme, isCompact),

                            // Hint Text
                            _buildHintText(theme, colorScheme),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme, bool isCompact) {
    final iconSize = isCompact ? 48.0 : 54.0;
    final fontSize = isCompact ? 28.0 : 32.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App Icon - Slack Plum Style
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: AppColors.deepPlum,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '#',
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
        SizedBox(height: isCompact ? 8 : 12),
        Text(
          'JustUS',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Private 1-on-1 Direct Messaging',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.midGray,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPinIndicator(PinPadState state, ThemeData theme, ColorScheme colorScheme) {
    final enteredPin = state.maybeWhen(
      idle: (pin, _) => pin,
      error: (pin, attemptCount, message, isShaking) => pin,
      success: (_) => '****',
      locked: (_) => '****',
      orElse: () => '',
    );

    final isError = state is PinPadError;
    final isSuccess = state is PinPadSuccess;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isFilled = index < enteredPin.length;

        return AnimatedScale(
          scale: isFilled ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 9),
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFilled
                  ? (isError ? AppColors.error : (isSuccess ? AppColors.success : AppColors.aubergine))
                  : Colors.transparent,
              border: Border.all(
                color: isError
                    ? AppColors.error
                    : (isFilled ? AppColors.aubergine : AppColors.fog),
                width: 2,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildErrorMessage(PinPadState state, ThemeData theme, ColorScheme colorScheme) {
    if (state is PinPadError) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              state.message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '(${5 - state.attemptCount} left)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.error.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLockoutTimer(PinPadState state, ThemeData theme, ColorScheme colorScheme) {
    if (state is PinPadLocked) {
      final minutes = state.remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = state.remaining.inSeconds.remainder(60).toString().padLeft(2, '0');

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.warning,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Try again in ',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              '$minutes:$seconds',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildNumberPad(PinPadState state, ThemeData theme, ColorScheme colorScheme, bool isCompact) {
    final isLocked = state is PinPadLocked;
    final keySize = isCompact ? 56.0 : 62.0;
    final rowSpacing = isCompact ? 8.0 : 12.0;
    final hMargin = isCompact ? 6.0 : 8.0;

    return LiquidGlass(
      config: const GlassConfig(
        tier: GlassTier.panel,
        borderRadius: 18,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 14 : 18,
        vertical: isCompact ? 12 : 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rows 1-3: 1-9
          for (int row = 0; row < 3; row++)
            Padding(
              padding: EdgeInsets.only(bottom: rowSpacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int col = 0; col < 3; col++)
                    _buildNumberKey(
                      context,
                      digit: '${row * 3 + col + 1}',
                      isLocked: isLocked,
                      keySize: keySize,
                      hMargin: hMargin,
                      theme: theme,
                      colorScheme: colorScheme,
                    ),
                ],
              ),
            ),

          // Row 4: empty, 0, backspace
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Empty space
              SizedBox(
                width: keySize,
                height: keySize,
                child: const SizedBox.shrink(),
              ),
              SizedBox(width: hMargin * 2),
              // 0 key
              _buildNumberKey(
                context,
                digit: '0',
                isLocked: isLocked,
                keySize: keySize,
                hMargin: 0,
                theme: theme,
                colorScheme: colorScheme,
              ),
              SizedBox(width: hMargin * 2),
              // Backspace key
              _buildBackspaceKey(context, isLocked, keySize, theme, colorScheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberKey(
    BuildContext context, {
    required String digit,
    required bool isLocked,
    required double keySize,
    required double hMargin,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Container(
      width: keySize,
      height: keySize,
      margin: EdgeInsets.symmetric(horizontal: hMargin),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? const Color(0xFF2A2D32) : Colors.white,
        borderRadius: BorderRadius.circular(keySize / 2),
        border: Border.all(
          color: theme.brightness == Brightness.dark ? const Color(0xFF35373B) : AppColors.fog,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLocked
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  ref.read(pinPadNotifierProvider.notifier).addDigit(digit);
                },
          borderRadius: BorderRadius.circular(keySize / 2),
          splashColor: AppColors.aubergine.withValues(alpha: 0.15),
          highlightColor: AppColors.aubergine.withValues(alpha: 0.08),
          child: Center(
            child: Text(
              digit,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isLocked
                    ? AppColors.midGray
                    : (theme.brightness == Brightness.dark ? Colors.white : AppColors.carbon),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey(
    BuildContext context,
    bool isLocked,
    double keySize,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      width: keySize,
      height: keySize,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(keySize / 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLocked
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  ref.read(pinPadNotifierProvider.notifier).removeDigit();
                },
          borderRadius: BorderRadius.circular(keySize / 2),
          splashColor: AppColors.error.withValues(alpha: 0.15),
          highlightColor: AppColors.error.withValues(alpha: 0.08),
          child: Center(
            child: Icon(
              Icons.backspace_outlined,
              size: 22,
              color: isLocked
                  ? AppColors.midGray
                  : (theme.brightness == Brightness.dark ? Colors.white : AppColors.carbon),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHintText(ThemeData theme, ColorScheme colorScheme) {
    return Text(
      'Enter your 4-digit PIN to continue',
      style: theme.textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
      ),
      textAlign: TextAlign.center,
    );
  }
}
