import 'package:flutter/material.dart';

class DemoBannerWidget extends StatelessWidget {
  final String message;

  const DemoBannerWidget({
    super.key,
    this.message = 'Demo Mode - Showing sample data',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      color: Colors.orange.shade100,
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
