import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../viewmodel/map_viewmodel.dart';

class MapView extends GetView<MapViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Family Map')),
      body: Column(
        children: [
          // Demo Mode Banner
          Obx(() {
            if (controller.isDemoMode.value) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                color: Colors.orange.shade100,
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade900),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Demo Mode - Showing sample location data',
                        style: TextStyle(color: Colors.orange.shade900),
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          }),

          // Map
          Expanded(
            child: Obx(
              () => GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: controller.initialPosition.value,
                  zoom: 5,
                ),
                markers: controller.markers,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
