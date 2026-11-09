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
      backgroundColor: isDark ? const Color(0xFF222529) : Colors.white,
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
                        color: isDark ? const Color(0xFF454245) : AppColors.fog,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Share Content',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
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
                                  ? (isDark ? const Color(0xFF611F69) : AppColors.aubergine)
                                  : (isDark ? const Color(0xFF2E3136) : const Color(0xFFF0EDF2)),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isViewOnce
                                    ? AppColors.aubergine
                                    : (isDark ? const Color(0xFF454245) : AppColors.fog),
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
                                      ? Colors.white
                                      : (isDark ? const Color(0xFFABABAD) : AppColors.charcoal),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'View Once',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isViewOnce
                                        ? Colors.white
                                        : (isDark ? const Color(0xFFABABAD) : AppColors.charcoal),
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
      color: isDark ? const Color(0xFF1A1D21) : AppColors.softWhite,
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
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

          // Main input container
          _isRecording
              ? _buildRecordingBar(isDark)
              : _buildStandardInputBar(isDark, hasText),
        ],
      ),
    );
  }

  Widget _buildReplyingBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222529) : AppColors.purpleHaze,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: AppColors.aubergine, width: 3),
        ),
      ),
      child: Row(
        children: [
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
                    color: AppColors.aubergine,
                  ),
                ),
                Text(
                  widget.replyingTo!.content ?? 'Attachment',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
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
            color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222529) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE01E5A).withValues(alpha: 0.5),
          width: 1,
        ),
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
              color: Color(0xFFE01E5A),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Recording voice note...',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
            ),
          ),
          const Spacer(),
          // Cancel
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
            tooltip: 'Cancel',
            onPressed: _cancelRecording,
          ),
          const SizedBox(width: 4),
          // Send
          InkWell(
            onTap: _stopAndSendRecording,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.aubergine,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardInputBar(bool isDark, bool hasText) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222529) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF35373B) : AppColors.fog,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attachment Button (+)
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, size: 24),
            color: isDark ? const Color(0xFFABABAD) : AppColors.charcoal,
            onPressed: () => _showAttachmentModal(context, isDark),
            tooltip: 'Attach file',
            padding: const EdgeInsets.all(10),
            constraints: const BoxConstraints(),
          ),

          // Message Input Field
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              maxLines: 5,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              onChanged: _onTextChanged,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
              ),
              decoration: InputDecoration(
                hintText: 'Send a message...',
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: isDark ? const Color(0xFF696969) : AppColors.midGray,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                isCollapsed: true,
              ),
            ),
          ),

          // Mic or Send Button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: hasText
                ? Padding(
                    key: const ValueKey('send_btn'),
                    padding: const EdgeInsets.only(right: 6, bottom: 6),
                    child: InkWell(
                      onTap: _handleSendText,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.aubergine,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    key: const ValueKey('mic_btn'),
                    icon: const Icon(Icons.mic_none_rounded, size: 24),
                    color: isDark ? const Color(0xFFABABAD) : AppColors.charcoal,
                    onPressed: _startRecording,
                    tooltip: 'Record voice note',
                    padding: const EdgeInsets.all(10),
                    constraints: const BoxConstraints(),
                  ),
          ),
        ],
      ),
    );
  }
}
