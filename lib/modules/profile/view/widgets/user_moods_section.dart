import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/mood_model.dart';
import '../../../mood/viewmodel/mood_viewmodel.dart';
import '../../../../widgets/section_header.dart';

class UserMoodsSection extends StatelessWidget {
  final String? userId;

  const UserMoodsSection({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moodViewModel = Get.find<MoodViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      // Get moods by this user
      final userMoods = moodViewModel.todaysMoods.where((mood) {
        if (userId == null) return true;
        return mood.userId == userId;
      }).toList();

      // Sort by date descending
      userMoods.sort((a, b) => b.date.compareTo(a.date));

      return Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: SectionHeader(
                title: 'Mood Tracker',
                icon: Icons.emoji_emotions,
                iconGradient: LinearGradient(
                  colors: [Colors.orange, Colors.orange.withOpacity(0.7)],
                ),
                actionText: '${userMoods.length}',
                onActionPressed: () {},
              ),
            ),

            // Moods List
            if (userMoods.isEmpty)
              Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.emoji_emotions_outlined,
                        size: 48,
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No moods recorded yet',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                itemCount: userMoods.length > 5 ? 5 : userMoods.length,
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final mood = userMoods[index];
                  return _buildMoodItem(context, mood, isDark);
                },
              ),

            // See all button if more than 5
            if (userMoods.length > 5)
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextButton(
                  onPressed: () => Get.toNamed('/mood'),
                  child: Text('View all ${userMoods.length} moods'),
                  style: TextButton.styleFrom(foregroundColor: Colors.orange),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildMoodItem(BuildContext context, MoodModel mood, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed('/mood'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: Row(
            children: [
              // Emoji
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getMoodColor(mood.mood).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(mood.emoji, style: TextStyle(fontSize: 24)),
                ),
              ),
              SizedBox(width: 12),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getMoodName(mood.mood),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, yyyy').format(mood.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    if (mood.note != null && mood.note!.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        mood.note!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Mood badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getMoodColor(mood.mood).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getMoodColor(mood.mood).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _getMoodName(mood.mood),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getMoodColor(mood.mood),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return Colors.yellow[700]!;
      case 'sad':
        return Colors.blue;
      case 'excited':
        return Colors.orange;
      case 'tired':
        return Colors.grey;
      case 'angry':
        return Colors.red;
      case 'anxious':
        return Colors.purple;
      case 'calm':
        return Colors.green;
      case 'stressed':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  String _getMoodName(String mood) {
    return mood[0].toUpperCase() + mood.substring(1).toLowerCase();
  }
}
