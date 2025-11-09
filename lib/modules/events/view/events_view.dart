import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/events_viewmodel.dart';
import 'widgets/event_calendar_widget.dart';
import 'widgets/event_card.dart';
import 'widgets/empty_events_widget.dart';
import 'widgets/add_event_dialog.dart';
import 'family_availability_view.dart';

class EventsView extends GetView<EventsViewModel> {
  const EventsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Theme.of(context).primaryColor.withOpacity(0.2)
                      : Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  controller.calendarView.value == CalendarView.month
                      ? Icons.event_rounded
                      : Icons.calendar_view_week,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.calendarView.value == CalendarView.month
                      ? 'events_calendar'.tr
                      : 'family_availability'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          actions: [
            // Toggle between Calendar and Availability views
            IconButton(
              icon: Icon(
                controller.calendarView.value == CalendarView.month
                    ? Icons.people_outline
                    : Icons.calendar_month,
              ),
              onPressed: () {
                if (controller.calendarView.value == CalendarView.month) {
                  controller.calendarView.value = CalendarView.availability;
                } else {
                  controller.calendarView.value = CalendarView.month;
                }
              },
              tooltip: controller.calendarView.value == CalendarView.month
                  ? 'view_availability'.tr
                  : 'view_calendar'.tr,
            ),
          ],
        ),
        body: controller.calendarView.value == CalendarView.availability
            ? FamilyAvailabilityView()
            : Column(
                children: [
                  // Calendar View - Events Mode
                  EventCalendarWidget(mode: CalendarDisplayMode.events),

                  // Events List for Selected Day
                  Expanded(
                    child: Obx(() {
                      final selectedEvents = controller.selectedEvents;

                      if (selectedEvents.isEmpty) {
                        return EmptyEventsWidget();
                      }

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: selectedEvents.length,
                        itemBuilder: (context, index) {
                          final event = selectedEvents[index];
                          return EventCard(event: event);
                        },
                      );
                    }),
                  ),
                ],
              ),
        floatingActionButton:
            controller.calendarView.value == CalendarView.availability
            ? null
            : FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddEventDialog(),
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
                label: Text(
                  'add_event'.tr,
                  style: TextStyle(
                    color: isDarkMode ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                elevation: isDarkMode ? 4 : 6,
              ),
      );
    });
  }
}
