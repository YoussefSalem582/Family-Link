import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../viewmodel/events_viewmodel.dart';
import '../../../data/models/availability_model.dart';

/// Widget showing family members' schedules (read-only view)
class FamilyScheduleOverview extends GetView<EventsViewModel> {
  final String currentUserId;

  const FamilyScheduleOverview({Key? key, required this.currentUserId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDate = controller.selectedDay.value;
      final selectedDateOnly = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );

      // Get other family members (exclude current user) for selected date
      final uniqueMembers = <String, Map<String, String>>{};
      for (var slot in controller.availabilitySlots) {
        final slotDate = DateTime(
          slot.start.year,
          slot.start.month,
          slot.start.day,
        );
        final isSelectedDate =
            slotDate.year == selectedDateOnly.year &&
            slotDate.month == selectedDateOnly.month &&
            slotDate.day == selectedDateOnly.day;

        if (slot.userId != currentUserId &&
            isSelectedDate &&
            !uniqueMembers.containsKey(slot.userId)) {
          uniqueMembers[slot.userId] = {
            'id': slot.userId,
            'name': slot.userName,
          };
        }
      }

      if (uniqueMembers.isEmpty) {
        return SizedBox.shrink();
      }

      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.groups, color: Theme.of(context).primaryColor),
                  SizedBox(width: 12),
                  Text(
                    'Family Schedule',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ...uniqueMembers.values.map((member) {
                final memberSlots = controller.availabilitySlots.where((s) {
                  final slotDate = DateTime(
                    s.start.year,
                    s.start.month,
                    s.start.day,
                  );
                  return s.userId == member['id'] &&
                      slotDate.year == selectedDateOnly.year &&
                      slotDate.month == selectedDateOnly.month &&
                      slotDate.day == selectedDateOnly.day;
                }).toList();
                return _buildMemberTimeline(
                  context,
                  member['name']!,
                  memberSlots,
                );
              }).toList(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMemberTimeline(
    BuildContext context,
    String name,
    List<AvailabilitySlot> slots,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Row(
            children: slots.map((slot) {
              Color backgroundColor;
              Color textColor = Colors.white;

              if (slot.isFree) {
                backgroundColor = isDarkMode
                    ? Colors.green.shade700.withOpacity(0.7)
                    : Colors.green.shade400;
              } else {
                final baseColor = slot.color ?? Colors.orange;
                backgroundColor = isDarkMode
                    ? baseColor.withOpacity(0.8)
                    : Color.lerp(baseColor, Colors.black, 0.2)!;
              }

              return Expanded(
                flex: slot.duration.inHours.clamp(1, 24),
                child: Container(
                  height: 40,
                  margin: EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: slot.familyWelcome
                        ? Border.all(
                            color: isDarkMode
                                ? Colors.purple.shade300
                                : Colors.purple.shade700,
                            width: 2.5,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      slot.isFree ? 'Free' : slot.activityName ?? 'Busy',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
