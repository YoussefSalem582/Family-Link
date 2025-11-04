# 🛠️ Development Documentation

Active development guides, implementation references, and troubleshooting resources.

---

## 📄 Files in This Section

### 🌍 Localization

#### [LOCALIZATION_IMPLEMENTATION.md](./LOCALIZATION_IMPLEMENTATION.md)
**Use when:** Adding or modifying translations

**Contents:**
- How to add new translation keys
- Updating existing translations
- Best practices for localization
- Code examples

---

#### [LOCALIZATION_TESTING_GUIDE.md](./LOCALIZATION_TESTING_GUIDE.md)
**Use when:** Testing language features

**Contents:**
- Manual testing procedures
- Test scenarios for both languages
- RTL testing for Arabic
- Validation checklist

---

#### [TRANSLATION_REFERENCE.md](./TRANSLATION_REFERENCE.md)
**Use when:** Looking up translation keys

**Contents:**
- Complete list of all 216+ translation keys
- Organized by module/feature
- English and Arabic values
- Quick search reference

---

### 🎮 Demo Mode

#### [DEMO_MODE_IMPROVEMENTS.md](./DEMO_MODE_IMPROVEMENTS.md)
**Use when:** Working with demo functionality

**Contents:**
- Demo mode implementation details
- How to add demo data
- Demo vs. production behavior
- Best practices

---

### 🐛 Bug Fixes & Testing

#### [BUG_FIXES_AND_FREE_MAP.md](./BUG_FIXES_AND_FREE_MAP.md)
**Use when:** Encountering or fixing issues

**Contents:**
- Known issues and solutions
- Map/Location troubleshooting
- Common error fixes
- Workarounds

---

#### [DATA_PERSISTENCE_TEST.md](./DATA_PERSISTENCE_TEST.md)
**Use when:** Testing data storage and persistence

**Contents:**
- Data persistence testing guide
- GetStorage implementation details
- Test scenarios for posts, meals, and moods
- Storage keys and date format reference
- Debug logging information

---

#### [QUICK_FEATURE_GUIDE.md](./QUICK_FEATURE_GUIDE.md)
**Use when:** Need quick reference for implemented features

**Contents:**
- Visual feature guides with UI mockups
- Step-by-step testing instructions
- Real-time update behavior
- Pro tips and demo data reference
- Quick 5-minute test sequence

---

## 🎯 Common Development Tasks

### Adding a New Translation

1. Open [TRANSLATION_REFERENCE.md](./TRANSLATION_REFERENCE.md)
2. Find the appropriate category
3. Follow [LOCALIZATION_IMPLEMENTATION.md](./LOCALIZATION_IMPLEMENTATION.md) guide
4. Test using [LOCALIZATION_TESTING_GUIDE.md](./LOCALIZATION_TESTING_GUIDE.md)

### Fixing a Bug

1. Check [BUG_FIXES_AND_FREE_MAP.md](./BUG_FIXES_AND_FREE_MAP.md) for known issues
2. Search for similar problems
3. Apply documented solutions
4. Update the file if you find a new fix

### Working with Demo Data

1. Review [DEMO_MODE_IMPROVEMENTS.md](./DEMO_MODE_IMPROVEMENTS.md)
2. Understand demo vs. real mode
3. Add demo data following patterns
4. Test both modes

---

## 📊 Quick Reference Tables

### Translation Key Naming Convention
| Module | Prefix | Example |
|--------|--------|---------|
| Home | `home_` | `home_family_status` |
| Profile | `profile_` | `profile_edit` |
| Wall | `wall_` | `wall_create_post` |
| Meals | `meals_` | `meals_add_meal` |
| Mood | `mood_` | `mood_share_mood` |
| Map | `map_` | `map_title` |
| General | (none) | `app_name`, `loading` |

### File Modification Workflow
```
1. Read relevant guide
2. Make changes
3. Test locally
4. Update documentation if needed
5. Commit with clear message
```

---

## 🔧 Development Tools & Commands

### Flutter Commands
```bash
# Get dependencies
flutter pub get

# Run app
flutter run

# Build release
flutter build apk

# Clean build
flutter clean

# Check for issues
flutter doctor
```

### Localization Commands
```bash
# Check current language
Get.locale

# Change language
Get.updateLocale(Locale('ar'))

# Get translation
'key'.tr
```

---

## 🆘 Common Issues & Solutions

### Issue: Translation not showing
**Solution:** 
1. Check key exists in [TRANSLATION_REFERENCE.md](./TRANSLATION_REFERENCE.md)
2. Verify `.tr` is appended to string
3. Restart app after adding keys

### Issue: RTL layout broken
**Solution:**
1. Check MaterialApp has proper locale setup
2. Verify widget wrapping
3. Test with `Directionality` widget

### Issue: Demo data not loading
**Solution:**
1. Verify Firebase initialization status
2. Check `isDemoMode` flag
3. Review [DEMO_MODE_IMPROVEMENTS.md](./DEMO_MODE_IMPROVEMENTS.md)

---

## 📚 Learning Path

For new developers working on this project:

```
1. Start → LOCALIZATION_IMPLEMENTATION.md
   └─ Learn translation system basics
   
2. Practice → TRANSLATION_REFERENCE.md
   └─ Familiarize with existing keys
   
3. Validate → LOCALIZATION_TESTING_GUIDE.md
   └─ Test your changes properly
   
4. Advanced → DEMO_MODE_IMPROVEMENTS.md
   └─ Understand demo functionality
   
5. Troubleshoot → BUG_FIXES_AND_FREE_MAP.md
   └─ Solve common issues
```

---

## 🎓 Best Practices

### ✅ DO
- Use existing translation keys when possible
- Follow naming conventions
- Test in both languages
- Update documentation when making changes
- Keep demo data realistic but generic

### ❌ DON'T
- Hardcode strings in UI
- Skip RTL testing for Arabic
- Mix demo and production logic
- Leave TODO comments without tracking
- Duplicate translation keys

---

## 🔄 Continuous Improvement

These guides are living documents. If you:
- ✨ Find a better way to do something
- 🐛 Discover a new issue and solution
- 💡 Have suggestions for clarity
- 📝 Notice outdated information

**Please update the documentation!**

---

**Last Updated:** November 4, 2025  
**Maintained By:** Development Team
