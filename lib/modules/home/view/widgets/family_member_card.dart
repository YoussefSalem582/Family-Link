import 'package:flutter/material.dart';
import '../../../../widgets/avatar_widget.dart';

class FamilyMemberCard extends StatelessWidget {
  final dynamic member;
  final VoidCallback onTap;

  const FamilyMemberCard({Key? key, required this.member, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isHome = member.isHome;
    final statusColor = isHome ? Colors.green : Colors.orange;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white.withOpacity(0.3) : Colors.white;
    final locationColor = isDark ? Colors.grey[500] : Colors.grey[600];
    final chevronColor = isDark ? Colors.grey[600] : Colors.grey[400];

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  AvatarWidget(
                    name: member.name,
                    photoUrl: member.photoUrl,
                    size: 56,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: Icon(
                        isHome ? Icons.home : Icons.near_me,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            member.location,
                            style: TextStyle(
                              fontSize: 13,
                              color: locationColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        member.status,
                        style: TextStyle(
                          fontSize: 11,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: chevronColor),
            ],
          ),
        ),
      ),
    );
  }
}
