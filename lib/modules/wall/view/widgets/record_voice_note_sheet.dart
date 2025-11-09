import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';

class RecordVoiceNoteSheet extends StatefulWidget {
  final Function(
    String title,
    String category,
    String duration,
    String audioPath,
  )
  onRecorded;

  const RecordVoiceNoteSheet({Key? key, required this.onRecorded})
    : super(key: key);

  @override
  State<RecordVoiceNoteSheet> createState() => _RecordVoiceNoteSheetState();
}

class _RecordVoiceNoteSheetState extends State<RecordVoiceNoteSheet> {
  final TextEditingController _titleController = TextEditingController();
  final AudioRecorder _recorder = AudioRecorder();

  bool _isRecording = false;
  bool _hasRecorded = false;
  String? _recordedPath;
  Duration _recordDuration = Duration.zero;
  String _selectedCategory = 'message';

  final List<Map<String, dynamic>> _categories = [
    {'id': 'bedtime_story', 'icon': Icons.menu_book, 'color': Colors.indigo},
    {'id': 'greeting', 'icon': Icons.waving_hand, 'color': Colors.green},
    {'id': 'recipe', 'icon': Icons.restaurant, 'color': Colors.orange},
    {'id': 'message', 'icon': Icons.message, 'color': Colors.blue},
    {'id': 'other', 'icon': Icons.voice_chat, 'color': Colors.grey},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        // In demo mode, simulate recording
        setState(() {
          _isRecording = true;
          _recordDuration = Duration.zero;
        });

        // Simulate duration increase
        _simulateRecording();

        Get.snackbar(
          'voice_notes_recording'.tr,
          'voice_notes_demo_recording'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'error'.tr,
          'voice_notes_permission_denied'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error starting recording: $e');
      Get.snackbar(
        'error'.tr,
        'voice_notes_recording_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _simulateRecording() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording && mounted) {
        setState(() {
          _recordDuration += const Duration(seconds: 1);
        });
        _simulateRecording();
      }
    });
  }

  Future<void> _stopRecording() async {
    try {
      // In demo mode, simulate stopping
      setState(() {
        _isRecording = false;
        _hasRecorded = true;
        _recordedPath =
            'demo_voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';
      });
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  void _deleteRecording() {
    setState(() {
      _hasRecorded = false;
      _recordedPath = null;
      _recordDuration = Duration.zero;
    });
  }

  void _saveVoiceNote() {
    if (!_hasRecorded) {
      Get.snackbar(
        'error'.tr,
        'voice_notes_no_recording'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final title = _titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'voice_notes_enter_title'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    widget.onRecorded(
      title,
      _selectedCategory,
      _formatDuration(_recordDuration),
      _recordedPath ?? '',
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final handleColor = isDark ? Colors.grey[700] : Colors.grey[300];
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: handleColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            'voice_notes_record_new'.tr,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Category Selection
          Text(
            'voice_notes_select_category'.tr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category['id'];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildCategoryOption(
                    category['id'],
                    category['icon'],
                    category['color'],
                    isSelected,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Title Input
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'voice_notes_title_label'.tr,
              hintText: 'voice_notes_title_hint'.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.title),
            ),
            maxLength: 50,
          ),
          const SizedBox(height: 20),

          // Recording Interface
          if (!_hasRecorded) ...[
            // Record Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withOpacity(0.1),
                    Colors.pink.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isRecording
                      ? Colors.red
                      : (isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.3)),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _isRecording ? _stopRecording : _startRecording,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red, Colors.red.withOpacity(0.8)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: _isRecording
                            ? [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isRecording
                        ? _formatDuration(_recordDuration)
                        : 'voice_notes_tap_to_record'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isRecording ? Colors.red : null,
                    ),
                  ),
                  if (_isRecording) ...[
                    const SizedBox(height: 8),
                    Text(
                      'voice_notes_recording_active'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ] else ...[
            // Recorded Preview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.1),
                    Colors.teal.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'voice_notes_recorded'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'voice_notes_duration'.trParams({
                      'duration': _formatDuration(_recordDuration),
                    }),
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: _deleteRecording,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: Text(
                      'voice_notes_delete_recording'.tr,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveVoiceNote,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'voice_notes_save'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryOption(
    String id,
    IconData icon,
    Color color,
    bool isSelected,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedBg = isDark ? const Color(0xFF2A2A2A) : Colors.grey[100];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = id;
        });
      },
      child: Container(
        width: 70,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : unselectedBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? color
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              'voice_notes_category_$id'.tr,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? color
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
