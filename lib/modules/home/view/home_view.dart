import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_app_bar.dart';
import '../viewmodel/home_viewmodel.dart';
import '../../../core/routes/app_routes.dart';
import '../../../widgets/demo_banner_widget.dart';
import '../../../widgets/section_header.dart';
import 'widgets/family_status_card.dart';
import 'widgets/family_member_card.dart';
import 'widgets/member_details_sheet.dart';
import 'widgets/events_section.dart';
import 'widgets/smart_status_section.dart';
import 'widgets/geofence_notifications_section.dart';

class HomeView extends GetView<HomeViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'app_name',
        icon: Icons.home_rounded,
        actionIcon: Icons.chat_bubble_outline,
        actionTooltip: 'Chats',
        onActionPressed: () => Get.toNamed(AppRoutes.chatList),
        showBackButton: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.loadFamilyMembers();
          },
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Demo Mode Banner
              if (controller.isDemoMode.value)
                DemoBannerWidget(message: 'demo_home'.tr),

              // Summary Card with gradient
              FamilyStatusCard(
                membersAtHome: controller.membersAtHome,
                membersOut: controller.membersOut,
                totalMembers: controller.familyMembers.length,
              ),
              // SizedBox(height: 24),

              // // Quick Actions Row
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     QuickActionButton(
              //       icon: Icons.restaurant,
              //       label: 'Meals',
              //       color: Colors.orange,
              //       onTap: () => _navigateToTab(1),
              //     ),
              //     QuickActionButton(
              //       icon: Icons.mood,
              //       label: 'Mood',
              //       color: Colors.purple,
              //       onTap: () => _navigateToTab(2),
              //     ),
              //     QuickActionButton(
              //       icon: Icons.map,
              //       label: 'Map',
              //       color: Colors.blue,
              //       onTap: () => _navigateToTab(3),
              //     ),
              //     QuickActionButton(
              //       icon: Icons.forum,
              //       label: 'Wall',
              //       color: Colors.green,
              //       onTap: () => _navigateToTab(4),
              //     ),
              //   ],
              // ),
              SizedBox(height: 24),

              // Upcoming Events Section
              EventsSection(),
              SizedBox(height: 24),

              // Smart Status Updates Section
              SmartStatusSection(),
              SizedBox(height: 24),

              // Geofence Notifications Section
              GeofenceNotificationsSection(),
              SizedBox(height: 24),

              // Family Members List
              SectionHeader(
                title: 'Family Members',
                icon: Icons.group_rounded,
                iconGradient: LinearGradient(
                  colors: [Colors.indigo, Colors.indigo.withOpacity(0.7)],
                ),
                actionText: controller.familyMembers.length.toString(),
                onActionPressed: () {},
              ),
              SizedBox(height: 12),

              ...controller.familyMembers.map(
                (member) => FamilyMemberCard(
                  member: member,
                  onTap: () => _showMemberDetails(context, member),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showMemberDetails(BuildContext context, dynamic member) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MemberDetailsSheet(
        member: member,
        isDemoMode: controller.isDemoMode.value,
      ),
    );
  }
}
