import 'package:bandhucare_new/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Color backgroundColor;
  final double toolbarHeight;
  final double titleSpacing;
  final Color iconColor;
  final IconData? actionIcon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Color? actionButtonColor;
  final Color? actionTextColor;
  final Color? actionIconColor;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.backgroundColor = Colors.white,
    this.toolbarHeight = 95,
    this.titleSpacing = 50,
    this.iconColor = Colors.black,
    this.actionIcon,
    this.actionText,
    this.onActionPressed,
    this.actionButtonColor,
    this.actionTextColor,
    this.actionIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeight,
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 15),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: iconColor,
                  size: 20,
                ),
                onPressed: () => Get.back(),
              ),
            )
          : null,
      centerTitle: true,

      title: Padding(
        padding: EdgeInsets.only(
          right: (actionIcon != null || actionText != null) ? 0 : titleSpacing,
        ),
        child: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      actions:
          (actionIcon != null || actionText != null) && onActionPressed != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: ElevatedButton.icon(
                  onPressed: onActionPressed,
                  icon: actionIcon != null
                      ? Icon(
                          actionIcon,
                          size: 16,
                          color: actionIconColor ?? Colors.white,
                        )
                      : const SizedBox.shrink(),
                  label: actionText != null
                      ? Text(
                          actionText!,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: actionTextColor ?? Colors.white,
                          ),
                        )
                      : const SizedBox.shrink(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        actionButtonColor ?? AppColors.primaryColor,
                    foregroundColor: Colors.white,
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
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
