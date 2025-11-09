import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../viewmodel/events_viewmodel.dart';
import '../../../data/models/availability_model.dart';

/// Widget for current user to view and edit their own schedule
class UserScheduleEditor extends GetView<EventsViewModel> {
  final String currentUserId;

  const UserScheduleEditor({Key? key, required this.currentUserId})
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

      // Get only current user's slots for the selected date
      final userSlots = controller.availabilitySlots.where((slot) {
        final slotDate = DateTime(
          slot.start.year,
          slot.start.month,
          slot.start.day,
        );
        return slot.userId == currentUserId &&
            slotDate.year == selectedDateOnly.year &&
            slotDate.month == selectedDateOnly.month &&
            slotDate.day == selectedDateOnly.day;
      }).toList();

      if (userSlots.isEmpty) {
        return _buildEmptyState(context);
      }

      // Sort slots by start time
      userSlots.sort((a, b) => a.start.compareTo(b.start));

      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 16),
              _buildTimelineBar(context, userSlots),
              SizedBox(height: 16),
              _buildSlotsList(context, userSlots),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.person, color: Theme.of(context).primaryColor),
        SizedBox(width: 12),
        Text(
          'Your Schedule',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.add_circle, color: Theme.of(context).primaryColor),
          tooltip: 'Add time block',
          onPressed: () => _showAddSlotDialog(context),
        ),
      ],
    );
  }

  Widget _buildTimelineBar(BuildContext context, List<AvailabilitySlot> slots) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 50,
      child: Row(
        children: slots.map((slot) {
          final isEditable = slot.userId == currentUserId;
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
            child: InkWell(
              onTap: isEditable
                  ? () => _showEditSlotDialog(context, slot)
                  : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
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
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        slot.isFree ? 'Free' : slot.activityName ?? 'Busy',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isEditable)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Icon(
                          Icons.edit,
                          size: 14,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSlotsList(BuildContext context, List<AvailabilitySlot> slots) {
    return Column(
      children: slots.map((slot) {
        return _buildSlotCard(context, slot);
      }).toList(),
    );
  }

  Widget _buildSlotCard(BuildContext context, AvailabilitySlot slot) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: isDarkMode ? 2 : 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: slot.isFree
              ? Colors.green
              : (slot.color ?? Colors.orange).withOpacity(0.8),
          child: Icon(
            slot.isFree ? Icons.schedule : Icons.event_busy,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          slot.isFree ? 'Free Time' : slot.activityName ?? 'Busy',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_formatTime(slot.start)} - ${_formatTime(slot.end)} (${slot.duration.inHours}h)',
            ),
            if (slot.location != null) ...[
              SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.location_on, size: 12, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(slot.location!, style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
            if (slot.familyWelcome) ...[
              SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.waving_hand, size: 12, color: Colors.purple),
                  SizedBox(width: 4),
                  Text(
                    'Family Welcome',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
          onPressed: () => _showEditSlotDialog(context, slot),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.calendar_today, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No schedule for this day',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add your availability to help family plan together',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _showAddSlotDialog(context),
                icon: Icon(Icons.add),
                label: Text('Add Time Block'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddSlotDialog(BuildContext context) {
    Get.snackbar(
      'Coming Soon',
      'Add time block functionality will be available soon',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }

  void _showEditSlotDialog(BuildContext context, AvailabilitySlot slot) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final activityController = TextEditingController(
      text: slot.activityName ?? '',
    );
    final locationController = TextEditingController(text: slot.location ?? '');
    bool isFree = slot.isFree;
    bool familyWelcome = slot.familyWelcome;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
          title: Row(
            children: [
              Icon(Icons.edit_calendar, color: Colors.blue),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('edit_schedule'.tr, style: TextStyle(fontSize: 20)),
                    Text(
                      '${_formatTime(slot.start)} - ${_formatTime(slot.end)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Free/Busy Toggle
                SwitchListTile(
                  title: Text('mark_as_free'.tr),
                  subtitle: Text(
                    isFree
                        ? 'available_for_activities'.tr
                        : 'busy_with_activity'.tr,
                    style: TextStyle(fontSize: 12),
                  ),
                  value: isFree,
                  onChanged: (value) {
                    setState(() => isFree = value);
                  },
                  activeColor: Colors.green,
                  contentPadding: EdgeInsets.zero,
                ),

                if (!isFree) ...[
                  SizedBox(height: 16),
                  // Activity Name
                  TextField(
                    controller: activityController,
                    decoration: InputDecoration(
                      labelText: 'activity_name'.tr,
                      hintText: 'activity_hint'.tr,
                      prefixIcon: Icon(Icons.event),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Location
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'location_optional'.tr,
                      hintText: 'location_hint'.tr,
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Family Welcome Toggle
                  SwitchListTile(
                    title: Row(
                      children: [
                        Text('family_welcome'.tr),
                        SizedBox(width: 8),
                        Icon(Icons.waving_hand, size: 18, color: Colors.purple),
                      ],
                    ),
                    subtitle: Text(
                      'others_can_join'.tr,
                      style: TextStyle(fontSize: 12),
                    ),
                    value: familyWelcome,
                    onChanged: (value) {
                      setState(() => familyWelcome = value);
                    },
                    activeColor: Colors.purple,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],

                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.blue.shade900.withOpacity(0.3)
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Changes help family find time together',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode
                                ? Colors.blue.shade200
                                : Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  '✅ ${'schedule_updated'.tr}',
                  isFree
                      ? '${'now_free'.tr} ${_formatTime(slot.start)} - ${_formatTime(slot.end)}'
                      : '${activityController.text} ${'scheduled_for'.tr} you',
                  duration: Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('save'.tr),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }
}
