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
        icon: Icons.person_outline,
        label: 'Personal Information',
        onTap: () => {Get.toNamed(AppRoutes.personalInformationScreen)},
      ),
      ProfileMenuModel(
        icon: Icons.language,
        label: 'Language Settings',
        onTap: () => Get.toNamed(AppRoutes.simpleLanguageScreen),
      ),
      ProfileMenuModel(
        icon: Icons.notifications_outlined,
        label: 'Notification',
        onTap: () {},
      ),
      ProfileMenuModel(
        icon: Icons.local_hospital,
        label: 'Hospital Information',
        onTap: () => Get.toNamed(AppRoutes.hospitalInformationScreen),
      ),
      ProfileMenuModel(
        icon: Icons.security,
        label: 'Privacy & Security',
        onTap: () {},
      ),
      ProfileMenuModel(
        icon: Icons.qr_code_scanner,
        label: 'Scan',
        onTap: () {},
      ),
      ProfileMenuModel(
        icon: Icons.logout,
        label: 'Logout',
        onTap: () => logoutBottomSheet(context),
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
            ),
            if (i != menuItems.length - 1) ...[
              const SizedBox(height: 20),
              const SeperatorLine(height: 3, horizontalPadding: 20),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
