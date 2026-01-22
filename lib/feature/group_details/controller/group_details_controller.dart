import 'dart:async';

import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:bandhucare_new/feature/group_details/model/group_model.dart';
import 'package:get/get.dart';

class GroupDetailsController extends GetxController {
  final RxList<GroupModel> currentGroups = <GroupModel>[].obs;
  final RxList<GroupModel> pastGroups = <GroupModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadGroups();
  }

  Future<void> loadGroups() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Call API (language is automatically retrieved from SharedPreferences in the API function)
      final response = await getUserGroupsApi();

      if (response['success'] == true && response['data'] != null) {
        final groupsData = response['data']['groups'] as List<dynamic>?;

        if (groupsData != null) {
          final allGroups = groupsData
              .map((group) => GroupModel.fromJson(group as Map<String, dynamic>))
              .toList();

          // Separate active and inactive groups
          currentGroups.value =
              allGroups.where((group) => group.isActive).toList();
          pastGroups.value =
              allGroups.where((group) => !group.isActive).toList();

          print('Loaded ${currentGroups.length} current groups and ${pastGroups.length} past groups');
        } else {
          currentGroups.value = [];
          pastGroups.value = [];
        }
      } else {
        throw Exception(response['message'] ?? 'Failed to load groups');
      }
    } catch (e) {
      print('Error loading groups: $e');
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      currentGroups.value = [];
      pastGroups.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  List<GroupModel> get filteredCurrentGroups {
    if (searchQuery.value.isEmpty) {
      return currentGroups;
    }
    return currentGroups
        .where((group) =>
            group.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            group.hospitalName
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  List<GroupModel> get filteredPastGroups {
    if (searchQuery.value.isEmpty) {
      return pastGroups;
    }
    return pastGroups
        .where((group) =>
            group.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            group.hospitalName
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void onJoinGroupTap() {
    // TODO: Navigate to join group screen
    Get.toNamed('/join-group');
  }
}

