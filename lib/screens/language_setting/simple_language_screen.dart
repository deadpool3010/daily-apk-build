import 'package:bandhucare_new/constant/colors.dart';
import 'package:bandhucare_new/general_widget_&_classes/custom_app_bar.dart';
import 'package:bandhucare_new/general_widget_&_classes/button.dart';
import 'package:bandhucare_new/general_widget_&_classes/choose_language_drop_down.dart';
import 'package:bandhucare_new/general_widget_&_classes/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controller.dart';

class SimpleLanguageScreen extends StatefulWidget {
  const SimpleLanguageScreen({super.key});

  @override
  State<SimpleLanguageScreen> createState() => _SimpleLanguageScreenState();
}

class _SimpleLanguageScreenState extends State<SimpleLanguageScreen> {
  final LanguageSettingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonAppBar(title: 'Language Settings'),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  buildHeader('Choose Language'),
                  const SizedBox(height: 24),
                  Obx(
                    () => ChooseLanguageDropDown(
                      title: 'Choose language you like the app to be in',
                      value: controller.selectedAppLanguage.value,
                      isExpanded:
                          controller.activeTarget.value ==
                          LanguageSelectionTarget.app,
                      onTap: () =>
                          controller.toggleTarget(LanguageSelectionTarget.app),
                      backgroundColor: AppColors.lightBlue2,
                      borderColor: AppColors.borderOfbox,
                    ),
                  ),
                  Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child:
                          controller.activeTarget.value ==
                              LanguageSelectionTarget.app
                          ? _LanguagePickerApp(controller: controller)
                          : const SizedBox(height: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => ChooseLanguageDropDown(
                      title: 'Choose language you like the Mitra to be in',
                      value: controller.selectedMitraLanguage.value,
                      isExpanded:
                          controller.activeTarget.value ==
                          LanguageSelectionTarget.mitra,
                      onTap: () => controller.toggleTarget(
                        LanguageSelectionTarget.mitra,
                      ),
                      backgroundColor: AppColors.lightBlue2,
                      borderColor: AppColors.borderOfbox,
                    ),
                  ),
                  Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child:
                          controller.activeTarget.value ==
                              LanguageSelectionTarget.mitra
                          ? _LanguagePickerMitra(controller: controller)
                          : const SizedBox(height: 12),
                    ),
                  ),
                  const SizedBox(height: 120), // space for button
                ],
              ),
              Positioned(
                // left: 180,
                right: 29,
                bottom: 140,
                child: Center(
                  child: SizedBox(
                    width: 139,
                    height: 50,
                    child: DynamicButton(
                      trailingIcon: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      fontSize: 18,
                      text: 'Continue',
                      onPressed: () async {
                        await controller.saveLanguages();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Language updated successfully'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        Get.back(
                          result: {
                            'appLanguage': controller.selectedAppLanguage.value,
                            'mitraLanguage':
                                controller.selectedMitraLanguage.value,
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguagePickerApp extends StatelessWidget {
  final LanguageSettingController controller;

  const _LanguagePickerApp({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Obx(() {
        return CupertinoPicker(
          scrollController: controller.scrollControllerApp,
          backgroundColor: Colors.white,
          itemExtent: 60,
          selectionOverlay: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              color: const Color(0x299BBEF8).withOpacity(0.3),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onSelectedItemChanged: (index) {
            HapticFeedback.heavyImpact();
            SystemSound.play(SystemSoundType.click);
            controller.handleWheelChange(index);
          },
          children: controller.languages.asMap().entries.map((entry) {
            final index = entry.key;
            final language = entry.value;
            final distance = (index - controller.currentSelectedIndexApp.value)
                .abs();
            final opacity = distance == 0
                ? 1.0
                : distance == 1
                ? 0.7
                : distance == 2
                ? 0.5
                : 0.3;
            final fontWeight = distance == 0
                ? FontWeight.w600
                : distance == 1
                ? FontWeight.w500
                : FontWeight.w400;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  language,
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: fontWeight,
                    color: distance == 0
                        ? const Color(0xFF1E40AF)
                        : Colors.black.withValues(alpha: opacity),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}

class _LanguagePickerMitra extends StatelessWidget {
  final LanguageSettingController controller;

  const _LanguagePickerMitra({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Obx(() {
        //final currentIndex = controller.currentSelectedIndexMitra.value;
        return CupertinoPicker(
          scrollController: controller.scrollControllerMitra,
          backgroundColor: Colors.white,
          itemExtent: 60,
          selectionOverlay: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              color: const Color(0x299BBEF8).withOpacity(0.3),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onSelectedItemChanged: (index) {
            HapticFeedback.heavyImpact();
            SystemSound.play(SystemSoundType.click);
            controller.handleWheelChange(index);
          },
          children: controller.languages.asMap().entries.map((entry) {
            final index = entry.key;
            final language = entry.value;
            final distance =
                (index - controller.currentSelectedIndexMitra.value).abs();
            final opacity = distance == 0
                ? 1.0
                : distance == 1
                ? 0.7
                : distance == 2
                ? 0.5
                : 0.3;
            final fontWeight = distance == 0
                ? FontWeight.w600
                : distance == 1
                ? FontWeight.w500
                : FontWeight.w400;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  language,
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: fontWeight,
                    color: distance == 0
                        ? const Color(0xFF1E40AF)
                        : Colors.black.withValues(alpha: opacity),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}
