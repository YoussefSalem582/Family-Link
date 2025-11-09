import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyMoodsWidget extends StatelessWidget {
  final VoidCallback onShareMood;

  const EmptyMoodsWidget({Key? key, required this.onShareMood})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.grey[700] : Colors.grey[300];
    final textColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Icon(Icons.mood, size: 64, color: iconColor),
          const SizedBox(height: 16),
          Text(
            'mood_no_moods'.tr,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onShareMood,
            icon: const Icon(Icons.add_reaction),
            label: Text('mood_share_mood'.tr),
          ),
        ],
      ),
    );
  }
}
