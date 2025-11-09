import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyVoiceNotesWidget extends StatelessWidget {
  final VoidCallback onRecord;

  const EmptyVoiceNotesWidget({Key? key, required this.onRecord})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.grey[700] : Colors.grey[300];
    final textColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: iconColor?.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.mic_off, size: 80, color: iconColor),
            ),
            const SizedBox(height: 24),
            Text(
              'voice_notes_no_notes'.tr,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'voice_notes_empty_description'.tr,
              style: TextStyle(color: textColor, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Feature Highlights
            _buildFeatureItem(
              Icons.menu_book,
              'voice_notes_feature_stories'.tr,
              Colors.indigo,
              isDark,
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              Icons.waving_hand,
              'voice_notes_feature_greetings'.tr,
              Colors.green,
              isDark,
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              Icons.restaurant,
              'voice_notes_feature_recipes'.tr,
              Colors.orange,
              isDark,
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              Icons.message,
              'voice_notes_feature_messages'.tr,
              Colors.blue,
              isDark,
            ),
            const SizedBox(height: 32),

            // CTA Button
            ElevatedButton.icon(
              onPressed: onRecord,
              icon: const Icon(Icons.mic),
              label: Text('voice_notes_start_recording'.tr),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    IconData icon,
    String text,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[300] : Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
