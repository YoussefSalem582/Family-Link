import 'package:get/get.dart';
import '../../modules/splash/view/splash_view.dart';
import '../../modules/splash/viewmodel/splash_viewmodel.dart';
import '../../modules/onboarding/view/onboarding_view.dart';
import '../../modules/onboarding/viewmodel/onboarding_viewmodel.dart';
import '../../modules/auth/view/welcome_view.dart';
import '../../modules/auth/view/login_view.dart';
import '../../modules/auth/view/signup_view.dart';
import '../../modules/auth/view/forgot_password_view.dart';
import '../../modules/auth/binding/auth_binding.dart';
import '../../modules/main_container/view/main_container_view.dart';
import '../../modules/main_container/binding/main_container_binding.dart';
import '../../modules/home/view/home_view.dart';
import '../../modules/home/viewmodel/home_viewmodel.dart';
import '../../modules/meals/view/meals_view.dart';
import '../../modules/meals/viewmodel/meals_viewmodel.dart';
import '../../modules/mood/view/mood_view.dart';
import '../../modules/mood/viewmodel/mood_viewmodel.dart';
import '../../modules/map/view/map_view.dart';
import '../../modules/map/viewmodel/map_viewmodel.dart';
import '../../modules/wall/view/wall_view.dart';
import '../../modules/wall/viewmodel/wall_viewmodel.dart';
import '../../modules/profile/view/profile_view.dart';
import '../../modules/profile/view/settings_view.dart';
import '../../modules/profile/viewmodel/profile_viewmodel.dart';
import '../../modules/events/view/events_view.dart';
import '../../modules/events/viewmodel/events_viewmodel.dart';
import '../../modules/chat/view/chat_view.dart';
import '../../modules/chat/view/chat_list_view.dart';
import '../../modules/chat/viewmodel/chat_viewmodel.dart';
import '../../modules/chat/viewmodel/chat_list_viewmodel.dart';
import '../../modules/wall/view/voice_notes_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SplashViewModel());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => OnboardingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => OnboardingViewModel());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => WelcomeView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignupView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.mainContainer,
      page: () => MainContainerView(),
      binding: MainContainerBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeViewModel());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.meals,
      page: () => MealsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MealsViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.mood,
      page: () => MoodView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MoodViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.map,
      page: () => MapView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MapViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.wall,
      page: () => WallView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => WallViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ProfileViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.events,
      page: () => EventsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => EventsViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => ChatView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ChatViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.chatList,
      page: () => ChatListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ChatListViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.voiceNotes,
      page: () => VoiceNotesView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => WallViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ProfileViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
  ];
}
