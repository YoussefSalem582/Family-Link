import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/availability_model.dart';

/// Card widget showing common free time slots
class CommonFreeSlotCard extends StatelessWidget {
  final CommonFreeSlot slot;

  const CommonFreeSlotCard({Key? key, required this.slot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isEveryone = slot.isEveryoneAvailable;
    final percentage = slot.availabilityPercentage.toInt();

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isDarkMode ? 3 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? (isEveryone
                            ? Colors.green.withOpacity(0.3)
                            : Colors.blue.withOpacity(0.3))
                      : (isEveryone ? Colors.green[100] : Colors.blue[100]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isEveryone ? Icons.check_circle : Icons.group,
                  color: isEveryone ? Colors.green : Colors.blue,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_formatTime(slot.start)} - ${_formatTime(slot.end)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      slot.availableMemberNames.join(', '),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${'available'.tr}: ${slot.availableCount}/${slot.totalMembers}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isEveryone ? Colors.green : Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
