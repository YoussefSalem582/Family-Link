import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/demo_banner_widget.dart';
import '../viewmodel/meals_viewmodel.dart';
import 'widgets/family_member_meal_card.dart';
import 'widgets/calendar_header.dart';
import '../../../widgets/calendar.dart';

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

        return RefreshIndicator(
          onRefresh: () async {
            controller.changeDate(controller.selectedDate.value);
          },
          child: ListView(
            padding: EdgeInsets.zero,
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
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current User Section
                    if (controller.currentUser != null) ...[
                      Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          'meals_your_meals'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      FamilyMemberMealCard(
                        userId: controller.currentUser!.id,
                        userName: controller.currentUser!.name,
                        location: controller.currentUser!.location,
                        avatarUrl: controller.currentUser!.photoUrl,
                        meals: controller.getMealsForUser(
                          controller.currentUser!.id,
                        ),
                        isCurrentUser: true,
                        onMealTap: (mealType, isEaten) {
                          controller.updateMealStatus(
                            controller.currentUser!.id,
                            controller.currentUser!.name,
                            mealType,
                            isEaten,
                          );
                        },
                      ),
                      SizedBox(height: 24),
                    ],

                    // Family Members Section
                    if (controller.familyMembers.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          'home_family_members'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      // Family Members List
                      ...controller.familyMembers.map((member) {
                        final meals = controller.getMealsForUser(member.id);

                        return FamilyMemberMealCard(
                          userId: member.id,
                          userName: member.name,
                          location: member.location,
                          avatarUrl: member.photoUrl,
                          meals: meals,
                          isCurrentUser: false,
                          onMealTap: (mealType, isEaten) {
                            controller.updateMealStatus(
                              member.id,
                              member.name,
                              mealType,
                              isEaten,
                            );
                          },
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await Calendar.show(
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
