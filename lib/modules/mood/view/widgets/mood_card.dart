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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.grey.withOpacity(0.1);
    final gradEnd = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final noteColor = isDark ? Colors.grey[300] : Colors.grey[700];
    final timeColor = isDark ? Colors.grey[600] : Colors.grey[500];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            colors: [color.withOpacity(0.05), gradEnd],
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
                border: Border.all(color: color.withOpacity(0.3), width: 2),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        mood.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
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
                  const SizedBox(height: 4),
                  if (mood.note != null && mood.note!.isNotEmpty) ...[
                    Text(
                      mood.note!,
                      style: TextStyle(color: noteColor, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    formatTime(mood.date),
                    style: TextStyle(color: timeColor, fontSize: 12),
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
