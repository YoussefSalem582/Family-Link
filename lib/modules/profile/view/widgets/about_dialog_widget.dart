import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutDialogWidget extends StatelessWidget {
  const AboutDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.family_restroom, color: Colors.blue),
          SizedBox(width: 12),
          Text('app_name'.tr),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('profile_version'.tr),
          SizedBox(height: 16),
          Text(
            'profile_description'.tr,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          SizedBox(height: 16),
          Text(
            'profile_built_with'.tr,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('close'.tr),
        ),
      ],
    );
  }
}
