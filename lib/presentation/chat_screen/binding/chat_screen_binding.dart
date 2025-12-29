import 'package:bandhucare_new/presentation/chat_screen/controller/chat_screeen_controller.dart';
import 'package:get/get.dart';

class ChatScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatScreenController());
  }
}
