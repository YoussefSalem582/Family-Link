import 'package:flutter/material.dart';

class DemoBannerWidget extends StatelessWidget {
  final String message;

  const DemoBannerWidget({
    Key? key,
    this.message = 'Demo Mode - Firebase not configured.\nShowing sample data.',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade900),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.orange.shade900),
            ),
          ),
        ],
      ),
    );
  }
}
