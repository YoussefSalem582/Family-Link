import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/meals_viewmodel.dart';

class MealsView extends GetView<MealsViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Family Meals')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Demo Mode Banner
            if (controller.isDemoMode.value)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                color: Colors.orange.shade100,
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade900),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Demo Mode - Showing sample meal data',
                        style: TextStyle(color: Colors.orange.shade900),
                      ),
                    ),
                  ],
                ),
              ),

            // Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Text(
                    'Today\'s Meals',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  // Display meals
                  ...controller.todaysMeals.map(
                    (meal) => Card(
                      child: ListTile(
                        leading: Icon(
                          meal.isEaten ? Icons.check_circle : Icons.cancel,
                          color: meal.isEaten ? Colors.green : Colors.red,
                        ),
                        title: Text(meal.userName),
                        subtitle: Text(
                          '${meal.mealType} - ${meal.isEaten ? "Eaten" : "Skipped"}',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
