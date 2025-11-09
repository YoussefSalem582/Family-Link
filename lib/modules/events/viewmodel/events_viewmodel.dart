import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/event_model.dart';
import '../../../core/services/event_service.dart';
import '../data/models/availability_model.dart';

enum CalendarView { month, week, availability }

class EventsViewModel extends GetxController {
  final EventService _eventService = Get.find<EventService>();

  // Observable properties
  final focusedDay = DateTime.now().obs;
  final selectedDay =
      DateTime.now().obs; // Shared by both Events and Availability views
  final calendarView = CalendarView.month.obs;

  // Family Availability
  RxList<AvailabilitySlot> availabilitySlots = <AvailabilitySlot>[].obs;
  RxList<CommonFreeSlot> commonFreeSlots = <CommonFreeSlot>[].obs;
  RxList<FamilyEventSuggestion> eventSuggestions =
      <FamilyEventSuggestion>[].obs;
  RxBool isLoadingAvailability = false.obs;

  // Get events for selected day
  List<EventModel> get selectedEvents {
    return _eventService.getEventsForDate(selectedDay.value);
  }

  // Get events for a specific day (for calendar markers)
  List<EventModel> getEventsForDay(DateTime day) {
    return _eventService.getEventsForDate(day);
  }

  // Handle day selection (unified for both events and availability)
  void onDaySelected(DateTime day) {
    selectedDay.value = day;
    loadAvailabilityData(); // Keep availability data in sync
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

  @override
  void onInit() {
    super.onInit();
    loadAvailabilityData();
  }

  // ==================== FAMILY AVAILABILITY FEATURES ====================

  /// Load availability data for the family
  Future<void> loadAvailabilityData() async {
    isLoadingAvailability.value = true;

    // Load demo data for now
    _loadDemoAvailability();
    _findCommonFreeSlots();
    _generateEventSuggestions();

    isLoadingAvailability.value = false;
  }

  /// Load demo availability data
  void _loadDemoAvailability() {
    final date = selectedDay.value;
    final today = DateTime(date.year, date.month, date.day);

    // Create demo availability slots for multiple days
    final List<AvailabilitySlot> allSlots = [];

    // Generate slots for entire current month and next month
    // Start from first day of current month
    final firstDayOfMonth = DateTime(today.year, today.month, 1);
    // End at last day of next month
    final firstDayOfNextNextMonth = DateTime(today.year, today.month + 2, 1);
    final lastDayOfNextMonth = firstDayOfNextNextMonth.subtract(
      Duration(days: 1),
    );

    // Calculate total days to generate
    final totalDays = lastDayOfNextMonth.difference(firstDayOfMonth).inDays + 1;

    for (int dayIndex = 0; dayIndex < totalDays; dayIndex++) {
      final targetDate = firstDayOfMonth.add(Duration(days: dayIndex));
      final dayStart = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
      );
      final isWeekend =
          targetDate.weekday == DateTime.saturday ||
          targetDate.weekday == DateTime.sunday;
      final isMonday = targetDate.weekday == DateTime.monday;
      final isWednesday = targetDate.weekday == DateTime.wednesday;
      final isFriday = targetDate.weekday == DateTime.friday;

      // Ahmed - Full time worker (Current User - demo_user_1)
      if (!isWeekend) {
        // Weekday work schedule
        allSlots.add(
          AvailabilitySlot(
            id: '${dayIndex}_1',
            start: dayStart.add(Duration(hours: 9)),
            end: dayStart.add(Duration(hours: 17)),
            userId: 'demo_user_1',
            userName: 'Ahmed (You)',
            isFree: false,
            activityName: 'Work',
            color: Color(0xFFFF9800),
            location: 'Office',
          ),
        );
        allSlots.add(
          AvailabilitySlot(
            id: '${dayIndex}_1b',
            start: dayStart.add(Duration(hours: 8)),
            end: dayStart.add(Duration(hours: 9)),
            userId: 'demo_user_1',
            userName: 'Ahmed (You)',
            isFree: true,
          ),
        );
      } else {
        // Weekend activities for Ahmed
        if (targetDate.weekday == DateTime.saturday) {
          // Saturday morning errands
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_1',
              start: dayStart.add(Duration(hours: 10)),
              end: dayStart.add(Duration(hours: 12)),
              userId: 'demo_user_1',
              userName: 'Ahmed (You)',
              isFree: false,
              activityName: 'Grocery Shopping',
              color: Color(0xFF9C27B0),
              location: 'Local Market',
            ),
          );
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_1b',
              start: dayStart.add(Duration(hours: 13)),
              end: dayStart.add(Duration(hours: 17)),
              userId: 'demo_user_1',
              userName: 'Ahmed (You)',
              isFree: true,
            ),
          );
        } else {
          // Sunday - family time and relaxation
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_1',
              start: dayStart.add(Duration(hours: 14)),
              end: dayStart.add(Duration(hours: 16)),
              userId: 'demo_user_1',
              userName: 'Ahmed (You)',
              isFree: false,
              activityName: 'Family Outing',
              familyWelcome: true,
              color: Color(0xFF673AB7),
              location: 'Park or Mall',
            ),
          );
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_1b',
              start: dayStart.add(Duration(hours: 9)),
              end: dayStart.add(Duration(hours: 14)),
              userId: 'demo_user_1',
              userName: 'Ahmed (You)',
              isFree: true,
            ),
          );
        }
      }
      allSlots.add(
        AvailabilitySlot(
          id: '${dayIndex}_2',
          start: dayStart.add(Duration(hours: 18)),
          end: dayStart.add(Duration(hours: 23)),
          userId: 'demo_user_1',
          userName: 'Ahmed (You)',
          isFree: true,
        ),
      );

      // Fatima - Part time schedule with variations
      if (!isWeekend) {
        allSlots.add(
          AvailabilitySlot(
            id: '${dayIndex}_3',
            start: dayStart.add(Duration(hours: 10)),
            end: dayStart.add(Duration(hours: 15)),
            userId: '2',
            userName: 'Fatima',
            isFree: false,
            activityName: 'Work',
            color: Color(0xFFFF9800),
            location: 'Office',
          ),
        );

        // Morning free time before work
        allSlots.add(
          AvailabilitySlot(
            id: '${dayIndex}_3a',
            start: dayStart.add(Duration(hours: 8)),
            end: dayStart.add(Duration(hours: 10)),
            userId: '2',
            userName: 'Fatima',
            isFree: true,
          ),
        );

        // Add doctor appointment on some Mondays
        if (isMonday && dayIndex % 14 == 0) {
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_3b',
              start: dayStart.add(Duration(hours: 16)),
              end: dayStart.add(Duration(hours: 17, minutes: 30)),
              userId: '2',
              userName: 'Fatima',
              isFree: false,
              activityName: 'Doctor Appointment',
              color: Color(0xFFF44336),
              location: 'Medical Center',
            ),
          );
        }
      } else {
        if (targetDate.weekday == DateTime.sunday) {
          // Sunday yoga class
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_3',
              start: dayStart.add(Duration(hours: 9)),
              end: dayStart.add(Duration(hours: 11)),
              userId: '2',
              userName: 'Fatima',
              isFree: false,
              activityName: 'Yoga Class',
              familyWelcome: true,
              color: Color(0xFFE91E63),
              location: 'Wellness Center',
            ),
          );
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_3a',
              start: dayStart.add(Duration(hours: 11)),
              end: dayStart.add(Duration(hours: 18)),
              userId: '2',
              userName: 'Fatima',
              isFree: true,
            ),
          );
        } else {
          // Saturday - beauty salon / personal time
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_3',
              start: dayStart.add(Duration(hours: 14)),
              end: dayStart.add(Duration(hours: 16)),
              userId: '2',
              userName: 'Fatima',
              isFree: false,
              activityName: 'Personal Time',
              color: Color(0xFFE91E63),
              location: 'Beauty Salon',
            ),
          );
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_3a',
              start: dayStart.add(Duration(hours: 9)),
              end: dayStart.add(Duration(hours: 14)),
              userId: '2',
              userName: 'Fatima',
              isFree: true,
            ),
          );
        }
      }
      allSlots.add(
        AvailabilitySlot(
          id: '${dayIndex}_4',
          start: dayStart.add(Duration(hours: 18)),
          end: dayStart.add(Duration(hours: 22)),
          userId: '2',
          userName: 'Fatima',
          isFree: true,
        ),
      );

      // Omar - School schedule (weekdays only) with extracurricular activities
      if (!isWeekend) {
        allSlots.add(
          AvailabilitySlot(
            id: '${dayIndex}_5',
            start: dayStart.add(Duration(hours: 8)),
            end: dayStart.add(Duration(hours: 14)),
            userId: '3',
            userName: 'Omar',
            isFree: false,
            activityName: 'School',
            color: Color(0xFF3F51B5),
            location: 'Cairo International School',
          ),
        );

        // Soccer practice on Wednesday and Friday
        if (isWednesday || isFriday) {
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_6',
              start: dayStart.add(Duration(hours: 15)),
              end: dayStart.add(Duration(hours: 17)),
              userId: '3',
              userName: 'Omar',
              isFree: false,
              activityName: 'Soccer Practice',
              familyWelcome: true,
              color: Color(0xFF4CAF50),
              location: 'Sports Club',
            ),
          );
        }

        // Piano lessons on Monday
        if (isMonday) {
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_6b',
              start: dayStart.add(Duration(hours: 16)),
              end: dayStart.add(Duration(hours: 17)),
              userId: '3',
              userName: 'Omar',
              isFree: false,
              activityName: 'Piano Lesson',
              color: Color(0xFF00BCD4),
              location: 'Music Academy',
            ),
          );
        }
      } else {
        // Weekend activities for Omar
        if (targetDate.weekday == DateTime.saturday) {
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_6',
              start: dayStart.add(Duration(hours: 10)),
              end: dayStart.add(Duration(hours: 12)),
              userId: '3',
              userName: 'Omar',
              isFree: false,
              activityName: 'Swimming Class',
              familyWelcome: true,
              color: Color(0xFF03A9F4),
              location: 'Community Pool',
            ),
          );
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_6a',
              start: dayStart.add(Duration(hours: 13)),
              end: dayStart.add(Duration(hours: 18)),
              userId: '3',
              userName: 'Omar',
              isFree: true,
            ),
          );
        } else {
          // Sunday - playtime and homework
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_6',
              start: dayStart.add(Duration(hours: 15)),
              end: dayStart.add(Duration(hours: 17)),
              userId: '3',
              userName: 'Omar',
              isFree: false,
              activityName: 'Homework & Study',
              color: Color(0xFF3F51B5),
              location: 'Home',
            ),
          );
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_6a',
              start: dayStart.add(Duration(hours: 10)),
              end: dayStart.add(Duration(hours: 15)),
              userId: '3',
              userName: 'Omar',
              isFree: true,
            ),
          );
        }
      }
      allSlots.add(
        AvailabilitySlot(
          id: '${dayIndex}_7',
          start: dayStart.add(Duration(hours: 18)),
          end: dayStart.add(Duration(hours: 23)),
          userId: '3',
          userName: 'Omar',
          isFree: true,
        ),
      );

      // Layla - Flexible schedule with varied activities
      if (!isWeekend) {
        allSlots.add(
          AvailabilitySlot(
            id: '${dayIndex}_8',
            start: dayStart.add(Duration(hours: 11)),
            end: dayStart.add(Duration(hours: 13)),
            userId: '4',
            userName: 'Layla',
            isFree: false,
            activityName: 'Gym Session',
            familyWelcome: true,
            color: Color(0xFFE91E63),
            location: 'Fitness Center',
            description: 'Yoga and cardio',
          ),
        );

        // Art class on Wednesday
        if (isWednesday) {
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_8b',
              start: dayStart.add(Duration(hours: 14)),
              end: dayStart.add(Duration(hours: 16)),
              userId: '4',
              userName: 'Layla',
              isFree: false,
              activityName: 'Art Class',
              familyWelcome: true,
              color: Color(0xFF9C27B0),
              location: 'Creative Studio',
            ),
          );
        }
      } else {
        // Weekend brunch with friends on Sunday
        if (targetDate.weekday == DateTime.sunday) {
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_8',
              start: dayStart.add(Duration(hours: 11)),
              end: dayStart.add(Duration(hours: 13)),
              userId: '4',
              userName: 'Layla',
              isFree: false,
              activityName: 'Brunch with Friends',
              color: Color(0xFFFF5722),
              location: 'Cafe Downtown',
            ),
          );
        } else {
          // Saturday morning hiking
          allSlots.add(
            AvailabilitySlot(
              id: '${dayIndex}_8',
              start: dayStart.add(Duration(hours: 8)),
              end: dayStart.add(Duration(hours: 11)),
              userId: '4',
              userName: 'Layla',
              isFree: false,
              activityName: 'Hiking',
              familyWelcome: true,
              color: Color(0xFF4CAF50),
              location: 'Nature Trail',
            ),
          );
        }
      }
      allSlots.add(
        AvailabilitySlot(
          id: '${dayIndex}_9',
          start: dayStart.add(Duration(hours: 15)),
          end: dayStart.add(Duration(hours: 23)),
          userId: '4',
          userName: 'Layla',
          isFree: true,
        ),
      );
    }

    availabilitySlots.value = allSlots;

    // Debug: Print generated data summary
    print('📅 Generated ${allSlots.length} availability slots');
    print(
      '📅 Date range: ${firstDayOfMonth.toString().substring(0, 10)} to ${lastDayOfNextMonth.toString().substring(0, 10)}',
    );
    print('📅 Total days covered: $totalDays');

    // Debug: Check first few days
    final nov1Slots = allSlots.where((s) {
      final d = DateTime(s.start.year, s.start.month, s.start.day);
      return d.year == 2025 && d.month == 11 && d.day == 1;
    }).length;
    final nov2Slots = allSlots.where((s) {
      final d = DateTime(s.start.year, s.start.month, s.start.day);
      return d.year == 2025 && d.month == 11 && d.day == 2;
    }).length;
    final nov9Slots = allSlots.where((s) {
      final d = DateTime(s.start.year, s.start.month, s.start.day);
      return d.year == 2025 && d.month == 11 && d.day == 9;
    }).length;
    print(
      '📅 Nov 1: $nov1Slots slots, Nov 2: $nov2Slots slots, Nov 9: $nov9Slots slots',
    );
  }

  /// Find time slots when family members are free together
  void _findCommonFreeSlots() {
    final date = selectedDay.value;
    final today = DateTime(date.year, date.month, date.day);

    // Get all unique user IDs
    final allUserIds = availabilitySlots.map((s) => s.userId).toSet().toList();
    final totalMembers = allUserIds.length;

    // Simple algorithm: find 2+ hour windows where most are free
    final List<CommonFreeSlot> slots = [];

    // Evening slot (6-9 PM) - typically best for family time
    final evening6to9 = CommonFreeSlot(
      id: 'evening_6_9',
      start: today.add(Duration(hours: 18)),
      end: today.add(Duration(hours: 21)),
      availableMembers: ['1', '2', '3', '4'],
      availableMemberNames: ['Ahmed', 'Fatima', 'Omar', 'Layla'],
      totalMembers: totalMembers,
    );
    slots.add(evening6to9);

    // Late evening slot (9-10 PM)
    final evening9to10 = CommonFreeSlot(
      id: 'evening_9_10',
      start: today.add(Duration(hours: 21)),
      end: today.add(Duration(hours: 22)),
      availableMembers: ['1', '3', '4'],
      availableMemberNames: ['Ahmed', 'Omar', 'Layla'],
      totalMembers: totalMembers,
    );
    slots.add(evening9to10);

    // Weekend morning slot (if weekend)
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      final morning10to12 = CommonFreeSlot(
        id: 'morning_10_12',
        start: today.add(Duration(hours: 10)),
        end: today.add(Duration(hours: 12)),
        availableMembers: ['1', '2', '3', '4'],
        availableMemberNames: ['Ahmed', 'Fatima', 'Omar', 'Layla'],
        totalMembers: totalMembers,
      );
      slots.insert(0, morning10to12);
    }

    commonFreeSlots.value = slots;
  }

  /// Generate smart event suggestions based on common free time
  void _generateEventSuggestions() {
    if (commonFreeSlots.isEmpty) {
      eventSuggestions.value = [];
      return;
    }

    final List<FamilyEventSuggestion> suggestions = [];

    // Get the best slot (everyone available or highest percentage)
    final bestSlot = commonFreeSlots.reduce(
      (a, b) => a.qualityScore > b.qualityScore ? a : b,
    );

    // Determine time of day
    final hour = bestSlot.start.hour;
    TimePreference timePreference;
    if (hour >= 6 && hour < 11) {
      timePreference = TimePreference.morning;
    } else if (hour >= 12 && hour < 17) {
      timePreference = TimePreference.afternoon;
    } else {
      timePreference = TimePreference.evening;
    }

    // Get matching categories
    final matchingCategories = EventCategory.categories
        .where(
          (cat) =>
              cat.timePreference == timePreference ||
              cat.timePreference == TimePreference.anytime,
        )
        .toList();

    // Create suggestions from matching categories
    for (var i = 0; i < matchingCategories.length && i < 3; i++) {
      final category = matchingCategories[i];
      final slot = i < commonFreeSlots.length ? commonFreeSlots[i] : bestSlot;

      suggestions.add(
        FamilyEventSuggestion(
          id: 'suggestion_${category.name}_$i',
          title: category.titles[0],
          emoji: category.emoji,
          timeSlot: slot,
          category: category.name,
          priority: slot.isEveryoneAvailable ? 5 : 3,
          description: slot.isEveryoneAvailable
              ? 'Everyone is free! Perfect time for ${category.titles[0].toLowerCase()}.'
              : '${slot.availableCount} of ${slot.totalMembers} family members available.',
        ),
      );
    }

    // Sort by priority and quality
    suggestions.sort((a, b) {
      final priorityCompare = b.priority.compareTo(a.priority);
      if (priorityCompare != 0) return priorityCompare;
      return b.timeSlot.qualityScore.compareTo(a.timeSlot.qualityScore);
    });

    eventSuggestions.value = suggestions.take(3).toList();
  }

  /// Mark an activity as "Family Welcome"
  Future<void> toggleFamilyWelcome(String slotId) async {
    final index = availabilitySlots.indexWhere((slot) => slot.id == slotId);
    if (index != -1) {
      availabilitySlots[index] = availabilitySlots[index].copyWith(
        familyWelcome: !availabilitySlots[index].familyWelcome,
      );
      availabilitySlots.refresh();
    }
  }

  /// Get availability for a specific member
  List<AvailabilitySlot> getAvailabilityForMember(String userId) {
    return availabilitySlots.where((slot) => slot.userId == userId).toList();
  }

  /// Get all family-welcome activities for the selected date
  List<AvailabilitySlot> get familyWelcomeActivities {
    final selectedDate = selectedDay.value;
    final selectedDateOnly = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    return availabilitySlots.where((slot) {
      final slotDate = DateTime(
        slot.start.year,
        slot.start.month,
        slot.start.day,
      );
      return slot.familyWelcome &&
          !slot.isFree &&
          slotDate.year == selectedDateOnly.year &&
          slotDate.month == selectedDateOnly.month &&
          slotDate.day == selectedDateOnly.day;
    }).toList();
  }

  /// Schedule a suggested event
  Future<void> scheduleSuggestedEvent(FamilyEventSuggestion suggestion) async {
    // This would create an actual event in the calendar
    Get.snackbar(
      '✅ Event Scheduled',
      '${suggestion.title} added to family calendar',
      duration: Duration(seconds: 3),
      backgroundColor: Get.theme.colorScheme.primaryContainer,
    );

    // TODO: Create actual EventModel and save to EventService
  }

  /// Change availability date (unified with events calendar)
  void changeAvailabilityDate(DateTime date) {
    selectedDay.value = date;
    loadAvailabilityData();
  }

  /// Switch to availability view
  void showAvailabilityView() {
    calendarView.value = CalendarView.availability;
  }
}
