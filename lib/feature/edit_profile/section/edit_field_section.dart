import 'package:bandhucare_new/feature/edit_profile/widgets/field_widget.dart';
import 'package:flutter/material.dart';

class EditFieldSection extends StatelessWidget {
  const EditFieldSection({super.key});

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        bottom: keyboardHeight + 50, // ⭐ KEY LINE
      ),
      child: Column(
        children: [
          SizedBox(height: 25),
          FieldWidget(label: "Full Name"),
          SizedBox(height: 20),
          FieldWidget(
            label: "Gender",
            readOnly: true,
            icon: Icons.keyboard_arrow_down,
          ),
          SizedBox(height: 20),
          FieldWidget(label: "House Address", icon: Icons.location_pin),
          SizedBox(height: 20),
          FieldWidget(
            label: "State",
            icon: Icons.keyboard_arrow_down,
            readOnly: true,
          ),
          SizedBox(height: 20),
          FieldWidget(
            label: "City",
            icon: Icons.keyboard_arrow_down,
            readOnly: true,
          ),
        ],
      ),
    );
  }
}
