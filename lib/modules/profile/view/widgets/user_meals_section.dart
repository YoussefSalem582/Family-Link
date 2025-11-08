import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/meal_model.dart';
import '../../../meals/viewmodel/meals_viewmodel.dart';
import '../../../../widgets/section_header.dart';

class UserMealsSection extends StatelessWidget {
  final String? userId;

  const UserMealsSection({Key? key, this.userId}) : super(key: key);

  List<MealModel> _getAllMeals() {
    final storage = GetStorage();
    final savedMeals = storage.read<List>('meals_data');

    if (savedMeals == null) return [];

    return savedMeals.map((m) {
      final json = Map<String, dynamic>.from(m);
      return MealModel(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        userName: json['userName'] ?? '',
        mealType: json['mealType'] ?? '',
        isEaten: json['isEaten'] ?? false,
        date: DateTime.parse(json['date']),
        notes: json['notes'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mealsViewModel = Get.find<MealsViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      // Trigger rebuild when meals change
      mealsViewModel.todaysMeals.length;

      // Get ALL meals by this user from storage
      final allMeals = _getAllMeals();
      final userMeals = allMeals.where((meal) {
        if (userId == null) return true;
        return meal.userId == userId;
      }).toList();

      // Sort by date descending
      userMeals.sort((a, b) => b.date.compareTo(a.date));

      return Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: SectionHeader(
                title: 'Meals',
                icon: Icons.restaurant,
                iconGradient: LinearGradient(
                  colors: [Colors.green, Colors.green.withOpacity(0.7)],
                ),
                actionText: '${userMeals.length}',
                onActionPressed: () {},
              ),
            ),

            // Meals List
            if (userMeals.isEmpty)
              Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.restaurant_outlined,
                        size: 48,
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No meals logged yet',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                itemCount: userMeals.length > 5 ? 5 : userMeals.length,
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final meal = userMeals[index];
                  return _buildMealItem(context, meal, isDark);
                },
              ),

            // See all button if more than 5
            if (userMeals.length > 5)
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextButton(
                  onPressed: () => Get.toNamed('/meals'),
                  child: Text('View all ${userMeals.length} meals'),
                  style: TextButton.styleFrom(foregroundColor: Colors.green),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildMealItem(BuildContext context, MealModel meal, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed('/meals'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: Row(
            children: [
              // Meal icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getMealColor(meal.mealType).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    _getMealEmoji(meal.mealType),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(width: 12),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getMealTypeName(meal.mealType),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, yyyy').format(meal.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    if (meal.notes != null && meal.notes!.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        meal.notes!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Status badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: meal.isEaten
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: meal.isEaten
                        ? Colors.green.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      meal.isEaten ? Icons.check_circle : Icons.schedule,
                      size: 12,
                      color: meal.isEaten ? Colors.green : Colors.grey,
                    ),
                    SizedBox(width: 4),
                    Text(
                      meal.isEaten ? 'Eaten' : 'Pending',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: meal.isEaten ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMealColor(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return Colors.orange;
      case 'lunch':
        return Colors.green;
      case 'dinner':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getMealEmoji(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return '🍳';
      case 'lunch':
        return '🍽️';
      case 'dinner':
        return '🌙';
      default:
        return '🍴';
    }
  }

  String _getMealTypeName(String mealType) {
    return mealType[0].toUpperCase() + mealType.substring(1).toLowerCase();
  }
}
