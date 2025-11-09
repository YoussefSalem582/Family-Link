import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/geofence_model.dart';
import '../../viewmodel/home_viewmodel.dart';

/// Widget to display arrival/departure notifications
class GeofenceNotificationsSection extends GetView<HomeViewModel> {
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
                          ? [Colors.purple.shade700, Colors.purple.shade500]
                          : [Colors.purple, Colors.purple.shade300],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.location_on, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Text(
                  'location_updates'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.settings, size: 20),
              onPressed: () => _showLocationSettings(context),
              tooltip: 'settings'.tr,
            ),
          ],
        ),
        SizedBox(height: 16),

        // Recent Notifications
        Obx(() {
          if (controller.recentNotifications.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: controller.recentNotifications.take(3).map((
              notification,
            ) {
              return _buildNotificationCard(notification, context);
            }).toList(),
          );
        }),

        // Managed Locations
        SizedBox(height: 16),
        Text(
          'managed_locations'.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.geofenceLocations.map((location) {
              return _buildLocationChip(location);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(
    LocationNotification notification,
    BuildContext context,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isRecent =
        DateTime.now().difference(notification.timestamp).inMinutes < 30;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isRecent ? 3 : (isDarkMode ? 2 : 1),
        color: isRecent
            ? (isDarkMode
                  ? Colors.blue.shade900.withOpacity(0.3)
                  : Colors.blue.shade50)
            : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? (notification.isArrival
                            ? Colors.green.withOpacity(0.3)
                            : Colors.orange.withOpacity(0.3))
                      : (notification.isArrival
                            ? Colors.green.shade100
                            : Colors.orange.shade100),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification.isArrival ? Icons.home : Icons.directions_car,
                  color: notification.isArrival ? Colors.green : Colors.orange,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isRecent
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _formatTime(notification.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(notification.location.emoji, style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationChip(GeofenceLocation location) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Chip(
          avatar: Text(location.emoji, style: TextStyle(fontSize: 16)),
          label: Text(location.name, style: TextStyle(fontSize: 12)),
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
          visualDensity: VisualDensity.compact,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.notifications_off,
                  size: 48,
                  color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                ),
                SizedBox(height: 12),
                Text(
                  'no_recent_location_updates'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLocationSettings(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    controller: scrollController,
                    itemCount: controller.geofenceLocations.length,
                    itemBuilder: (context, index) {
                      final location = controller.geofenceLocations[index];
                      return _buildLocationSettingItem(location);
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddLocationDialog(context),
                  icon: Icon(Icons.add_location),
                  label: Text('Add Location'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSettingItem(GeofenceLocation location) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Text(location.emoji, style: TextStyle(fontSize: 24)),
        title: Text(location.name),
        subtitle: Text(location.address ?? 'No address'),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Notify on Arrival'),
                  value: location.notifyOnArrival,
                  onChanged: (value) {
                    controller.toggleLocationNotifications(
                      location.id,
                      value,
                      location.notifyOnDeparture,
                    );
                  },
                ),
                SwitchListTile(
                  title: Text('Notify on Departure'),
                  value: location.notifyOnDeparture,
                  onChanged: (value) {
                    controller.toggleLocationNotifications(
                      location.id,
                      location.notifyOnArrival,
                      value,
                    );
                  },
                ),
                SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    controller.removeGeofenceLocation(location.id);
                    Get.back();
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                  label: Text(
                    'Remove Location',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddLocationDialog(BuildContext context) {
    // This would normally show a location picker
    Get.snackbar(
      'Add Location',
      'Location picker would open here',
      duration: Duration(seconds: 2),
    );
  }

  String _formatTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} days ago';
  }
}
