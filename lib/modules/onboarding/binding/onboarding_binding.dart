import 'package:get/get.dart';
import '../viewmodel/onboarding_viewmodel.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingViewModel());
  }
}
