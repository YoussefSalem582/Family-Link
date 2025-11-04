import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_app_bar.dart';
import '../viewmodel/meals_viewmodel.dart';
import '../../home/view/widgets/demo_banner_widget.dart';
import 'widgets/family_member_meal_card.dart';
import 'widgets/calendar_header.dart';
import 'widgets/modern_date_picker.dart';

class MealsView extends GetView<MealsViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'meals_title',
        icon: Icons.restaurant_menu_rounded,
        actionIcon: Icons.calendar_month,
        actionTooltip: 'Select Date',
        onActionPressed: () => _showDatePicker(context),
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

            // Calendar Header
            CalendarHeader(
              selectedDate: controller.selectedDate.value,
              isToday: controller.isToday(controller.selectedDate.value),
              onPreviousDay: () {
                final previousDay = controller.selectedDate.value.subtract(
                  Duration(days: 1),
                );
                controller.changeDate(previousDay);
              },
              onNextDay: () {
                final nextDay = controller.selectedDate.value.add(
                  Duration(days: 1),
                );
                controller.changeDate(nextDay);
              },
              onCalendarTap: () => _showDatePicker(context),
              onTodayTap: () {
                controller.changeDate(DateTime.now());
              },
            ),

            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.changeDate(controller.selectedDate.value);
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount:
                      controller.familyMembers.length +
                      1, // +1 for current user
                  itemBuilder: (context, index) {
                    // First item is current user
                    if (index == 0) {
                      final userId = controller.currentUser['id']!;
                      final userName = controller.currentUser['name']!;
                      final location = controller.currentUser['location']!;
                      final meals = controller.getMealsForUser(userId);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 4, bottom: 8),
                            child: Text(
                              'Your Meals',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: FamilyMemberMealCard(
                              userId: userId,
                              userName: userName,
                              location: location,
                              meals: meals,
                              isCurrentUser: true,
                              onMealTap: (mealType, isEaten) {
                                controller.updateMealStatus(
                                  userId,
                                  userName,
                                  mealType,
                                  isEaten,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 24),
                          Padding(
                            padding: EdgeInsets.only(left: 4, bottom: 8),
                            child: Text(
                              'Family Members',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    // Other family members
                    final member = controller.familyMembers[index - 1];
                    final userId = member['id']!;
                    final userName = member['name']!;
                    final location = member['location']!;
                    final meals = controller.getMealsForUser(userId);

                    return FamilyMemberMealCard(
                      userId: userId,
                      userName: userName,
                      location: location,
                      meals: meals,
                      isCurrentUser: false,
                      onMealTap: (mealType, isEaten) {
                        controller.updateMealStatus(
                          userId,
                          userName,
                          mealType,
                          isEaten,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await ModernDatePicker.show(
      context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != controller.selectedDate.value) {
      controller.changeDate(picked);
    }
  }
}
