import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MealCard extends StatelessWidget {
  final dynamic meal;
  final String Function(DateTime) formatTime;
  final String Function(String) capitalizeFirst;

  const MealCard({
    Key? key,
    required this.meal,
    required this.formatTime,
    required this.capitalizeFirst,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEaten = meal.isEaten;
    final color = isEaten ? Colors.green : Colors.red;
    final icon = isEaten ? Icons.check_circle : Icons.cancel;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          meal.userName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${capitalizeFirst(meal.mealType)} • ${formatTime(meal.date)}',
          style: TextStyle(fontSize: 12),
        ),
        trailing: Chip(
          label: Text(
            isEaten ? 'meals_eaten_status'.tr : 'meals_skipped_status'.tr,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: color.withOpacity(0.1),
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }
}
