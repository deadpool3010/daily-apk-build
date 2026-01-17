import 'package:bandhucare_new/feature/hospital_information/controller/hospital_controller.dart';
import 'package:get/get.dart';

class HospitalInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HospitalController());
  }
}
