import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bandhucare_new/presentation/login_screen/controller/login_screen_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xFF1E3A8A),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              // Header Section with Dark Blue Background
              _buildLoginHeader(controller),

              // Content Card Section
              Expanded(child: _buildLoginContentCard(controller)),
            ],
          ),
        ),
      ),
    );
  }

  // Header Section with Dark Blue Background
  Widget _buildLoginHeader(LoginController controller) {
    return Container(
      height: 280,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageConstant.loginHeader),
          fit: BoxFit.cover,
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
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
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
                Positioned(
                  right: 24,
                  top: 20,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipOval(
                      child: Image.asset(
                        ImageConstant.appLogoWhite,
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
                ),

                // Title and Subtitle
                Positioned(
                  left: 24,
                  top: 80,
                  right: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Go ahead and set up your account',
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
                          controller.goToCreateAbhaFlow();
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Don't have an Abha Address? ",
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              TextSpan(
                                text: 'Create one',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  // decoration: TextDecoration.underline,
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
          ),
        ],
      ),
    );
  }

  // Content Card Section
  Widget _buildLoginContentCard(LoginController controller) {
    return Transform.translate(
      offset: Offset(0, -60),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF8F9FA),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instruction Text
              Text(
                'Enter the Mobile Number linked to your Abha Address',
                style: TextStyle(
                  fontFamily: 'Lato',
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
                  Expanded(
                    child: Divider(color: Color(0xFFCBD5E1), thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or login with',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Color(0xFFCBD5E1), thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Alternative Login Options
              _buildAlternativeLoginOptions(),
            ],
          ),
        ),
      ),
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3864FD),
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
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                counterText: '',
              ),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
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
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
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
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
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
          icon: Icons.phone,
          label: 'Mobile',
          iconColor: Color(0xFF3864FD),
        ),
        _buildAlternativeLoginButton(
          icon: Icons.email,
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
  }) {
    return GestureDetector(
      onTap: () {
        // Handle alternative login options
        if (label == 'Google') {
          // Handle Google login
        } else if (label == 'Mobile') {
          // Already on mobile login
        } else if (label == 'E-Mail ID') {
          // Handle email login
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
              Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Lato',
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
    return PinCodeTextField(
      key: ValueKey(
        'otp_field_${controller.currentPage.value}_${controller.otpFieldKey.value}',
      ),
      appContext: Get.context!,
      length: 6,
      keyboardType: TextInputType.number,
      animationType: AnimationType.scale,
      animationDuration: const Duration(milliseconds: 200),
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
      ),
      cursorColor: AppColors.primaryColor,
      backgroundColor: Colors.transparent,
      onChanged: (value) {
        controller.handleOTPChange(value);
      },
      onCompleted: (value) {
        controller.enteredOtp.value = value;
        debugPrint('OTP Completed: $value');
      },
    );
  }
}
