import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_app_bar.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../../../widgets/demo_banner_widget.dart';
import '../../../widgets/custom_button.dart';
import 'widgets/profile_header.dart';
import 'widgets/family_code_card.dart';
import 'widgets/user_events_section.dart';
import 'widgets/user_posts_section.dart';
import 'widgets/user_moods_section.dart';
import 'widgets/user_meals_section.dart';
import 'widgets/edit_profile_dialog.dart';

class ProfileView extends GetView<ProfileViewModel> {
  @override
  Widget build(BuildContext context) {
    // Check if viewing another user's profile
    final args = Get.arguments as Map<String, dynamic>?;
    final viewingUserId = args?['userId'] as String?;
    final viewingUserName = args?['userName'] as String?;
    final isViewingOtherUser =
        viewingUserId != null &&
        viewingUserId != controller.currentUser.value?.id;

    return Scaffold(
      appBar: CustomAppBar(
        title: isViewingOtherUser
            ? viewingUserName ?? 'Profile'
            : 'profile_title',
        icon: Icons.person_rounded,
        actionIcon: isViewingOtherUser ? null : Icons.edit_outlined,
        actionTooltip: isViewingOtherUser ? null : 'profile_edit',
        onActionPressed: isViewingOtherUser
            ? null
            : () => _showEditDialog(context),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final user = controller.currentUser.value;
        if (user == null) {
          return Center(child: Text('profile_no_data'.tr));
        }

        // Determine which user ID to show data for
        final displayUserId = viewingUserId ?? user.id;

        return Column(
          children: [
            // Demo Mode Banner
            if (controller.isDemoMode.value)
              DemoBannerWidget(message: 'demo_profile'.tr),

            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refreshProfile(),
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    // Profile Header (only show for current user)
                    if (!isViewingOtherUser) ...[
                      ProfileHeader(user: user),
                      SizedBox(height: 24),
                    ] else ...[
                      // Show viewing user's name
                      Center(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.2),
                                    Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              padding: EdgeInsets.all(4),
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.1),
                                child: Text(
                                  viewingUserName
                                          ?.substring(0, 1)
                                          .toUpperCase() ??
                                      'U',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              viewingUserName ?? 'User Profile',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],

                    // Chat Button (only show when viewing other user's profile)
                    if (isViewingOtherUser) ...[
                      CustomButton(
                        text: 'Message ${viewingUserName ?? 'User'}',
                        onPressed: () {
                          Get.toNamed(
                            '/chat',
                            arguments: {
                              'receiverId': viewingUserId,
                              'receiverName': viewingUserName,
                              'receiverPhotoUrl': null,
                            },
                          );
                        },
                        icon: Icons.chat_bubble_outline_rounded,
                        backgroundColor: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        width: double.infinity,
                      ),
                      SizedBox(height: 24),
                    ],

                    // Family Code Card (only show for own profile)
                    if (!isViewingOtherUser) ...[
                      FamilyCodeCard(),
                      SizedBox(height: 16),
                    ],

                    // User Events Section
                    UserEventsSection(userId: displayUserId),
                    SizedBox(height: 16),

                    // User Posts Section
                    UserPostsSection(userId: displayUserId),
                    SizedBox(height: 16),

                    // User Moods Section
                    UserMoodsSection(userId: displayUserId),
                    SizedBox(height: 16),

                    // User Meals Section
                    UserMealsSection(userId: displayUserId),
                    SizedBox(height: 24),

                    // Settings Button (only for current user)
                    if (!isViewingOtherUser)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Get.toNamed('/settings'),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Settings',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditProfileDialog(
        currentName: controller.currentUser.value?.name ?? '',
        currentLocation: controller.currentUser.value?.location ?? '',
      ),
    );
  }
}
