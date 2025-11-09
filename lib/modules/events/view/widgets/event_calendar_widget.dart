import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../viewmodel/events_viewmodel.dart';

enum CalendarDisplayMode {
  events, // Show only events
  availability, // Show only availability
  combined, // Show both events and availability
}

class EventCalendarWidget extends GetView<EventsViewModel> {
  final CalendarDisplayMode mode;

  const EventCalendarWidget({
    Key? key,
    this.mode = CalendarDisplayMode.combined,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final focusedMonth = controller.focusedDay.value;
      final selectedDay = controller.selectedDay.value;
      // Watch availability slots to update dots when data changes
      controller.availabilitySlots.length;

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

            SizedBox(height: 16),

            // Legend
            _buildLegend(context, isDark),
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

  Widget _buildLegend(BuildContext context, bool isDark) {
    // Build legend based on display mode
    final List<Widget> legendItems = [];

    // Add event indicator if showing events
    if (mode == CalendarDisplayMode.events ||
        mode == CalendarDisplayMode.combined) {
      legendItems.add(
        _buildLegendItem(
          context,
          color: Theme.of(context).primaryColor,
          label: 'events'.tr,
          isDark: isDark,
        ),
      );
    }

    // Add availability indicators if showing availability
    if (mode == CalendarDisplayMode.availability ||
        mode == CalendarDisplayMode.combined) {
      legendItems.add(
        _buildLegendItem(
          context,
          color: Colors.blue[600]!,
          label: 'free_time'.tr,
          isDark: isDark,
        ),
      );
      legendItems.add(
        _buildLegendItem(
          context,
          color: Colors.amber[700]!,
          label: 'busy_time'.tr,
          isDark: isDark,
        ),
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: legendItems,
    );
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required Color color,
    required String label,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.grey[300] : Colors.grey[800],
          ),
        ),
      ],
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

            // Check availability for this date
            final hasAvailability = _hasAvailabilityForDate(date);
            final hasFreeTime = _hasFreeTimeForDate(date);

            // Determine what to show based on mode
            final showEvents =
                (mode == CalendarDisplayMode.events ||
                    mode == CalendarDisplayMode.combined) &&
                hasEvents;
            final showFreeTime =
                (mode == CalendarDisplayMode.availability ||
                    mode == CalendarDisplayMode.combined) &&
                hasFreeTime;
            final showBusyTime =
                (mode == CalendarDisplayMode.availability ||
                    mode == CalendarDisplayMode.combined) &&
                hasAvailability;

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
                    // Event indicator (purple dot) - centered at bottom
                    if (showEvents)
                      Positioned(
                        bottom: 3,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: isSelected
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 1,
                                      offset: Offset(0, 0.5),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                    // Availability indicators (row of dots) - positioned higher
                    if (showFreeTime || showBusyTime)
                      Positioned(
                        bottom: showEvents
                            ? 10
                            : 3, // Move up if event dot exists
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Free time indicator (blue dot)
                            if (showFreeTime)
                              Container(
                                width: 4,
                                height: 4,
                                margin: EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.95)
                                      : Colors.blue[600],
                                  shape: BoxShape.circle,
                                  boxShadow: isSelected
                                      ? null
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 1,
                                            offset: Offset(0, 0.5),
                                          ),
                                        ],
                                ),
                              ),
                            // Busy time indicator (amber dot)
                            if (showBusyTime)
                              Container(
                                width: 4,
                                height: 4,
                                margin: EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.95)
                                      : Colors.amber[700],
                                  shape: BoxShape.circle,
                                  boxShadow: isSelected
                                      ? null
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 1,
                                            offset: Offset(0, 0.5),
                                          ),
                                        ],
                                ),
                              ),
                          ],
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

  /// Check if date has any availability slots (busy time)
  bool _hasAvailabilityForDate(DateTime date) {
    return controller.availabilitySlots.any((slot) {
      final slotDate = DateTime(
        slot.start.year,
        slot.start.month,
        slot.start.day,
      );
      return _isSameDay(slotDate, date) && !slot.isFree;
    });
  }

  /// Check if date has any free time slots
  bool _hasFreeTimeForDate(DateTime date) {
    return controller.availabilitySlots.any((slot) {
      final slotDate = DateTime(
        slot.start.year,
        slot.start.month,
        slot.start.day,
      );
      return _isSameDay(slotDate, date) && slot.isFree;
    });
  }
}
