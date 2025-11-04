import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MealTypeCard extends StatelessWidget {
  final String type;
  final IconData icon;
  final Color color;
  final int count;

  const MealTypeCard({
    Key? key,
    required this.type,
    required this.icon,
    required this.color,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              type,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              '$count ${'meals_eaten_count'.tr}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
