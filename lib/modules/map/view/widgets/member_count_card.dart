import 'package:flutter/material.dart';

class MemberCountCard extends StatelessWidget {
  final int memberCount;
  final VoidCallback onViewPressed;

  const MemberCountCard({
    super.key,
    required this.memberCount,
    required this.onViewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.people, color: Theme.of(context).primaryColor),
            SizedBox(width: 12),
            Text(
              '$memberCount family members',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Spacer(),
            TextButton(onPressed: onViewPressed, child: Text('View')),
          ],
        ),
      ),
    );
  }
}
