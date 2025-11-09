import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class VoiceNoteCard extends StatefulWidget {
  final dynamic voiceNote;
  final VoidCallback? onDelete;

  const VoiceNoteCard({Key? key, required this.voiceNote, this.onDelete})
    : super(key: key);

  @override
  State<VoiceNoteCard> createState() => _VoiceNoteCardState();
}

class _VoiceNoteCardState extends State<VoiceNoteCard> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // In demo mode, simulate playback
      if (widget.voiceNote.voiceUrl == null ||
          widget.voiceNote.voiceUrl!.isEmpty) {
        Get.snackbar(
          'demo_mode'.tr,
          'voice_notes_demo_playback'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return;
      }
      await _audioPlayer.play(UrlSource(widget.voiceNote.voiceUrl!));
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'bedtime_story':
        return Colors.indigo;
      case 'greeting':
        return Colors.green;
      case 'recipe':
        return Colors.orange;
      case 'message':
        return Colors.blue;
      case 'other':
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'bedtime_story':
        return Icons.menu_book;
      case 'greeting':
        return Icons.waving_hand;
      case 'recipe':
        return Icons.restaurant;
      case 'message':
        return Icons.message;
      case 'other':
      default:
        return Icons.voice_chat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.grey.withOpacity(0.1);
    final categoryColor = _getCategoryColor(
      widget.voiceNote.category ?? 'other',
    );
    final categoryIcon = _getCategoryIcon(widget.voiceNote.category ?? 'other');
    final timeColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info and category
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: categoryColor.withOpacity(0.2),
                  child: Icon(categoryIcon, color: categoryColor, size: 20),
                ),
                const SizedBox(width: 12),
                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.voiceNote.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        _formatTime(widget.voiceNote.createdAt),
                        style: TextStyle(fontSize: 12, color: timeColor),
                      ),
                    ],
                  ),
                ),
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: categoryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'voice_notes_category_${widget.voiceNote.category ?? 'other'}'
                        .tr,
                    style: TextStyle(
                      fontSize: 11,
                      color: categoryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (widget.onDelete != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: widget.onDelete,
                    color: Colors.red,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            // Title
            if (widget.voiceNote.title != null &&
                widget.voiceNote.title!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  widget.voiceNote.title!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            // Audio Player
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: categoryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Play/Pause button
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [categoryColor, categoryColor.withOpacity(0.8)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Progress bar and duration
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Waveform or progress
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _duration.inMilliseconds > 0
                                ? _position.inMilliseconds /
                                      _duration.inMilliseconds
                                : 0,
                            backgroundColor: categoryColor.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              categoryColor,
                            ),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Duration text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_position),
                              style: TextStyle(fontSize: 11, color: timeColor),
                            ),
                            Text(
                              widget.voiceNote.duration ?? '0:00',
                              style: TextStyle(fontSize: 11, color: timeColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'just_now'.tr;
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}${'minutes_ago'.tr}';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}${'hours_ago'.tr}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}${'days_ago'.tr}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
