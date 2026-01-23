import 'package:bandhucare_new/feature/edit_profile/section/edit_field_section.dart';
import 'package:bandhucare_new/feature/edit_profile/section/profile_image.dart';
import 'package:bandhucare_new/widget/custom_app_bar.dart';
import 'package:bandhucare_new/widget/custom_button.dart';
import 'package:flutter/material.dart';

class EditProfileUi extends StatelessWidget {
  const EditProfileUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Edit Profile", titleSpacing: 150),
      body: Column(
        children: [
          EditProfileImage(),
          Expanded(child: EditFieldSection()),
          DynamicButton(
            text: "Save Changes",
            onPressed: () {},
            fontSize: 15,
            height: 50,
            width: 160,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
