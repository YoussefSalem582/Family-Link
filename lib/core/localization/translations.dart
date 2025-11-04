import 'package:get/get.dart';
import 'languages/ar.dart';
import 'languages/en.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en': en, 'ar': ar};
}
