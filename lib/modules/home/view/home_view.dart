import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/home_viewmodel.dart';
import '../../main_container/viewmodel/main_container_viewmodel.dart';
import '../../../core/routes/app_routes.dart';
import '../../../widgets/demo_banner_widget.dart';
import 'widgets/family_status_card.dart';
import 'widgets/quick_action_button.dart';
import 'widgets/family_member_card.dart';
import 'widgets/member_details_sheet.dart';

class HomeView extends GetView<HomeViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FamilyLink'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Get.toNamed(AppRoutes.profile),
          ),
        ],
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
              if (controller.isDemoMode.value) DemoBannerWidget(),

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

              // Family Members List
              Text(
                'Family Members',
                style: Theme.of(context).textTheme.headlineSmall,
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

  void _navigateToTab(int index) {
    try {
      Get.find<MainContainerViewModel>().changeTab(index);
    } catch (e) {
      Get.snackbar('Demo', 'Navigation feature');
    }
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
