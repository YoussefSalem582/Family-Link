import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyMealsWidget extends StatelessWidget {
  final VoidCallback onAddMeal;

  const EmptyMealsWidget({Key? key, required this.onAddMeal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.grey[700] : Colors.grey[300];
    final textColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Center(
      child: Column(
        children: [
          SizedBox(height: 32),
          Icon(Icons.restaurant_menu, size: 64, color: iconColor),
          SizedBox(height: 16),
          Text(
            'meals_no_meals'.tr,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          SizedBox(height: 8),
          TextButton.icon(
            onPressed: onAddMeal,
            icon: Icon(Icons.add),
            label: Text('meals_add_meal'.tr),
          ),
        ],
      ),
    );
  }
}
