import 'package:bandhucare_new/core/services/screen_shot_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AffirmationsScreenController extends GetxController {
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    ScreenShotService.screenShotService.disable();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    ScreenShotService.screenShotService.enable();
    super.onClose();
  }
}
