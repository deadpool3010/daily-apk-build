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

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.backgroundColor = Colors.white,
    this.toolbarHeight = 95,
    this.titleSpacing = 50,
    this.iconColor = Colors.black,
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
        padding: EdgeInsets.only(right: titleSpacing),
        child: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
