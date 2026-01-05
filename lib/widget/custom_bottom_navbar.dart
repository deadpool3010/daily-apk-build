import 'package:bandhucare_new/core/utils/image_constant.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bandhucare_new/presentation/home_screen/controller/home_screen_controller.dart';
import 'package:bandhucare_new/theme/app_theme.dart';

class CustomBottomBar extends StatelessWidget {
  final HomepageController controller;

  const CustomBottomBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentIndex = controller.selectedBottomNavIndex.value;
      
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        height: 65,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              context,
              ImageConstant.home,
              null,
              0,
              currentIndex,
            ),
            _buildNavItem(
              context,
              ImageConstant.chatIcon,
              null,
              1,
              currentIndex,
              onTap: () async {
                await Get.toNamed(AppRoutes.chatbotSplashLoadingScreen);
                controller.changeBottomNavIndex(currentIndex);
              },
            ),
            _buildNavItem(
              context,
              ImageConstant.hospitalLogo,
              null,
              2,
              currentIndex,
              isLogo: true,
            ),
            _buildNavItem(
              context,
              ImageConstant.community_icon,
              null,
              3,
              currentIndex,
            ),
            _buildNavItem(
              context,
              ImageConstant.avatar,
              null,
              4,
              currentIndex,
              isProfile: true,
              onTap: () async {
                await Get.toNamed(AppRoutes.userProfileScreen);
                controller.changeBottomNavIndex(0);
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNavItem(
    BuildContext context,
    String? imagePath,
    IconData? iconData,
    int index,
    int currentIndex, {
    Future<void> Function()? onTap,
    bool isProfile = false,
    bool isLogo = false,
  }) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.white : Colors.grey[600]!;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          controller.changeBottomNavIndex(index);
          if (onTap != null) {
            await onTap();
          }
        },
        child: Container(
          height: 65,
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Icon or Image
                isProfile
                    ? _buildProfileIcon(isSelected)
                    : imagePath != null
                        ? isLogo
                            ? _buildLogoIcon(imagePath, isSelected)
                            : _buildImageIcon(imagePath, color, isSelected)
                        : Icon(
                            iconData ?? Icons.circle,
                            size: 24,
                            color: color,
                          ),              
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageIcon(String imagePath, Color color, bool isSelected,) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      child: Image.asset(
        imagePath,
        width: isSelected ? 26 : 24,
        height: isSelected ? 26 : 24,
      ),
    );
  }

  Widget _buildLogoIcon(String imagePath, bool isSelected) {
    return Image.asset(
      imagePath,
      width: isSelected ? 40 : 40,
      height: isSelected ? 40 : 40,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: isSelected ? 40 : 40,
          height: isSelected ? 40 : 40,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.local_hospital,
            size: isSelected ? 20 : 18,
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildProfileIcon(bool isSelected) {
    final borderColor = isSelected ? AppColors.white : Colors.grey[600]!;
    return Container(
      width: isSelected ? 40 : 30,
      height: isSelected ? 40 : 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: isSelected ? 2.5 : 2,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          ImageConstant.avatar,
          width: isSelected ? 30 : 30,
          height: isSelected ? 30 : 30,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
