import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'controller/email_register_controller.dart';
import 'package:bandhucare_new/widget/alternative_login_buttons.dart';

class EmailRegisterScreen extends StatelessWidget {
  const EmailRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmailRegisterController>();

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
    );
  }

  // Header Section with Dark Blue Background
  Widget _buildRegisterHeader(EmailRegisterController controller) {
    return CommonLoginRegisterHeader(
      title: 'lbl_go_ahead_and_set_up_account'.tr,
      subtitleText: 'lbl_already_have_an_account'.tr,
      actionText: 'lbl_login'.tr,
      onActionTap: () {
        Get.toNamed(AppRoutes.emailPasswordLoginScreen);
      },
      onBackTap: () {
        Get.toNamed(AppRoutes.registerHomescreen);
      },
    );
  }

  // Content Card Section
  Widget _buildRegisterContentCard(
    BuildContext context,
    EmailRegisterController controller,
    bool keyboardVisible,
  ) {
    const double containerHeightPercentage = 0.68;

    final contentWidget = SingleChildScrollView(
      padding: EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name Input
          _buildFullNameInput(controller),
          const SizedBox(height: 16),

          // Email Input
          _buildEmailInput(controller),
          const SizedBox(height: 16),

          // Create Password Input
          _buildCreatePasswordInput(controller),
          const SizedBox(height: 16),

          // Confirm Password Input
          _buildConfirmPasswordInput(controller),
          const SizedBox(height: 24),

          // Continue Button
          _buildContinueButton(controller),
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
                icon: TablerIcons.phone,
                label: 'lbl_mobile'.tr,
                iconSize: Size(20, 20),
                iconColor: Color(0xFF3864FD),
                onTap: () {
                  Get.toNamed(AppRoutes.mobileRegisterScreen);
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
  Widget _buildFullNameInput(EmailRegisterController controller) {
    return CustomTextField(
      controller: controller.fullNameController,
      hintText: 'lbl_full_name'.tr,
      icon: BootstrapIcons.person,
      keyboardType: TextInputType.name,
    );
  }

  // Email Input
  Widget _buildEmailInput(EmailRegisterController controller) {
    return CustomTextField(
      controller: controller.emailController,
      hintText: 'lbl_email_id'.tr,
      icon: BootstrapIcons.envelope,
      keyboardType: TextInputType.emailAddress,
    );
  }

  // Create Password Input
  Widget _buildCreatePasswordInput(EmailRegisterController controller) {
    return Obx(
      () => CustomTextField(
        controller: controller.createPasswordController,
        hintText: 'lbl_create_password'.tr,
        icon: BootstrapIcons.lock,
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
  Widget _buildConfirmPasswordInput(EmailRegisterController controller) {
    return Obx(
      () => CustomTextField(
        controller: controller.confirmPasswordController,
        hintText: 'lbl_confirm_password'.tr,
        icon: BootstrapIcons.lock,
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

  // Continue Button
  Widget _buildContinueButton(EmailRegisterController controller) {
    return Obx(() {
      final isLoading = controller.isLoading.value;

      return DynamicButton(
        text: isLoading ? '' : 'lbl_continue'.tr,
        width: double.infinity,
        height: 50,
        fontSize: 16,
        onPressed: isLoading
            ? null
            : () {
                controller.handleRegister();
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
