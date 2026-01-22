import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/feature/group_details/controller/group_details_controller.dart';
import 'package:bandhucare_new/feature/group_details/model/group_model.dart';
import 'package:bandhucare_new/feature/group_details/widgets/expandable_group_card.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class GroupDetailsScreen extends StatelessWidget {
  const GroupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GroupDetailsController>();
    
    return Scaffold(
      backgroundColor: Color(0xFFF3F9FF),
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.red[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.loadGroups(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildSearchSection(controller),
                const SizedBox(height: 24),
                _buildCurrentGroupSection(controller),
                const SizedBox(height: 24),
                _buildPastGroupsSection(controller),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF3F9FF),
      elevation: 0,
      surfaceTintColor: const Color(0xFFF3F9FF),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text("Group Details", style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(AppRoutes.joinGroupScreen);
                },
                icon: const Icon(
                  TablerIcons.qrcode,
                  size: 16,
                  color: AppColors.primaryColor,
                ),
                label: Text(
                  'Join Group',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE5EFFE),
                  foregroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildSearchSection(GroupDetailsController controller) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) => controller.onSearchChanged(value),
            decoration: InputDecoration(
              hintText: 'Search Groups',
              hintStyle: GoogleFonts.lato(
                fontSize: 14,
                color: const Color(0xFFB8B8B8),
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: const Color(0xFFFFFFFF),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                  width: 1,
                ),
              ),
              prefixIcon: const Icon(
                TablerIcons.search,
                size: 24,
                color: Color(0xFFB8B8B8),
              ),
            ),
            style: GoogleFonts.lato(
              fontSize: 14,
              color: AppColors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderColor, width: 1),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Ionicons.filter_outline,
              size: 20,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildCurrentGroupSection(GroupDetailsController controller) {
    final filteredGroups = controller.filteredCurrentGroups;

    if (filteredGroups.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Groups',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFE7EEF4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'No active groups found',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Groups',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...filteredGroups.map((group) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildGroupCard(group),
            )),
      ],
    );
  }

  Widget _buildPastGroupsSection(GroupDetailsController controller) {
    final filteredGroups = controller.filteredPastGroups;

    if (filteredGroups.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Past Groups',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFE7EEF4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'No past groups found',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past Groups',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...filteredGroups.map((group) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildGroupCard(group),
            )),
      ],
    );
  }

  Widget _buildGroupCard(GroupModel group) {
    // Map members to doctors and health workers format
    List<Map<String, String>> doctorsAndHealthWorkers = group.members
        .map((member) => {
              'name': member.name,
              'role': member.userType == 'doctor' ? 'Doctor' : 'Health Worker',
              'avatar': member.profilePhoto ?? '',
            })
        .toList();

    return ExpandableGroupCard(
      groupName: group.name,
      createdDate: group.createdDate,
      location: group.location,
      isActive: group.isActive,
      linkedNode: group.associatedNodeName ?? 'N/A',
      nodeType: group.associatedNodeType ?? 'N/A',
      totalUsers: group.members.length.toString().padLeft(2, '0'),
      contactNo: group.contactNumber ?? 'N/A',
      contactName: group.contactPersonName ?? 'N/A',
      emailAddress: group.contactEmail ?? 'N/A',
      hospitalAddress: group.address ?? 'N/A',
      doctorsAndHealthWorkers: doctorsAndHealthWorkers,
    );
  }
}

