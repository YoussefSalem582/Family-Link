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
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? Theme.of(context).primaryColor.withOpacity(0.05)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isCurrentUser ? 0.08 : 0.05),
            blurRadius: isCurrentUser ? 12 : 10,
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
                radius: 24,
                backgroundColor: _getAvatarColor(userName),
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: avatarUrl == null
                    ? Text(
                        userName[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      location,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
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
              SizedBox(width: 12),
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
              SizedBox(width: 12),
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
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: hasStatus
              ? (isEaten ? color.withOpacity(0.15) : Colors.grey[100])
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasStatus
                ? (isEaten ? color : Colors.grey[400]!)
                : Colors.grey[300]!,
            width: hasStatus ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: hasStatus
                  ? (isEaten ? color : Colors.grey[600])
                  : Colors.grey[400],
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: hasStatus && isEaten
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: hasStatus
                    ? (isEaten ? color : Colors.grey[700])
                    : Colors.grey[500],
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
