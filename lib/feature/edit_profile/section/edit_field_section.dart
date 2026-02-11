import 'package:bandhucare_new/core/controller/session_controller.dart';
import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/feature/edit_profile/controller.dart';
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
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                SizedBox(height: 25),
                FieldWidget(
                  label: "Full Name",
                  controller: controller.nameController,
                  mandatory: true,
                ),
                SizedBox(height: 20),
                FieldWidget(
                  label: "Gender",
                  readOnly: true,
                  icon: Icons.keyboard_arrow_down,
                  controller: controller.genderController,
                  onTap: () {
                    showCupertinoSelectionSheet(
                      context: context,
                      title: "Gender",
                      items: controller.genderList,
                      labelBuilder: (gender) => gender,
                      selectedIndex: controller.selectedGenderIndex,
                      onDone: () {
                        final index = controller.selectedGenderIndex.value >= 0
                            ? controller.selectedGenderIndex.value
                            : 0;

                        if (index < controller.genderList.length) {
                          controller.genderController.text =
                              controller.genderList[index];
                          controller.selectedGenderIndex.value = index;
                        }
                      },
                      onDismiss: () {
                        final index = controller.selectedGenderIndex.value >= 0
                            ? controller.selectedGenderIndex.value
                            : 0;

                        if (index < controller.genderList.length) {
                          controller.genderController.text =
                              controller.genderList[index];
                          controller.selectedGenderIndex.value = index;
                        }
                      },
                    );
                  },
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
                    showCupertinoSelectionSheet(
                      context: context,
                      title: "States",
                      items: controller.states,
                      labelBuilder: (item) => item.name ?? '',
                      selectedIndex: controller.selectedStateIndex,
                      onDone: () async {
                        final index = controller.selectedStateIndex.value >= 0
                            ? controller.selectedStateIndex.value
                            : 0;

                        if (index < controller.states.length) {
                          controller.selectedStateIndex.value = index;
                          controller.stateController.text =
                              controller.states[index].name ?? '';
                          controller.cityController.text = 'NA';
                          controller.selectedCityIndex.value = -1;

                          final stateCode = controller.states[index].code;
                          if (stateCode != null) {
                            await controller.loadCity(stateCode);
                          }
                        }
                      },
                      onDismiss: () async {
                        final index = controller.selectedStateIndex.value >= 0
                            ? controller.selectedStateIndex.value
                            : 0;

                        if (index < controller.states.length) {
                          controller.selectedStateIndex.value = index;
                          controller.stateController.text =
                              controller.states[index].name ?? '';
                          controller.cityController.text = 'NA';
                          controller.selectedCityIndex.value = -1;

                          final stateCode = controller.states[index].code;
                          if (stateCode != null) {
                            await controller.loadCity(stateCode);
                          }
                        }
                      },
                    );
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
                      showCupertinoSelectionSheet(
                        context: context,
                        title: 'Select City',
                        items: controller.cities,
                        selectedIndex: controller.selectedCityIndex,
                        labelBuilder: (city) => city.name ?? '',
                        onDone: () {
                          final index = controller.selectedCityIndex.value >= 0
                              ? controller.selectedCityIndex.value
                              : 0;

                          if (index < controller.cities.length) {
                            controller.selectedCityIndex.value = index;
                            controller.cityController.text =
                                controller.cities[index].name ?? '';
                          }
                        },
                        onDismiss: () {
                          final index = controller.selectedCityIndex.value >= 0
                              ? controller.selectedCityIndex.value
                              : 0;

                          if (index < controller.cities.length) {
                            controller.selectedCityIndex.value = index;
                            controller.cityController.text =
                                controller.cities[index].name ?? '';
                          }
                        },
                      );
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Fluttertoast.showToast(
                          msg: "Please Select State First",
                        );
                      });
                    }
                  },
                ),
              ],
            ),
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

  void showCupertinoSelectionSheet<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T item) labelBuilder,
    required RxInt selectedIndex,
    required VoidCallback onDone,
    VoidCallback? onDismiss,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
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
                      Text(
                        title,
                        style: const TextStyle(
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
                          onDone();
                          Navigator.of(context).pop();
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
                      itemExtent: 51,
                      scrollController: FixedExtentScrollController(
                        initialItem: selectedIndex.value >= 0
                            ? selectedIndex.value
                            : 0,
                      ),
                      onSelectedItemChanged: (value) {
                        HapticFeedback.selectionClick();
                        SystemSound.play(SystemSoundType.click);
                        selectedIndex.value = value;
                      },
                      children: items
                          .map(
                            (item) => Center(child: Text(labelBuilder(item))),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      if (onDismiss != null) {
        onDismiss();
      }
    });
  }
}
