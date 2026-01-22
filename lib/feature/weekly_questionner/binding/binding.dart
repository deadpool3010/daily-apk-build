import 'package:bandhucare_new/feature/weekly_questionner/controller/weekly_questionner_controller.dart';
import 'package:bandhucare_new/feature/search_function/controller/controller.dart';
import 'package:get/get.dart';

class WeeklyQuestionnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WeeklyQuestionnerController());
    Get.lazyPut(() => Search());
  }
}
