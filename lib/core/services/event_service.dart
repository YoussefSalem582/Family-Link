import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/event_model.dart';

class EventService extends GetxService {
  final _storage = GetStorage();
  final RxList<EventModel> events = <EventModel>[].obs;

  static const String _storageKey = 'events_data';

  @override
  void onInit() {
    super.onInit();
    _loadEvents();
  }

  // Load events from storage
  void _loadEvents() {
    try {
      final savedEvents = _storage.read<List>(_storageKey);
      if (savedEvents != null) {
        events.value = savedEvents
            .map((json) => EventModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();

        // Check if demo_user_1 has any events, if not add demo events for them
        final hasUserEvents = events.any((e) => e.userId == 'demo_user_1');
        if (!hasUserEvents) {
          _addDemoUserEvents();
        }
      } else {
        // Load demo events
        _loadDemoEvents();
      }
    } catch (e) {
      print('Error loading events: $e');
      _loadDemoEvents();
    }
  }

  // Add demo events for the current user
  void _addDemoUserEvents() {
    final now = DateTime.now();
    final demoUserEvents = [
      EventModel(
        id: 'demo_event_1',
        title: 'My Doctor Appointment',
        description: 'Annual health checkup',
        date: DateTime(now.year, now.month, now.day + 3),
        type: EventType.appointment,
        userId: 'demo_user_1',
        userName: 'Demo User',
        isRecurring: false,
      ),
      EventModel(
        id: 'demo_event_2',
        title: 'My Birthday',
        description: 'Celebrate my birthday with family',
        date: DateTime(now.year, now.month, now.day + 10),
        type: EventType.birthday,
        userId: 'demo_user_1',
        userName: 'Demo User',
        isRecurring: true,
      ),
      EventModel(
        id: 'demo_event_3',
        title: 'Work Meeting',
        description: 'Important team meeting',
        date: DateTime(now.year, now.month, now.day + 1),
        type: EventType.other,
        userId: 'demo_user_1',
        userName: 'Demo User',
        isRecurring: false,
      ),
    ];

    events.addAll(demoUserEvents);
    _saveEvents();
    print('✅ Added ${demoUserEvents.length} demo events for demo_user_1');
  }

  // Load demo events for testing
  void _loadDemoEvents() {
    final now = DateTime.now();
    events.value = [
      // Current user's events
      EventModel(
        id: 'demo_event_1',
        title: 'My Doctor Appointment',
        description: 'Annual health checkup',
        date: DateTime(now.year, now.month, now.day + 3),
        type: EventType.appointment,
        userId: 'demo_user_1',
        userName: 'Demo User',
        isRecurring: false,
      ),
      EventModel(
        id: 'demo_event_2',
        title: 'My Birthday',
        description: 'Celebrate my birthday with family',
        date: DateTime(now.year, now.month, now.day + 10),
        type: EventType.birthday,
        userId: 'demo_user_1',
        userName: 'Demo User',
        isRecurring: true,
      ),
      EventModel(
        id: 'demo_event_3',
        title: 'Work Meeting',
        description: 'Important team meeting',
        date: DateTime(now.year, now.month, now.day + 1),
        type: EventType.other,
        userId: 'demo_user_1',
        userName: 'Demo User',
        isRecurring: false,
      ),
      // Birthday events
      EventModel(
        id: '1',
        title: 'Ahmed\'s Birthday',
        description: 'Birthday celebration for Ahmed',
        date: DateTime(now.year, now.month, now.day + 2),
        type: EventType.birthday,
        userId: '1',
        userName: 'Ahmed',
        isRecurring: true,
      ),
      EventModel(
        id: '2',
        title: 'Fatima\'s Birthday',
        description: 'Birthday celebration for Fatima',
        date: DateTime(now.year, now.month, now.day + 5),
        type: EventType.birthday,
        userId: '2',
        userName: 'Fatima',
        isRecurring: true,
      ),
      // Family events
      EventModel(
        id: '3',
        title: 'Family Dinner',
        description: 'Monthly family dinner at home',
        date: DateTime(now.year, now.month, now.day + 1),
        type: EventType.familyEvent,
        isRecurring: false,
      ),
      EventModel(
        id: '4',
        title: 'Weekend Picnic',
        description: 'Family picnic at the park',
        date: DateTime(now.year, now.month, now.day + 6),
        type: EventType.familyEvent,
        isRecurring: false,
      ),
      // Holidays
      EventModel(
        id: '5',
        title: 'Eid Al-Fitr',
        description: 'Eid celebration',
        date: DateTime(now.year, now.month + 1, 15),
        type: EventType.holiday,
        isRecurring: true,
      ),
      // Appointments
      EventModel(
        id: '6',
        title: 'Doctor Appointment',
        description: 'Annual checkup for Omar',
        date: DateTime(now.year, now.month, now.day + 3),
        type: EventType.appointment,
        userId: '3',
        userName: 'Omar',
        isRecurring: false,
      ),
      // Anniversaries
      EventModel(
        id: '7',
        title: 'Wedding Anniversary',
        description: 'Parents wedding anniversary',
        date: DateTime(now.year, now.month, now.day + 7),
        type: EventType.anniversary,
        isRecurring: true,
      ),
    ];
    _saveEvents();
  }

  // Save events to storage
  void _saveEvents() {
    try {
      final eventsJson = events.map((e) => e.toJson()).toList();
      _storage.write(_storageKey, eventsJson);
    } catch (e) {
      print('Error saving events: $e');
    }
  }

  // Add new event
  void addEvent(EventModel event) {
    events.add(event);
    _saveEvents();
  }

  // Update event
  void updateEvent(EventModel event) {
    final index = events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      events[index] = event;
      _saveEvents();
    }
  }

  // Delete event
  void deleteEvent(String eventId) {
    events.removeWhere((e) => e.id == eventId);
    _saveEvents();
  }

  // Get upcoming events (within next 7 days)
  List<EventModel> get upcomingEvents {
    return events.where((e) => e.isUpcoming).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // Get today's events
  List<EventModel> get todayEvents {
    return events.where((e) => e.isToday).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // Get events by type
  List<EventModel> getEventsByType(EventType type) {
    return events.where((e) => e.type == type).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // Get events for a specific date
  List<EventModel> getEventsForDate(DateTime date) {
    return events.where((e) {
      return e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day;
    }).toList();
  }

  // Get birthdays this month
  List<EventModel> get birthdaysThisMonth {
    final now = DateTime.now();
    return events.where((e) {
      return e.type == EventType.birthday && e.date.month == now.month;
    }).toList()..sort((a, b) => a.date.day.compareTo(b.date.day));
  }
}
