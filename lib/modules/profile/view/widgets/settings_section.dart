import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsSection extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const SettingsSection({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SETTINGS',
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
                leading: Icon(Icons.dark_mode),
                title: Text('Dark Mode'),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (_) => onThemeToggle(),
                ),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    Get.snackbar(
                      'Settings',
                      'Notifications ${value ? 'enabled' : 'disabled'}',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 2),
                    );
                  },
                ),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Location Sharing'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    Get.snackbar(
                      'Settings',
                      'Location sharing ${value ? 'enabled' : 'disabled'}',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 2),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
