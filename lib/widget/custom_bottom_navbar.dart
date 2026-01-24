import 'dart:async';
import 'package:bandhucare_new/core/utils/image_constant.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:bandhucare_new/widget/search_groups_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bandhucare_new/presentation/home_screen/controller/home_screen_controller.dart';
import 'package:bandhucare_new/theme/app_theme.dart';
import 'package:heroicons/heroicons.dart';
import 'package:bandhucare_new/core/ui/shimmer/shimmer.dart';

class CustomBottomBar extends StatefulWidget {
  final HomepageController controller;

  const CustomBottomBar({super.key, required this.controller});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final GlobalKey _hospitalIconKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentIndex = widget.controller.selectedBottomNavIndex.value;
      final profilePhoto = widget.controller.profileInfo.value?.profilePhoto;
      final activeGroup = widget.controller.activeGroup;
      final activeGroupImage = activeGroup?.image;
      
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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
                    widget.controller.changeBottomNavIndex(currentIndex);
                  },
                ),
                _buildNavItem(
                  context,
                  activeGroupImage != null && activeGroupImage.isNotEmpty
                      ? null
                      : ImageConstant.hospitalLogo,
                  null,
                  2,
                  currentIndex,
                  isLogo: true,
                  iconKey: _hospitalIconKey,
                  groupImage: activeGroupImage,
                  onTap: () async {
                    Navigator.of(context, rootNavigator: true).push(
                      PageRouteBuilder(
                        opaque: false,
                        barrierColor: Colors.transparent,
                        pageBuilder:
                            (context, animation, secondaryAnimation) {
                          return SearchGroupsCard(
                            onClose: () {
                              Navigator.of(context).pop();
                            },
                            hospitalIconKey: _hospitalIconKey,
                          );
                        },
                        transitionsBuilder: (context, animation,
                            secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
                // Community icon temporarily commented out
                // _buildNavItem(
                //   context,
                //   null,
                //   null,
                //   3,
                //   currentIndex,
                //   heroIcon: HeroIcons.user,
                // ),
                _buildNavItem(
                  context,
                  ImageConstant.avatar,
                  null,
                  4,
                  currentIndex,
                  isProfile: true,
                  profilePhoto: profilePhoto,
                  onTap: () async {
                    await Get.toNamed(AppRoutes.userProfileScreen);
                    widget.controller.changeBottomNavIndex(0);
                  },
                ),
              ],
            ),
          ),
        ],
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
    HeroIcons? heroIcon,
    GlobalKey? iconKey,
    String? profilePhoto,
    String? groupImage,
  }) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.white : Colors.grey[600]!;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          widget.controller.changeBottomNavIndex(index);
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
                    ? _buildProfileIcon(isSelected, profilePhoto)
                    : isLogo && groupImage != null && groupImage.isNotEmpty
                        ? _buildGroupLogoIcon(groupImage, isSelected, iconKey)
                        : imagePath != null
                            ? isLogo
                                ? _buildLogoIcon(imagePath, isSelected, iconKey)
                                : _buildImageIcon(imagePath, color, isSelected)
                            : heroIcon != null
                                ? HeroIcon(
                                    heroIcon,
                                    style: HeroIconStyle.solid,
                                    color: color,
                                    size: 24,
                                  )
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

  Widget _buildLogoIcon(String imagePath, bool isSelected, GlobalKey? iconKey) {
    return Image.asset(
      imagePath,
      key: iconKey,
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

  Widget _buildGroupLogoIcon(String groupImage, bool isSelected, GlobalKey? iconKey) {
    return ClipOval(
      child: _DelayedImageWithShimmer(
      imageUrl: groupImage,
      width: 40,
      height: 40,
      fit: BoxFit.contain,
      key: iconKey,
      fallbackWidget: Image.asset(
        ImageConstant.hospitalLogo,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_hospital,
              size: 20,
              color: Colors.white,
            ),
          );
          },
        ),
      ),
    );
  }

  Widget _buildProfileIcon(bool isSelected, String? profilePhoto) {
    final borderColor = isSelected ? AppColors.white : Colors.grey[600]!;
    final size = isSelected ? 30.0 : 30.0;
    final hasActiveGroup = widget.controller.activeGroup != null;
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
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
            child: profilePhoto != null && profilePhoto.isNotEmpty
                ? _DelayedImageWithShimmer(
                    imageUrl: profilePhoto,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    fallbackWidget: Image.asset(
                      ImageConstant.avatar,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    ImageConstant.avatar,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        // Blue dot indicator for active group
      
      ],
    );
  }
}

class _DelayedImageWithShimmer extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Widget fallbackWidget;
  final Key? key;

  const _DelayedImageWithShimmer({
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.fit,
    required this.fallbackWidget,
    this.key,
  }) : super(key: key);

  @override
  State<_DelayedImageWithShimmer> createState() => _DelayedImageWithShimmerState();
}

class _DelayedImageWithShimmerState extends State<_DelayedImageWithShimmer> {
  bool _showImage = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showImage = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showImage) {
      return Shimmer(
        child: Container(
          width: widget.width,
          height: widget.height,
          
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return Image.network(
      widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Shimmer(
          child: Container(
            width: widget.width,
            height: widget.height,
            color: Colors.white,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return widget.fallbackWidget;
      },
    );
  }
}
