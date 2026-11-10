import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/enums.dart';
import '../../../domain/models/message.dart';

/// Message Input Bar - Slack-inspired clean minimalist input bar
class MessageInputBar extends ConsumerStatefulWidget {
  final ValueChanged<String>? onSendText;
  final void Function(String path, MessageType type, {bool isViewOnce})? onSendMedia;
  final void Function(String path, Duration duration)? onSendVoice;
  final ValueChanged<bool>? onTyping;
  final VoidCallback? onCancelReply;
  final Message? replyingTo;

  const MessageInputBar({
    super.key,
    this.onSendText,
    this.onSendMedia,
    this.onSendVoice,
    this.onTyping,
    this.onCancelReply,
    this.replyingTo,
  });

  @override
  ConsumerState<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends ConsumerState<MessageInputBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();
  AudioRecorder? _audioRecorder;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool _isRecording = false;
  String? _recordingPath;
  Duration _recordingDuration = Duration.zero;
  Timer? _recordingTimer;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _pulseController.dispose();
    _recordingTimer?.cancel();
    _typingTimer?.cancel();
    _audioRecorder?.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    setState(() {});
    widget.onTyping?.call(true);
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      widget.onTyping?.call(false);
    });
  }

  Future<void> _startRecording() async {
    try {
      final recorder = _audioRecorder;
      if (recorder == null) return;

      if (await recorder.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        final path =
            '${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        _recordingPath = path;

        await recorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );

        setState(() {
          _isRecording = true;
          _recordingDuration = Duration.zero;
        });

        _pulseController.repeat(reverse: true);
        _recordingTimer =
            Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordingDuration += const Duration(seconds: 1);
          });
        });
        HapticFeedback.mediumImpact();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission required')),
        );
      }
    } catch (e) {
      debugPrint('Voice record error: $e');
    }
  }

  Future<void> _stopAndSendRecording() async {
    try {
      _pulseController.stop();
      _recordingTimer?.cancel();
      final path = await _audioRecorder?.stop();
      final finalPath = path ?? _recordingPath;

      final duration = _recordingDuration;
      setState(() {
        _isRecording = false;
        _recordingDuration = Duration.zero;
      });

      if (finalPath != null && duration.inSeconds >= 1) {
        HapticFeedback.lightImpact();
        widget.onSendVoice?.call(finalPath, duration);
      }
    } catch (e) {
      debugPrint('Stop recording error: $e');
    }
  }

  Future<void> _cancelRecording() async {
    try {
      _pulseController.stop();
      _recordingTimer?.cancel();
      await _audioRecorder?.stop();
      setState(() {
        _isRecording = false;
        _recordingDuration = Duration.zero;
      });
      HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Cancel recording error: $e');
    }
  }

  void _handleSendText() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendText?.call(text);
      _textController.clear();
      widget.onTyping?.call(false);
      setState(() {});
    }
  }

  Future<void> _pickImage(ImageSource source, {bool isViewOnce = false}) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked != null) {
        widget.onSendMedia?.call(
          picked.path,
          isViewOnce ? MessageType.viewOnce : MessageType.image,
          isViewOnce: isViewOnce,
        );
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  Future<void> _pickVideo({bool isViewOnce = false}) async {
    try {
      final picked = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );
      if (picked != null) {
        widget.onSendMedia?.call(
          picked.path,
          isViewOnce ? MessageType.viewOnce : MessageType.video,
          isViewOnce: isViewOnce,
        );
      }
    } catch (e) {
      debugPrint('Video pick error: $e');
    }
  }

  Future<void> _pickDocument({bool isViewOnce = false}) async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        widget.onSendMedia?.call(
          result.files.single.path!,
          isViewOnce ? MessageType.viewOnce : MessageType.document,
          isViewOnce: isViewOnce,
        );
      }
    } catch (e) {
      debugPrint('Document pick error: $e');
    }
  }

  void _showAttachmentModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (modalContext) {
        bool isViewOnce = false;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF4A2641) : AppColors.borderLight,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Share Content',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.pureWhite,
                          ),
                        ),
                        // View Once Toggle Pill
                        InkWell(
                          onTap: () {
                            setModalState(() {
                              isViewOnce = !isViewOnce;
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isViewOnce
                                  ? AppColors.mulberryWine
                                  : const Color(0xFF2B1626),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isViewOnce
                                    ? AppColors.roseMauve
                                    : const Color(0xFF4A2641),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isViewOnce ? Icons.lock_clock_rounded : Icons.lock_clock_outlined,
                                  size: 16,
                                  color: isViewOnce
                                      ? AppColors.roseMauve
                                      : (isDark ? AppColors.mutedMauve : AppColors.charcoal),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'View Once',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isViewOnce
                                        ? Colors.white
                                        : (isDark ? AppColors.mutedMauve : AppColors.charcoal),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isViewOnce)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Recipient can only view this media once. It disappears immediately after closing.',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? const Color(0xFFECB22E) : const Color(0xFF9E6500),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildModalOption(
                          icon: Icons.photo_library_outlined,
                          label: 'Photos',
                          color: AppColors.aubergine,
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(modalContext);
                            _pickImage(ImageSource.gallery, isViewOnce: isViewOnce);
                          },
                        ),
                        _buildModalOption(
                          icon: Icons.camera_alt_outlined,
                          label: 'Camera',
                          color: const Color(0xFF0B4C8C),
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(modalContext);
                            _pickImage(ImageSource.camera, isViewOnce: isViewOnce);
                          },
                        ),
                        _buildModalOption(
                          icon: Icons.videocam_outlined,
                          label: 'Video',
                          color: const Color(0xFF730394),
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(modalContext);
                            _pickVideo(isViewOnce: isViewOnce);
                          },
                        ),
                        _buildModalOption(
                          icon: Icons.description_outlined,
                          label: 'File',
                          color: const Color(0xFF454245),
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(modalContext);
                            _pickDocument(isViewOnce: isViewOnce);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalOption({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2D32) : AppColors.purpleHaze,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF35373B) : AppColors.lavenderMist,
                  width: 1,
                ),
              ),
              child: Icon(icon, color: isDark ? Colors.white : color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFFABABAD) : AppColors.charcoal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasText = _textController.text.trim().isNotEmpty;

    return Container(
      color: Colors.transparent, // Floating over chat canvas without top/bottom bars
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reply preview if active
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutCubic,
            child: widget.replyingTo != null
                ? _buildReplyingBar(isDark)
                : const SizedBox.shrink(),
          ),

          // Main floating row (Pill on left + Circular Action Button on right)
          _isRecording
              ? _buildRecordingBar(isDark)
              : _buildStandardInputBar(isDark, hasText),
        ],
      ),
    );
  }

  Widget _buildReplyingBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderDark,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.mulberryWine,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Replying to',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.roseMauve,
                  ),
                ),
                Text(
                  widget.replyingTo!.content ?? 'Attachment',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.titaniumText,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            onPressed: widget.onCancelReply,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            color: AppColors.neutralGreyMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingBar(bool isDark) {
    final minutes =
        _recordingDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        _recordingDuration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Row(
      children: [
        // Left Recording Pill
        Expanded(
          child: Container(
            constraints: const BoxConstraints(minHeight: 50),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.toneOfBlack,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppColors.borderDark,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE01E5A)
                            .withValues(alpha: _pulseAnimation.value),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                Text(
                  '$minutes:$seconds',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.pureWhite,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Recording audio...',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.neutralGreyMuted,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: AppColors.neutralGreyMuted,
                  tooltip: 'Cancel',
                  onPressed: _cancelRecording,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Right Circular Send FAB
        InkWell(
          onTap: _stopAndSendRecording,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.actionFab,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.actionFab.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStandardInputBar(bool isDark, bool hasText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 1 & 2: Left Pill Container (Add Button + Text Field + Attachments)
        Expanded(
          child: Container(
            constraints: const BoxConstraints(minHeight: 50),
            decoration: BoxDecoration(
              color: AppColors.toneOfBlack, // Tone of black (#181818)
              borderRadius: BorderRadius.circular(28), // Pill shape
              border: Border.all(
                color: AppColors.borderDark,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // (1) The Add Button (+)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 24),
                  color: AppColors.neutralGreyMuted,
                  onPressed: () => _showAttachmentModal(context, isDark),
                  tooltip: 'Add attachment',
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  constraints: const BoxConstraints(),
                ),

                // (2) The Text Field
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      maxLines: 5,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: _onTextChanged,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.pureWhite,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter message',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: AppColors.neutralGreyMuted,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isCollapsed: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      ),
                    ),
                  ),
                ),

                // Attachment Paperclip Quick-Access
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded, size: 22),
                  color: AppColors.neutralGreyMuted,
                  onPressed: () => _showAttachmentModal(context, isDark),
                  tooltip: 'Attach media',
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // (3) Standalone Circular Floating Action Button (Mic / Send)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: hasText
              ? InkWell(
                  key: const ValueKey('send_fab_btn'),
                  onTap: _handleSendText,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.actionFab, // Mulberry Wine (#6E1C53)
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.actionFab.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                )
              : InkWell(
                  key: const ValueKey('mic_fab_btn'),
                  onTap: _startRecording,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.actionFab, // Mulberry Wine (#6E1C53)
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.actionFab.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.mic_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
