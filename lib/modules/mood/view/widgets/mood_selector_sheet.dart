import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoodSelectorSheet extends StatefulWidget {
  final Function(String mood, String? note) onMoodSelected;

  const MoodSelectorSheet({Key? key, required this.onMoodSelected})
    : super(key: key);

  @override
  State<MoodSelectorSheet> createState() => _MoodSelectorSheetState();
}

class _MoodSelectorSheetState extends State<MoodSelectorSheet> {
  final TextEditingController noteController = TextEditingController();
  String? selectedMood;

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final handleColor = isDark ? Colors.grey[700] : Colors.grey[300];

    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: handleColor,
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
                'happy',
                (mood) => selectedMood = mood,
              ),
              _buildMoodOption(
                context,
                '😢',
                'mood_sad'.tr,
                'sad',
                (mood) => selectedMood = mood,
              ),
              _buildMoodOption(
                context,
                '😠',
                'mood_angry'.tr,
                'angry',
                (mood) => selectedMood = mood,
              ),
              _buildMoodOption(
                context,
                '😰',
                'mood_anxious'.tr,
                'anxious',
                (mood) => selectedMood = mood,
              ),
              _buildMoodOption(
                context,
                '😴',
                'mood_tired'.tr,
                'tired',
                (mood) => selectedMood = mood,
              ),
              _buildMoodOption(
                context,
                '😎',
                'mood_excited'.tr,
                'excited',
                (mood) => selectedMood = mood,
              ),
              _buildMoodOption(
                context,
                '😌',
                'mood_calm'.tr,
                'calm',
                (mood) => selectedMood = mood,
              ),
              _buildMoodOption(
                context,
                '😐',
                'mood_neutral'.tr,
                'neutral',
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
                  widget.onMoodSelected(
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
    String moodKey,
    Function(String) onSelect,
  ) {
    final isSelected = selectedMood == moodKey;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedBg = isDark ? Color(0xFF1E1E1E) : Colors.grey[100];
    final unselectedBorder = isDark ? Colors.grey[700]! : Colors.grey[300]!;

    return InkWell(
      onTap: () {
        setState(() {
          selectedMood = moodKey;
        });
        onSelect(moodKey);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : unselectedBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : unselectedBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(fontSize: 32)),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Theme.of(context).primaryColor : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
