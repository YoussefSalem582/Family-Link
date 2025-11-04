# Testing the Localization Feature 🌍

## Quick Test Guide

### Test 1: Language Switching (30 seconds)
1. **Run the app**
   ```powershell
   flutter run
   ```

2. **Navigate to Profile**
   - Tap the "Profile" icon in bottom navigation

3. **Open Settings**
   - Scroll down to the Settings section

4. **Change Language**
   - Tap the Language dropdown
   - Select "العربية" (Arabic)
   - **Expected**: All text changes to Arabic instantly
   - **Expected**: Layout switches to RTL (right-to-left)

5. **Switch Back**
   - Tap Language dropdown again
   - Select "English"
   - **Expected**: All text changes to English
   - **Expected**: Layout switches to LTR (left-to-right)

### Test 2: Navigation Bar (10 seconds)
**With English selected**, check bottom navigation shows:
- Home
- Meals
- Mood
- Map
- Wall
- Profile

**Switch to Arabic**, check bottom navigation shows:
- الرئيسية (Home)
- الوجبات (Meals)
- المزاج (Mood)
- الخريطة (Map)
- الحائط (Wall)
- الملف الشخصي (Profile)

### Test 3: Each Screen (2 minutes)

#### Home Screen
- **English**: "FamilyLink", "Family Members"
- **Arabic**: "رابط العائلة", "أفراد العائلة"

#### Wall Screen
- Tap "Wall" tab
- **English**: "Family Wall", "Post", "Create Post"
- **Arabic**: "حائط العائلة", "نشر", "إنشاء منشور"
- Tap "+" button → Check dialog text

#### Meals Screen
- Tap "Meals" tab
- **English**: "Family Meals", "Breakfast", "Lunch", "Dinner", "Snack"
- **Arabic**: "وجبات العائلة", "الإفطار", "الغداء", "العشاء", "وجبة خفيفة"
- Tap "+" button → Check dialog text

#### Mood Screen
- Tap "Mood" tab
- **English**: "Family Moods", "Share Mood"
- **Arabic**: "مزاج العائلة", "شارك مزاجك"
- Tap mood icon → Check mood names (Happy → سعيد, Sad → حزين, etc.)

#### Map Screen
- Tap "Map" tab
- **English**: "Family Map", "Members List"
- **Arabic**: "خريطة العائلة", "قائمة الأعضاء"
- Tap list icon → Check sheet title

#### Profile Screen
- Tap "Profile" tab
- **English**: "Profile", "Dark Mode", "Notifications", "Sign Out"
- **Arabic**: "الملف الشخصي", "الوضع الداكن", "الإشعارات", "تسجيل الخروج"

### Test 4: Persistence (15 seconds)
1. **Set language to Arabic**
   - Profile → Settings → Language → العربية

2. **Close the app completely**
   - Swipe away from recent apps

3. **Reopen the app**
   - **Expected**: App opens in Arabic
   - **Expected**: All screens still in Arabic

4. **Switch back to English for next test**

### Test 5: Demo Mode Messages (1 minute)
Check demo banners on each screen:

| Screen  | English                              | Arabic                                   |
|---------|--------------------------------------|------------------------------------------|
| Home    | "Demo Mode - Showing sample data"    | "الوضع التجريبي - عرض بيانات تجريبية"    |
| Wall    | "Demo Mode - Showing sample posts"   | "الوضع التجريبي - عرض منشورات تجريبية"   |
| Meals   | "Demo Mode - Showing sample meals"   | "الوضع التجريبي - عرض وجبات تجريبية"     |
| Mood    | "Demo Mode - Showing sample moods"   | "الوضع التجريبي - عرض مزاج تجريبي"       |
| Map     | "Demo Mode - Showing sample locations" | "الوضع التجريبي - عرض مواقع تجريبية"   |
| Profile | "Demo Mode - Sample profile data"    | "الوضع التجريبي - بيانات ملف تجريبية"    |

### Test 6: Dialogs & Snackbars (1 minute)

#### Sign Out Dialog (Profile screen)
1. Scroll down in Profile
2. Tap "Sign Out"
3. **English**: "Sign Out", "Are you sure...", "Cancel", "Sign Out"
4. **Arabic**: "تسجيل الخروج", "هل أنت متأكد...", "إلغاء", "تسجيل الخروج"

#### Add Meal Dialog (Meals screen)
1. Go to Meals tab
2. Tap "+" button
3. **English**: "Add Meal", "Meal Type", "Eaten", "Cancel", "Add"
4. **Arabic**: "إضافة وجبة", "نوع الوجبة", "تناولت", "إلغاء", "إضافة"

#### Share Mood Sheet (Mood screen)
1. Go to Mood tab
2. Tap mood icon
3. **English**: "How are you feeling?", "Add a note", "Share Mood"
4. **Arabic**: "كيف تشعر؟", "أضف ملاحظة", "شارك مزاجك"

### Test 7: RTL Layout (Arabic) (30 seconds)
When Arabic is selected, verify:
- ✅ Text aligns to the right
- ✅ Icons flip direction (back button, arrows)
- ✅ Navigation drawer opens from right
- ✅ Lists scroll from right to left
- ✅ AppBar actions move to left side
- ✅ Dropdown arrows point correct direction

## Expected Results Summary

| Feature               | Status | Notes                                  |
|-----------------------|--------|----------------------------------------|
| Language Selector     | ✅     | Dropdown in Profile → Settings         |
| English Translation   | ✅     | 180+ keys translated                   |
| Arabic Translation    | ✅     | 180+ keys translated                   |
| RTL Support           | ✅     | Automatic for Arabic                   |
| Persistence           | ✅     | Saved via GetStorage                   |
| Instant Switching     | ✅     | No app restart needed                  |
| All Screens           | ✅     | Home, Wall, Meals, Mood, Map, Profile  |
| All Dialogs           | ✅     | Create, Add, Delete, Sign Out          |
| All Buttons           | ✅     | Add, Cancel, Delete, Save, etc.        |
| All Labels            | ✅     | Breakfast, Happy, Lunch, Sad, etc.     |
| Demo Banners          | ✅     | All 6 screens                          |
| Navigation Bar        | ✅     | All 6 tabs                             |

## Common Issues & Solutions

### Issue: Text not changing
**Solution**: Make sure you're using `.tr` on all strings
```dart
// ❌ Wrong
Text('Hello')

// ✅ Correct
Text('greeting'.tr)
```

### Issue: Language not persisting
**Solution**: LanguageController should be initialized in main()
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(LanguageController());  // This line is important
  runApp(MyApp());
}
```

### Issue: RTL not working
**Solution**: GetX handles RTL automatically when locale is 'ar'. Check main.dart:
```dart
GetMaterialApp(
  translations: AppTranslations(),  // Must be present
  locale: languageController.currentLanguage,  // Must be set
  fallbackLocale: Locale('en'),
)
```

### Issue: "Unused import" warning for GetX
**Note**: This is a false warning. The `.tr` extension comes from GetX, so the import IS being used, even if the analyzer doesn't detect it.

## Performance Benchmarks

| Action                    | Expected Time |
|---------------------------|---------------|
| App launch                | <2s           |
| Language switch           | <100ms        |
| Screen navigation         | Instant       |
| Dialog opening            | <100ms        |
| Settings save             | <50ms         |

## Device Testing

Test on different devices:
- [ ] Android phone
- [ ] Android tablet
- [ ] iOS phone (if available)
- [ ] iOS tablet (if available)
- [ ] Different screen sizes
- [ ] Different OS versions

## Accessibility Testing

- [ ] Screen reader with English
- [ ] Screen reader with Arabic
- [ ] High contrast mode
- [ ] Large text size
- [ ] Keyboard navigation

## Success Criteria ✅

All tests pass if:
1. ✅ Language selector is visible and functional
2. ✅ All text changes when language is switched
3. ✅ Arabic shows correct RTL layout
4. ✅ Language preference persists after restart
5. ✅ No crashes or errors during switching
6. ✅ All 6 main screens fully translated
7. ✅ All dialogs and sheets fully translated
8. ✅ Demo banners show in selected language

## Automation Testing (Optional)

```dart
// Integration test example
testWidgets('Language switching test', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Navigate to profile
  await tester.tap(find.byIcon(Icons.person));
  await tester.pumpAndSettle();
  
  // Change to Arabic
  await tester.tap(find.text('Language'));
  await tester.tap(find.text('العربية'));
  await tester.pumpAndSettle();
  
  // Verify Arabic text appears
  expect(find.text('الملف الشخصي'), findsOneWidget);
});
```

---

**Testing Time**: ~5 minutes for complete manual testing
**Status**: Ready for testing! 🚀

*Last Updated: November 4, 2025*
