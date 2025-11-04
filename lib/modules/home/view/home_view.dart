import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/home_viewmodel.dart';
import '../../../core/routes/app_routes.dart';
import '../../../widgets/avatar_widget.dart';
import '../../../widgets/custom_card.dart';

class HomeView extends GetView<HomeViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FamilyLink'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Get.toNamed(AppRoutes.profile),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.loadFamilyMembers();
          },
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Demo Mode Banner
              if (controller.isDemoMode.value)
                Container(
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
                          'Demo Mode - Firebase not configured.\nShowing sample data.',
                          style: TextStyle(color: Colors.orange.shade900),
                        ),
                      ),
                    ],
                  ),
                ),

              // Summary Card
              CustomCard(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        '🏠 Home',
                        controller.membersAtHome.toString(),
                      ),
                      _buildStat('🚶 Out', controller.membersOut.toString()),
                      _buildStat(
                        '👨‍👩‍👧‍👦 Total',
                        controller.familyMembers.length.toString(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Family Members List
              Text(
                'Family Members',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 12),

              ...controller.familyMembers.map(
                (member) => _buildMemberCard(context, member),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildMemberCard(BuildContext context, member) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: AvatarWidget(
          name: member.name,
          photoUrl: member.photoUrl,
          size: 50,
        ),
        title: Text(member.name),
        subtitle: Text('${member.location} • ${member.status}'),
        trailing: Icon(
          member.isHome ? Icons.home : Icons.near_me,
          color: member.isHome ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}
