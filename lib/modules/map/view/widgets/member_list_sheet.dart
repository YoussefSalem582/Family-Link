import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/user_model.dart';

class MemberListSheet extends StatelessWidget {
  final List<UserModel> members;
  final bool isDemoMode;
  final Function(UserModel) onMemberLocationTap;

  const MemberListSheet({
    super.key,
    required this.members,
    required this.isDemoMode,
    required this.onMemberLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'map_family_members'.tr,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getColorForIndex(index),
                    child: Text(
                      member.name[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    member.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          member.location,
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.my_location, color: Colors.blue),
                    onPressed: () {
                      if (member.latitude != null && member.longitude != null) {
                        onMemberLocationTap(member);
                      }
                    },
                  ),
                ),
              );
            },
          ),
          if (isDemoMode)
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'map_demo_locations'.tr,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.red,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
}
