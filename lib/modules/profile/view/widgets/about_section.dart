import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutSection extends StatelessWidget {
  final VoidCallback onAboutTap;

  const AboutSection({super.key, required this.onAboutTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'profile_about'.tr,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('profile_help_support'.tr),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Get.snackbar(
                    'profile_help_support'.tr,
                    'profile_help_coming'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.privacy_tip_outlined),
                title: Text('profile_privacy_policy'.tr),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Get.snackbar(
                    'profile_privacy_policy'.tr,
                    'profile_privacy_coming'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('profile_about_app'.tr),
                subtitle: Text('profile_version'.tr),
                trailing: Icon(Icons.chevron_right),
                onTap: onAboutTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
