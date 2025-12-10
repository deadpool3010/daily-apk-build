import 'package:get/get.dart';
import '../controller/join_group_controller.dart';

class JoinGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JoinGroupController>(() => JoinGroupController());
  }
}
