import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onCalendarTap;
  final VoidCallback? onTodayTap;
  final bool isToday;

  const CalendarHeader({
    Key? key,
    required this.selectedDate,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onCalendarTap,
    this.onTodayTap,
    required this.isToday,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main date row with navigation
          Row(
            children: [
              // Previous day button
              IconButton(
                onPressed: onPreviousDay,
                icon: Icon(Icons.chevron_left),
                color: Theme.of(context).primaryColor,
                tooltip: 'Previous day',
              ),

              // Date display (tappable for calendar)
              Expanded(
                child: InkWell(
                  onTap: onCalendarTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Column(
                      children: [
                        // Day name and date
                        Text(
                          DateFormat('EEEE').format(selectedDate),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              DateFormat('d').format(selectedDate),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                height: 1,
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat('MMM').format(selectedDate),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  DateFormat('yyyy').format(selectedDate),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        // Calendar icon hint
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Colors.grey[400],
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Tap to select date',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Next day button
              IconButton(
                onPressed: onNextDay,
                icon: Icon(Icons.chevron_right),
                color: Theme.of(context).primaryColor,
                tooltip: 'Next day',
              ),
            ],
          ),

          // Quick action buttons
          if (!isToday) ...[
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: onTodayTap,
                  icon: Icon(Icons.today, size: 18),
                  label: Text('Jump to Today'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    side: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ],

          // Date indicator badges
          SizedBox(height: 8),
          _buildDateBadges(context),
        ],
      ),
    );
  }

  Widget _buildDateBadges(BuildContext context) {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));
    final tomorrow = now.add(Duration(days: 1));

    String badge = '';
    Color badgeColor = Colors.grey;

    if (_isSameDay(selectedDate, now)) {
      badge = 'TODAY';
      badgeColor = Colors.green;
    } else if (_isSameDay(selectedDate, yesterday)) {
      badge = 'YESTERDAY';
      badgeColor = Colors.orange;
    } else if (_isSameDay(selectedDate, tomorrow)) {
      badge = 'TOMORROW';
      badgeColor = Colors.blue;
    } else if (selectedDate.isBefore(now)) {
      final diff = now.difference(selectedDate).inDays;
      badge = '$diff ${diff == 1 ? 'DAY' : 'DAYS'} AGO';
      badgeColor = Colors.grey;
    } else {
      final diff = selectedDate.difference(now).inDays;
      badge = 'IN $diff ${diff == 1 ? 'DAY' : 'DAYS'}';
      badgeColor = Colors.purple;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        badge,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: badgeColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
