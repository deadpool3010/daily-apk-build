import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/core/utils/context_extensions.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'controller/mobile_register_controller.dart';
import 'package:bandhucare_new/widget/alternative_login_buttons.dart';

class MobileRegisterScreen extends StatelessWidget {
  const MobileRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MobileRegisterController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: SafeArea(
            top: false,
            bottom: context.hasThreeButtonNavigation,
            child: Builder(
              builder: (context) {
                final keyboardVisible =
                    MediaQuery.of(context).viewInsets.bottom > 0;

                if (keyboardVisible) {
                  return Stack(
                    children: [
                      Column(
                        children: [_buildRegisterHeader(controller), Spacer()],
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: _buildRegisterContentCard(
                          context,
                          controller,
                          keyboardVisible,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Stack(
                    children: [
                      // Header Section with Dark Blue Background
                      _buildRegisterHeader(controller),

                      // Content Card Section
                      _buildRegisterContentCard(
                        context,
                        controller,
                        keyboardVisible,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  // Header Section with Dark Blue Background
  Widget _buildRegisterHeader(MobileRegisterController controller) {
    return CommonLoginRegisterHeader(
      title: 'lbl_go_ahead_and_set_up_account'.tr,
      subtitleText: 'lbl_already_have_an_account'.tr,
      actionText: 'lbl_login'.tr,
      onActionTap: () {
        Get.toNamed(AppRoutes.mobilePasswordLoginScreen);
      },
      onBackTap: () {
        Get.toNamed(AppRoutes.registerHomescreen);
      },
    );
  }

  // Content Card Section
  Widget _buildRegisterContentCard(
    BuildContext context,
    MobileRegisterController controller,
    bool keyboardVisible,
  ) {
    const double containerHeightPercentage = 0.68;
    final loginController = Get.find<LoginController>();
    final contentWidget = SingleChildScrollView(
      padding: EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name Input
          _buildFullNameInput(controller),
          const SizedBox(height: 16),

          // Mobile Number Input
          _buildMobileNumberInput(controller),
          const SizedBox(height: 16),

          // Create Password Input
          _buildCreatePasswordInput(controller),
          const SizedBox(height: 16),

          // Confirm Password Input
          _buildConfirmPasswordInput(controller),
          const SizedBox(height: 24),

          // Get OTP Button
          _buildGetOtpButton(controller),
          const SizedBox(height: 24),

          // Separator
          Row(
            children: [
              Expanded(child: Divider(color: Color(0xFFCBD5E1), thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'lbl_other_options'.tr,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(child: Divider(color: Color(0xFFCBD5E1), thickness: 1)),
            ],
          ),
          const SizedBox(height: 24),

          // Alternative Registration Options
          AlternativeLoginButtons(
            buttons: [
              AlternativeButtonConfig(
                icon: Icons.g_mobiledata,
                label: 'lbl_google'.tr,
                iconColor: Colors.orange,
                onTap: () {
                  // Handle Google registration
                  loginController.handleGoogleLogin();
                },
              ),
              AlternativeButtonConfig(
                label: 'lbl_abha_id'.tr,
                iconColor: Color(0xFF3864FD),
                imagePath: ImageConstant.ayushmanBharat,
                onTap: () {
                  Get.toNamed(AppRoutes.abhaRegisterScreen);
                },
              ),
              AlternativeButtonConfig(
                icon: TablerIcons.mail,
                label: 'lbl_email_id'.tr,
                iconSize: Size(20, 20),
                iconColor: Color(0xFF3864FD),
                onTap: () {
                  Get.toNamed(AppRoutes.emailRegisterScreen);
                },
              ),
            ],
          ),
        ],
      ),
    );

    final containerDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;

        final containerHeight = keyboardVisible
            ? availableHeight
            : containerHeightPercentage * availableHeight;

        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: containerHeight,
              child: Container(
                width: double.infinity,
                decoration: containerDecoration,
                child: contentWidget,
              ),
            ),
          ],
        );
      },
    );
  }

  // Full Name Input
  Widget _buildFullNameInput(MobileRegisterController controller) {
    return CustomTextField(
      controller: controller.fullNameController,
      hintText: 'lbl_full_name'.tr,
      hintStyle: GoogleFonts.lato(
        fontWeight: FontWeight.w500,
        color: Color(0xFF94A3B8),
        fontSize: 14,
      ),
      icon: BootstrapIcons.person,
      keyboardType: TextInputType.name,
    );
  }

  // Mobile Number Input
  Widget _buildMobileNumberInput(MobileRegisterController controller) {
    return CustomTextField(
      controller: controller.mobileController,
      hintText: 'lbl_mobile_number'.tr,
      iconSize: 16,
      icon: BootstrapIcons.telephone,
      hintStyle: GoogleFonts.lato(
        fontWeight: FontWeight.w500,
        color: Color(0xFF94A3B8),
        fontSize: 14,
      ),
      keyboardType: TextInputType.phone,
      maxLength: 10,
      onChanged: (value) {
        // Only allow numeric input
        if (value.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(value)) {
          // Remove non-numeric characters
          final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
          controller.mobileController.value = TextEditingValue(
            text: numericValue,
            selection: TextSelection.collapsed(offset: numericValue.length),
          );
          return;
        }
        if (value.length == 10) {
          FocusScope.of(Get.context!).unfocus();
        }
      },
    );
  }

  // Create Password Input
  Widget _buildCreatePasswordInput(MobileRegisterController controller) {
    return Obx(
      () => CustomTextField(
        controller: controller.createPasswordController,
        hintText: 'lbl_create_password'.tr,
        icon: BootstrapIcons.lock,
        hintStyle: GoogleFonts.lato(
          fontWeight: FontWeight.w500,
          color: Color(0xFF94A3B8),
          fontSize: 14,
        ),
        keyboardType: TextInputType.visiblePassword,
        obscureText: !controller.isCreatePasswordVisible.value,
        showPasswordToggle: true,
        onTogglePassword: () {
          controller.toggleCreatePasswordVisibility();
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  // Confirm Password Input
  Widget _buildConfirmPasswordInput(MobileRegisterController controller) {
    return Obx(
      () => CustomTextField(
        controller: controller.confirmPasswordController,
        hintText: 'lbl_confirm_password'.tr,
        icon: BootstrapIcons.lock,
        hintStyle: GoogleFonts.lato(
          fontWeight: FontWeight.w500,
          color: Color(0xFF94A3B8),
          fontSize: 14,
        ),
        keyboardType: TextInputType.visiblePassword,
        obscureText: !controller.isConfirmPasswordVisible.value,
        showPasswordToggle: true,
        onTogglePassword: () {
          controller.toggleConfirmPasswordVisibility();
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  // Get OTP Button
  Widget _buildGetOtpButton(MobileRegisterController controller) {
    return Obx(() {
      final isLoading = controller.isLoading.value;

      return DynamicButton(
        text: isLoading ? '' : 'lbl_sign_up'.tr,
        width: double.infinity,
        height: 50,
        fontSize: 16,
        onPressed: isLoading
            ? null
            : () {
                final fullName = controller.fullNameController.text.trim();
                final mobile = controller.mobileController.text.trim();
                final createPassword = controller.createPasswordController.text
                    .trim();
                final confirmPassword = controller
                    .confirmPasswordController
                    .text
                    .trim();

                // Validate before calling handleRegister
                if (controller.validateFullName(fullName) &&
                    controller.validateMobileNumber(mobile) &&
                    controller.validatePassword(createPassword) &&
                    controller.validateConfirmPassword(
                      createPassword,
                      confirmPassword,
                    )) {
                  controller.handleRegister();
                }
              },
        leadingIcon: isLoading
            ? LoadingAnimationWidget.horizontalRotatingDots(
                color: Colors.white,
                size: 24,
              )
            : null,
      );
    });
  }
}
