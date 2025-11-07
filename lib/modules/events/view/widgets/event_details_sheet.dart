import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/event_model.dart';
import '../../../../core/services/event_service.dart';
import 'package:get/get.dart';
import 'add_event_dialog.dart';

class EventDetailsSheet extends StatelessWidget {
  final EventModel event;

  const EventDetailsSheet({Key? key, required this.event}) : super(key: key);

  static void show(BuildContext context, EventModel event) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.all(24),
        child: EventDetailsSheet(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final eventColor = _getEventColor(event.type);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Handle bar
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[700] : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        SizedBox(height: 24),

        // Event icon and title
        _buildEventHeader(context, isDark, eventColor),
        SizedBox(height: 24),

        // Event details
        _buildDetailRow(
          context,
          Icons.description_rounded,
          'Description',
          event.description,
          isDark,
        ),
        SizedBox(height: 16),
        _buildDetailRow(
          context,
          Icons.calendar_today_rounded,
          'Date',
          DateFormat('EEEE, MMMM d, yyyy').format(event.date),
          isDark,
        ),
        if (event.userName != null) ...[
          SizedBox(height: 16),
          _buildDetailRow(
            context,
            Icons.person_rounded,
            'Related to',
            event.userName!,
            isDark,
          ),
        ],
        if (event.isRecurring) ...[
          SizedBox(height: 16),
          _buildDetailRow(
            context,
            Icons.repeat_rounded,
            'Recurring',
            'Yearly',
            isDark,
          ),
        ],
        SizedBox(height: 24),

        // Action buttons
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildEventHeader(
    BuildContext context,
    bool isDark,
    Color eventColor,
  ) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: eventColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: eventColor.withOpacity(0.3), width: 2),
          ),
          child: Center(
            child: Text(event.icon, style: TextStyle(fontSize: 32)),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: eventColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getEventTypeName(event.type),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: eventColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: Theme.of(context).primaryColor),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AddEventDialog(event: event),
                  );
                },
                icon: Icon(Icons.edit_rounded, size: 18),
                label: Text('Edit'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.check_rounded, size: 18),
                label: Text('Done'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        // Delete button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _deleteEvent(context),
            icon: Icon(Icons.delete_rounded, size: 18),
            label: Text('Delete Event'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  void _deleteEvent(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.orange),
            SizedBox(width: 12),
            Text('Delete Event?'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${event.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final eventService = Get.find<EventService>();
              eventService.deleteEvent(event.id);

              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(context); // Close bottom sheet

              Get.snackbar(
                'Deleted',
                'Event deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.withOpacity(0.1),
                colorText: Colors.red,
                icon: Icon(Icons.delete_rounded, color: Colors.red),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete'),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
