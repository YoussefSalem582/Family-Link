import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/meal_model.dart';

class FamilyMemberMealCard extends StatelessWidget {
  final String userId;
  final String userName;
  final String location;
  final String? avatarUrl;
  final List<MealModel> meals;
  final Function(String mealType, bool isEaten) onMealTap;
  final bool isCurrentUser;

  const FamilyMemberMealCard({
    Key? key,
    required this.userId,
    required this.userName,
    required this.location,
    this.avatarUrl,
    required this.meals,
    required this.onMealTap,
    this.isCurrentUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final breakfastMeal = meals.firstWhereOrNull(
      (m) => m.mealType.toLowerCase() == 'breakfast',
    );
    final lunchMeal = meals.firstWhereOrNull(
      (m) => m.mealType.toLowerCase() == 'lunch',
    );
    final dinnerMeal = meals.firstWhereOrNull(
      (m) => m.mealType.toLowerCase() == 'dinner',
    );

    return Container(
      margin: EdgeInsets.only(bottom: isCurrentUser ? 16 : 12),
      padding: EdgeInsets.all(isCurrentUser ? 16 : 12),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? Theme.of(context).primaryColor.withOpacity(0.05)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(isCurrentUser ? 16 : 12),
        border: Border.all(
          color: isCurrentUser
              ? Theme.of(context).primaryColor.withOpacity(0.3)
              : (isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1)),
          width: isCurrentUser ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isCurrentUser ? 0.08 : 0.05),
            blurRadius: isCurrentUser ? 12 : 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with avatar, name, and location
          Row(
            children: [
              CircleAvatar(
                radius: isCurrentUser ? 28 : 22,
                backgroundColor: _getAvatarColor(userName),
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: avatarUrl == null
                    ? Text(
                        userName[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isCurrentUser ? 24 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: isCurrentUser ? 16 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: isCurrentUser ? 18 : 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: isCurrentUser ? 14 : 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isCurrentUser ? 16 : 12),
          // Three meal boxes
          Row(
            children: [
              Expanded(
                child: _buildMealBox(
                  context,
                  'breakfast',
                  Icons.free_breakfast,
                  'meals_breakfast'.tr,
                  breakfastMeal,
                  Colors.orange,
                ),
              ),
              SizedBox(width: isCurrentUser ? 12 : 8),
              Expanded(
                child: _buildMealBox(
                  context,
                  'lunch',
                  Icons.lunch_dining,
                  'meals_lunch'.tr,
                  lunchMeal,
                  Colors.green,
                ),
              ),
              SizedBox(width: isCurrentUser ? 12 : 8),
              Expanded(
                child: _buildMealBox(
                  context,
                  'dinner',
                  Icons.dinner_dining,
                  'meals_dinner'.tr,
                  dinnerMeal,
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealBox(
    BuildContext context,
    String mealType,
    IconData icon,
    String label,
    MealModel? meal,
    Color color,
  ) {
    final bool isEaten = meal?.isEaten ?? false;
    final bool hasStatus = meal != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final noStatusBg = isDark ? Color(0xFF1E1E1E) : Colors.grey[50];
    final noStatusBorder = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    final skippedBg = isDark ? Color(0xFF1E1E1E) : Colors.grey[100];
    final skippedBorder = isDark ? Colors.grey[600]! : Colors.grey[400]!;
    final skippedIcon = isDark ? Colors.grey[500] : Colors.grey[600];
    final skippedText = isDark ? Colors.grey[400] : Colors.grey[700];
    final noStatusIcon = isDark ? Colors.grey[600] : Colors.grey[400];
    final noStatusText = isDark ? Colors.grey[500] : Colors.grey[500];

    return GestureDetector(
      onTap: () {
        _showMealStatusDialog(
          context,
          mealType,
          label,
          color,
          hasStatus,
          isEaten,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isCurrentUser ? 12 : 8,
          horizontal: isCurrentUser ? 8 : 6,
        ),
        decoration: BoxDecoration(
          color: hasStatus
              ? (isEaten ? color.withOpacity(0.15) : skippedBg)
              : noStatusBg,
          borderRadius: BorderRadius.circular(isCurrentUser ? 12 : 10),
          border: Border.all(
            color: hasStatus
                ? (isEaten ? color : skippedBorder)
                : noStatusBorder,
            width: hasStatus ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isCurrentUser ? 28 : 22,
              color: hasStatus ? (isEaten ? color : skippedIcon) : noStatusIcon,
            ),
            SizedBox(height: isCurrentUser ? 4 : 2),
            Text(
              label,
              style: TextStyle(
                fontSize: isCurrentUser ? 11 : 10,
                fontWeight: hasStatus && isEaten
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: hasStatus
                    ? (isEaten ? color : skippedText)
                    : noStatusText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showMealStatusDialog(
    BuildContext context,
    String mealType,
    String label,
    Color color,
    bool hasStatus,
    bool currentStatus,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(label),
        content: Text('meals_select_status'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              onMealTap(mealType, true);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('meals_eaten'.tr),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onMealTap(mealType, false);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel, color: Colors.red),
                SizedBox(width: 8),
                Text('meals_skipped'.tr),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[name.length % colors.length];
  }
}
