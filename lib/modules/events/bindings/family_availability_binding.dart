import 'package:get/get.dart';
import '../viewmodel/family_availability_viewmodel.dart';
import '../viewmodel/events_viewmodel.dart';

/// Binding for Family Availability View
/// Ensures EventsViewModel is loaded first, then creates FamilyAvailabilityViewModel
class FamilyAvailabilityBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure EventsViewModel is available (may already be loaded)
    if (!Get.isRegistered<EventsViewModel>()) {
      Get.lazyPut<EventsViewModel>(() => EventsViewModel());
    }

    // Create FamilyAvailabilityViewModel
    Get.lazyPut<FamilyAvailabilityViewModel>(
      () => FamilyAvailabilityViewModel(),
    );
  }
}
