import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyMoodsWidget extends StatelessWidget {
  final VoidCallback onShareMood;

  const EmptyMoodsWidget({Key? key, required this.onShareMood})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 32),
          Icon(Icons.mood, size: 64, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'mood_no_moods'.tr,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          SizedBox(height: 8),
          TextButton.icon(
            onPressed: onShareMood,
            icon: Icon(Icons.add_reaction),
            label: Text('mood_share_mood'.tr),
          ),
        ],
      ),
    );
  }
}
