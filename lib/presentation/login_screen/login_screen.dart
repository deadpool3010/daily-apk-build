import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
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
                    Column(children: [_buildLoginHeader(controller), Spacer()]),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _buildLoginContentCard(
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
                    _buildLoginHeader(controller),

                    // Content Card Section
                    _buildLoginContentCard(
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
  Widget _buildLoginHeader(LoginController controller) {
    return CommonLoginRegisterHeader(
      title: 'lbl_go_ahead_and_set_up_your_account'.tr,
      subtitleText: 'lbl_dont_have_an_account'.tr,
      actionText: 'lbl_register'.tr,
      onActionTap: () {
        Get.toNamed(AppRoutes.registerHomescreen);
      },
      onBackTap: () {
        Get.back();
      },
    );
  }

  // Content Card Section
  Widget _buildLoginContentCard(
    BuildContext context,
    LoginController controller,
    bool keyboardVisible,
  ) {
    // Adjust this value to control container height when keyboard is not visible
    // When keyboard is visible: container will be full height automatically
    const double containerHeightPercentage =
        0.70; // Slightly increased for longer text

    final contentWidget = SingleChildScrollView(
      padding: EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instruction Text
          Text(
            'msg_enter_mobile_number_linked_to_abha'.tr,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),

          // Mobile Number Input
          _buildMobileNumberInput(controller),
          const SizedBox(height: 16),

          // OTP Input with Get OTP Button
          _buildOTPInputWithButton(controller),
          const SizedBox(height: 24),

          // Login Button
          _buildLoginButton(controller),
          const SizedBox(height: 24),

          // Separator
          Row(
            children: [
              Expanded(child: Divider(color: Color(0xFFCBD5E1), thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'lbl_or_login_with'.tr,
                  style: GoogleFonts.lato(
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

          // Alternative Login Options
          _buildAlternativeLoginOptions(controller),
        ],
      ),
    );

    final containerDecoration = BoxDecoration(
      color: Color(0xFFF8F9FA),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;

        // When keyboard is visible: use full available height, when not: use percentage
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

  // Mobile Number Input
  Widget _buildMobileNumberInput(LoginController controller) {
    return CustomTextField(
      controller: controller.phoneController,
      hintText: '1234567890',
      countryCode: '+91',
      keyboardType: TextInputType.phone,
      maxLength: 10,
      iconColor: AppColors.primaryColor,
      hintStyle: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF94A3B8),
      ),
      textStyle: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF94A3B8),
      ),
      onChanged: (value) {
        // Only allow numeric input
        if (value.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(value)) {
          // Remove non-numeric characters
          final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
          controller.phoneController.value = TextEditingValue(
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

  // OTP Input with Get OTP Button
  Widget _buildOTPInputWithButton(LoginController controller) {
    return Column(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE2E8F0), width: 1),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: _buildPinCodeField(controller),
                    ),
                  ),
                  Obx(
                    () => Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                        onPressed: controller.isLoadingSignIn.value
                            ? null
                            : () {
                                final phone = controller.phoneController.text.trim();
                                if (controller.validatePhoneNumber(phone)) {
                                  controller.handleGetOTP();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3864FD),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12, // Reduced padding
                            vertical: 8,
                          ),
                          minimumSize: Size(0, 0), // Allow button to shrink
                        ),
                        child: controller.isLoadingSignIn.value
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'lbl_get_otp'.tr,
                                  style: GoogleFonts.lato(
                                    fontSize: 13, // Slightly reduced
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Hint text below OTP field instead of overlay
        Obx(
          () =>
              controller.showGetOtpHint.value &&
                  controller.enteredOtp.value.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: GestureDetector(
                    onTap: () {
                      controller.showGetOtpHint.value = false;
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'msg_click_get_otp_to_receive_code'.tr,
                            style: GoogleFonts.lato(
                              fontSize: 11, // Slightly reduced
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }

  // Login Button
  Widget _buildLoginButton(LoginController controller) {
    return Obx(() {
      final isLoading = controller.isLoadingVerifyOtp.value;
      final otpLength = controller.enteredOtp.value.length;

      return DynamicButton(
        text: isLoading ? '' : 'lbl_login'.tr,
        width: double.infinity,
        height: 50,
        fontSize: 16,
        onPressed: isLoading || otpLength != 6
            ? null
            : () {
                // Verify OTP when button is clicked
                final otp = controller.enteredOtp.value;
                if (controller.validateOTP(otp)) {
                  controller.verifyOTPforMobileNumber(otp);
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

  // Alternative Login Options
  Widget _buildAlternativeLoginOptions(LoginController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildAlternativeLoginButton(
            onTap: () {
              controller.handleGoogleLogin();
            },
            icon: Icons.g_mobiledata,
            label: 'lbl_google'.tr,
            iconColor: Colors.orange,
            route: null, // Google login handler
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAlternativeLoginButton(
            icon: BootstrapIcons.telephone_fill,
            label: 'lbl_mobile'.tr,
            iconSize: Size(16, 16),
            iconColor: Color(0xFF3864FD),
            route: AppRoutes.mobilePasswordLoginScreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAlternativeLoginButton(
            icon: TablerIcons.mail,
            label: 'lbl_email_id'.tr,
            iconColor: Color(0xFF3864FD),
            route: AppRoutes.emailPasswordLoginScreen,
          ),
        ),
      ],
    );
  }

  // Alternative Login Button
  Widget _buildAlternativeLoginButton({
    required IconData icon,
    required String label,
    required Color iconColor,
    Size? iconSize,
    String? route,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            // Handle alternative login options
            if (route != null) {
              Get.toNamed(route);
            }
          },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ), // Reduced padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Color(0xFFE2E8F0), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label == 'lbl_google'.tr)
              Image.asset(
                ImageConstant.googleLogo,
                width: 18,
                height: 18,
              ) // Slightly smaller
            else
              Icon(
                icon,
                color: iconColor,
                size: (iconSize?.width ?? 18).clamp(16.0, 18.0),
              ), // Smaller icon
            const SizedBox(width: 4), // Reduced spacing
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.lato(
                  fontSize: 12, // Reduced font size
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                maxLines: 2, // Allow 2 lines for longer text
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build PinCodeTextField
  Widget _buildPinCodeField(LoginController controller) {
    return ClipRect(
      child: SizedBox(
        height: 40,
        child: PinCodeTextField(
          key: ValueKey(
            'otp_field_${controller.currentPage.value}_${controller.otpFieldKey.value}',
          ),
          appContext: Get.context!,
          length: 6,
          keyboardType: TextInputType.number,
          animationType: AnimationType.none,
          enableActiveFill: false,
          enabled: !controller.isLoadingVerifyOtp.value,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          pinTheme: PinTheme(
            borderWidth: 0,
            fieldHeight: 40,
            fieldWidth: 35,
            activeFillColor: Colors.transparent,
            selectedFillColor: Colors.transparent,
            inactiveFillColor: Colors.transparent,
            activeColor: Colors.transparent,
            selectedColor: Colors.transparent,
            inactiveColor: Colors.transparent,
            shape: PinCodeFieldShape.box,
            activeBorderWidth: 0,
            selectedBorderWidth: 0,
            inactiveBorderWidth: 0,
            disabledColor: Colors.transparent,
            errorBorderColor: Colors.transparent,
          ),
          hapticFeedbackTypes: HapticFeedbackTypes.heavy,
          cursorColor: AppColors.primaryColor,
          backgroundColor: Colors.transparent,
          onChanged: (value) {
            controller.handleOTPChange(value);
          },
          onCompleted: (value) {
            controller.enteredOtp.value = value;
            debugPrint('OTP Completed: $value');
          },
        ),
      ),
    );
  }
}
