import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../core/services/event_service.dart';

enum CalendarView { month, week }

class EventsViewModel extends GetxController {
  final EventService _eventService = Get.find<EventService>();

  // Observable properties
  final focusedDay = DateTime.now().obs;
  final selectedDay = DateTime.now().obs;
  final calendarView = CalendarView.month.obs;

  // Get events for selected day
  List<EventModel> get selectedEvents {
    return _eventService.getEventsForDate(selectedDay.value);
  }

  // Get events for a specific day (for calendar markers)
  List<EventModel> getEventsForDay(DateTime day) {
    return _eventService.getEventsForDate(day);
  }

  // Handle day selection
  void onDaySelected(DateTime day) {
    selectedDay.value = day;
  }

  // Navigate to previous month
  void previousMonth() {
    focusedDay.value = DateTime(
      focusedDay.value.year,
      focusedDay.value.month - 1,
    );
  }

  // Navigate to next month
  void nextMonth() {
    focusedDay.value = DateTime(
      focusedDay.value.year,
      focusedDay.value.month + 1,
    );
  }

  // Toggle calendar view
  void toggleView() {
    calendarView.value = calendarView.value == CalendarView.month
        ? CalendarView.week
        : CalendarView.month;
  }

  // Get all events
  List<EventModel> get allEvents => _eventService.events;

  // Get upcoming events
  List<EventModel> get upcomingEvents => _eventService.upcomingEvents;

  // Get today's events
  List<EventModel> get todayEvents => _eventService.todayEvents;
}
