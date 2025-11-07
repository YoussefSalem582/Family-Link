import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_app_bar.dart';
import '../viewmodel/events_viewmodel.dart';
import 'widgets/event_calendar_widget.dart';
import 'widgets/event_card.dart';
import 'widgets/empty_events_widget.dart';
import 'widgets/add_event_dialog.dart';

class EventsView extends GetView<EventsViewModel> {
  const EventsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Events Calendar',
        icon: Icons.event_rounded,
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Calendar View
          EventCalendarWidget(),

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(context: context, builder: (context) => AddEventDialog());
        },
        icon: Icon(Icons.add),
        label: Text('Add Event'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
