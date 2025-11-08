import 'package:flutter/material.dart';

class DateSeparator extends StatelessWidget {
  final DateTime date;
  final bool isDark;

  const DateSeparator({Key? key, required this.date, required this.isDark})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final isYesterday =
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1;

    String dateText;
    if (isToday) {
      dateText = 'Today';
    } else if (isYesterday) {
      dateText = 'Yesterday';
    } else {
      dateText = '${date.day}/${date.month}/${date.year}';
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              dateText,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[500] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
          ),
        ],
      ),
    );
  }
}
