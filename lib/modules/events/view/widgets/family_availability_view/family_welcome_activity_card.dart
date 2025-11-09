import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/availability_model.dart';

/// Card widget for family welcome activities
class FamilyWelcomeActivityCard extends StatelessWidget {
  final AvailabilitySlot activity;

  const FamilyWelcomeActivityCard({Key? key, required this.activity})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isDarkMode ? 3 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? (activity.color?.withOpacity(0.3) ??
                            Colors.purple.withOpacity(0.3))
                      : (activity.color?.withOpacity(0.2) ??
                            Colors.purple[100]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.waving_hand,
                  color: activity.color ?? Colors.purple,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.activityName ?? 'activity'.tr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${activity.userName} • ${_formatTime(activity.start)} - ${_formatTime(activity.end)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    if (activity.location != null) ...[
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[500],
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              activity.location!,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[500],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8),
              Chip(
                label: Text(
                  'join'.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: activity.color ?? Colors.purple,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }
}
