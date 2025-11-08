# FamilyLink 👨‍👩‍👧‍👦

A modern family management application built with Flutter, featuring real-time location tracking, meal monitoring, mood sharing, and a family social wall.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.9.2-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-Ready-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 📱 About FamilyLink

FamilyLink helps families stay connected by providing:
- **Real-time location sharing** - Know where your family members are
- **Meal tracking** - Monitor daily eating habits
- **Mood sharing** - Understand how everyone is feeling
- **Family wall** - Share moments and stay engaged
- **Interactive map** - Visual family location overview
- **Profile management** - Customize your experience

## ✨ Features

### 🏠 Home Dashboard
- Family member status overview with real-time indicators
- Activity statistics (members at home/away)
- Location display with last seen timestamps
- Member detail sheets with complete info
- Pull-to-refresh functionality

### 🍽️ Meals Module
- Track all meals (breakfast, lunch, dinner, snacks)
- Mark meals as eaten or skipped
- Calendar navigation to view any date
- Meal history with full persistence
- Family meal overview and statistics
- Prevents duplicate meal entries

### 😊 Mood Tracker
- Share mood with 8 emoji options
- Add optional notes to moods
- View family mood history
- Daily mood tracking
- Mood statistics and insights
- Complete data persistence

### 🗺️ Interactive Map
- Family member location visualization
- OpenStreetMap integration (no API key needed)
- Custom markers with user initials
- Location privacy controls
- Free and open-source solution

### 📅 Events Calendar
- Full calendar view with month navigation
- Multiple event types (birthdays, appointments, holidays, etc.)
- Add, edit, delete events
- Recurring events support
- Upcoming events list
- Color-coded event categories
- Event countdown display

### 💬 Family Wall
- Create text posts with timestamps
- Like and comment on posts
- Delete own posts with confirmation
- Real-time like count updates
- Comment system with threading
- Full CRUD operations with persistence

### 👤 Profile & Settings
- Real-time activity statistics
  - Posts count (from wall)
  - Moods count (from mood tracker)
  - Meals count (from meal tracker)
  - Days active (calculated from all activities)
- View recent posts, moods, and meals
- Dark/Light theme toggle with persistence
- Language switcher (English/Arabic)
- Location sharing controls
- Live location toggle
- Comprehensive settings panel
- Sign out functionality

## 🏗️ Architecture

FamilyLink is built using **MVVM (Model-View-ViewModel)** architecture pattern with **GetX** for state management.

```
lib/
├── core/
│   ├── bindings/         # Dependency injection
│   ├── routes/           # Navigation
│   ├── services/         # Core services
│   ├── theme/            # App theming
│   └── utils/            # Utilities
├── data/
│   ├── models/           # Data models
│   └── repositories/     # Data access layer
├── modules/
│   ├── home/             # Home module
│   ├── meals/            # Meals module
│   ├── mood/             # Mood module
│   ├── map/              # Map module
│   ├── wall/             # Wall module
│   ├── profile/          # Profile module
│   └── main_container/   # Navigation container
└── widgets/              # Reusable widgets
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.x or higher
- Dart SDK 3.9.2 or higher
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YoussefSalem582/Family-Link.git
   cd Family-Link
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

The app will run in **Demo Mode** with sample data if Firebase is not configured.

## 🔥 Firebase Setup (Optional)

To enable real-time features and backend functionality:

1. **Create a Firebase project** at [Firebase Console](https://console.firebase.google.com/)

2. **Enable services:**
   - Authentication (Email/Password, Google Sign-In)
   - Cloud Firestore
   - Firebase Storage
   - Cloud Messaging

3. **Download configuration files:**
   - Android: `google-services.json` → Place in `android/app/`
   - iOS: `GoogleService-Info.plist` → Place in `ios/Runner/`

4. **Run FlutterFire CLI:**
   ```bash
   flutter pub global activate flutterfire_cli
   flutterfire configure
   ```

5. **Restart the app:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

For detailed setup instructions, see [QUICK_START.md](tech_readme_files/QUICK_START.md)

## 🎨 Demo Mode

FamilyLink includes a comprehensive **Demo Mode** that allows you to:
- ✅ Test all features without Firebase setup
- ✅ View sample family data
- ✅ Navigate through all modules
- ✅ Experience the UI and UX

Demo mode activates automatically when Firebase is not configured. Look for the orange banner at the top of each screen.

See [DEMO_MODE_COMPLETE.md](DEMO_MODE_COMPLETE.md) for more details.

## 📦 Dependencies

### Core
- **get** (^4.6.6) - State management & routing
- **get_storage** (^2.1.1) - Local storage

### Firebase
- **firebase_core** (^3.8.1)
- **firebase_auth** (^5.3.3)
- **cloud_firestore** (^5.5.2)
- **firebase_storage** (^12.3.7)
- **firebase_messaging** (^15.1.5)

### Location & Maps
- **geolocator** (^13.0.2)
- **google_maps_flutter** (^2.10.0)

### UI & Media
- **cached_network_image** (^3.4.1)
- **image_picker** (^1.1.2)
- **flutter_svg** (^2.0.10+1)

### Utilities
- **intl** (^0.20.1)
- **connectivity_plus** (^6.1.0)
- **permission_handler** (^11.3.1)
- **url_launcher** (^6.3.1)
- **share_plus** (^10.1.2)
- **flutter_local_notifications** (^18.0.1)

## 🧪 Testing

Run tests with:

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Coverage report
flutter test --coverage
```

## 📱 Supported Platforms

| Platform | Status | Minimum Version |
|----------|--------|-----------------|
| Android  | ✅ Supported | API 21 (Android 5.0) |
| iOS      | ✅ Supported | iOS 12.0+ |
| Web      | 🚧 In Progress | Modern browsers |
| Windows  | 🚧 Planned | Windows 10+ |
| macOS    | 🚧 Planned | macOS 10.14+ |
| Linux    | 🚧 Planned | Ubuntu 20.04+ |

## 🗺️ Roadmap

### Phase 1 - Foundation ✅ COMPLETE
- [x] MVVM architecture setup
- [x] All UI modules with demo mode
- [x] Navigation system
- [x] Theme management
- [x] Project structure

### Phase 2 - Backend Integration 🚀 NEXT
- [ ] Firebase authentication
- [ ] Real-time data sync
- [ ] Push notifications
- [ ] Location tracking
- [ ] Image uploads
- [ ] Production deployment

### Phase 3 - Advanced Features 📋 PLANNED
- [ ] Voice messages
- [ ] Video calls
- [ ] Advanced analytics
- [ ] Multi-language support
- [ ] iOS app release
- [ ] Web version

See [PHASE_2_PLAN.md](PHASE_2_PLAN.md) for detailed roadmap.

## 📸 Screenshots

> Screenshots coming soon after Phase 2 completion

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Youssef Hassan**
- Email: youssef.salem.hassan582@gmail.com
- GitHub: [@YoussefSalem582](https://github.com/YoussefSalem582)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX package for simplified state management
- Firebase for backend infrastructure
- Google Maps for location services
- The open-source community

## 📞 Support

If you encounter any issues or have questions:

1. Check the [documentation](tech_readme_files/)
2. Look for similar [issues](https://github.com/YoussefSalem582/Family-Link/issues)
3. Create a new issue with detailed information
4. Contact: youssef.salem.hassan582@gmail.com

## 🌟 Star History

If you find this project useful, please consider giving it a star ⭐

---

**Project Status:** Phase 1 Complete ✅ | Phase 2 In Planning 🚀

Built with ❤️ using Flutter
