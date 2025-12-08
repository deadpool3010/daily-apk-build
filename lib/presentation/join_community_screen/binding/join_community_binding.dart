import 'package:get/get.dart';
import 'package:bandhucare_new/presentation/join_community_screen/controller/join_community_controller.dart';

class JoinCommunityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JoinCommunityController());
  }
}
