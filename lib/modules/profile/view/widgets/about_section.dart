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
          'ABOUT',
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
                title: Text('Help & Support'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Get.snackbar(
                    'Help',
                    'Support page coming soon',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.privacy_tip_outlined),
                title: Text('Privacy Policy'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Get.snackbar(
                    'Privacy',
                    'Privacy policy coming soon',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('About FamilyLink'),
                subtitle: Text('Version 1.0.0'),
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
