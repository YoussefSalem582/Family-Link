import 'package:flutter/material.dart';
import '../../../../data/models/event_model.dart';
import 'event_details_sheet.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final eventColor = _getEventColor(event.type);
    final isToday = event.isToday;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isToday
              ? eventColor
              : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
          width: isToday ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isToday
                ? eventColor.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => EventDetailsSheet.show(context, event),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Event Icon
                _buildEventIcon(eventColor),
                SizedBox(width: 16),

                // Event Details
                Expanded(
                  child: _buildEventDetails(context, isDark, eventColor),
                ),

                // Arrow Icon
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventIcon(Color eventColor) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: eventColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: eventColor.withOpacity(0.3), width: 1.5),
      ),
      child: Center(child: Text(event.icon, style: TextStyle(fontSize: 28))),
    );
  }

  Widget _buildEventDetails(
    BuildContext context,
    bool isDark,
    Color eventColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                event.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (event.isRecurring)
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: eventColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: eventColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.repeat_rounded, size: 12, color: eventColor),
                    SizedBox(width: 4),
                    Text(
                      'Yearly',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: eventColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          event.description,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (event.userName != null) ...[
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                size: 14,
                color: isDark ? Colors.grey[500] : Colors.grey[600],
              ),
              SizedBox(width: 4),
              Text(
                event.userName!,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              SizedBox(width: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: eventColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getEventTypeName(event.type),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: eventColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
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
        return 'Family Event';
      case EventType.appointment:
        return 'Appointment';
      case EventType.reminder:
        return 'Reminder';
      case EventType.other:
        return 'Other';
    }
  }
}
