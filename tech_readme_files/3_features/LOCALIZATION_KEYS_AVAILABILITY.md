# 🌐 Localization Keys for Smart Features

## Required Translation Keys

Add these keys to your translation files for all smart features (Home & Events modules) to work properly.

---

## Events Module Keys

### Navigation & Titles
```dart
'events_calendar' => 'Events Calendar'
'family_availability' => 'Family Availability'
'view_availability' => 'View Availability'
'view_calendar' => 'View Calendar'
'add_event' => 'Add Event'
```

### Availability View Sections
```dart
'suggested_family_time' => '💡 Suggested Family Time'
'find_time_together' => '⏰ Find Time Together'
'family_welcome_activities' => '👋 Family Welcome Activities'
'todays_schedule' => '📊 Today\'s Schedule'
```

### Common Words (Events)
```dart
'available' => 'available'
'activity' => 'Activity'
'join' => 'Join!'
'schedule_event' => 'Schedule Event'
'cancel' => 'Cancel'
```

---

## Home Module Keys

### Smart Status Section
```dart
'family_status' => 'Family Status'
'auto' => 'Auto'
'update_status_for' => 'Update Status for'
```

### Time Formatting
```dart
'just_now' => 'Just now'
'm_ago' => 'm ago'
'h_ago' => 'h ago'
'd_ago' => 'd ago'
```

### Geofence Notifications Section
```dart
'location_updates' => 'Location Updates'
'managed_locations' => 'Managed Locations'
'settings' => 'Settings'
'no_recent_location_updates' => 'No recent location updates'
```

---

## Example Translation Files

### English (en_US.dart)
```dart
const Map<String, String> enUS = {
  // Events Module
  'events_calendar': 'Events Calendar',
  'family_availability': 'Family Availability',
  'view_availability': 'View Availability',
  'view_calendar': 'View Calendar',
  'add_event': 'Add Event',
  
  // Availability Sections
  'suggested_family_time': '💡 Suggested Family Time',
  'find_time_together': '⏰ Find Time Together',
  'family_welcome_activities': '👋 Family Welcome Activities',
  'todays_schedule': '📊 Today\'s Schedule',
  
  // Events Common
  'available': 'available',
  'activity': 'Activity',
  'join': 'Join!',
  'schedule_event': 'Schedule Event',
  'cancel': 'Cancel',
  
  // Home Module - Smart Status
  'family_status': 'Family Status',
  'auto': 'Auto',
  'update_status_for': 'Update Status for',
  
  // Time
  'just_now': 'Just now',
  'm_ago': 'm ago',
  'h_ago': 'h ago',
  'd_ago': 'd ago',
  
  // Geofence Notifications
  'location_updates': 'Location Updates',
  'managed_locations': 'Managed Locations',
  'settings': 'Settings',
  'no_recent_location_updates': 'No recent location updates',
};
```

### Arabic (ar_SA.dart)
```dart
const Map<String, String> arSA = {
  // Events Module
  'events_calendar': 'تقويم الأحداث',
  'family_availability': 'توفر العائلة',
  'view_availability': 'عرض التوفر',
  'view_calendar': 'عرض التقويم',
  'add_event': 'إضافة حدث',
  
  // Availability Sections
  'suggested_family_time': '💡 وقت عائلي مقترح',
  'find_time_together': '⏰ إيجاد وقت معاً',
  'family_welcome_activities': '👋 أنشطة ترحيب عائلي',
  'todays_schedule': '📊 جدول اليوم',
  
  // Events Common
  'available': 'متاح',
  'activity': 'نشاط',
  'join': 'انضم!',
  'schedule_event': 'جدولة حدث',
  'cancel': 'إلغاء',
  
  // Home Module - Smart Status
  'family_status': 'حالة العائلة',
  'auto': 'تلقائي',
  'update_status_for': 'تحديث الحالة لـ',
  
  // Time
  'just_now': 'الآن',
  'm_ago': ' د مضت',
  'h_ago': ' س مضت',
  'd_ago': ' ي مضت',
  
  // Geofence Notifications
  'location_updates': 'تحديثات الموقع',
  'managed_locations': 'المواقع المدارة',
  'settings': 'الإعدادات',
  'no_recent_location_updates': 'لا توجد تحديثات موقع حديثة',
};
```

---

## Implementation Steps

1. **Create or update translation files** in `lib/core/localization/` or `lib/translations/`

2. **Register translations** in your GetX configuration:
```dart
return GetMaterialApp(
  translations: AppTranslations(), // Your translations class
  locale: Get.deviceLocale,
  fallbackLocale: Locale('en', 'US'),
  // ... rest of your app config
);
```

3. **Create AppTranslations class** if not exists:
```dart
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'ar_SA': arSA,
    // Add more languages
  };
}
```

---

## Dark Mode Support

The following components now support dark mode automatically:

### AppBar
- Icon container background adapts to dark mode
- Text color changes for better readability
- Proper contrast in both light and dark themes

### Cards
- Elevated shadows adjust for dark mode
- Background colors adapt automatically
- Color opacity changes for dark backgrounds

### Common Free Slot Cards
- Icon backgrounds use opacity in dark mode
- Text colors (grey[400] vs grey[600])
- Proper contrast for percentage badges

### Family Welcome Cards
- Activity color opacity adjusted for dark mode
- Location and time text colors adapt
- Better visibility in both themes

### FAB (Floating Action Button)
- Icon and text color inverts in dark mode
- Elevation adjusts for dark themes
- Better visibility on dark backgrounds

---

## Testing Checklist

- [ ] Switch between light and dark mode
- [ ] Change language and verify all keys display correctly
- [ ] Check RTL (Right-to-Left) support for Arabic
- [ ] Verify all sections show translated text
- [ ] Test tooltips in different languages
- [ ] Check date formatting for different locales
- [ ] Verify color contrast in dark mode
- [ ] Test with different font sizes (accessibility)

---

## Additional Recommendations

### Date Formatting
Consider localizing date formats using `intl` package:

```dart
import 'package:intl/intl.dart';

// Current
DateFormat('EEEE, MMMM d, y').format(date)

// Localized
DateFormat.yMMMMEEEEd(Get.locale?.languageCode).format(date)
```

### Time Formatting
```dart
// 12-hour vs 24-hour format based on locale
final timeFormat = Get.locale?.languageCode == 'ar' 
    ? DateFormat('HH:mm')  // 24-hour for Arabic
    : DateFormat('h:mm a'); // 12-hour for English
```

### Number Formatting
```dart
// For percentage display
NumberFormat.percentPattern(Get.locale?.languageCode).format(0.75)
```

---

## Features with Dark Mode & Localization

✅ **Events View**
- Dynamic AppBar title
- Localized tooltips
- Dark mode icon container
- Adaptive FAB styling

✅ **Family Availability View**
- All section headers localized
- Date selector (with intl support)
- Event suggestion cards
- Common free slot cards (with dark mode)
- Family welcome cards (with dark mode)
- Timeline view
- Schedule dialog

---

## Color Palette Adjustments

### Light Mode
- Primary color: As defined in theme
- Card backgrounds: White
- Text: Black/Grey[900]
- Disabled: Grey[600]
- Icons: Theme primary

### Dark Mode
- Primary color: Lighter variant
- Card backgrounds: Grey[850]
- Text: White/Grey[100]
- Disabled: Grey[400]
- Icon backgrounds: Opacity 0.3 instead of 0.1

---

**Last Updated:** November 2024  
**Status:** Ready for translation  
**Files Affected:** 2 (events_view.dart, family_availability_view.dart)
