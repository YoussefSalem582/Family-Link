class AppConstants {
  // App Info
  static const String appName = 'FamilyLink';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String wallCollection = 'wall';
  static const String mealsCollection = 'meals';
  static const String moodsCollection = 'moods';

  // Storage Keys
  static const String userIdKey = 'userId';
  static const String userNameKey = 'userName';
  static const String themeKey = 'isDarkMode';

  // Status Types
  static const String statusHome = 'home';
  static const String statusOut = 'out';
  static const String statusTraveling = 'traveling';

  // Meal Types
  static const String breakfast = 'breakfast';
  static const String lunch = 'lunch';
  static const String dinner = 'dinner';

  // Mood Emojis
  static const Map<String, String> moodEmojis = {
    'happy': '😊',
    'sad': '😢',
    'excited': '🤩',
    'tired': '😴',
    'stressed': '😰',
    'loved': '🥰',
    'angry': '😠',
    'peaceful': '😌',
  };
}
