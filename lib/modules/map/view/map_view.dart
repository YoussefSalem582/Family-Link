import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
      appBar: AppBar(
        title: Text('map_title'.tr),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () => _showMembersList(context),
            tooltip: 'map_members_list'.tr,
          ),
        ],
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
                      // My Location
                      MapControlButton(
                        icon: Icons.my_location,
                        onPressed: () {
                          _mapController.move(
                            LatLng(
                              controller.initialPosition.value.latitude,
                              controller.initialPosition.value.longitude,
                            ),
                            12.0,
                          );
                        },
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
    return controller.familyMembers
        .where((member) => member.latitude != null && member.longitude != null)
        .map((member) {
          return Marker(
            point: LatLng(member.latitude!, member.longitude!),
            width: 80,
            height: 80,
            child: GestureDetector(
              onTap: () {
                _showMemberInfo(member.name, member.location);
              },
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      member.name,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Icon(Icons.location_on, color: Colors.red, size: 32),
                ],
              ),
            ),
          );
        })
        .toList();
  }

  void _showMemberInfo(String name, String location) {
    Get.snackbar(
      name,
      location,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.black,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      icon: Icon(Icons.location_on, color: Colors.red),
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
}
