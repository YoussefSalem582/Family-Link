import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import '../core/services/event_service.dart';
import '../data/models/event_model.dart';
import '../modules/events/data/models/availability_model.dart';

class Calendar {
  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    List<AvailabilitySlot>? availabilitySlots,
    bool showAvailability = false,
  }) async {
    return await showDialog<DateTime>(
      context: context,
      builder: (context) => _ModernDatePickerDialog(
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2020),
        lastDate: lastDate ?? DateTime(2030),
        availabilitySlots: availabilitySlots ?? [],
        showAvailability: showAvailability,
      ),
    );
  }
}

class _ModernDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final List<AvailabilitySlot> availabilitySlots;
  final bool showAvailability;

  const _ModernDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.availabilitySlots,
    required this.showAvailability,
  });

  @override
  State<_ModernDatePickerDialog> createState() =>
      _ModernDatePickerDialogState();
}

class _ModernDatePickerDialogState extends State<_ModernDatePickerDialog> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;
  final _storage = GetStorage();
  Map<String, Map<String, int>> _mealStats = {}; // date -> {eaten, total}

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
    );
    _loadMealStatistics();
  }

  void _loadMealStatistics() {
    final savedMeals = _storage.read<List>('meals_data');
    if (savedMeals != null) {
      final stats = <String, Map<String, int>>{};

      for (var mealJson in savedMeals) {
        final meal = Map<String, dynamic>.from(mealJson);
        final dateStr = meal['date'] as String?;
        if (dateStr != null) {
          final date = DateTime.parse(dateStr);
          final dateKey = _formatDateKey(date);

          if (!stats.containsKey(dateKey)) {
            stats[dateKey] = {'eaten': 0, 'total': 0};
          }

          stats[dateKey]!['total'] = (stats[dateKey]!['total'] ?? 0) + 1;
          if (meal['isEaten'] == true) {
            stats[dateKey]!['eaten'] = (stats[dateKey]!['eaten'] ?? 0) + 1;
          }
        }
      }

      setState(() {
        _mealStats = stats;
      });
    }
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Map<String, int>? _getStatsForDate(DateTime date) {
    return _mealStats[_formatDateKey(date)];
  }

  List<EventModel> _getEventsForDate(DateTime date) {
    try {
      final eventService = Get.find<EventService>();
      return eventService.getEventsForDate(date);
    } catch (e) {
      return [];
    }
  }

  List<AvailabilitySlot> _getAvailabilityForDate(DateTime date) {
    return widget.availabilitySlots.where((slot) {
      final slotDate = DateTime(
        slot.start.year,
        slot.start.month,
        slot.start.day,
      );
      final targetDate = DateTime(date.year, date.month, date.day);
      return slotDate == targetDate;
    }).toList();
  }

  Map<String, dynamic> _getAvailabilityStats(DateTime date) {
    final slots = _getAvailabilityForDate(date);
    if (slots.isEmpty) return {};

    final freeSlots = slots.where((s) => s.isFree).length;
    final busySlots = slots.where((s) => !s.isFree).length;
    final uniqueUsers = slots.map((s) => s.userId).toSet().length;

    return {
      'free': freeSlots,
      'busy': busySlots,
      'total': slots.length,
      'users': uniqueUsers,
      'hasFamilyWelcome': slots.any((s) => s.familyWelcome),
    };
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = _isSameDay(_selectedDate, now);
    final isYesterday = _isSameDay(
      _selectedDate,
      now.subtract(Duration(days: 1)),
    );
    final isTomorrow = _isSameDay(_selectedDate, now.add(Duration(days: 1)));
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      child: Container(
        constraints: BoxConstraints(maxWidth: 400, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [
                          Theme.of(context).primaryColor.withOpacity(0.8),
                          Theme.of(context).primaryColor.withOpacity(0.6),
                        ]
                      : [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'select_date'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      if (isToday || isYesterday || isTomorrow)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            isToday
                                ? 'today'.tr.toUpperCase()
                                : isYesterday
                                ? 'yesterday'.tr.toUpperCase()
                                : 'tomorrow'.tr.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateFormat('EEE, MMM d').format(_selectedDate),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Quick select buttons
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildQuickButton(
                              context,
                              'yesterday'.tr,
                              Icons.arrow_back,
                              now.subtract(Duration(days: 1)),
                              Colors.orange,
                              isDarkMode,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _buildQuickButton(
                              context,
                              'today'.tr,
                              Icons.today,
                              now,
                              Colors.green,
                              isDarkMode,
                              isPrimary: true,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _buildQuickButton(
                              context,
                              'tomorrow'.tr,
                              Icons.arrow_forward,
                              now.add(Duration(days: 1)),
                              Colors.blue,
                              isDarkMode,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Month navigation
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left),
                            onPressed: () {
                              setState(() {
                                _displayedMonth = DateTime(
                                  _displayedMonth.year,
                                  _displayedMonth.month - 1,
                                );
                              });
                            },
                            color: Theme.of(context).primaryColor,
                          ),
                          Expanded(
                            child: Text(
                              DateFormat('MMMM yyyy').format(_displayedMonth),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.chevron_right),
                            onPressed: () {
                              setState(() {
                                _displayedMonth = DateTime(
                                  _displayedMonth.year,
                                  _displayedMonth.month + 1,
                                );
                              });
                            },
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),

                    // Calendar grid
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: _buildCalendarGrid(context),
                    ),

                    // Selected date meal statistics
                    if (!widget.showAvailability &&
                        _getStatsForDate(_selectedDate) != null)
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.blue.withOpacity(0.15)
                              : Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.blue.withOpacity(0.4)
                                : Colors.blue.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 18,
                              color: isDarkMode
                                  ? Colors.blue[300]
                                  : Colors.blue[700],
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _buildDateStats(_selectedDate, isDarkMode),
                            ),
                          ],
                        ),
                      ),

                    // Selected date events
                    if (_getEventsForDate(_selectedDate).isNotEmpty)
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.purple.withOpacity(0.15)
                              : Colors.purple.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.purple.withOpacity(0.4)
                                : Colors.purple.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.event,
                                  size: 18,
                                  color: isDarkMode
                                      ? Colors.purple[300]
                                      : Colors.purple[700],
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'events_on_date'.tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                        ? Colors.purple[200]
                                        : Colors.purple[900],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            ..._getEventsForDate(_selectedDate).map((event) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      event.icon,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        event.title,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: isDarkMode
                                              ? Colors.purple[200]
                                              : Colors.purple[900],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),

                    // Selected date availability
                    if (widget.showAvailability &&
                        _getAvailabilityForDate(_selectedDate).isNotEmpty)
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.blue.withOpacity(0.15)
                              : Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.blue.withOpacity(0.4)
                                : Colors.blue.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 18,
                                  color: isDarkMode
                                      ? Colors.blue[300]
                                      : Colors.blue[700],
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'availability_on_date'.tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                        ? Colors.blue[200]
                                        : Colors.blue[900],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            ..._getAvailabilityForDate(_selectedDate).map((
                              slot,
                            ) {
                              final timeStr =
                                  '${DateFormat('h:mm a').format(slot.start)} - ${DateFormat('h:mm a').format(slot.end)}';
                              return Padding(
                                padding: EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: slot.isFree
                                            ? (isDarkMode
                                                  ? Colors.blue[300]
                                                  : Colors.blue)
                                            : (isDarkMode
                                                  ? Colors.amber[500]
                                                  : Colors.amber[700]),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isDarkMode
                                                ? Colors.blue[200]
                                                : Colors.blue[900],
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '${slot.userName}: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            TextSpan(
                                              text: slot.isFree
                                                  ? '${'free'.tr} ($timeStr)'
                                                  : '${slot.activityName ?? 'busy'.tr} ($timeStr)',
                                            ),
                                            if (slot.familyWelcome)
                                              TextSpan(
                                                text: ' 👋',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),

                    // Legend
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey[800]?.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          if (!widget.showAvailability) ...[
                            _buildLegendItem(
                              Colors.green,
                              'all_eaten'.tr,
                              isDarkMode,
                            ),
                            _buildLegendItem(
                              Colors.orange,
                              'partial'.tr,
                              isDarkMode,
                            ),
                            _buildLegendItem(Colors.red, 'none'.tr, isDarkMode),
                          ],
                          _buildLegendItem(
                            Colors.purple,
                            'event'.tr,
                            isDarkMode,
                          ),
                          if (widget.showAvailability) ...[
                            _buildLegendItem(
                              isDarkMode ? Colors.blue[300]! : Colors.blue,
                              'free'.tr,
                              isDarkMode,
                            ),
                            _buildLegendItem(
                              isDarkMode
                                  ? Colors.amber[500]!
                                  : Colors.amber[700]!,
                              'busy'.tr,
                              isDarkMode,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Divider(height: 1),

            // Action buttons
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'cancel'.tr,
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, _selectedDate);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'ok'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;

    final firstDayOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    );

    final startingWeekday = firstDayOfMonth.weekday % 7;

    return Column(
      children: [
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map(
                (day) => Container(
                  width: 40,
                  height: 32,
                  alignment: Alignment.center,
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: day == 'S'
                          ? Colors.red[400]
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 4),
        // Calendar days
        ...List.generate((daysInMonth + startingWeekday + 6) ~/ 7, (weekIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (dayIndex) {
              final dayNumber = weekIndex * 7 + dayIndex - startingWeekday + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return Container(width: 40, height: 40);
              }

              final date = DateTime(
                _displayedMonth.year,
                _displayedMonth.month,
                dayNumber,
              );

              final isSelected = _isSameDay(date, _selectedDate);
              final isToday = _isSameDay(date, DateTime.now());
              final isSunday = dayIndex == 0;
              final stats = widget.showAvailability
                  ? null
                  : _getStatsForDate(date);
              final hasData =
                  !widget.showAvailability &&
                  stats != null &&
                  stats['total']! > 0;
              final eatenCount = stats?['eaten'] ?? 0;
              final totalCount = stats?['total'] ?? 0;
              final events = _getEventsForDate(date);
              final hasEvents = events.isNotEmpty;
              final availStats = widget.showAvailability
                  ? _getAvailabilityStats(date)
                  : <String, dynamic>{};
              final hasAvailability =
                  widget.showAvailability && availStats.isNotEmpty;
              final hasFreeTime = hasAvailability && availStats['free'] > 0;
              final hasBusyTime = hasAvailability && availStats['busy'] > 0;

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : isToday
                        ? Colors.green.withOpacity(0.15)
                        : null,
                    shape: BoxShape.circle,
                    border: isToday && !isSelected
                        ? Border.all(color: Colors.green, width: 2)
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        dayNumber.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected || isToday
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : isToday
                              ? Colors.green[900]
                              : isSunday
                              ? Colors.red[400]
                              : null,
                        ),
                      ),
                      // Indicators row (meals, events, and availability)
                      if (hasData || hasEvents || hasAvailability)
                        Positioned(
                          bottom: 2,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Meal indicator dot
                              if (hasData)
                                Container(
                                  width: 4,
                                  height: 4,
                                  margin: EdgeInsets.only(
                                    right: (hasEvents || hasAvailability)
                                        ? 2
                                        : 0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: eatenCount == totalCount
                                        ? (isSelected
                                              ? Colors.white
                                              : Colors.green)
                                        : eatenCount > 0
                                        ? (isSelected
                                              ? Colors.white.withOpacity(0.7)
                                              : Colors.orange)
                                        : (isSelected
                                              ? Colors.white.withOpacity(0.5)
                                              : Colors.red),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              // Event indicator dot
                              if (hasEvents)
                                Container(
                                  width: 4,
                                  height: 4,
                                  margin: EdgeInsets.only(
                                    right: hasAvailability ? 2 : 0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.purple,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              // Free time indicator (blue dot)
                              if (hasFreeTime)
                                Container(
                                  width: 4,
                                  height: 4,
                                  margin: EdgeInsets.only(
                                    right: hasBusyTime ? 2 : 0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              // Busy time indicator (amber dot)
                              if (hasBusyTime)
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white.withOpacity(0.8)
                                        : Colors.amber[700],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildQuickButton(
    BuildContext context,
    String label,
    IconData icon,
    DateTime date,
    Color color,
    bool isDarkMode, {
    bool isPrimary = false,
  }) {
    final isSelected = _isSameDay(_selectedDate, date);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedDate = date;
          _displayedMonth = DateTime(date.year, date.month);
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color
              : isPrimary
              ? (isDarkMode ? color.withOpacity(0.25) : color.withOpacity(0.1))
              : (isDarkMode
                    ? Colors.grey[800]?.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.08)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color
                : isPrimary
                ? (isDarkMode ? color.withOpacity(0.6) : color.withOpacity(0.4))
                : (isDarkMode
                      ? Colors.grey[700]!
                      : Colors.grey.withOpacity(0.2)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected
                  ? Colors.white
                  : isPrimary
                  ? (isDarkMode ? color.withOpacity(0.9) : color)
                  : (isDarkMode ? Colors.grey[400] : Colors.grey[700]),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : isPrimary
                    ? (isDarkMode ? color.withOpacity(0.9) : color)
                    : (isDarkMode ? Colors.grey[400] : Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildDateStats(DateTime date, bool isDarkMode) {
    final stats = _getStatsForDate(date);
    if (stats == null) return SizedBox.shrink();

    final eaten = stats['eaten'] ?? 0;
    final total = stats['total'] ?? 0;
    final percentage = total > 0 ? (eaten / total * 100).round() : 0;

    return Text(
      '$eaten / $total ${'meals_eaten_count'.tr} ($percentage%)',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.blue[200] : Colors.blue[900],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, bool isDarkMode) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
