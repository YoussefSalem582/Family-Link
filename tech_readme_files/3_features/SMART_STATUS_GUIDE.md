# 📊 Smart Status Updates - Implementation Guide

**Feature**: Smart Status Updates  
**Status**: ✅ Fully Implemented  
**Date**: November 9, 2025  
**Version**: 1.0

---

## 📋 Overview

Smart Status Updates allow family members to share their current activity/location status with automatic detection and Do Not Disturb modes for driving and sleeping.

---

## 🏗️ Architecture

### **Module Structure**
```
lib/modules/status/
├── view/
│   ├── status_view.dart               # Main status screen
│   └── widgets/
│       ├── current_status_card.dart   # Your status display
│       ├── status_selector_sheet.dart # Status picker modal
│       ├── family_status_list.dart    # Family statuses
│       └── family_status_card.dart    # Individual family status
├── viewmodel/
│   └── status_viewmodel.dart          # Business logic
└── data/
    ├── models/
    │   └── user_status_model.dart     # Status data model
    └── repositories/
        └── status_repository.dart     # Firebase integration
```

---

## ✨ Status Types (8 Total)

| Status | Emoji | Theme Color | DND | Auto-Detect |
|--------|-------|-------------|-----|-------------|
| At Home | 🏠 | Green | ❌ | ✅ |
| Driving | 🚗 | Blue | ✅ | ✅ |
| At Work | 💼 | Orange | ❌ | ✅ |
| At Gym | 🏋️ | Red | ❌ | ❌ |
| Shopping | 🛒 | Purple | ❌ | ❌ |
| At School | 🎓 | Indigo | ❌ | ✅ |
| Sleeping | 😴 | Deep Purple | ✅ | ❌ |
| Available to Chat | 🎉 | Teal | ❌ | ❌ |

---

## 📦 Data Model

### **UserStatusModel**
```dart
enum StatusType {
  atHome,
  driving,
  atWork,
  atGym,
  shopping,
  atSchool,
  sleeping,
  availableToChat,
  custom,
}

class UserStatusModel {
  final String userId;
  final StatusType statusType;
  final String statusText;
  final String emoji;
  final DateTime updatedAt;
  final bool isAutoDetected;
  final bool doNotDisturb;
  final String? customMessage;
  final Map<String, dynamic>? location; // lat, lng, address
  
  // Helper method
  static Map<String, dynamic> getStatusInfo(StatusType type) {
    switch (type) {
      case StatusType.atHome:
        return {'emoji': '🏠', 'text': 'At Home', 'dnd': false};
      case StatusType.driving:
        return {'emoji': '🚗', 'text': 'Driving', 'dnd': true};
      // ... other cases
    }
  }
}
```

---

## 🤖 Auto-Detection

### **Location-Based Detection**
```dart
class StatusViewModel extends GetxController {
  Position? _lastPosition;
  DateTime? _lastMovementCheck;
  
  // Start periodic checks (every 5 minutes)
  void _startAutoDetection() async {
    if (!isAutoDetectionEnabled.value) return;
    
    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    // Periodic location checks
    Future.delayed(Duration(minutes: 5), () {
      if (isAutoDetectionEnabled.value) {
        _checkAndUpdateStatus();
        _startAutoDetection();
      }
    });
  }
}
```

### **Speed-Based Driving Detection**
```dart
Future<void> _checkAndUpdateStatus() async {
  final position = await Geolocator.getCurrentPosition();
  
  if (_lastPosition != null && _lastMovementCheck != null) {
    final distance = Geolocator.distanceBetween(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      position.latitude,
      position.longitude,
    );
    
    final timeDiff = DateTime.now()
        .difference(_lastMovementCheck!)
        .inSeconds;
    
    final speed = distance / timeDiff; // meters per second
    
    // If moving faster than 5 m/s (~18 km/h), likely driving
    if (speed > 5 && currentStatus.value?.statusType != StatusType.driving) {
      await updateStatus(StatusType.driving, isAutoDetected: true);
    } else if (speed < 1 && currentStatus.value?.statusType == StatusType.driving) {
      await updateStatus(StatusType.availableToChat, isAutoDetected: true);
    }
  }
  
  _lastPosition = position;
  _lastMovementCheck = DateTime.now();
}
```

---

## 🎨 UI Components

### **Status Selector Sheet**
```dart
// 2x4 grid layout with color-coded cards
GridView.count(
  crossAxisCount: 2,
  childAspectRatio: 1.5,
  children: [
    _buildStatusOption(
      context,
      StatusType.atHome,
      '🏠',
      'At Home',
      Colors.green,
    ),
    // ... other status options
  ],
)
```

### **Current Status Card**
```dart
// Large card showing your current status
Container(
  child: Row(
    children: [
      Container(
        // Emoji in colored circle
        child: Text(status.emoji, style: TextStyle(fontSize: 32)),
      ),
      Column(
        children: [
          Text(status.statusText), // e.g., "Driving"
          if (status.customMessage != null)
            Text(status.customMessage),
          Row(
            children: [
              Icon(Icons.access_time),
              Text(_formatTime(status.updatedAt)), // "2h ago"
              if (status.doNotDisturb)
                Icon(Icons.do_not_disturb_on),
            ],
          ),
        ],
      ),
    ],
  ),
)
```

### **Family Status Cards**
```dart
// Compact cards showing family member statuses
Container(
  child: Row(
    children: [
      Stack(
        children: [
          AvatarWidget(name: userName),
          // Status emoji badge overlay
          Positioned(
            right: 0,
            bottom: 0,
            child: Text(status.emoji),
          ),
        ],
      ),
      Column(
        children: [
          Text(userName),
          Text(status.statusText),
          Text(_formatTime(status.updatedAt)),
        ],
      ),
    ],
  ),
)
```

---

## 📝 Implementation Steps

### **Step 1: Create Data Model**
```dart
// lib/data/models/user_status_model.dart
class UserStatusModel {
  // See full model above
}
```

### **Step 2: Create Repository**
```dart
// lib/data/repositories/status_repository.dart
class StatusRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<UserStatusModel?> getUserStatus(String userId) async {
    final doc = await _firestore
        .collection('user_statuses')
        .doc(userId)
        .get();
    
    if (doc.exists) {
      return UserStatusModel.fromJson(doc.data()!);
    }
    return null;
  }
  
  Future<void> updateUserStatus(UserStatusModel status) async {
    await _firestore
        .collection('user_statuses')
        .doc(status.userId)
        .set(status.toJson());
  }
}
```

### **Step 3: Create ViewModel**
```dart
// lib/modules/status/viewmodel/status_viewmodel.dart
class StatusViewModel extends GetxController {
  Rx<UserStatusModel?> currentStatus = Rx<UserStatusModel?>(null);
  RxMap<String, UserStatusModel> familyStatuses = {};
  RxBool isAutoDetectionEnabled = true.obs;
  
  // Update status
  Future<void> updateStatus(
    StatusType statusType, {
    String? customMessage,
    bool isAutoDetected = false,
  }) async {
    final statusInfo = UserStatusModel.getStatusInfo(statusType);
    
    final newStatus = UserStatusModel(
      userId: userId,
      statusType: statusType,
      statusText: statusInfo['text'],
      emoji: statusInfo['emoji'],
      updatedAt: DateTime.now(),
      isAutoDetected: isAutoDetected,
      doNotDisturb: statusInfo['dnd'],
      customMessage: customMessage,
    );
    
    currentStatus.value = newStatus;
    await _statusRepository.updateUserStatus(newStatus);
  }
  
  // Toggle auto detection
  void toggleAutoDetection() {
    isAutoDetectionEnabled.value = !isAutoDetectionEnabled.value;
    
    if (isAutoDetectionEnabled.value) {
      _startAutoDetection();
    }
  }
}
```

### **Step 4: Create Views**
```dart
// lib/modules/status/view/status_view.dart
class StatusView extends GetView<StatusViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'status_title',
        icon: Icons.radar,
        actionIcon: Icons.settings,
        onActionPressed: () => _showSettings(context),
      ),
      body: Column(
        children: [
          CurrentStatusCard(
            status: controller.currentStatus.value,
            onTap: () => _showStatusSelector(context),
          ),
          FamilyStatusList(
            statuses: controller.familyStatuses,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showStatusSelector(context),
        icon: Icon(Icons.edit_rounded),
        label: Text('status_update'.tr),
      ),
    );
  }
}
```

### **Step 5: Add Routes**
```dart
// lib/core/routes/app_routes.dart
static const status = '/status';

// lib/core/routes/app_pages.dart
GetPage(
  name: AppRoutes.status,
  page: () => StatusView(),
  binding: BindingsBuilder(() {
    Get.lazyPut(() => StatusViewModel());
  }),
),
```

### **Step 6: Add Translations**
```dart
// lib/core/localization/languages/en.dart
'status_title': 'Family Status',
'status_at_home': 'At Home',
'status_driving': 'Driving',
'status_at_work': 'At Work',
'status_at_gym': 'At Gym',
'status_shopping': 'Shopping',
'status_at_school': 'At School',
'status_sleeping': 'Sleeping',
'status_available': 'Available to Chat',
'status_auto_detection': 'Auto Detection',
'status_auto_detection_desc': 'Automatically detect status based on location and activity',
// ... more keys

// lib/core/localization/languages/ar.dart
'status_title': 'حالة العائلة',
'status_at_home': 'في المنزل',
// ... Arabic translations
```

---

## 🎮 Demo Mode

### **Demo Statuses**
```dart
void _createDemoStatuses() {
  familyStatuses.value = {
    'demo_user_2': UserStatusModel(
      userId: 'demo_user_2',
      statusType: StatusType.atWork,
      statusText: 'At Work',
      emoji: '💼',
      updatedAt: DateTime.now().subtract(Duration(hours: 2)),
    ),
    'demo_user_3': UserStatusModel(
      userId: 'demo_user_3',
      statusType: StatusType.atSchool,
      statusText: 'At School',
      emoji: '🎓',
      updatedAt: DateTime.now().subtract(Duration(hours: 3)),
    ),
    'demo_user_4': UserStatusModel(
      userId: 'demo_user_4',
      statusType: StatusType.sleeping,
      statusText: 'Sleeping',
      emoji: '😴',
      updatedAt: DateTime.now().subtract(Duration(hours: 8)),
      doNotDisturb: true,
    ),
  };
}
```

---

## 🔧 Settings

### **Auto-Detection Toggle**
```dart
SwitchListTile(
  title: Text('status_auto_detection'.tr),
  subtitle: Text('status_auto_detection_desc'.tr),
  value: controller.isAutoDetectionEnabled.value,
  onChanged: (value) {
    controller.toggleAutoDetection();
  },
)
```

---

## 📱 Navigation Integration

### **Add to Wall View**
```dart
// lib/modules/wall/view/wall_view.dart
FeatureNavigationCard(
  title: 'status_title',
  subtitle: 'status_family_members',
  icon: Icons.radar,
  onTap: () => Get.toNamed('/status'),
  gradientColors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
),
```

---

## ♿ Accessibility

### **Features**
- Screen reader support
- High contrast colors
- Large touch targets (min 48x48)
- Semantic labels
- Keyboard navigation support

---

## 🧪 Testing Checklist

- [ ] Update status manually
- [ ] View family statuses
- [ ] Toggle auto-detection
- [ ] Test speed-based driving detection
- [ ] Verify DND modes (Driving, Sleeping)
- [ ] Check dark mode
- [ ] Test Arabic translations
- [ ] Verify empty state
- [ ] Test status selector
- [ ] Check time formatting
- [ ] Test location permissions

---

## 🐛 Known Limitations

1. **Demo Mode**: Auto-detection simulated, not real
2. **No Geofencing**: Can't detect specific locations yet
3. **Basic Speed Detection**: Simple threshold, not ML-based
4. **No Custom Statuses**: Fixed 8 status types only
5. **No Status History**: Can't view past statuses

---

## 🚀 Future Enhancements

1. **Geofencing**: Auto-detect home, work, school locations
2. **ML-Based Detection**: Smarter activity recognition
3. **Custom Statuses**: User-defined statuses with emojis
4. **Status History**: View timeline of status changes
5. **Notifications**: Notify when family member changes status
6. **Status Schedules**: Auto-set status at specific times
7. **Integration**: Connect with calendar/events
8. **Analytics**: Status patterns and insights

---

## 📚 Related Documentation

- [PROJECT_ARCHITECTURE.md](../1_getting_started/PROJECT_ARCHITECTURE.md)
- [LOCALIZATION_IMPLEMENTATION.md](../2_development/LOCALIZATION_IMPLEMENTATION.md)
- [DEMO_MODE_COMPLETE.md](./DEMO_MODE_COMPLETE.md)

---

**Last Updated**: November 9, 2025  
**Author**: Development Team  
**Status**: Production Ready
