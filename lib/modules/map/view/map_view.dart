import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../widgets/custom_app_bar.dart';
import '../viewmodel/map_viewmodel.dart';
import '../../../widgets/demo_banner_widget.dart';
import 'widgets/map_control_button.dart';
import 'widgets/member_count_card.dart';
import 'widgets/member_list_sheet.dart';

class MapView extends StatefulWidget {
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  final MapViewModel controller = Get.find<MapViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'map_title',
        icon: Icons.map_rounded,
        actionIcon: Icons.people_outline,
        actionTooltip: 'map_members_list',
        onActionPressed: () => _showMembersList(context),
      ),
      body: Column(
        children: [
          // Demo Mode Banner
          Obx(() {
            if (controller.isDemoMode.value) {
              return DemoBannerWidget(message: 'demo_map'.tr);
            }
            return SizedBox.shrink();
          }),

          // Map
          Expanded(
            child: Stack(
              children: [
                Obx(
                  () => FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(
                        controller.initialPosition.value.latitude,
                        controller.initialPosition.value.longitude,
                      ),
                      initialZoom: 5.0,
                      minZoom: 3.0,
                      maxZoom: 18.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.family_link',
                        maxZoom: 19,
                      ),
                      MarkerLayer(markers: _buildMarkers()),
                    ],
                  ),
                ),

                // Custom Controls
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: Column(
                    children: [
                      // Zoom In
                      MapControlButton(
                        icon: Icons.add,
                        onPressed: () {
                          _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom + 1,
                          );
                        },
                      ),
                      SizedBox(height: 12),
                      // Zoom Out
                      MapControlButton(
                        icon: Icons.remove,
                        onPressed: () {
                          _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom - 1,
                          );
                        },
                      ),
                      SizedBox(height: 12),
                      // My Location
                      Obx(
                        () => MapControlButton(
                          icon: controller.isLoadingLocation.value
                              ? Icons.hourglass_empty
                              : Icons.my_location,
                          backgroundColor: controller.isLoadingLocation.value
                              ? Colors.grey[300]
                              : Theme.of(context).primaryColor,
                          iconColor: Colors.white,
                          onPressed: controller.isLoadingLocation.value
                              ? null
                              : () => _goToMyLocation(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Member Count Card
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Obx(
                    () => MemberCountCard(
                      memberCount: controller.familyMembers.length,
                      onViewPressed: () => _showMembersList(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];

    // Add current user marker if location is available AND sharing is enabled
    if (controller.currentUserLocation != null &&
        controller.isLocationSharingEnabled.value) {
      markers.add(
        Marker(
          point: LatLng(
            controller.currentUserLocation!.value.latitude,
            controller.currentUserLocation!.value.longitude,
          ),
          width: 120,
          height: 100,
          child: GestureDetector(
            onTap: () {
              _showMemberInfo('You', 'Your current location');
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name tag
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[700]!, Colors.blue[500]!],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        blurRadius: 12,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: controller.isLiveLocationEnabled.value
                              ? Colors.green
                              : Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (controller.isLiveLocationEnabled.value
                                          ? Colors.green
                                          : Colors.red)
                                      .withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'You',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                // Pin icon with person icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.blue[700],
                      size: 40,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    Positioned(
                      top: 4,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue[700]!,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 12,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Add family member markers
    markers.addAll(
      controller.familyMembers
          .where(
            (member) => member.latitude != null && member.longitude != null,
          )
          .toList()
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final member = entry.value;

            return Marker(
              point: LatLng(member.latitude!, member.longitude!),
              width: 120,
              height: 100,
              child: GestureDetector(
                onTap: () {
                  _showMemberInfo(member.name, member.location);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name tag
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getColorForIndex(index),
                            _getColorForIndex(index).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            member.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),

                    // Pin icon with avatar
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: _getColorForIndex(index),
                          size: 40,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        Positioned(
                          top: 4,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _getColorForIndex(index),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                member.name[0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: _getColorForIndex(index),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          })
          .toList(),
    );

    return markers;
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

  void _showMemberInfo(String name, String location) {
    Get.snackbar(
      '',
      '',
      titleText: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_pin_circle,
              color: Theme.of(Get.context!).primaryColor,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Get.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
      messageText: Padding(
        padding: EdgeInsets.only(left: 52),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              size: 14,
              color: Get.isDarkMode ? Colors.grey[500] : Colors.grey[600],
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                location,
                style: TextStyle(
                  fontSize: 13,
                  color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 16,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 16,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  void _showMembersList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Obx(
        () => MemberListSheet(
          members: controller.familyMembers,
          isDemoMode: controller.isDemoMode.value,
          onMemberLocationTap: (member) {
            if (member.latitude != null && member.longitude != null) {
              _mapController.move(
                LatLng(member.latitude!, member.longitude!),
                12.0,
              );
              Navigator.pop(context);
              Get.snackbar(
                'map_location'.tr,
                'map_showing_location'.tr + ' ${member.name}',
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _goToMyLocation() async {
    if (controller.currentUserLocation != null) {
      _mapController.move(
        LatLng(
          controller.currentUserLocation!.value.latitude,
          controller.currentUserLocation!.value.longitude,
        ),
        15.0,
      );
      Get.snackbar(
        'Your Location',
        'Showing your current location',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: Icon(Icons.my_location, color: Colors.white),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      // Try to get location again
      await controller.refreshCurrentLocation();
      if (controller.currentUserLocation != null) {
        _mapController.move(
          LatLng(
            controller.currentUserLocation!.value.latitude,
            controller.currentUserLocation!.value.longitude,
          ),
          15.0,
        );
        Get.snackbar(
          'Your Location',
          'Location updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        Get.snackbar(
          'Location Error',
          'Unable to get your location. Please check permissions.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          icon: Icon(Icons.warning, color: Colors.white),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    }
  }
}
