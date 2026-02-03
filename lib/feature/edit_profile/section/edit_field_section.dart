import 'package:bandhucare_new/core/controller/session_controller.dart';
import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/feature/edit_profile/controller.dart';
import 'package:bandhucare_new/feature/edit_profile/section/save_changes.dart';
import 'package:bandhucare_new/feature/edit_profile/widgets/field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class EditFieldSection extends StatelessWidget {
  EditFieldSection({super.key});
  final controller = Get.find<EditProfileController>();

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GetBuilder<SessionController>(
      builder: (sessionController) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: keyboardHeight + 50),
          child: Column(
            children: [
              SizedBox(height: 25),
              FieldWidget(
                label: "Full Name",
                controller: controller.nameController,
              ),
              SizedBox(height: 20),
              FieldWidget(
                label: "Gender",
                readOnly: true,
                icon: Icons.keyboard_arrow_down,
                controller: controller.genderController,
              ),
              SizedBox(height: 20),
              FieldWidget(
                label: "House Address",
                icon: Icons.location_pin,
                controller: controller.addressController,
              ),
              SizedBox(height: 20),
              FieldWidget(
                label: "State",
                icon: Icons.keyboard_arrow_down,
                readOnly: true,
                onTap: () {
                  buildStateSelectionSheet(context);
                },
                controller: controller.stateController,
              ),
              SizedBox(height: 20),
              FieldWidget(
                label: "City",
                icon: Icons.keyboard_arrow_down,
                readOnly: true,
                controller: controller.cityController,
                onTap: () {
                  if (controller.selectedStateIndex.value != -1) {
                    buildCitySelectionSheet(context);
                  } else {
                    Fluttertoast.showToast(msg: "Please Select State First");
                  }
                },
              ),
              // SaveChanges(onTap: () {}),
            ],
          ),
        );
      },
    );
  }

  Map<String, dynamic> getChangedProfileFeilds() {
    final compare = controller.sessionController.user;

    if (compare?.name.trim() != controller.nameController.text.trim()) {
      controller.changes['name'] = controller.nameController.text;
    }

    if (compare?.gender?.trim() != controller.genderController.text.trim()) {
      controller.changes['gender'] = controller.genderController.text;
    }

    if (compare?.state?.trim() != controller.stateController.text.trim()) {
      controller.changes['state'] = controller.stateController.text;
    }

    if (compare?.city?.trim() != controller.cityController.text.trim()) {
      controller.changes['city'] = controller.cityController.text;
    }
    if (compare?.address?.trim() != controller.addressController.text.trim()) {
      controller.changes['address'] = controller.addressController.text;
    }

    return controller.changes;
  }

  void buildStateSelectionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 350,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // ===== Header =====
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select State',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 0,
                        onPressed: () {
                          int? index = controller.selectedStateIndex.value;
                          print("the id is ${controller.states[index].name} ");
                          print("the id is ${controller.states[index].code} ");

                          final stateCode = controller.states[index].code;
                          controller.loadCity(stateCode!);
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.activeBlue,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== Picker =====
                Expanded(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                    ),
                    child: CupertinoPicker(
                      itemExtent: 51.0,
                      scrollController: FixedExtentScrollController(
                        initialItem: controller.selectedStateIndex.value,
                      ),
                      onSelectedItemChanged: (value) {
                        HapticFeedback.selectionClick();
                        SystemSound.play(SystemSoundType.click);
                        controller.selectedStateIndex.value = value;
                      },
                      children: controller.states
                          .map((state) => Center(child: Text(state.name ?? '')))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void buildCitySelectionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 350,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // ===== Header =====
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select City',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 0,
                        onPressed: () {
                          // print(
                          //   'the code is ${controller.selectedStateIndex.value}',
                          // );
                          // // print("the id is ${controller.states[0].id} ");
                          int index = controller.selectedStateIndex.value;
                          print("the id is ${controller.states[index].name} ");
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.activeBlue,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== Picker =====
                Expanded(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                    ),
                    child: CupertinoPicker(
                      itemExtent: 51.0,
                      scrollController: FixedExtentScrollController(
                        initialItem: controller.selectedStateIndex.value,
                      ),
                      onSelectedItemChanged: (value) {
                        HapticFeedback.selectionClick();
                        SystemSound.play(SystemSoundType.click);
                        controller.selectedStateIndex.value = value;
                      },
                      children: controller.cities
                          .map((city) => Center(child: Text(city.name ?? '')))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
