import 'package:get/get.dart';
import '../data/models/availability_model.dart';
import 'events_viewmodel.dart';

/// ViewModel for Family Availability View
/// Manages availability-specific state and logic
class FamilyAvailabilityViewModel extends GetxController {
  // Reference to EventsViewModel for shared data
  final EventsViewModel _eventsViewModel = Get.find<EventsViewModel>();

  // Current user ID - in demo mode
  static const String currentUserId = 'demo_user_1';

  // ==================== GETTERS FROM EVENTS VIEWMODEL ====================

  /// Selected date (shared with calendar)
  Rx<DateTime> get selectedDay => _eventsViewModel.selectedDay;

  /// Focused month for calendar navigation
  Rx<DateTime> get focusedDay => _eventsViewModel.focusedDay;

  /// All availability slots
  RxList<AvailabilitySlot> get availabilitySlots =>
      _eventsViewModel.availabilitySlots;

  /// Common free time slots
  RxList<CommonFreeSlot> get commonFreeSlots =>
      _eventsViewModel.commonFreeSlots;

  /// Event suggestions
  RxList<FamilyEventSuggestion> get eventSuggestions =>
      _eventsViewModel.eventSuggestions;

  /// Loading state
  RxBool get isLoadingAvailability => _eventsViewModel.isLoadingAvailability;

  // ==================== COMPUTED PROPERTIES ====================

  /// Get current user's slots for selected date
  List<AvailabilitySlot> get currentUserSlots {
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
      return slot.userId == currentUserId &&
          slotDate.year == selectedDateOnly.year &&
          slotDate.month == selectedDateOnly.month &&
          slotDate.day == selectedDateOnly.day;
    }).toList()..sort((a, b) => a.start.compareTo(b.start));
  }

  /// Get other family members' information for selected date
  Map<String, Map<String, String>> get familyMembers {
    final selectedDate = selectedDay.value;
    final selectedDateOnly = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final uniqueMembers = <String, Map<String, String>>{};
    for (var slot in availabilitySlots) {
      final slotDate = DateTime(
        slot.start.year,
        slot.start.month,
        slot.start.day,
      );
      final isSelectedDate =
          slotDate.year == selectedDateOnly.year &&
          slotDate.month == selectedDateOnly.month &&
          slotDate.day == selectedDateOnly.day;

      if (slot.userId != currentUserId &&
          isSelectedDate &&
          !uniqueMembers.containsKey(slot.userId)) {
        uniqueMembers[slot.userId] = {'id': slot.userId, 'name': slot.userName};
      }
    }
    return uniqueMembers;
  }

  /// Get family welcome activities for selected date
  List<AvailabilitySlot> get familyWelcomeActivities {
    return _eventsViewModel.familyWelcomeActivities;
  }

  /// Get slots count for selected date
  int get slotsForSelectedDate {
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
      return slotDate.year == selectedDateOnly.year &&
          slotDate.month == selectedDateOnly.month &&
          slotDate.day == selectedDateOnly.day;
    }).length;
  }

  /// Check if selected date is today
  bool get isSelectedDateToday {
    final selectedDate = selectedDay.value;
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  /// Get formatted selected date
  String get formattedSelectedDate {
    final date = selectedDay.value;
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));
    final yesterday = now.subtract(Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  // ==================== METHODS ====================

  /// Handle date selection
  void onDaySelected(DateTime day) {
    _eventsViewModel.onDaySelected(day);
  }

  /// Refresh availability data
  Future<void> refreshAvailabilityData() async {
    await _eventsViewModel.loadAvailabilityData();
  }

  /// Navigate to previous month
  void previousMonth() {
    _eventsViewModel.previousMonth();
  }

  /// Navigate to next month
  void nextMonth() {
    _eventsViewModel.nextMonth();
  }

  /// Toggle family welcome for an activity
  Future<void> toggleFamilyWelcome(String slotId) async {
    await _eventsViewModel.toggleFamilyWelcome(slotId);
  }

  /// Schedule a suggested event
  Future<void> scheduleSuggestedEvent(FamilyEventSuggestion suggestion) async {
    await _eventsViewModel.scheduleSuggestedEvent(suggestion);
  }

  /// Get member slots for a specific member on selected date
  List<AvailabilitySlot> getMemberSlots(String memberId) {
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
      return slot.userId == memberId &&
          slotDate.year == selectedDateOnly.year &&
          slotDate.month == selectedDateOnly.month &&
          slotDate.day == selectedDateOnly.day;
    }).toList()..sort((a, b) => a.start.compareTo(b.start));
  }

  /// Format time for display
  String formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  @override
  void onInit() {
    super.onInit();
    // Data is already loaded by EventsViewModel
  }
}
