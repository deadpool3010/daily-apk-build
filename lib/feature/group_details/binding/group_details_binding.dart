import 'package:get/get.dart';
import '../controller/group_details_controller.dart';

class GroupDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupDetailsController>(
      () => GroupDetailsController(),
    );
  }
}

