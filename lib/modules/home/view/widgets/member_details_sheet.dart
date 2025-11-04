import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/avatar_widget.dart';
import '../../../../data/repositories/mood_repository.dart';
import '../../../../data/repositories/meal_repository.dart';
import '../../../../data/models/mood_model.dart';
import '../../../../data/models/meal_model.dart';

class MemberDetailsSheet extends StatelessWidget {
  final dynamic member;
  final bool isDemoMode;

  const MemberDetailsSheet({
    Key? key,
    required this.member,
    this.isDemoMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? Color(0xFF2A2A2A) : Colors.white;
    final handleColor = isDark ? Colors.grey[700] : Colors.grey[300];
    final emailColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final dividerColor = isDark ? Colors.grey[800] : Colors.grey[200];

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: handleColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content - wrapped in Flexible with SingleChildScrollView
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar with gradient background
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.2),
                          Theme.of(context).primaryColor.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: EdgeInsets.all(4),
                    child: AvatarWidget(
                      name: member.name,
                      photoUrl: member.photoUrl,
                      size: 90,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Name
                  Text(
                    member.name,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 8),

                  // Email with icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email_outlined, size: 16, color: emailColor),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          member.email,
                          style: TextStyle(color: emailColor, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 28),

                  // Divider
                  Divider(color: dividerColor, height: 1),

                  SizedBox(height: 24),

                  // Details cards
                  _buildDetailCard(
                    context,
                    icon: Icons.location_on_rounded,
                    iconColor: Colors.red,
                    iconBg: Colors.red.withOpacity(0.1),
                    label: 'Location',
                    value: member.location,
                    isDark: isDark,
                  ),

                  SizedBox(height: 16),

                  _buildDetailCard(
                    context,
                    icon: member.isHome
                        ? Icons.home_rounded
                        : Icons.near_me_rounded,
                    iconColor: member.isHome ? Colors.green : Colors.blue,
                    iconBg: (member.isHome ? Colors.green : Colors.blue)
                        .withOpacity(0.1),
                    label: 'Status',
                    value: member.status,
                    isDark: isDark,
                  ),

                  SizedBox(height: 16),

                  // Last Activity
                  _buildDetailCard(
                    context,
                    icon: Icons.access_time_rounded,
                    iconColor: Colors.purple,
                    iconBg: Colors.purple.withOpacity(0.1),
                    label: 'Last Seen',
                    value: _getLastActivityText(member),
                    isDark: isDark,
                  ),

                  SizedBox(height: 16),

                  // Coordinates (if available)
                  if (member.latitude != null && member.longitude != null)
                    _buildDetailCard(
                      context,
                      icon: Icons.pin_drop_rounded,
                      iconColor: Colors.indigo,
                      iconBg: Colors.indigo.withOpacity(0.1),
                      label: 'Coordinates',
                      value:
                          '${member.latitude?.toStringAsFixed(4)}, ${member.longitude?.toStringAsFixed(4)}',
                      isDark: isDark,
                    ),

                  if (member.latitude != null && member.longitude != null)
                    SizedBox(height: 16),

                  // Connection Status (using lastSeen to determine)
                  _buildDetailCard(
                    context,
                    icon: _isOnline(member)
                        ? Icons.wifi_rounded
                        : Icons.wifi_off_rounded,
                    iconColor: _isOnline(member) ? Colors.teal : Colors.grey,
                    iconBg: (_isOnline(member) ? Colors.teal : Colors.grey)
                        .withOpacity(0.1),
                    label: 'Connection',
                    value: _isOnline(member) ? 'Recently Active' : 'Inactive',
                    isDark: isDark,
                  ),

                  SizedBox(height: 24),

                  // Recent Mood Section
                  _buildRecentMoodCard(context, member, isDark),

                  SizedBox(height: 16),

                  // Meals Section
                  _buildMealsSection(context, member, isDark),

                  if (isDemoMode) ...[
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Demo Mode - Sample data',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
    required bool isDark,
  }) {
    final cardBg = isDark ? Color(0xFF1E1E1E) : Colors.grey[50];
    final labelColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final valueColor = isDark ? Colors.white : Colors.black87;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),

          SizedBox(width: 16),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: labelColor,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: valueColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLastActivityText(dynamic member) {
    final lastSeen = member.lastSeen;
    if (lastSeen == null) return 'Recently';

    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    }
  }

  bool _isOnline(dynamic member) {
    if (member.lastSeen == null) return false;
    final difference = DateTime.now().difference(member.lastSeen);
    return difference.inMinutes <
        15; // Consider online if active in last 15 minutes
  }

  Widget _buildRecentMoodCard(
    BuildContext context,
    dynamic member,
    bool isDark,
  ) {
    final cardBg = isDark ? Color(0xFF1E1E1E) : Colors.amber.withOpacity(0.05);
    final textColor = isDark ? Colors.grey[300] : Colors.grey[700];

    // Check if mood repository is available
    if (!Get.isRegistered<MoodRepository>()) {
      return _buildMoodCardWithoutData(isDark, cardBg, textColor);
    }

    // Get mood repository
    final moodRepository = Get.find<MoodRepository>();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.mood_rounded, color: Colors.amber, size: 22),
              ),
              SizedBox(width: 12),
              Text(
                'Recent Mood',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF2A2A2A) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: FutureBuilder<MoodModel?>(
              future: moodRepository.getLatestUserMood(member.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                      ),
                    ),
                  );
                }

                if (snapshot.hasData && snapshot.data != null) {
                  final mood = snapshot.data!;
                  final today = DateTime.now();
                  final isTodayMood =
                      mood.date.year == today.year &&
                      mood.date.month == today.month &&
                      mood.date.day == today.day;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(mood.emoji, style: TextStyle(fontSize: 28)),
                      SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mood.mood,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            if (mood.note != null && mood.note!.isNotEmpty)
                              Text(
                                mood.note!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            Text(
                              isTodayMood
                                  ? 'Today'
                                  : _formatMoodDate(mood.date),
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? Colors.grey[500]
                                    : Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return _getMoodEmptyState(isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatMoodDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _getMoodEmptyState(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.sentiment_neutral_rounded,
          color: isDark ? Colors.grey[600] : Colors.grey[400],
          size: 24,
        ),
        SizedBox(width: 8),
        Text(
          'No mood shared yet',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey[500] : Colors.grey[500],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildMoodCardWithoutData(
    bool isDark,
    Color cardBg,
    Color? textColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.mood_rounded, color: Colors.amber, size: 22),
              ),
              SizedBox(width: 12),
              Text(
                'Recent Mood',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF2A2A2A) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _getMoodEmptyState(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsSection(BuildContext context, dynamic member, bool isDark) {
    final cardBg = isDark ? Color(0xFF1E1E1E) : Colors.orange.withOpacity(0.05);
    final textColor = isDark ? Colors.grey[300] : Colors.grey[700];

    // Check if meal repository is available
    if (!Get.isRegistered<MealRepository>()) {
      return _buildMealsCardWithoutData(isDark, cardBg, textColor, member);
    }

    // Get meal repository
    final mealRepository = Get.find<MealRepository>();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.restaurant_rounded,
                  color: Colors.orange,
                  size: 22,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Today\'s Meals',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          StreamBuilder<List<MealModel>>(
            stream: mealRepository.getUserMeals(
              member.id,
              DateTime.now(),
              DateTime.now(),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                );
              }

              final userMeals = snapshot.hasData
                  ? snapshot.data!
                  : <MealModel>[];
              return _buildMealsList(member, isDark, userMeals);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealsList(
    dynamic member,
    bool isDark,
    List<MealModel> userMeals,
  ) {
    // Meal types
    final meals = [
      {
        'type': 'breakfast',
        'displayName': 'Breakfast',
        'icon': Icons.free_breakfast_rounded,
        'time': '8:00 AM',
      },
      {
        'type': 'lunch',
        'displayName': 'Lunch',
        'icon': Icons.lunch_dining_rounded,
        'time': '1:00 PM',
      },
      {
        'type': 'dinner',
        'displayName': 'Dinner',
        'icon': Icons.dinner_dining_rounded,
        'time': '7:00 PM',
      },
    ];

    return Column(
      children: meals.map((meal) {
        // Check if user has eaten this meal
        final mealData = userMeals.firstWhereOrNull(
          (m) => m.mealType.toLowerCase() == meal['type'],
        );
        final hasEaten = mealData?.isEaten ?? false;

        return _buildMealItem(
          type: meal['displayName'] as String,
          icon: meal['icon'] as IconData,
          time: meal['time'] as String,
          isDark: isDark,
          hasEaten: hasEaten,
          notes: mealData?.notes,
        );
      }).toList(),
    );
  }

  Widget _buildMealItem({
    required String type,
    required IconData icon,
    required String time,
    required bool isDark,
    required bool hasEaten,
    String? notes,
  }) {
    final itemBg = isDark ? Color(0xFF2A2A2A) : Colors.white;
    final textColor = isDark ? Colors.grey[300] : Colors.grey[800];
    final subtitleColor = isDark ? Colors.grey[500] : Colors.grey[500];

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: itemBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.orange, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(fontSize: 11, color: subtitleColor),
                    ),
                  ],
                ),
              ),
              // Status indicator
              _buildMealStatus(hasEaten, isDark),
            ],
          ),
          if (notes != null && notes.isNotEmpty) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF1E1E1E) : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 14,
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      notes,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMealStatus(bool hasEaten, bool isDark) {
    if (hasEaten) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 14),
            SizedBox(width: 4),
            Text(
              'Done',
              style: TextStyle(
                fontSize: 11,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Pending',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.grey[500] : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  Widget _buildMealsCardWithoutData(
    bool isDark,
    Color cardBg,
    Color? textColor,
    dynamic member,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.restaurant_rounded,
                  color: Colors.orange,
                  size: 22,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Today\'s Meals',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildMealsList(member, isDark, <MealModel>[]),
        ],
      ),
    );
  }
}
