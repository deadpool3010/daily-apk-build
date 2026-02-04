import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/feature/edit_profile/section/edit_field_section.dart';
import 'package:bandhucare_new/feature/edit_profile/section/profile_image.dart';
import 'package:bandhucare_new/feature/edit_profile/section/save_changes.dart';
import 'package:bandhucare_new/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';

class EditProfileUi extends StatelessWidget {
  const EditProfileUi({super.key});

  void _handleBackPressed() {
    if (MediaQuery.of(Get.context!).viewInsets.bottom > 0) {
      FocusManager.instance.primaryFocus?.unfocus();
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBackPressed();
      },
      child: Scaffold(
        //  resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: CommonAppBar(
          title: "Edit Profile",
          titleSpacing: 150,
          onActionPressed: _handleBackPressed,
        ),
        body: Column(
          children: [
            EditProfileImage(),
            Expanded(child: EditFieldSection()),
            SaveChanges(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
