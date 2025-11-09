import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../viewmodel/events_viewmodel.dart';
import '../../../../../widgets/calendar.dart';

/// Date selector widget for availability calendar
class AvailabilityDateSelector extends GetView<EventsViewModel> {
  const AvailabilityDateSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                final newDate = controller.selectedDay.value.subtract(
                  Duration(days: 1),
                );
                controller.changeAvailabilityDate(newDate);
              },
            ),
            Expanded(
              child: Obx(
                () => InkWell(
                  onTap: () async {
                    final selectedDate = await Calendar.show(
                      context,
                      initialDate: controller.selectedDay.value,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      availabilitySlots: controller.availabilitySlots,
                      showAvailability: true,
                    );
                    if (selectedDate != null) {
                      controller.changeAvailabilityDate(selectedDate);
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            DateFormat(
                              'EEEE, MMM d, y',
                            ).format(controller.selectedDay.value),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () {
                final newDate = controller.selectedDay.value.add(
                  Duration(days: 1),
                );
                controller.changeAvailabilityDate(newDate);
              },
            ),
            IconButton(
              icon: Icon(Icons.today),
              tooltip: 'Today',
              onPressed: () {
                controller.changeAvailabilityDate(DateTime.now());
              },
            ),
          ],
        ),
      ),
    );
  }
}
