import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:bandhucare_new/model/homepage_model.dart';

class CarehubHomeScreenController extends GetxController
    with GetTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final RxBool isAppBarCollapsed = false.obs;
  late AnimationController titleAnimationController;
  late AnimationController searchBarAnimationController;
  late Animation<double> titleFadeAnimation;
  late Animation<double> searchBarFadeAnimation;
  late Animation<Offset> searchBarSlideAnimation;

  // CareHub data observables
  final RxList<CarehubArticle> articles = <CarehubArticle>[].obs;
  final RxList<CarehubStory> stories = <CarehubStory>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  bool _hasCalledApi = false;

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
    
    // Load CareHub data
    if (!_hasCalledApi) {
      loadCarehubData();
    }
  }

  Future<void> loadCarehubData() async {
    if (_hasCalledApi && isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      _hasCalledApi = true;

      // Call API - fetch both articles and stories
      final response = await getCarehubApiService();

      if (response['success'] == true && response['data'] != null) {
        final carehubResponse = CarehubResponse.fromJson(response);

        // Update observables
        articles.value = carehubResponse.data.articles;
        stories.value = carehubResponse.data.stories;

        print('CareHub data loaded successfully');
        print('Articles: ${articles.length}');
        print('Stories: ${stories.length}');
      } else {
        throw Exception(response['message'] ?? 'Failed to load CareHub data');
      }
    } catch (e) {
      print('Error loading CareHub data: $e');
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      _hasCalledApi = false;
    } finally {
      isLoading.value = false;
    }
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