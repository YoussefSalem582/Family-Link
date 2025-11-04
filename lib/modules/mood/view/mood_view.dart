import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/mood_viewmodel.dart';
import '../../../widgets/demo_banner_widget.dart';
import 'widgets/mood_stats_card.dart';
import 'widgets/mood_selector_sheet.dart';
import 'widgets/mood_card.dart';
import 'widgets/empty_moods_widget.dart';

class MoodView extends GetView<MoodViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mood_title'.tr),
        actions: [
          IconButton(
            icon: Icon(Icons.add_reaction_outlined),
            onPressed: () => _showMoodSelector(context),
            tooltip: 'mood_share_mood'.tr,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Demo Mode Banner
            if (controller.isDemoMode.value)
              DemoBannerWidget(message: 'demo_mood'.tr),

            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.loadTodaysMoods();
                },
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    // Mood Stats
                    MoodStatsCard(getMoodCount: _getMoodCount),
                    SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'mood_family_today'.tr,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        TextButton.icon(
                          onPressed: () => _showMoodSelector(context),
                          icon: Icon(Icons.add),
                          label: Text('mood_share'.tr),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Family Moods
                    if (controller.todaysMoods.isNotEmpty) ...[
                      ...controller.todaysMoods.map(
                        (mood) => MoodCard(
                          mood: mood,
                          getMoodColor: _getMoodColor,
                          getMoodEmoji: _getMoodEmoji,
                          formatTime: _formatTime,
                        ),
                      ),
                    ] else ...[
                      EmptyMoodsWidget(
                        onShareMood: () => _showMoodSelector(context),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  int _getMoodCount(String moodType) {
    return controller.todaysMoods
        .where((mood) => mood.mood.toLowerCase() == moodType)
        .length;
  }

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return Colors.green;
      case 'excited':
        return Colors.purple;
      case 'sad':
        return Colors.blue;
      case 'angry':
        return Colors.red;
      case 'neutral':
        return Colors.grey;
      case 'tired':
        return Colors.orange;
      case 'anxious':
        return Colors.amber;
      case 'calm':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _getMoodEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return '😊';
      case 'sad':
        return '😢';
      case 'angry':
        return '😠';
      case 'anxious':
        return '😰';
      case 'tired':
        return '😴';
      case 'excited':
        return '😎';
      case 'calm':
        return '😌';
      case 'neutral':
        return '😐';
      default:
        return '😊';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showMoodSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MoodSelectorSheet(
        onMoodSelected: (mood, note) {
          Get.back();
          Get.snackbar(
            'demo_mode'.tr,
            'mood_shared'.tr + ': "$mood"',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.purple.withOpacity(0.8),
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
        },
      ),
    );
  }
}
