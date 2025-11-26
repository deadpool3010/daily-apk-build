import 'package:get/get.dart';

class HomepageController extends GetxController {
  // Observable for selected bottom navigation index
  final selectedBottomNavIndex = 0.obs;

  // Methods
  void changeBottomNavIndex(int index) {
    selectedBottomNavIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
