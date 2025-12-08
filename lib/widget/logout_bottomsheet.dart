import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:bandhucare_new/presentation/user_profile_screen/bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logoutFunction() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Get.offAllNamed(AppRoutes.loginScreen);
}

Future<void> logoutBottomSheet(BuildContext context) async {
  await AppBottomSheet.show(
    context: context,
    height: 220,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
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
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // close bottom sheet
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop(); // close sheet first
                    await logoutFunction();
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
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
