import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bandhucare_new/core/controller/session_controller.dart';
import 'package:bandhucare_new/feature/userProfile/widgets/avatar.dart';
import 'package:flutter/material.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionController>(
      builder: (sessionController) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Row(
          children: [
            Avatar(),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${sessionController.user?.name}",
                  style: TextStyle(
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${sessionController.user?.email ?? sessionController.user?.abhaAddress}",
                  style: TextStyle(
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Spacer(), // Pushes edit icon to the end
            Icon(Icons.edit, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
