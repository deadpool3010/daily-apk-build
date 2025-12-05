import 'package:get/get.dart';
import '../controller/your_reminders_controller.dart';

class YourRemindersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(YourRemindersController(), permanent: false);
  }
}
