import 'package:flutter/material.dart';

class MoodCard extends StatelessWidget {
  final dynamic mood;
  final Color Function(String) getMoodColor;
  final String Function(String) getMoodEmoji;
  final String Function(DateTime) formatTime;

  const MoodCard({
    Key? key,
    required this.mood,
    required this.getMoodColor,
    required this.getMoodEmoji,
    required this.formatTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = getMoodColor(mood.mood);
    final emoji = getMoodEmoji(mood.mood);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.05), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(child: Text(emoji, style: TextStyle(fontSize: 28))),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        mood.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          mood.mood,
                          style: TextStyle(
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  if (mood.note != null && mood.note!.isNotEmpty) ...[
                    Text(
                      mood.note!,
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    SizedBox(height: 4),
                  ],
                  Text(
                    formatTime(mood.date),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
