import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarehubHomeScreenController extends GetxController
    with GetTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final RxBool isAppBarCollapsed = false.obs;
  late AnimationController titleAnimationController;
  late AnimationController searchBarAnimationController;
  late Animation<double> titleFadeAnimation;
  late Animation<double> searchBarFadeAnimation;
  late Animation<Offset> searchBarSlideAnimation;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(onScroll);
    titleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    titleFadeAnimation = CurvedAnimation(
      parent: titleAnimationController,
      curve: Curves.easeInOutCubic,
    );
    searchBarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    searchBarFadeAnimation = CurvedAnimation(
      parent: searchBarAnimationController,
      curve: Curves.easeInOutCubic,
    );
    searchBarSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: searchBarAnimationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void onClose() {
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    titleAnimationController.dispose();
    searchBarAnimationController.dispose();
    super.onClose();
  }

  void onScroll() {
    if (!scrollController.hasClients) return;
    
    final scrollOffset = scrollController.offset;
    final threshold = (220 - kToolbarHeight - 30);
    final isCollapsed = scrollOffset > threshold;
    
    if (isCollapsed != isAppBarCollapsed.value) {
      isAppBarCollapsed.value = isCollapsed;
      if (isCollapsed) {
        titleAnimationController.forward();
        searchBarAnimationController.forward();
      } else {
        titleAnimationController.reverse();
        searchBarAnimationController.reverse();
      }
    }
  }
}

