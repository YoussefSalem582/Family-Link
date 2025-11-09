import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoodStatsCard extends StatelessWidget {
  final int Function(String) getMoodCount;

  const MoodStatsCard({Key? key, required this.getMoodCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.grey.withOpacity(0.1);

    return Container(
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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.purple.withOpacity(0.1),
              Colors.blue.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          children: [
            // First row - 4 moods
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMoodStat('😊', 'mood_happy'.tr, getMoodCount('happy')),
                _buildMoodStat('😢', 'mood_sad'.tr, getMoodCount('sad')),
                _buildMoodStat('😠', 'mood_angry'.tr, getMoodCount('angry')),
                _buildMoodStat(
                  '😰',
                  'mood_anxious'.tr,
                  getMoodCount('anxious'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Second row - 4 moods
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMoodStat('😴', 'mood_tired'.tr, getMoodCount('tired')),
                _buildMoodStat(
                  '😎',
                  'mood_excited'.tr,
                  getMoodCount('excited'),
                ),
                _buildMoodStat('😌', 'mood_calm'.tr, getMoodCount('calm')),
                _buildMoodStat(
                  '😐',
                  'mood_neutral'.tr,
                  getMoodCount('neutral'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodStat(String emoji, String label, int count) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final labelColor = isDark ? Colors.grey[400] : Colors.grey[600];

        return Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(label, style: TextStyle(fontSize: 11, color: labelColor)),
          ],
        );
      },
    );
  }
}
