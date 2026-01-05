import 'package:bandhucare_new/presentation/documents_screen/controller/documents_screen_controller.dart';
import 'package:get/get.dart';

class DocumentsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentsScreenController>(
      () => DocumentsScreenController(),
    );
  }
}

