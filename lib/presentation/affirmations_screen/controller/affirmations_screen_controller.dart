import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AffirmationsScreenController extends GetxController {
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

