import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'controller/mobile_password_login_controller.dart';

class MobilePasswordLoginScreen extends StatelessWidget {
  const MobilePasswordLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MobilePasswordLoginController>();

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
  Widget _buildLoginHeader(MobilePasswordLoginController controller) {
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
                      Get.back();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
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
    MobilePasswordLoginController controller,
    bool keyboardVisible,
  ) {
    const double containerHeightPercentage = 0.68;

    final contentWidget = SingleChildScrollView(
      padding: EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mobile Number Input
          _buildMobileNumberInput(controller),
          const SizedBox(height: 16),

          // Password Input
          _buildPasswordInput(controller),
          const SizedBox(height: 16),

          // Remember me and Forget Password
          _buildRememberMeAndForgetPassword(controller),
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
                  style: TextStyle(
                    fontFamily: 'Lato',
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

  // Mobile Number Input
  Widget _buildMobileNumberInput(MobilePasswordLoginController controller) {
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
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
          // Divider
          Container(width: 1, height: 30, color: Color(0xFFE2E8F0)),
          // Phone number input
          Expanded(
            child: TextField(
              controller: controller.mobileController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              onChanged: (value) {
                if (value.length == 10) {
                  FocusScope.of(Get.context!).unfocus();
                }
              },
              decoration: InputDecoration(
                hintText: '1234567890',
                hintStyle: GoogleFonts.lato(
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

  // Password Input
  Widget _buildPasswordInput(MobilePasswordLoginController controller) {
    return Obx(
      () => Container(
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFE2E8F0), width: 1),
        ),
        child: Row(
          children: [
            // Padlock Icon
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                BootstrapIcons.lock,
                color: Color(0xFF2563EB),
                size: 20,
              ),
            ),
            // Password input
            Expanded(
              child: TextField(
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            // Show/Hide Password Icon
            GestureDetector(
              onTap: () {
                controller.togglePasswordVisibility();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Remember me and Forget Password
  Widget _buildRememberMeAndForgetPassword(
    MobilePasswordLoginController controller,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember me checkbox
        GestureDetector(
          onTap: () {
            controller.toggleRememberMe();
          },
          child: Row(
            children: [
              Obx(
                () => Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: controller.rememberMe.value
                        ? Color(0xFF3864FD)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: controller.rememberMe.value
                          ? Color(0xFF3864FD)
                          : Color(0xFFE2E8F0),
                      width: 2,
                    ),
                  ),
                  child: controller.rememberMe.value
                      ? Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Remember me',
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
        // Forget Password link
        GestureDetector(
          onTap: () {
            // Handle forget password
            // controller.goToForgetPassword();
          },
          child: Text(
            'Forget Password?',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF3864FD),
            ),
          ),
        ),
      ],
    );
  }

  // Login Button
  Widget _buildLoginButton(MobilePasswordLoginController controller) {
    return Obx(() {
      final isLoading = controller.isLoading.value;

      return DynamicButton(
        text: isLoading ? '' : 'Login',
        width: double.infinity,
        height: 50,
        fontSize: 16,
        onPressed: isLoading
            ? null
            : () {
                controller.handleLogin();
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
          label: 'Abha ID',
          iconColor: Color(0xFF3864FD),
          imagePath: ImageConstant.ayushmanBharat,
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
    IconData? icon,
    required String label,
    Color? iconColor,
    String? imagePath,
    Size? iconSize,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle alternative login options
        if (label == 'Google') {
          // Handle Google login
        } else if (label == 'E-Mail ID') {
          // Navigate to email login
          Get.offNamed(AppRoutes.emailPasswordLoginScreen);
        } else if (label == 'Abha ID') {
          Get.back();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
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
            else if (imagePath != null)
              Image.asset(imagePath, width: 20, height: 20)
            else
              Icon(icon, color: iconColor, size: iconSize?.width ?? 20),
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
}
