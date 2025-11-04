# Quick Start Guide - Localization

## 🌍 How to Switch Languages

### From the App:
1. Open the app
2. Navigate to **Profile** tab (bottom right)
3. Scroll down to **SETTINGS** section
4. Tap on the **Language dropdown**
5. Select your preferred language:
   - **English** 🇬🇧
   - **العربية** 🇸🇦

The app will immediately switch to the selected language and remember your choice!

---

## 📱 What Changes When You Switch

### English → Arabic
```
Profile                →  الملف الشخصي
Home                   →  الرئيسية
Settings               →  الإعدادات
Dark Mode              →  الوضع الداكن
Notifications          →  الإشعارات
Sign Out               →  تسجيل الخروج
```

### Layout Changes (Arabic RTL)
```
Before (English):              After (Arabic):
[Icon] Text →                 ← Text [Icon]
Left to Right reading         Right to Left reading
```

---

## 👨‍💻 For Developers: Adding Translations

### 1. Add Translation Keys
**File**: `lib/core/localization/languages/en.dart`
```dart
'my_new_feature': 'My New Feature',
```

**File**: `lib/core/localization/languages/ar.dart`
```dart
'my_new_feature': 'ميزتي الجديدة',
```

### 2. Use in Your Code
```dart
Text('my_new_feature'.tr)
```

That's it! ✨

---

## 🔧 Programmatic Language Control

### Change Language
```dart
Get.find<LanguageController>().changeLanguage('ar');
```

### Toggle Language
```dart
Get.find<LanguageController>().toggleLanguage();
```

### Check Current Language
```dart
String currentLang = Get.find<LanguageController>().currentLanguage;
// Returns: 'en' or 'ar'

bool isArabic = Get.find<LanguageController>().isArabic;
// Returns: true if Arabic
```

---

## 📝 Translation Key Naming Convention

```
<module>_<element>_<description>

Examples:
- home_title
- profile_edit_button
- wall_create_post
- meals_add_meal
- mood_share_mood
```

---

## ✅ Completed Translations

- ✅ App Name
- ✅ Navigation Bar (6 items)
- ✅ Profile Screen (30+ strings)
- ✅ Home Screen Header
- ✅ Settings Section
- ✅ Common Actions (save, cancel, edit, etc.)
- ✅ Demo Mode Messages

## 🚧 Ready for Translation (Keys exist, screens not updated yet)

- 🔜 Wall Screen (20+ keys ready)
- 🔜 Meals Screen (15+ keys ready)
- 🔜 Mood Screen (15+ keys ready)
- 🔜 Map Screen (10+ keys ready)

---

## 🎯 Quick Tips

1. **Always use `.tr`** on display strings
2. **Never translate** user data or API responses
3. **Hot restart** after adding new translations
4. **Test both languages** before releasing
5. **Keep keys descriptive** for easy maintenance

---

## 📞 Need Help?

Check the full documentation: `LOCALIZATION_IMPLEMENTATION.md`

