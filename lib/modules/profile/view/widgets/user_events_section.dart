import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/event_service.dart';
import '../../../../data/models/event_model.dart';
import '../../../../widgets/section_header.dart';
import '../../../events/view/widgets/event_details_sheet.dart';

class UserEventsSection extends StatelessWidget {
  final String? userId;

  const UserEventsSection({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventService = Get.find<EventService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      // Get events related to this user
      final userEvents = eventService.events.where((event) {
        if (userId == null) return true;
        return event.userId == userId;
      }).toList()..sort((a, b) => b.date.compareTo(a.date));

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
                title: 'Events',
                icon: Icons.event_rounded,
                iconGradient: LinearGradient(
                  colors: [Colors.purple, Colors.purple.withOpacity(0.7)],
                ),
                actionText: '${userEvents.length}',
                onActionPressed: () {},
              ),
            ),

            // Events List
            if (userEvents.isEmpty)
              Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_busy_rounded,
                        size: 48,
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No events yet',
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
                itemCount: userEvents.length > 5 ? 5 : userEvents.length,
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final event = userEvents[index];
                  return _buildEventItem(context, event, isDark);
                },
              ),

            // See all button if more than 5
            if (userEvents.length > 5)
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextButton(
                  onPressed: () => Get.toNamed('/events'),
                  child: Text('View all ${userEvents.length} events'),
                  style: TextButton.styleFrom(foregroundColor: Colors.purple),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildEventItem(BuildContext context, EventModel event, bool isDark) {
    final eventColor = _getEventColor(event.type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => EventDetailsSheet.show(context, event),
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
              // Event Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: eventColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: eventColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(event.icon, style: TextStyle(fontSize: 20)),
                ),
              ),
              SizedBox(width: 12),

              // Event Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      DateFormat('MMM d, yyyy').format(event.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Event type badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: eventColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getEventTypeName(event.type),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: eventColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getEventColor(EventType type) {
    switch (type) {
      case EventType.birthday:
        return Colors.pink;
      case EventType.anniversary:
        return Colors.red;
      case EventType.holiday:
        return Colors.orange;
      case EventType.familyEvent:
        return Colors.green;
      case EventType.appointment:
        return Colors.blue;
      case EventType.reminder:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getEventTypeName(EventType type) {
    switch (type) {
      case EventType.birthday:
        return 'Birthday';
      case EventType.anniversary:
        return 'Anniversary';
      case EventType.holiday:
        return 'Holiday';
      case EventType.familyEvent:
        return 'Family';
      case EventType.appointment:
        return 'Appointment';
      case EventType.reminder:
        return 'Reminder';
      case EventType.other:
        return 'Other';
    }
  }
}
