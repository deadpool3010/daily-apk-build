import 'package:bandhucare_new/core/app_exports.dart';
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
    return Container(
      height: 360,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageConstant.loginHeader),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          // Status bar overlay to prevent image showing through
          SafeArea(
            child: Stack(
              children: [
                // Back Button
                Positioned(
                  left: 24,
                  top: 20,
                  child: GestureDetector(
                    onTap: () {
                      Get.offNamed(AppRoutes.chooseLanguageScreen);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        // color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // Logo on the right
                // Positioned(
                //   right: 24,
                //   top: 20,
                //   child: SizedBox(
                //     width: 60,
                //     height: 60,
                //     child: ClipOval(
                //       child: Image.asset(
                //         ImageConstant.blueLogo,
                //         color: Colors.white,
                //         fit: BoxFit.contain,
                //         errorBuilder: (context, error, stackTrace) {
                //           return Icon(
                //             Icons.medical_services,
                //             color: Colors.white,
                //             size: 30,
                //           );
                //         },
                //       ),
                //     ),
                //   ),
                // ),

                // Title and Subtitle
                Positioned(
                  left: 0,
                  top: 100,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Go ahead and set\nup your account',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Get.toNamed(AppRoutes.registerHomescreen);
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Don't have an account? ",
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Register',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: ClipOval(
                            child: Image.asset(
                              ImageConstant.blueLogo,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.medical_services,
                                  color: Colors.white,
                                  size: 30,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
    const double containerHeightPercentage = 0.68;

    final contentWidget = SingleChildScrollView(
      padding: EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instruction Text
          Text(
            'Enter the Mobile Number linked to your Abha Address',
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
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
                  'Or login with',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
              Expanded(child: Divider(color: Color(0xFFCBD5E1), thickness: 1)),
            ],
          ),
          const SizedBox(height: 24),

          // Alternative Login Options
          _buildAlternativeLoginOptions(),
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
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
      ),
      child: Row(
        children: [
          // Country code
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '+91',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          // Divider
          Container(width: 1, height: 30, color: Color(0xFFE2E8F0)),
          // Phone number input
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              onChanged: (value) {
                if (value.length == 10) {
                  FocusScope.of(Get.context!).unfocus();
                }
              },
              decoration: InputDecoration(
                hintText: '1234567890',
                hintStyle: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                counterText: '',
              ),
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // OTP Input with Get OTP Button
  Widget _buildOTPInputWithButton(LoginController controller) {
    return Container(
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
                        : () => controller.handleGetOTP(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3864FD),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
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
                        : Text(
                            'Get OTP',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
          // Hint overlay on OTP field
          Obx(
            () =>
                controller.showGetOtpHint.value &&
                    controller.enteredOtp.value.isEmpty
                ? Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        controller.showGetOtpHint.value = false;
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 16),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Click "Get OTP" to receive code',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // Login Button
  Widget _buildLoginButton(LoginController controller) {
    return Obx(() {
      final isLoading = controller.isLoadingVerifyOtp.value;
      final otpLength = controller.enteredOtp.value.length;

      return DynamicButton(
        text: isLoading ? '' : 'Login',
        width: double.infinity,
        height: 50,
        fontSize: 16,
        onPressed: isLoading || otpLength != 6
            ? null
            : () {
                // Verify OTP when button is clicked
                controller.verifyOTPforMobileNumber(
                  controller.enteredOtp.value,
                );
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
  Widget _buildAlternativeLoginOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAlternativeLoginButton(
          icon: Icons.g_mobiledata,
          label: 'Google',
          iconColor: Colors.orange,
        ),
        _buildAlternativeLoginButton(
          icon: BootstrapIcons.telephone_fill,
          label: 'Mobile',
          iconSize: Size(16, 16),
          iconColor: Color(0xFF3864FD),
        ),
        _buildAlternativeLoginButton(
          icon: TablerIcons.mail,
          label: 'E-Mail ID',
          iconColor: Color(0xFF3864FD),
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
  }) {
    return GestureDetector(
      onTap: () {
        // Handle alternative login options
        if (label == 'Google') {
          // Handle Google login
        } else if (label == 'Mobile') {
          Get.toNamed(AppRoutes.mobilePasswordLoginScreen);
        } else if (label == 'E-Mail ID') {
          // Navigate to email/password login screen
          Get.toNamed(AppRoutes.emailPasswordLoginScreen);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Color(0xFFE2E8F0), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (label == 'Google')
              Image.asset(ImageConstant.googleLogo, width: 20, height: 20)
            else
              Icon(icon, color: iconColor, size: iconSize?.width ?? 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
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
