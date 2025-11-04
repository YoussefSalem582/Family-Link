import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoodSelectorSheet extends StatelessWidget {
  final Function(String mood, String? note) onMoodSelected;

  const MoodSelectorSheet({Key? key, required this.onMoodSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController noteController = TextEditingController();
    String? selectedMood;

    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'mood_how_feeling'.tr,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildMoodOption(
                context,
                '😊',
                'mood_happy'.tr,
                (mood) => selectedMood = mood,
              ),
              _buildMoodOption(
                context,
                '😢',
                'mood_sad'.tr,
                (mood) => selectedMood = mood,
              ),
              _buildMoodOption(
                context,
                '😠',
                'mood_angry'.tr,
                (mood) => selectedMood = mood,
              ),
              _buildMoodOption(
                context,
                '😰',
                'mood_anxious'.tr,
                (mood) => selectedMood = mood,
              ),
              _buildMoodOption(
                context,
                '😴',
                'mood_tired'.tr,
                (mood) => selectedMood = mood,
              ),
              _buildMoodOption(
                context,
                '😎',
                'mood_excited'.tr,
                (mood) => selectedMood = mood,
              ),
              _buildMoodOption(
                context,
                '😌',
                'mood_calm'.tr,
                (mood) => selectedMood = mood,
              ),
              _buildMoodOption(
                context,
                '😐',
                'mood_neutral'.tr,
                (mood) => selectedMood = mood,
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            controller: noteController,
            decoration: InputDecoration(
              labelText: 'mood_add_note'.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: Icon(Icons.note),
            ),
            maxLines: 2,
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (selectedMood != null) {
                  onMoodSelected(
                    selectedMood!,
                    noteController.text.isEmpty ? null : noteController.text,
                  );
                } else {
                  Get.snackbar(
                    'error'.tr,
                    'mood_select_mood'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('mood_share_mood'.tr, style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodOption(
    BuildContext context,
    String emoji,
    String label,
    Function(String) onSelect,
  ) {
    return InkWell(
      onTap: () => onSelect(label.toLowerCase()),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(fontSize: 32)),
            SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
