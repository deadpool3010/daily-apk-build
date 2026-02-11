import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/feature/user_profile/presentation/models/profile_menu_model.dart';
import 'package:bandhucare_new/feature/user_profile/widgets/logout_bottomsheet.dart';
import 'package:bandhucare_new/feature/user_profile/widgets/profile_menu_item.dart';
import 'package:bandhucare_new/feature/user_profile/widgets/seperator_line.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key});
  @override
  Widget build(BuildContext context) {
    List<ProfileMenuModel> menuItems = [
      ProfileMenuModel(
        icon: JamIcons.userCircle,
        label: 'Personal Information',
        onTap: () => {Get.toNamed(AppRoutes.personalInformationScreen)},
      ),
      ProfileMenuModel(
        icon: TablerIcons.language,
        label: 'Language Settings',
        onTap: () => Get.toNamed(AppRoutes.simpleLanguageScreen),
      ),
      ProfileMenuModel(
        icon: TablerIcons.bell,
        label: 'Notification',
        onTap: () {},
      ),
      ProfileMenuModel(
        icon: TablerIcons.building_hospital,
        label: 'Hospital details',
        onTap: () => Get.toNamed(AppRoutes.hospitalInformationScreen),
      ),
      ProfileMenuModel(
        icon: TablerIcons.building_hospital,
        label: 'Group details',
        onTap: () => Get.toNamed(AppRoutes.groupDetailsScreen),
      ),
      ProfileMenuModel(
        icon: TablerIcons.shield_check,
        label: 'Privacy & Security',
        onTap: () {},
      ),
      ProfileMenuModel(
        icon: Icons.qr_code_scanner,
        label: 'Scan',
        onTap: () {},
      ),
      ProfileMenuModel(
        icon: TablerIcons.arrow_bar_right,
        label: 'Logout',
        onTap: () => logoutBottomSheet(context),
        color: AppColors.errorColor,
      ),
    ];
    return Column(
      children: List.generate(
        menuItems.length,
        (i) => Column(
          children: [
            ProfileMenuItem(
              icon: menuItems[i].icon,
              label: menuItems[i].label,
              onTap: menuItems[i].onTap,
              color: menuItems[i].color,
            ),
            if (i != menuItems.length - 1) ...[
              const SizedBox(height: 20),
              const SeperatorLine(
                height: 1.5,
                horizontalPadding: 20,
                color: Color(0xFFDADADA),
              ),
              const SizedBox(height: 20),
            ],
            if (i == menuItems.length - 1) ...[const SizedBox(height: 60)],
          ],
        ),
      ),
    );
  }
}
