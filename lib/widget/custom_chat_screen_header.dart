import 'package:bandhucare_new/core/utils/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:bandhucare_new/theme/app_theme.dart';

class ChatScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.chatScreenHeader,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.35), width: 1.05),
        ),
      ),
      child: AppBar(
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 11, top: 41, bottom: 25),
          child: InkWell(
            onTap: () {
              // Use Navigator for safe navigation without snackbar dependencies
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            child: Icon(Icons.arrow_back_ios_new, size: 22),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 41, bottom: 25),
          child: Image.asset(
            ImageConstant.mitra_logo_header,
            height: 20,
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFEDF2F7),
        elevation: 0,
        toolbarHeight: 90,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 0, top: 41, bottom: 25),
            child: Icon(Icons.language, size: 22),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 11, top: 41, bottom: 25),
            child: Icon(Icons.keyboard_arrow_down, size: 22),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
