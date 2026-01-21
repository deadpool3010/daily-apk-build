import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/feature/group_details/widgets/expandable_group_card.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class GroupDetailsScreen extends StatelessWidget {
  const GroupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F9FF),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSearchSection(),
              const SizedBox(height: 24),
              _buildCurrentGroupSection(),
              const SizedBox(height: 24),
              _buildPastGroupsSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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
  Widget _buildSearchSection() {
    return Row(
      children: [
        Expanded(child: TextField(
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
          child: IconButton(onPressed: () {}, icon: const Icon(Ionicons.filter_outline, size: 20, color: AppColors.black,),)),
      ],
    );
  }


  Widget _buildCurrentGroupSection() {
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
        ExpandableGroupCard(
          groupName: 'Head and Neck Survivorship',
          createdDate: 'Created on Jun 1st, 2025',
          location: 'ABC Hospital - Paediatric Ward',
          isActive: true,
          linkedNode: 'Head and Neck Cancer',
          nodeType: 'Section',
          totalUsers: '09',
          contactNo: '1234567890',
          contactName: 'Rajashekar',
          emailAddress: 'madhurisharma@gmail.com',
          hospitalAddress: '1/16/76 ABC Hospital, Vellore, Chennai, B-Block',
          doctorsAndHealthWorkers: [
            {'name': 'Mike Mazowski', 'role': 'Doctor', 'avatar': ''},
            {'name': 'Marvin Robertson', 'role': 'Doctor', 'avatar': ''},
            {'name': 'Bambang Wijayanto', 'role': 'Doctor', 'avatar': ''},
            {'name': 'Gregory Robertson', 'role': 'Health Worker', 'avatar': ''},
            {'name': 'Samuel Witnessa', 'role': 'Health Worker', 'avatar': ''},
            {'name': 'Sururi Mandatson', 'role': 'Health Worker', 'avatar': ''},
            {'name': 'Michael Robbin', 'role': 'Health Worker', 'avatar': ''},
          ],
        ),
      ],
    );
  }

  Widget _buildPastGroupsSection() {
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
        ExpandableGroupCard(
          groupName: 'Paediatric Care Team - May',
          createdDate: 'Created on Jun 1st, 2025',
          location: 'ABC Hospital - Paediatric Ward',
          isActive: false,
          linkedNode: 'Head and Neck Cancer',
          nodeType: 'Section',
          totalUsers: '09',
          contactNo: '1234567890',
          contactName: 'Rajashekar',
          emailAddress: 'madhurisharma@gmail.com',
          hospitalAddress: '1/16/76 ABC Hospital, Vellore, Chennai, B-Block',
          doctorsAndHealthWorkers: [
            {'name': 'Dr. Sarah Johnson', 'role': 'Doctor', 'avatar': ''},
            {'name': 'John Smith', 'role': 'Health Worker', 'avatar': ''},
            {'name': 'Dr. Emily Brown', 'role': 'Doctor', 'avatar': ''},
            {'name': 'Michael Davis', 'role': 'Health Worker', 'avatar': ''},
            {'name': 'Dr. Robert Wilson', 'role': 'Doctor', 'avatar': ''},
            {'name': 'Lisa Anderson', 'role': 'Health Worker', 'avatar': ''},
          ],
        ),
        const SizedBox(height: 16),
        ExpandableGroupCard(
          groupName: 'ABC Group 11098',
          createdDate: 'Created on Jun 1st, 2025',
          location: 'ABC Hospital - Paediatric Ward',
          isActive: false,
          linkedNode: 'Head and Neck Cancer',
          nodeType: 'Section',
          totalUsers: '09',
          contactNo: '1234567890',
          contactName: 'Rajashekar',
          emailAddress: 'madhurisharma@gmail.com',
          hospitalAddress: '1/16/76 ABC Hospital, Vellore, Chennai, B-Block',
          doctorsAndHealthWorkers: [
            {'name': 'Dr. David Lee', 'role': 'Doctor', 'avatar': ''},
            {'name': 'Jennifer Taylor', 'role': 'Health Worker', 'avatar': ''},
            {'name': 'Dr. James White', 'role': 'Doctor', 'avatar': ''},
            {'name': 'Patricia Harris', 'role': 'Health Worker', 'avatar': ''},
            {'name': 'Dr. Christopher Martin', 'role': 'Doctor', 'avatar': ''},
          ],
        ),
      ],
    );
  }
}

