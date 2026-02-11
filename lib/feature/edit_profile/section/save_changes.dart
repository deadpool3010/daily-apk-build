import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/feature/edit_profile/controller.dart';
import 'package:flutter/material.dart';

class SaveChanges extends StatelessWidget {
  SaveChanges({super.key, this.onTap});
  VoidCallback? onTap;
  final controller = Get.find<EditProfileController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DynamicButton(
        text: "Save Changes",
        onPressed: () {
          if (!controller.formKey.currentState!.validate()) {
            Fluttertoast.showToast(msg: "Name cannot be empty");
            return;
          }
          controller.updateChanges();
        },
        isDisable: controller.isChanged.value,
      );
    });
  }
}
