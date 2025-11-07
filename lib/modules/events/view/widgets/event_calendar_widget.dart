import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../viewmodel/events_viewmodel.dart';

class EventCalendarWidget extends GetView<EventsViewModel> {
  const EventCalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final focusedMonth = controller.focusedDay.value;
      final selectedDay = controller.selectedDay.value;

      return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
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
          children: [
            // Calendar Header
            _buildCalendarHeader(context, focusedMonth, isDark),
            SizedBox(height: 16),

            // Weekday headers
            _buildWeekdayHeaders(context),
            SizedBox(height: 8),

            // Calendar Grid
            ..._buildCalendarGrid(context, focusedMonth, selectedDay, isDark),
          ],
        ),
      );
    });
  }

  Widget _buildCalendarHeader(
    BuildContext context,
    DateTime focusedMonth,
    bool isDark,
  ) {
    return Row(
      children: [
        IconButton(
          onPressed: controller.previousMonth,
          icon: Icon(Icons.chevron_left),
          color: Theme.of(context).primaryColor,
        ),
        Expanded(
          child: Text(
            DateFormat('MMMM yyyy').format(focusedMonth),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        IconButton(
          onPressed: controller.nextMonth,
          icon: Icon(Icons.chevron_right),
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
          .map(
            (day) => Container(
              width: 40,
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: day == 'S'
                      ? Colors.red[400]
                      : Theme.of(context).primaryColor,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  List<Widget> _buildCalendarGrid(
    BuildContext context,
    DateTime focusedMonth,
    DateTime selectedDay,
    bool isDark,
  ) {
    final daysInMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month + 1,
      0,
    ).day;

    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday % 7;
    final now = DateTime.now();

    return List.generate((daysInMonth + startingWeekday + 6) ~/ 7, (weekIndex) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (dayIndex) {
            final dayNumber = weekIndex * 7 + dayIndex - startingWeekday + 1;

            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return Container(width: 40, height: 40);
            }

            final date = DateTime(
              focusedMonth.year,
              focusedMonth.month,
              dayNumber,
            );

            final isSelected = _isSameDay(date, selectedDay);
            final isToday = _isSameDay(date, now);
            final isSunday = dayIndex == 0;
            final events = controller.getEventsForDay(date);
            final hasEvents = events.isNotEmpty;

            return InkWell(
              onTap: () => controller.onDaySelected(date),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : isToday
                      ? Colors.green.withOpacity(0.15)
                      : null,
                  shape: BoxShape.circle,
                  border: isToday && !isSelected
                      ? Border.all(color: Colors.green, width: 2)
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      dayNumber.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected || isToday
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : isToday
                            ? Colors.green[900]
                            : isSunday
                            ? Colors.red[400]
                            : isDark
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    if (hasEvents)
                      Positioned(
                        bottom: 4,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
