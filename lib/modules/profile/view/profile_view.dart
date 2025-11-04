import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../../../widgets/avatar_widget.dart';

class ProfileView extends GetView<ProfileViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final user = controller.currentUser.value;
        if (user == null) {
          return Center(child: Text('No user data'));
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
                        'Demo Mode - Showing sample profile',
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
                  Center(
                    child: AvatarWidget(
                      name: user.name,
                      photoUrl: user.photoUrl,
                      size: 100,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    user.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    user.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 32),

                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Location'),
                    subtitle: Text(user.location),
                  ),
                  ListTile(
                    leading: Icon(Icons.dark_mode),
                    title: Text('Dark Mode'),
                    trailing: Switch(
                      value: Get.isDarkMode,
                      onChanged: (_) => controller.toggleTheme(),
                    ),
                  ),
                  SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: controller.signOut,
                    child: Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
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
