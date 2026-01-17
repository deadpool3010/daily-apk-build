import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/presentation/choose_language_screen/controller/choose_language_controller.dart';
import 'package:heroicons/heroicons.dart';

class ChooseLanguageScreen extends StatelessWidget {
  const ChooseLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChooseLanguageController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),

              // Language Selection Section
              _buildLanguageSection(context, controller),

              const SizedBox(height: 40),

              // Illustration Image
              Expanded(
                child: Center(
                  child: Image.asset(
                    ImageConstant.loginLanguage,
                    width: 300,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 300,
                        height: 300,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image,
                          size: 100,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Next Button
              Padding(
                padding: const EdgeInsets.fromLTRB(23, 0, 23, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.proceedToLogin();
                      },
                      child: Container(
                        width: 47,
                        height: 47,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3864FD),
                          borderRadius: BorderRadius.circular(23.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3864FD).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Language Selection Section
  Widget _buildLanguageSection(
    BuildContext context,
    ChooseLanguageController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Choose Language" text
          Text(
            'lbl_choose_language'.tr,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 20 / 22, // line-height / font-size
              letterSpacing: 0,
              color: Color(0xFF3864FD),
            ),
          ),

          const SizedBox(height: 14),

          // "What language would you like the app to be in?" text
          Text(
            'lbl_what_language_would_you_like'.tr,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 16 / 14, // line-height / font-size
              letterSpacing: 0,
              color: Color(0xFF94A3B8),
            ),
          ),

          const SizedBox(height: 30), // Gap between text and dropdown
          // Language Dropdown Selector
          _buildLanguageDropdown(context, controller),
        ],
      ),
    );
  }

  // Custom Language Dropdown Widget
  Widget _buildLanguageDropdown(
    BuildContext context,
    ChooseLanguageController controller,
  ) {
    return Column(
      children: [
        // Dropdown Header (always visible) with Animation
        GestureDetector(
          onTap: () {
            controller.toggleDropdown();
          },
          child: AnimatedBuilder(
            animation: controller.dropdownAnimation,
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: controller.dropdownAnimation.value > 0
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        )
                      : BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        controller.selectedLanguageKey.value.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: controller.dropdownAnimation.value * 0.5,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: HeroIcon(
                        HeroIcons.chevronUpDown,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Expanded Options List with Animation
        AnimatedBuilder(
          animation: controller.dropdownAnimation,
          builder: (context, child) {
            return ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: controller.dropdownAnimation.value,
                child: Opacity(
                  opacity: controller.dropdownAnimation.value,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.1 * controller.dropdownAnimation.value,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Obx(
                      () => Column(
                        children: controller.languageKeys
                            .where(
                              (langKey) =>
                                  langKey !=
                                  controller.selectedLanguageKey.value,
                            )
                            .map((languageKey) {
                              return GestureDetector(
                                onTap: () {
                                  controller.selectLanguage(languageKey);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    languageKey.tr,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
