import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/family_availability_viewmodel.dart';
import '../viewmodel/events_viewmodel.dart';
import '../data/models/availability_model.dart';
import 'widgets/event_calendar_widget.dart';
import 'widgets/family_availability_view/user_schedule_editor.dart';
import 'widgets/family_availability_view/family_schedule_overview.dart';
import 'widgets/family_availability_view/event_suggestion_card.dart';
import 'widgets/family_availability_view/common_free_slot_card.dart';
import 'widgets/family_availability_view/family_welcome_activity_card.dart';

/// Main widget for Family Availability Calendar view
/// Focuses on current user's schedule management with family context
///
/// DATA FLOW & DATE FILTERING:
/// ┌─────────────────────────────────────────────────────────────┐
/// │ EventCalendarWidget (CalendarDisplayMode.availability)      │
/// │ - Uses: controller.selectedDay (shared date)                │
/// │ - Watches: controller.availabilitySlots.length              │
/// │ - Shows: availability dots on calendar dates                │
/// └──────────────────┬──────────────────────────────────────────┘
///                    │ User selects date
///                    ↓
/// ┌─────────────────────────────────────────────────────────────┐
/// │ controller.onDaySelected(date)                              │
/// │ - Updates: controller.selectedDay                           │
/// │ - Triggers: loadAvailabilityData()                          │
/// │ - Generates data for selected date only                     │
/// └──────────────────┬──────────────────────────────────────────┘
///                    │ Data loaded & filtered by selectedDay
///                    ↓
/// ┌─────────────────────────────────────────────────────────────┐
/// │ All widgets filter data by selectedDay:                     │
/// │ ✅ UserScheduleEditor → filters by userId + selectedDay     │
/// │ ✅ EventSuggestions → generated for selectedDay             │
/// │ ✅ CommonFreeSlots → calculated for selectedDay             │
/// │ ✅ FamilyWelcomeActivities → filtered by selectedDay        │
/// │ ✅ FamilyScheduleOverview → filters by selectedDay          │
/// └─────────────────────────────────────────────────────────────┘
class FamilyAvailabilityView extends GetView<FamilyAvailabilityViewModel> {
  const FamilyAvailabilityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure ViewModels are registered
    if (!Get.isRegistered<EventsViewModel>()) {
      Get.put(EventsViewModel());
    }
    if (!Get.isRegistered<FamilyAvailabilityViewModel>()) {
      Get.put(FamilyAvailabilityViewModel());
    }

    return Obx(() {
      if (controller.isLoadingAvailability.value) {
        return Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: () => controller.refreshAvailabilityData(),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Calendar Widget - Availability Mode (synced with selectedDay)
            EventCalendarWidget(mode: CalendarDisplayMode.availability),
            SizedBox(height: 8),

            // Date info - shows what date the data below is for
            _buildDateInfo(context),
            SizedBox(height: 16),

            // Current User's Schedule - Primary Focus
            // All data below automatically updates when calendar date changes
            _buildSectionHeader('Your Schedule', context),
            SizedBox(height: 12),
            Obx(() {
              // Reactive rebuild when date or availability data changes
              controller.selectedDay.value;
              controller.availabilitySlots.length;
              return UserScheduleEditor(
                currentUserId: FamilyAvailabilityViewModel.currentUserId,
              );
            }),
            SizedBox(height: 24),

            // Event Suggestions Section
            // Generated based on selected date's availability
            Obx(() {
              if (controller.eventSuggestions.isEmpty) return SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('suggested_family_time'.tr, context),
                  SizedBox(height: 12),
                  ...controller.eventSuggestions.map((suggestion) {
                    return EventSuggestionCard(
                      suggestion: suggestion,
                      onTap: () => _showScheduleDialog(context, suggestion),
                    );
                  }),
                  SizedBox(height: 24),
                ],
              );
            }),

            // Common Free Slots Section
            _buildSectionHeader('find_time_together'.tr, context),
            SizedBox(height: 12),
            Obx(
              () => Column(
                children: controller.commonFreeSlots.map((slot) {
                  return CommonFreeSlotCard(slot: slot);
                }).toList(),
              ),
            ),
            SizedBox(height: 24),

            // Family Welcome Activities
            Obx(() {
              if (controller.familyWelcomeActivities.isEmpty)
                return SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('family_welcome_activities'.tr, context),
                  SizedBox(height: 12),
                  ...controller.familyWelcomeActivities.map((activity) {
                    return FamilyWelcomeActivityCard(activity: activity);
                  }),
                  SizedBox(height: 24),
                ],
              );
            }),

            // Family Schedule Overview (Read-only)
            _buildSectionHeader('Family Schedule', context),
            SizedBox(height: 12),
            Obx(() {
              // Reactive rebuild when availability data changes
              controller.availabilitySlots.length;
              return FamilyScheduleOverview(
                currentUserId: FamilyAvailabilityViewModel.currentUserId,
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDateInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).primaryColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today,
                size: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.isSelectedDateToday
                        ? 'Today\'s Schedule'
                        : 'Schedule for ${controller.formattedSelectedDate}',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${controller.slotsForSelectedDate} time slot${controller.slotsForSelectedDate != 1 ? 's' : ''} loaded',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Theme.of(context).primaryColor),
          ],
        ),
      );
    });
  }

  void _showScheduleDialog(
    BuildContext context,
    FamilyEventSuggestion suggestion,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(suggestion.emoji, style: TextStyle(fontSize: 32)),
            SizedBox(width: 12),
            Expanded(
              child: Text(suggestion.title, style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, size: 20),
                SizedBox(width: 8),
                Text(
                  '${controller.formatTime(suggestion.timeSlot.start)} - ${controller.formatTime(suggestion.timeSlot.end)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (suggestion.description != null) Text(suggestion.description!),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.group, size: 20),
                SizedBox(width: 8),
                Text(
                  '${suggestion.timeSlot.availableCount} of ${suggestion.timeSlot.totalMembers} available',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: suggestion.timeSlot.availableMemberNames
                  .map(
                    (name) => Chip(
                      label: Text(name, style: TextStyle(fontSize: 11)),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              controller.scheduleSuggestedEvent(suggestion);
            },
            icon: Icon(Icons.event_available),
            label: Text('schedule_event'.tr),
          ),
        ],
      ),
    );
  }
}
