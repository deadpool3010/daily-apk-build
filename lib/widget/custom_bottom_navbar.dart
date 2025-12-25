import 'package:bandhucare_new/core/utils/image_constant.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jam_icons/jam_icons.dart';
import 'package:bandhucare_new/presentation/home_screen/controller/home_screen_controller.dart';

class CustomBottomBar extends StatelessWidget {
  final HomepageController controller;

  const CustomBottomBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const double cornerRadius = 20.0;

    return Container(
      width: double.infinity,
      height: 80,
      child: Stack(
        children: [
          Positioned(
            top: 6,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(cornerRadius),
                  topRight: Radius.circular(cornerRadius),
                  // bottomLeft: Radius.circular(cornerRadius),
                  // bottomRight: Radius.circular(cornerRadius),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 7,
                    spreadRadius: 0,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(context, ImageConstant.home, 'Home', 0),
                  _buildNavItem(
                    context,
                    ImageConstant.chatIcon,
                    'Chat Bot',
                    1,
                    onTap: () async {
                      await Get.toNamed(AppRoutes.chatbotSplashLoadingScreen);
                    },
                  ),
                  _buildNavItem(
                    context,
                    null,
                    'Groups',
                    2,
                    iconData: JamIcons.world,
                  ),
                  _buildNavItem(
                    context,
                    ImageConstant.community_icon,
                    'Community',
                    3,
                    iconData: JamIcons.world,
                  ),
                  _buildNavItem(
                    context,
                    ImageConstant.avatar,
                    'Profile',
                    4,
                    onTap: () async {
                      await Get.toNamed(AppRoutes.userProfileScreen);
                    },
                    resetIndexOnReturn: 0,
                    // resetIndexOnReturn defaults to current index (4) if not specified
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String? imagePath,
    String label,
    int index, {
    IconData? iconData,
    Future<void> Function()? onTap,
    int? resetIndexOnReturn,
  }) {
    return Obx(() {
      bool isSelected = controller.selectedBottomNavIndex.value == index;
      Color itemColor = isSelected ? Colors.lightBlue : Colors.grey[700]!;

      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            controller.changeBottomNavIndex(index);
            if (onTap != null) {
              await onTap();
              // Reset to the current index (or specified resetIndexOnReturn)
              controller.changeBottomNavIndex(resetIndexOnReturn ?? index);
            }
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imagePath != null)
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(itemColor, BlendMode.srcIn),
                    child: Image.asset(imagePath, width: 20, height: 20),
                  )
                else if (iconData != null)
                  Icon(iconData, size: 20, color: itemColor),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: itemColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
