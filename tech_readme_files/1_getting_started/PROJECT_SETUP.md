# 🏡 FamilyLink - MVVM Architecture with GetX

A Flutter application designed to keep family members connected across distance. Built with **MVVM (Model-View-ViewModel)** pattern and **GetX** for state management.

## ✅ Project Structure Created

The complete MVVM folder structure has been successfully created with all necessary files:

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_theme.dart           ✅ Light/Dark theme configuration
│   │   └── theme_service.dart       ✅ Theme switching service
│   ├── bindings/
│   │   └── initial_bindings.dart    ✅ Initial dependency injection
│   ├── routes/
│   │   ├── app_pages.dart           ✅ Route definitions with bindings
│   │   └── app_routes.dart          ✅ Route constants
│   ├── utils/
│   │   ├── constants.dart           ✅ App constants
│   │   └── helpers.dart             ✅ Helper functions
│   └── services/
│       ├── firebase_service.dart    ✅ Firebase initialization & auth
│       ├── location_service.dart    ✅ Location tracking
│       ├── notification_service.dart ✅ Push notifications
│       └── storage_service.dart     ✅ Local storage
│
├── data/
│   ├── models/
│   │   ├── user_model.dart          ✅ User data model
│   │   ├── meal_model.dart          ✅ Meal tracking model
│   │   ├── mood_model.dart          ✅ Mood tracking model
│   │   └── post_model.dart          ✅ Wall post model
│   └── repositories/
│       ├── user_repository.dart     ✅ User data operations
│       ├── meal_repository.dart     ✅ Meal CRUD operations
│       ├── mood_repository.dart     ✅ Mood CRUD operations
│       └── wall_repository.dart     ✅ Wall post operations
│
├── modules/
│   ├── home/
│   │   ├── view/home_view.dart      ✅ Home screen UI
│   │   ├── viewmodel/home_viewmodel.dart ✅ Home business logic
│   │   └── widgets/                 ✅ Home-specific widgets
│   ├── meals/
│   │   ├── view/meals_view.dart     ✅ Meals tracking UI
│   │   ├── viewmodel/meals_viewmodel.dart ✅ Meals logic
│   │   └── widgets/                 ✅ Meal-specific widgets
│   ├── mood/
│   │   ├── view/mood_view.dart      ✅ Mood tracking UI
│   │   ├── viewmodel/mood_viewmodel.dart ✅ Mood logic
│   │   └── widgets/                 ✅ Mood-specific widgets
│   ├── map/
│   │   ├── view/map_view.dart       ✅ Family location map UI
│   │   ├── viewmodel/map_viewmodel.dart ✅ Map logic
│   │   └── widgets/                 ✅ Map-specific widgets
│   ├── wall/
│   │   ├── view/wall_view.dart      ✅ Family wall UI
│   │   ├── viewmodel/wall_viewmodel.dart ✅ Wall logic
│   │   └── widgets/                 ✅ Wall-specific widgets
│   └── profile/
│       ├── view/profile_view.dart   ✅ Profile UI
│       ├── viewmodel/profile_viewmodel.dart ✅ Profile logic
│       └── widgets/                 ✅ Profile-specific widgets
│
├── widgets/
│   ├── custom_button.dart           ✅ Reusable button widget
│   ├── custom_card.dart             ✅ Reusable card widget
│   ├── avatar_widget.dart           ✅ Avatar with initials
│   └── loading_indicator.dart       ✅ Loading widget
│
└── main.dart                        ✅ App entry point with GetX setup
```

## 📦 Dependencies Installed

All required packages have been successfully added to `pubspec.yaml`:

### State Management
- ✅ `get: ^4.6.6` - State management and routing
- ✅ `get_storage: ^2.1.1` - Local storage

### Firebase
- ✅ `firebase_core: ^3.8.1`
- ✅ `firebase_auth: ^5.3.3`
- ✅ `firebase_storage: ^12.3.7`
- ✅ `cloud_firestore: ^5.5.2`
- ✅ `firebase_messaging: ^15.1.5`

### Location & Maps
- ✅ `geolocator: ^13.0.2`
- ✅ `google_maps_flutter: ^2.10.0`

### Notifications
- ✅ `flutter_local_notifications: ^18.0.1`

### UI & Utilities
- ✅ `intl: ^0.20.1`
- ✅ `cached_network_image: ^3.4.1`
- ✅ `image_picker: ^1.1.2`
- ✅ `path_provider: ^2.1.5`

## 🚀 Next Steps

### 1. Firebase Configuration

You need to set up Firebase for this project:

#### a. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named "FamilyLink"
3. Enable the following services:
   - Authentication (Email/Password)
   - Cloud Firestore
   - Firebase Storage
   - Cloud Messaging

#### b. Add Firebase Configuration Files

**For Android:**
1. Register your Android app in Firebase Console
2. Download `google-services.json`
3. Place it in `android/app/`

**For iOS:**
1. Register your iOS app in Firebase Console
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/`

#### c. Update Android Configuration

Edit `android/app/build.gradle.kts`:
```kotlin
// Add at the top
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Add this line
}
```

Edit `android/build.gradle.kts`:
```kotlin
dependencies {
    classpath("com.google.gms:google-services:4.4.0") // Add this line
}
```

#### d. Update iOS Configuration

The GoogleService-Info.plist file will be automatically used by iOS.

### 2. Firestore Database Structure

Create these collections in Firestore:

#### Users Collection
```
users/{userId}
  - id: string
  - name: string
  - email: string
  - photoUrl: string?
  - location: string
  - status: string (home/out/traveling)
  - isHome: boolean
  - latitude: number?
  - longitude: number?
  - lastSeen: timestamp
  - fcmToken: string?
```

#### Meals Collection
```
meals/{mealId}
  - id: string
  - userId: string
  - userName: string
  - mealType: string (breakfast/lunch/dinner)
  - isEaten: boolean
  - date: timestamp
  - notes: string?
```

#### Moods Collection
```
moods/{moodId}
  - id: string
  - userId: string
  - userName: string
  - mood: string
  - emoji: string
  - note: string?
  - date: timestamp
```

#### Wall Collection
```
wall/{postId}
  - id: string
  - userId: string
  - userName: string
  - userPhotoUrl: string?
  - text: string?
  - imageUrl: string?
  - voiceUrl: string?
  - createdAt: timestamp
  - likes: array<string>
  - likeCount: number
```

### 3. Firestore Security Rules

Add these security rules in Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read all user data
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Authenticated users can read/write meals
    match /meals/{mealId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Authenticated users can read/write moods
    match /moods/{moodId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Authenticated users can read/write wall posts
    match /wall/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null;
      allow delete: if request.auth != null && 
                       request.auth.uid == resource.data.userId;
    }
  }
}
```

### 4. Run the App

```bash
# For Android
flutter run

# For iOS
flutter run

# For Web (requires additional setup)
flutter run -d chrome
```

## 🎯 Features Overview

### ✅ Implemented
- **MVVM Architecture** - Clean separation of concerns
- **GetX State Management** - Reactive state management
- **Firebase Integration** - Auth, Firestore, Storage, Messaging
- **Modular Structure** - Easy to extend and maintain
- **Theme Support** - Light/Dark mode with persistence
- **Navigation System** - Route management with transitions

### 🚧 To Be Enhanced
- Complete UI implementations for each module
- Add authentication screens (login/register)
- Implement real-time location tracking
- Add image upload functionality
- Implement meal tracking charts
- Add mood history visualization
- Enhance wall posts with comments
- Add push notification handlers
- Implement WiFi-based home detection

## 🏗️ Architecture Pattern

This app follows the **MVVM (Model-View-ViewModel)** pattern:

- **Model**: Data classes in `data/models/`
- **View**: UI screens in `modules/*/view/`
- **ViewModel**: Business logic in `modules/*/viewmodel/`
- **Repository**: Data operations in `data/repositories/`

### Data Flow
```
View → ViewModel → Repository → Firebase
                    ↓
                  Model
```

## 📱 Key Features

1. **Home Status Tracking** - See who's home or out
2. **Meal Tracking** - Mark meals as eaten or skipped
3. **Mood Sharing** - Share daily moods with emoji
4. **Family Map** - See family members' locations
5. **Wall Posts** - Share updates, photos, and notes
6. **Profile Management** - Update user info and settings

## 🔧 Troubleshooting

If you encounter errors:

1. **Missing dependencies**: Run `flutter pub get`
2. **Firebase errors**: Ensure configuration files are in place
3. **Build errors**: Run `flutter clean` then `flutter pub get`
4. **iOS signing issues**: Open Xcode and configure signing

## 📚 Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://pub.dev/packages/get)
- [Firebase Flutter Setup](https://firebase.google.com/docs/flutter/setup)
- [MVVM Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)

## 👨‍💻 Development

This project structure is designed for scalability and maintainability. Feel free to:
- Add new modules following the existing MVVM pattern
- Create reusable widgets in the `widgets/` folder
- Add new services in `core/services/`
- Extend models with additional fields

---

**Built with ❤️ using Flutter, GetX, and Firebase**
