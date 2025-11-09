import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/section_header.dart';
import '../viewmodel/wall_viewmodel.dart';
import 'widgets/voice_note_card.dart';
import 'widgets/record_voice_note_sheet.dart';
import 'widgets/empty_voice_notes_widget.dart';

class VoiceNotesView extends GetView<WallViewModel> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[50];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        title: 'voice_notes_title',
        icon: Icons.mic_rounded,
        actionIcon: Icons.mic_none_rounded,
        actionTooltip: 'voice_notes_record',
        onActionPressed: () => _showRecordSheet(context),
      ),
      body: Obx(() {
        final voiceNotes = controller.getVoiceNotes();

        return Column(
          children: [
            // Demo Mode Banner
            if (controller.isDemoMode.value)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade50, Colors.orange.shade100],
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.orange.shade200, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.orange.shade900,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'demo_voice_notes'.tr,
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.loadPosts();
                },
                child: voiceNotes.isEmpty
                    ? EmptyVoiceNotesWidget(
                        onRecord: () => _showRecordSheet(context),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Section Header
                          SectionHeader(
                            title: 'voice_notes_family',
                            icon: Icons.family_restroom,
                            iconGradient: LinearGradient(
                              colors: [
                                Colors.deepPurple,
                                Colors.deepPurple.withOpacity(0.7),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Voice Notes List
                          ...voiceNotes.map(
                            (note) => VoiceNoteCard(
                              voiceNote: note,
                              onDelete:
                                  controller.isDemoMode.value ||
                                      note.userId == 'demo_user_1'
                                  ? () => _showDeleteConfirmation(context, note)
                                  : null,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.deepPurple.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showRecordSheet(context),
          icon: const Icon(Icons.mic, size: 22),
          label: Text(
            'voice_notes_record'.tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }

  void _showRecordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecordVoiceNoteSheet(
        onRecorded: (title, category, duration, audioPath) {
          Get.back();
          controller.createVoiceNote(
            'demo_user_1',
            'You',
            null,
            title,
            category,
            duration,
            audioPath,
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic note) {
    Get.dialog(
      AlertDialog(
        title: Text('voice_notes_delete'.tr),
        content: Text('voice_notes_delete_confirm'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deletePost(note.id, 'demo_user_1');
            },
            child: Text('delete'.tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
