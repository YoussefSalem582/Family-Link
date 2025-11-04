import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileDialog extends StatelessWidget {
  final String currentName;
  final String currentLocation;

  const EditProfileDialog({
    super.key,
    required this.currentName,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: currentName);
    final locationController = TextEditingController(text: currentLocation);

    return AlertDialog(
      title: Text('profile_edit'.tr),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'profile_name'.tr,
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'profile_location'.tr,
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              Navigator.pop(context);
              Get.snackbar(
                'success'.tr,
                'profile_updated'.tr,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: Duration(seconds: 2),
              );
            }
          },
          child: Text('save'.tr),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
