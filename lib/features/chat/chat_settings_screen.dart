import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/security/session_manager.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/repository_providers.dart';
import '../../../services/notification_service.dart';
import 'chat_notifier.dart';

/// Chat settings screen - Clean Slack Minimalist
class ChatSettingsScreen extends ConsumerStatefulWidget {
  const ChatSettingsScreen({super.key});

  @override
  ConsumerState<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends ConsumerState<ChatSettingsScreen> {
  Duration? _disappearingTimer;
  bool _isExporting = false;
  bool _isImporting = false;

  // Compass credentials & account state
  double? _userHeading;
  String? _userPin;
  String _userRole = '';
  String _userId = '';
  bool _isSavingCredentials = false;

  @override
  void initState() {
    super.initState();
    _loadDisappearingTimer();
    _loadUserCredentials();
  }

  Future<void> _loadUserCredentials() async {
    final session = ref.read(sessionManagerProvider);
    final (userId, userRole) = switch (session) {
      SessionAuthenticated(:final userId, :final userRole) => (userId, userRole),
      _ => ('', ''),
    };

    if (userId.isEmpty) return;

    _userId = userId;
    _userRole = userRole;

    try {
      final creds = await ref.read(chatRepositoryProvider).getCompassCredentials(userRole);
      if (mounted) {
        setState(() {
          _userHeading = creds.heading;
          _userPin = creds.pin;
        });
      }

      // Fetch fresh credentials from Supabase
      final freshMap = await ref.read(chatRepositoryProvider).fetchCompassCredentials();
      final fresh = freshMap[userRole];
      if (fresh != null && mounted) {
        setState(() {
          _userHeading = fresh.heading;
          _userPin = fresh.pin;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadDisappearingTimer() async {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => '',
    };

    if (userId.isEmpty) return;

    try {
      final conversation =
          await ref.read(chatRepositoryProvider).getOrCreateConversation();
      setState(() {
        _disappearingTimer = conversation.disappearingTimer;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF1A1D21) : AppColors.softWhite,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF222529) : Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? const Color(0xFF35373B) : AppColors.fog,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: isDark ? const Color(0xFFD1D2D3) : AppColors.charcoal,
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Preferences & Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                      ),
                    ),
                  ],
                ),
              ),

              // Settings content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSectionHeader('COMPASS TRIGGER CREDENTIALS', isDark),
                    _buildCompassCredentialsCard(isDark),
                    const SizedBox(height: 24),

                    _buildSectionHeader('ACCOUNT & DEVICE', isDark),
                    _buildAccountCard(isDark),
                    const SizedBox(height: 24),

                    _buildSectionHeader('DISAPPEARING MESSAGES', isDark),
                    _buildDisappearingCard(isDark),
                    const SizedBox(height: 24),

                    _buildSectionHeader('BACKUP & PRIVACY', isDark),
                    _buildBackupCard(isDark),
                    const SizedBox(height: 24),

                    _buildSectionHeader('DANGER ZONE', isDark),
                    _buildDangerCard(isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
        ),
      ),
    );
  }

  Widget _buildCompassCredentialsCard(bool isDark) {
    final headingText = _userHeading != null ? '${_userHeading!.round()}°' : '120°';
    final pinDisplay = _userPin != null ? _userPin! : '1234';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222529) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF35373B) : AppColors.fog,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF35373B) : AppColors.purpleHaze,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.explore_rounded,
                  color: AppColors.aubergine,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Compass Trigger & Secret PIN',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                      ),
                    ),
                    Text(
                      'Secret Heading: $headingText  •  PIN: $pinDisplay',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
              foregroundColor: isDark ? Colors.white : AppColors.aubergine,
              side: BorderSide(
                color: isDark ? const Color(0xFF4A154B) : AppColors.aubergine,
                width: 1,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _showEditCredentialsSheet(isDark),
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text(
              'Change Heading & PIN',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
              foregroundColor: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
              side: BorderSide(
                color: isDark ? const Color(0xFF35373B) : AppColors.fog,
                width: 1,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await NotificationService.showDecoyNotification();
              if (mounted) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Decoy compass notification sent! Check your status bar.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            icon: const Icon(Icons.notifications_active_outlined, size: 16),
            label: const Text(
              'Test Decoy Notification',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditCredentialsSheet(bool isDark) {
    double currentHeading = _userHeading ?? 120.0;
    final headingController = TextEditingController(text: currentHeading.round().toString());
    final pinController = TextEditingController(text: _userPin ?? '1234');
    String? errorMessage;

    final messenger = ScaffoldMessenger.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E2124) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (modalContext, setSheetState) {
            final bottomInset = MediaQuery.of(modalContext).viewInsets.bottom;

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: bottomInset + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Compass Credentials',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.carbon,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          color: isDark ? Colors.white70 : AppColors.midGray,
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Set the secret compass degree and 4-digit PIN for your account. Saved to Supabase without password hashing.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Heading input
                    Text(
                      'Secret Heading (Degrees 0 - 359)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: currentHeading.clamp(0.0, 359.0),
                            min: 0,
                            max: 359,
                            divisions: 359,
                            activeColor: AppColors.aubergine,
                            onChanged: (val) {
                              setSheetState(() {
                                currentHeading = val;
                                headingController.text = val.round().toString();
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: headingController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white : AppColors.carbon,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              suffixText: '°',
                              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (val) {
                              final deg = double.tryParse(val);
                              if (deg != null && deg >= 0 && deg < 360) {
                                setSheetState(() {
                                  currentHeading = deg;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // PIN input
                    Text(
                      'Secret PIN (4 Digits)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: pinController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.carbon,
                        letterSpacing: 4,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: '1234',
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    if (errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Color(0xFFE01E5A), fontSize: 12),
                      ),
                    ],

                    const SizedBox(height: 20),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 46),
                        backgroundColor: AppColors.aubergine,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _isSavingCredentials
                          ? null
                          : () async {
                              final pin = pinController.text.trim();
                              final deg = double.tryParse(headingController.text.trim()) ?? currentHeading;

                              if (pin.length < 4) {
                                setSheetState(() {
                                  errorMessage = 'PIN must be at least 4 digits';
                                });
                                return;
                              }
                              if (deg < 0 || deg >= 360) {
                                setSheetState(() {
                                  errorMessage = 'Heading must be between 0° and 359°';
                                });
                                return;
                              }

                              setSheetState(() {
                                errorMessage = null;
                              });

                              setState(() => _isSavingCredentials = true);
                              Navigator.pop(sheetContext);

                              try {
                                await ref.read(chatRepositoryProvider).updateCompassCredentials(
                                  userId: _userId,
                                  heading: deg,
                                  pin: pin,
                                );

                                if (mounted) {
                                  setState(() {
                                    _userHeading = deg;
                                    _userPin = pin;
                                    _isSavingCredentials = false;
                                  });
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text('Compass credentials updated: ${deg.round()}° & PIN saved'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  setState(() => _isSavingCredentials = false);
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to update credentials: $e'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              }
                            },
                      child: _isSavingCredentials
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'Save Credentials',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAccountCard(bool isDark) {
    final roleName = _userRole == 'user_2' ? 'User Two' : 'User One';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222529) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF35373B) : AppColors.fog,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF35373B) : AppColors.purpleHaze,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.aubergine,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roleName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2BAC76),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Phone bound to this account',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
              foregroundColor: const Color(0xFFE01E5A),
              side: BorderSide(
                color: const Color(0xFFE01E5A).withValues(alpha: 0.5),
                width: 1,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _showLogoutConfirmationDialog(isDark, roleName),
            icon: const Icon(Icons.logout_rounded, size: 16),
            label: const Text(
              'Log Out of this Phone',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(bool isDark, String roleName) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Log out of $roleName?'),
          content: const Text(
            'This will unbind this phone from your account and lock the app into compass mode.\n\nNext time, either User 1 or User 2 can log in.\n\nYour chat messages will remain safely stored on this device.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE01E5A),
              ),
              onPressed: () async {
                Navigator.pop(dialogCtx);
                await ref.read(sessionManagerProvider.notifier).logout();
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDisappearingCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222529) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF35373B) : AppColors.fog,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF35373B) : AppColors.purpleHaze,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.timer_outlined,
                  color: AppColors.aubergine,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto-delete timer',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                      ),
                    ),
                    Text(
                      'New messages expire after selected time',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimerOption('Off (Messages stay forever)', null, isDark),
          _buildTimerOption('24 Hours', const Duration(hours: 24), isDark),
          _buildTimerOption('7 Days', const Duration(days: 7), isDark),
        ],
      ),
    );
  }

  Widget _buildTimerOption(String label, Duration? timer, bool isDark) {
    final isSelected = _disappearingTimer == timer;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: () => _setDisappearingTimer(timer),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF381440) : AppColors.purpleHaze)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? (isDark ? const Color(0xFF730394) : AppColors.lavenderMist)
                  : (isDark ? const Color(0xFF35373B) : AppColors.fog),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? Colors.white : AppColors.aubergine)
                        : (isDark ? const Color(0xFFD1D2D3) : AppColors.carbon),
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.aubergine,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setDisappearingTimer(Duration? timer) async {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => '',
    };

    if (userId.isEmpty) return;

    try {
      final conv =
          await ref.read(chatRepositoryProvider).getOrCreateConversation();
      await ref.read(chatRepositoryProvider).setDisappearingTimer(conv.id, timer);
      setState(() {
        _disappearingTimer = timer;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(timer == null
                ? 'Disappearing messages turned off'
                : 'Disappearing timer updated to ${_formatDuration(timer)}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update timer: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildBackupCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222529) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF35373B) : AppColors.fog,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Export
          InkWell(
            onTap: _isExporting ? null : _exportBackup,
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF35373B) : AppColors.purpleHaze,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.download_rounded,
                    color: AppColors.aubergine,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Export Encrypted Backup',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                        ),
                      ),
                      Text(
                        'Save a password-protected local backup file',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isExporting)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.aubergine,
                    ),
                  )
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
                  ),
              ],
            ),
          ),
          Divider(
            color: isDark ? const Color(0xFF35373B) : AppColors.fog,
            height: 24,
          ),

          // Import
          InkWell(
            onTap: _isImporting ? null : _importBackup,
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF35373B) : AppColors.purpleHaze,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.upload_rounded,
                    color: AppColors.aubergine,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Restore Encrypted Backup',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFFD1D2D3) : AppColors.carbon,
                        ),
                      ),
                      Text(
                        'Import messages from a previously saved backup',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isImporting)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.aubergine,
                    ),
                  )
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportBackup() async {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => '',
    };

    if (userId.isEmpty) return;

    setState(() => _isExporting = true);

    try {
      final filePath =
          await ref.read(chatRepositoryProvider).exportEncryptedBackup(userId);

      if (mounted) {
        setState(() => _isExporting = false);
        await Share.shareXFiles([XFile(filePath)], text: 'JustUS Encrypted Backup');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isExporting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export backup: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _importBackup() async {
    final session = ref.read(sessionManagerProvider);
    final userId = switch (session) {
      SessionAuthenticated(:final userId) => userId,
      _ => '',
    };

    if (userId.isEmpty) return;

    setState(() => _isImporting = true);

    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        await ref
            .read(chatRepositoryProvider)
            .importEncryptedBackup(userId, filePath);
        if (mounted) {
          setState(() => _isImporting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Backup restored successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        setState(() => _isImporting = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isImporting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to import backup: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildDangerCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF222529) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE01E5A).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: _showClearChatConfirmation,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFE01E5A).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_forever_rounded,
                color: Color(0xFFE01E5A),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delete Chat Everywhere (Master Wipe)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE01E5A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Permanently delete all messages and media from both phones & the database',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? const Color(0xFFABABAD) : AppColors.midGray,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFE01E5A),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearChatConfirmation() {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Master Delete Chat History?'),
          content: const Text(
            'This will permanently delete ALL messages, voice notes, media files, and reactions from both phones and the cloud database.\n\nThis action is irreversible.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE01E5A),
              ),
              onPressed: () async {
                Navigator.pop(dialogCtx);
                try {
                  await ref.read(chatNotifierProvider.notifier).clearAllChatHistory();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All chat history permanently deleted everywhere'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete chat: $e'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              child: const Text('Delete Everywhere'),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays >= 7) {
      return '7 days';
    } else if (duration.inHours >= 24) {
      return '24 hours';
    } else {
      return '${duration.inMinutes} minutes';
    }
  }
}
