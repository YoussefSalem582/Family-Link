import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FamilyStatusCard extends StatelessWidget {
  final int membersAtHome;
  final int membersOut;
  final int totalMembers;

  const FamilyStatusCard({
    Key? key,
    required this.membersAtHome,
    required this.membersOut,
    required this.totalMembers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.7),
            Theme.of(context).primaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'home_family_status'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('🏠', membersAtHome.toString(), 'home_at_home'.tr),
              _buildDivider(),
              _buildStat('🚶', membersOut.toString(), 'home_away'.tr),
              _buildDivider(),
              _buildStat(
                '👨‍👩‍👧‍👦',
                totalMembers.toString(),
                'home_total'.tr,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 28)),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }
}
