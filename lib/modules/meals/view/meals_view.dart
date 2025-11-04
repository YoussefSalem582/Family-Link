import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/meals_viewmodel.dart';
import '../../home/view/widgets/demo_banner_widget.dart';
import 'widgets/meal_type_card.dart';
import 'widgets/meal_card.dart';
import 'widgets/add_meal_dialog.dart';
import 'widgets/empty_meals_widget.dart';

class MealsView extends GetView<MealsViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('meals_title'.tr),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () => _showAddMealDialog(context),
            tooltip: 'meals_add_meal'.tr,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Demo Mode Banner
            if (controller.isDemoMode.value)
              DemoBannerWidget(message: 'demo_meals'.tr),

            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.loadTodaysMeals();
                },
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    // Meal Type Cards
                    Row(
                      children: [
                        Expanded(
                          child: MealTypeCard(
                            type: 'meals_breakfast'.tr,
                            icon: Icons.free_breakfast,
                            color: Colors.orange,
                            count: _getMealCountByType('breakfast'),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: MealTypeCard(
                            type: 'meals_lunch'.tr,
                            icon: Icons.lunch_dining,
                            color: Colors.green,
                            count: _getMealCountByType('lunch'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: MealTypeCard(
                            type: 'meals_dinner'.tr,
                            icon: Icons.dinner_dining,
                            color: Colors.blue,
                            count: _getMealCountByType('dinner'),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: MealTypeCard(
                            type: 'meals_snack'.tr,
                            icon: Icons.emoji_food_beverage,
                            color: Colors.purple,
                            count: _getMealCountByType('snack'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    Text(
                      'meals_today'.tr,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 16),

                    // Display meals
                    if (controller.todaysMeals.isEmpty)
                      EmptyMealsWidget(
                        onAddMeal: () => _showAddMealDialog(context),
                      )
                    else
                      ...controller.todaysMeals.map(
                        (meal) => MealCard(
                          meal: meal,
                          formatTime: _formatTime,
                          capitalizeFirst: _capitalizeFirst,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  int _getMealCountByType(String type) {
    return controller.todaysMeals
        .where((meal) => meal.mealType.toLowerCase() == type && meal.isEaten)
        .length;
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void _showAddMealDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddMealDialog(
        capitalizeFirst: _capitalizeFirst,
        onAdd: (mealType, isEaten) {
          Get.back();
          Get.snackbar(
            'demo_mode'.tr,
            'meals_meal_added'.tr + ': "${_capitalizeFirst(mealType)}"',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
        },
      ),
    );
  }
}
