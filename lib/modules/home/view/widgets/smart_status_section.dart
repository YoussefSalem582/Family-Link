import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_status_model.dart';
import '../../viewmodel/home_viewmodel.dart';

/// Widget to display and manage smart status updates
class SmartStatusSection extends GetView<HomeViewModel> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [Colors.blue.shade700, Colors.blue.shade500]
                          : [Colors.blue, Colors.blue.shade300],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.radar, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Text(
                  'family_status'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                Obx(
                  () => Icon(
                    Icons.my_location,
                    size: 16,
                    color: controller.isAutoDetectionEnabled.value
                        ? Colors.green
                        : (isDarkMode ? Colors.grey[600] : Colors.grey),
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  'auto'.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),

        // Status Cards
        Obx(() {
          if (controller.memberStatuses.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.familyMembers.map((member) {
                final status = controller.getStatusForMember(member.id);
                return _buildStatusCard(member.name, status, context);
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatusCard(
    String name,
    UserStatusModel? status,
    BuildContext context,
  ) {
    if (status == null) {
      return SizedBox();
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final statusInfo = UserStatusModel.getStatusInfo(status.statusType);
    final color = statusInfo['color'] as Color;

    return Container(
      width: 140,
      margin: EdgeInsets.only(right: 12),
      child: Card(
        elevation: isDarkMode ? 3 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showStatusSelector(context, status.userId, name),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? color.withOpacity(0.25)
                            : color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(status.emoji, style: TextStyle(fontSize: 24)),
                    ),
                    Spacer(),
                    if (status.doNotDisturb)
                      Icon(
                        Icons.do_not_disturb_on,
                        size: 16,
                        color: Colors.red,
                      ),
                    if (status.isAutoDetected)
                      Icon(Icons.location_on, size: 14, color: Colors.green),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  status.statusText,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  _formatTime(status.updatedAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStatusSelector(
    BuildContext context,
    String userId,
    String userName,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'update_status_for'.tr} $userName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: StatusType.values.map((type) {
                final info = UserStatusModel.getStatusInfo(type);
                return _buildStatusOption(
                  context,
                  type,
                  info['emoji'],
                  info['text'],
                  info['color'],
                  userId,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption(
    BuildContext context,
    StatusType type,
    String emoji,
    String text,
    Color color,
    String userId,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        controller.updateMemberStatus(userId, type);
        Get.back();
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? color.withOpacity(0.2) : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? color.withOpacity(0.5) : color.withOpacity(0.3),
          ),
        ),
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'just_now'.tr;
    if (diff.inMinutes < 60) return '${diff.inMinutes}${'m_ago'.tr}';
    if (diff.inHours < 24) return '${diff.inHours}${'h_ago'.tr}';
    return '${diff.inDays}${'d_ago'.tr}';
  }
}
