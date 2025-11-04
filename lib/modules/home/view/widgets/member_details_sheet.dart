import 'package:flutter/material.dart';
import '../../../../widgets/avatar_widget.dart';

class MemberDetailsSheet extends StatelessWidget {
  final dynamic member;
  final bool isDemoMode;

  const MemberDetailsSheet({
    Key? key,
    required this.member,
    this.isDemoMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AvatarWidget(name: member.name, photoUrl: member.photoUrl, size: 80),
          SizedBox(height: 16),
          Text(
            member.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(member.email, style: TextStyle(color: Colors.grey[600])),
          SizedBox(height: 24),
          _buildDetailRow(Icons.location_on, 'Location', member.location),
          SizedBox(height: 12),
          _buildDetailRow(
            member.isHome ? Icons.home : Icons.near_me,
            'Status',
            member.status,
          ),
          SizedBox(height: 24),
          if (isDemoMode)
            Text(
              'Demo Mode - Details are sample data',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(value, style: TextStyle(color: Colors.grey[800])),
        ),
      ],
    );
  }
}
