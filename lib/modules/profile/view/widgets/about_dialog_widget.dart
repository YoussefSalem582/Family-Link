import 'package:flutter/material.dart';

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
          Text('FamilyLink'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Version 1.0.0'),
          SizedBox(height: 16),
          Text(
            'FamilyLink helps families stay connected through shared meals, mood tracking, location sharing, and a family wall.',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          SizedBox(height: 16),
          Text(
            'Built with Flutter & GetX',
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
          child: Text('Close'),
        ),
      ],
    );
  }
}
