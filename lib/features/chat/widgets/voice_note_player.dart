import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:just_audio/just_audio.dart';
import '../../../core/theme/app_colors.dart';

/// Voice Note Player - Slack-styled voice message player with audio playback and waveform
class VoiceNotePlayer extends StatefulWidget {
  final String? audioUrl;
  final Duration? duration;
  final bool isSent;

  const VoiceNotePlayer({
    super.key,
    required this.audioUrl,
    this.duration,
    required this.isSent,
  });

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer>
    with SingleTickerProviderStateMixin {
  late final AudioPlayer _player;
  late final AnimationController _waveController;
  late final List<double> _waveHeights;

  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isInitialized = false;
  Duration _position = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _totalDuration = widget.duration ?? Duration.zero;

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    // Generate balanced waveform heights
    final rng = Random(widget.audioUrl?.hashCode ?? 42);
    _waveHeights = List.generate(28, (index) {
      final base = 0.25 + rng.nextDouble() * 0.7;
      return base.clamp(0.2, 1.0);
    });

    _initPlayerStreams();
  }

  void _initPlayerStreams() {
    _player.playerStateStream.listen((state) {
      if (!mounted) return;
      final playing = state.playing;
      final processingState = state.processingState;

      setState(() {
        _isLoading = processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering;
        _isPlaying = playing && processingState != ProcessingState.completed;
      });

      if (_isPlaying) {
        if (!_waveController.isAnimating) {
          _waveController.repeat(reverse: true);
        }
      } else {
        _waveController.stop();
      }

      if (processingState == ProcessingState.completed) {
        _player.seek(Duration.zero);
        _player.pause();
        setState(() {
          _position = Duration.zero;
          _isPlaying = false;
        });
      }
    });

    _player.positionStream.listen((pos) {
      if (!mounted) return;
      setState(() {
        _position = pos;
      });
    });

    _player.durationStream.listen((dur) {
      if (!mounted || dur == null) return;
      setState(() {
        _totalDuration = dur;
      });
    });
  }

  Future<void> _togglePlayPause() async {
    final url = widget.audioUrl;
    if (url == null || url.isEmpty) return;

    HapticFeedback.lightImpact();

    try {
      if (!_isInitialized) {
        setState(() => _isLoading = true);
        if (url.startsWith('http://') || url.startsWith('https://')) {
          await _player.setUrl(url);
        } else {
          await _player.setFilePath(url);
        }
        _isInitialized = true;
      }

      if (_isPlaying) {
        await _player.pause();
      } else {
        await _player.play();
      }
    } catch (e) {
      debugPrint('Audio playback error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to play audio note'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleSpeed() async {
    HapticFeedback.selectionClick();
    double nextSpeed = 1.0;
    if (_playbackSpeed == 1.0) {
      nextSpeed = 1.5;
    } else if (_playbackSpeed == 1.5) {
      nextSpeed = 2.0;
    } else {
      nextSpeed = 1.0;
    }

    setState(() {
      _playbackSpeed = nextSpeed;
    });

    try {
      await _player.setSpeed(nextSpeed);
    } catch (_) {}
  }

  Future<void> _seekToFraction(double fraction) async {
    if (_totalDuration.inMilliseconds <= 0) return;
    HapticFeedback.selectionClick();

    final targetMs = (_totalDuration.inMilliseconds * fraction).round();
    final newPosition = Duration(milliseconds: targetMs);

    try {
      await _player.seek(newPosition);
    } catch (_) {}
  }

  @override
  void dispose() {
    _waveController.dispose();
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final secondaryColor = widget.isSent
        ? (isDark ? Colors.white60 : AppColors.aubergine.withValues(alpha: 0.7))
        : (isDark ? Colors.white54 : AppColors.midGray);

    final displayDuration = _isPlaying || _position > Duration.zero
        ? _position
        : (_totalDuration > Duration.zero ? _totalDuration : (widget.duration ?? Duration.zero));

    final progressFraction = _totalDuration.inMilliseconds > 0
        ? (_position.inMilliseconds / _totalDuration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Play / Pause / Loading button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isLoading ? null : _togglePlayPause,
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: widget.isSent
                    ? AppColors.aubergine
                    : (isDark ? const Color(0xFF2E3136) : const Color(0xFFE8E5EC)),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: _isLoading
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: widget.isSent ? Colors.white : AppColors.aubergine,
                        ),
                      )
                    : Icon(
                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: widget.isSent ? Colors.white : AppColors.aubergine,
                        size: 24,
                      ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Interactive Waveform
        GestureDetector(
          onTapDown: (details) {
            const width = 130.0;
            final fraction = (details.localPosition.dx / width).clamp(0.0, 1.0);
            _seekToFraction(fraction);
          },
          child: AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return SizedBox(
                height: 32,
                width: 130,
                child: CustomPaint(
                  painter: _WaveformPainter(
                    waveHeights: _waveHeights,
                    animationValue: _waveController.value,
                    isPlaying: _isPlaying,
                    progressFraction: progressFraction,
                    activeColor: widget.isSent ? (isDark ? Colors.white : AppColors.aubergine) : AppColors.aubergine,
                    inactiveColor: secondaryColor.withValues(alpha: 0.35),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 10),

        // Duration text
        SizedBox(
          width: 36,
          child: Text(
            _formatDuration(displayDuration),
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
              color: secondaryColor,
            ),
          ),
        ),

        const SizedBox(width: 6),

        // Speed toggle badge
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _toggleSpeed,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: _playbackSpeed > 1.0
                    ? AppColors.aubergine.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _playbackSpeed > 1.0
                      ? AppColors.aubergine.withValues(alpha: 0.4)
                      : (isDark ? const Color(0xFF35373B) : AppColors.fog),
                ),
              ),
              child: Text(
                '${_playbackSpeed.toStringAsFixed(1)}x',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _playbackSpeed > 1.0 ? AppColors.aubergine : secondaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> waveHeights;
  final double animationValue;
  final bool isPlaying;
  final double progressFraction;
  final Color activeColor;
  final Color inactiveColor;

  _WaveformPainter({
    required this.waveHeights,
    required this.animationValue,
    required this.isPlaying,
    required this.progressFraction,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barCount = waveHeights.length;
    final barWidth = size.width / barCount;
    final maxHeight = size.height;

    for (int i = 0; i < barCount; i++) {
      final barFraction = (i + 1) / barCount;
      final isElapsed = barFraction <= progressFraction;

      final baseHeight = waveHeights[i] * maxHeight;
      double height;

      if (isPlaying) {
        final phase = (i * 0.35 + animationValue * 2 * pi) % (2 * pi);
        final multiplier = 0.4 + 0.6 * (0.5 + 0.5 * sin(phase));
        height = baseHeight * multiplier;
      } else {
        height = baseHeight * 0.65;
      }

      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          i * barWidth + barWidth * 0.15,
          (size.height - height) / 2,
          barWidth * 0.7,
          height,
        ),
        Radius.circular(barWidth * 0.35),
      );

      final paint = Paint()
        ..color = isElapsed ? activeColor : inactiveColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(barRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.progressFraction != progressFraction ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
