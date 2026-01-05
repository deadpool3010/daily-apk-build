import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentTypeHomeScreenController extends GetxController
    with GetTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final RxBool isAppBarCollapsed = false.obs;
  late AnimationController titleAnimationController;
  late AnimationController searchBarAnimationController;
  late Animation<double> titleFadeAnimation;
  late Animation<double> searchBarFadeAnimation;
  late Animation<Offset> searchBarSlideAnimation;
  
  // Flag to determine if header image should be shown
  bool showHeaderImage = true;

  @override
  void onInit() {
    super.onInit();
    // Get the argument passed during navigation
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      showHeaderImage = arguments['showHeaderImage'] ?? true;
    }
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
    // Threshold based on typical screen height * 0.28 (expandedHeight) - toolbar
    final screenHeight = Get.height;
    final expandedHeight = screenHeight * 0.28;
    final threshold = (expandedHeight - kToolbarHeight - 30);
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

