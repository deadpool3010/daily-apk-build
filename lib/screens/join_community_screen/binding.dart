import 'package:get/get.dart';
import 'package:bandhucare_new/screens/join_community_screen/join_community_controller.dart';

class JoinCommunityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JoinCommunityController());
  }
}
