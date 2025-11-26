import 'package:get/get.dart';
import '../controller/scan_qr_controller.dart';

class ScanQrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanQrController>(() => ScanQrController());
  }
}

