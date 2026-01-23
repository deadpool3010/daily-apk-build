import 'package:bandhucare_new/core/controller/session_controller.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:bandhucare_new/presentation/user_profile_screen/bottomsheet.dart';
import 'package:bandhucare_new/presentation/login_screen/controller/login_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logoutFunction() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  final session = Get.find<SessionController>();
  session.clearSession();

  // Explicitly delete LoginController to ensure fresh instance
  try {
    if (Get.isRegistered<LoginController>()) {
      Get.delete<LoginController>();
    }
  } catch (e) {
    print('Error deleting LoginController: $e');
  }

  // Use a small delay to ensure cleanup completes before navigation
  await Future.delayed(Duration(milliseconds: 100));

  Get.offAllNamed(AppRoutes.loginScreen);
}

Future<void> logoutBottomSheet(BuildContext context) async {
  await AppBottomSheet.show(
    context: context,
    height: 220,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Logout',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                width: 175,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // close bottom sheet
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 175,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop(); // close sheet first
                    await logoutFunction();
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
