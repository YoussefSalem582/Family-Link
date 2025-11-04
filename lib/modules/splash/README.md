# Splash & Onboarding Screens

## Overview
The splash and onboarding screens provide a smooth introduction to the FamilyLink app for new users.

## Features

### Splash Screen
- **Animated Logo**: Beautiful entrance animation with elastic effect
- **App Branding**: Displays the FamilyLink logo and tagline
- **Loading Indicator**: Shows progress while initializing the app
- **Dark Mode Support**: Fully adaptive to light and dark themes
- **Smart Navigation**: 
  - First-time users → Onboarding
  - Returning users → Main app

### Onboarding Screens
The app includes 5 onboarding screens showcasing key features:

1. **Stay Connected** (Blue)
   - Real-time family connection
   - Location sharing and updates

2. **Share Meals Together** (Orange)
   - Plan and track family meals
   - Coordinate family time

3. **Track Family Moods** (Purple)
   - Share feelings with family
   - Emotional connection

4. **Real-time Location** (Green)
   - Family member location tracking
   - Safety and security

5. **Family Wall** (Pink)
   - Share photos and updates
   - Create lasting memories

### UI Features
- **Smooth Animations**: Page transitions and indicators
- **Skip Option**: Users can skip onboarding anytime
- **Progress Indicators**: Animated dots showing current page
- **Dark Mode Support**: All screens adapt to theme
- **Responsive Design**: Works on all screen sizes

## File Structure
```
lib/modules/
├── splash/
│   ├── view/
│   │   └── splash_view.dart
│   ├── viewmodel/
│   │   └── splash_viewmodel.dart
│   └── binding/
│       └── splash_binding.dart
└── onboarding/
    ├── view/
    │   └── onboarding_view.dart
    ├── viewmodel/
    │   └── onboarding_viewmodel.dart
    └── binding/
        └── onboarding_binding.dart
```

## How It Works

### Splash Flow
1. App launches → Splash screen displays
2. Check if user has seen onboarding
3. Navigate to:
   - Onboarding (first time)
   - Main app (returning user)

### Onboarding Flow
1. User sees 5 feature screens
2. Can swipe or tap "Next"
3. Can skip anytime with "Skip" button
4. On completion → Marks onboarding as seen
5. Navigates to main app

## Customization

### Changing Onboarding Content
Edit `OnboardingViewModel.onboardingPages`:
```dart
{
  'title': 'Your Title',
  'description': 'Your Description',
  'icon': Icons.your_icon,
  'color': Colors.your_color,
}
```

### Changing Splash Duration
Edit `SplashViewModel._initializeApp()`:
```dart
await Future.delayed(Duration(seconds: 2)); // Change duration
```

### Resetting Onboarding
To see onboarding again, clear storage:
```dart
GetStorage().remove('hasSeenOnboarding');
```

## Assets Used
- `assets/images/app_logo.png` - App logo displayed on splash screen

## Dark Mode Colors
- **Background**: `#121212` (dark) / `white` (light)
- **Surface**: `#1E1E1E`, `#2A2A2A` (dark) / `white` (light)
- **Text**: `white`, `grey[400]` (dark) / `black87`, `grey[600]` (light)
- **Accent**: Theme primary color with gradients

## Dependencies
- `get` - State management and navigation
- `get_storage` - Persistent storage for onboarding status

## Notes
- Splash screen uses animation builders for smooth entrance
- Onboarding uses PageView for swipeable screens
- Both screens are fully responsive and theme-aware
- State is managed using GetX reactive programming
