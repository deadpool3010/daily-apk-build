import 'dart:async';
import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:bandhucare_new/model/homepage_model.dart';
import 'package:get/get.dart';

class HomepageController extends GetxController {
  // Observable for selected bottom navigation index
  final selectedBottomNavIndex = 0.obs;

  // Homepage data observables
  final Rx<ProfileInfo?> profileInfo = Rx<ProfileInfo?>(null);
  final Rx<HospitalInfo?> hospitalInfo = Rx<HospitalInfo?>(null);
  final RxList<HomepageGroup> groups = <HomepageGroup>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Flag to track if API has been called (resets when app restarts)
  bool _hasCalledApi = false;

  // Methods
  void changeBottomNavIndex(int index) {
    selectedBottomNavIndex.value = index;
  }

  // Get the currently active group
  HomepageGroup? get activeGroup {
    try {
      return groups.firstWhere((group) => group.isActive == true);
    } catch (e) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Call API only if it hasn't been called yet
    if (!_hasCalledApi) {
      loadHomepageData();
    }
  }

  Future<void> loadHomepageData() async {
    // Prevent multiple simultaneous calls
    if (_hasCalledApi && isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      _hasCalledApi = true;

      // Call API
      final response = await getHomepageApi();

      if (response['success'] == true && response['data'] != null) {
        final homepageResponse = HomepageResponse.fromJson(response);

        // Update observables
        profileInfo.value = homepageResponse.data.profileInfo;
        hospitalInfo.value = homepageResponse.data.hospitalInfo;
        groups.value = homepageResponse.data.groups;

        print('Homepage data loaded successfully');
        print('Profile: ${profileInfo.value?.name}');
        print('Hospital: ${hospitalInfo.value?.hospitalName}');
        print('Groups: ${groups.length}');
      } else {
        throw Exception(response['message'] ?? 'Failed to load homepage data');
      }
    } catch (e) {
      print('Error loading homepage data: $e');
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      // Reset flag on error so it can be retried
      _hasCalledApi = false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
