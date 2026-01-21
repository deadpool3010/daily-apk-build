import 'package:bandhucare_new/feature/group_details/model/group_model.dart';
import 'package:get/get.dart';

class GroupDetailsController extends GetxController {
  final RxList<GroupModel> currentGroups = <GroupModel>[].obs;
  final RxList<GroupModel> pastGroups = <GroupModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadGroups();
  }

  void loadGroups() {
    isLoading.value = true;
    // TODO: Replace with actual API call
    // For now, using mock data
    _loadMockData();
    isLoading.value = false;
  }

  void _loadMockData() {
    currentGroups.value = [
      GroupModel(
        id: '1',
        name: 'Head and Neck Survivorship',
        createdDate: 'Jun 1st, 2025',
        hospitalName: 'ABC Hospital',
        ward: 'Paediatric Ward',
        isActive: true,
      ),
    ];

    pastGroups.value = [
      GroupModel(
        id: '2',
        name: 'Paediatric Care Team - May',
        createdDate: 'Jun 1st, 2025',
        hospitalName: 'ABC Hospital',
        ward: 'Paediatric Ward',
        isActive: false,
      ),
      GroupModel(
        id: '3',
        name: 'ABC Group 11098',
        createdDate: 'Jun 1st, 2025',
        hospitalName: 'ABC Hospital',
        ward: 'Paediatric Ward',
        isActive: false,
      ),
    ];
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

