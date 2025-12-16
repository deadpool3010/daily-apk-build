import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'controller/abha_register_controller.dart';

class AbhaRegisterScreen extends StatelessWidget {
  const AbhaRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AbhaRegisterController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFF7FAFC),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  const SizedBox(height: 40),

                  // Title
                  Text(
                    'lbl_create_your_abha'.tr,
                    style: GoogleFonts.roboto(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3864FD),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'msg_no_abha_address_found'.tr,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 32),

                  // ABHA Card
                  _buildAbhaCard(controller),
                  const SizedBox(height: 32),

                  // Content based on current step (only show after animation completes)
                  Obx(() {
                    if (!controller.isAnimationComplete.value) {
                      return SizedBox.shrink();
                    }
                    if (controller.currentStep.value == 0) {
                      return _buildAadhaarInputStep(controller);
                    } else {
                      return _buildOtpAndMobileStep(controller);
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ABHA Card with Slide and Flip Animation
  Widget _buildAbhaCard(AbhaRegisterController controller) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        controller.slideAnimation,
        controller.flipAnimation,
      ]),
      builder: (context, child) {
        final slideProgress = controller.slideAnimation.value;
        final flipProgress = controller.flipAnimation.value;
        final angle = flipProgress * 3.14159; // 0 to π
        final isFrontVisible = angle > 1.5708; // π/2

        // Slide animation: from left (-200) to center (0)
        final slideOffsetX = -200 * (1 - slideProgress);

        // Enhanced flip animation with scale
        final scale =
            1.0 -
            (0.1 *
                (flipProgress < 0.5
                    ? flipProgress * 2
                    : (1 - flipProgress) * 2));

        return Transform.translate(
          offset: Offset(slideOffsetX, 0),
          child: Transform.scale(
            scale: scale,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: Container(
                width: 360,
                height: 198,
                child: isFrontVisible
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(3.14159),
                        child: _buildCardFront(),
                      )
                    : _buildCardBack(),
              ),
            ),
          ),
        );
      },
    );
  }

  // Card Back (Blank)
  Widget _buildCardBack() {
    return Container(
      width: 360,
      height: 198,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Top Blue Section with Design Pattern
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Stack(
              children: [
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    image: DecorationImage(
                      image: AssetImage(ImageConstant.cardUpDesign),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Top Left - Small Ayushman Bharat Logo
                Positioned(
                  left: 12,
                  top: 8,
                  child: Image.asset(
                    ImageConstant.ayushmanBharat,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.medical_information,
                          size: 24,
                          color: Colors.green,
                        ),
                      );
                    },
                  ),
                ),
                // Top Right - National Health Authority Logo
                Positioned(
                  right: 12,
                  top: 8,
                  child: Image.asset(
                    ImageConstant.nationalHealthAuthorityLogo,
                    width: 50,
                    height: 44,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.health_and_safety,
                          size: 24,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Main White Section
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageConstant.ayushmanBharat,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.medical_information,
                            size: 45,
                            color: Colors.green,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card Front (Placeholder)
  Widget _buildCardFront() {
    return Container(
      width: 360,
      height: 198,
      margin: EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Blue header section
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              image: DecorationImage(
                image: AssetImage(ImageConstant.cardUpDesign),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // National Health Authority Logo (Left)
                Positioned(
                  left: 12,
                  top: 14,
                  child: Image.asset(
                    ImageConstant.nationalHealthAuthorityLogo,
                    width: 70,
                    height: 30,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.health_and_safety,
                          size: 24,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ),
                // Ayushman Bharat Logo (Right)
                Positioned(
                  right: 22,
                  top: 10,
                  child: Image.asset(
                    ImageConstant.ayushmanBharat,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.medical_information,
                          size: 24,
                          color: Colors.green,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // White body section
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: 16,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Picture Placeholder
                      Container(
                        width: 62,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // User Details Placeholders
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCardText('lbl_name'.tr, '...........', 12),
                            const SizedBox(height: 6),
                            _buildCardText(
                              'lbl_abha_no'.tr,
                              '........  ........  ........  ........',
                              11,
                            ),
                            const SizedBox(height: 6),
                            _buildCardText(
                              'lbl_abha_address'.tr,
                              '...........',
                              11,
                            ),
                          ],
                        ),
                      ),
                      // QR Code Placeholder
                      Image.asset(ImageConstant.qrCode, width: 60, height: 60),
                    ],
                  ),
                  Spacer(),
                  // Bottom row details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCardText('lbl_gender'.tr, '........', 11),
                      _buildCardText('lbl_dob'.tr, '..........', 11),
                      _buildCardText('lbl_mobile'.tr + ': ', '..........', 11),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build card text
  Widget _buildCardText(String label, String value, double fontSize) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  // Aadhaar Number Input Step
  Widget _buildAadhaarInputStep(AbhaRegisterController controller) {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'lbl_aadhar_number'.tr,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 16),
          // Aadhaar Number Input (3 TextField widgets with 4 digits each)
          FocusTraversalGroup(
            child: Builder(
              builder: (context) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildAadhaarPinCodeField(context, controller, 0),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildAadhaarPinCodeField(context, controller, 1),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildAadhaarPinCodeField(context, controller, 2),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'msg_otp_will_be_sent_to_aadhar'.tr,
            style: GoogleFonts.lato(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF94A3B8),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          // Get OTP Button
          Obx(() {
            final isLoading = controller.isLoadingGetOtp.value;
            return DynamicButton(
              text: isLoading ? '' : 'lbl_get_otp'.tr,
              width: double.infinity,
              height: 50,
              fontSize: 14,
              onPressed: isLoading
                  ? null
                  : () {
                      controller.handleGetAadhaarOTP();
                    },
              leadingIcon: isLoading
                  ? LoadingAnimationWidget.horizontalRotatingDots(
                      color: Colors.white,
                      size: 24,
                    )
                  : null,
            );
          }),
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
                icon: TablerIcons.phone,
                label: 'lbl_mobile'.tr,
                iconSize: Size(20, 20),
                iconColor: Color(0xFF3864FD),
                onTap: () {
                  Get.toNamed(AppRoutes.mobileRegisterScreen);
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
  }

  // TextField for Aadhaar number (4 digits each, 3 fields total)
  Widget _buildAadhaarPinCodeField(
    BuildContext context,
    AbhaRegisterController controller,
    int index,
  ) {
    return Container(
      height: 55,
      padding: EdgeInsets.only(left: 6, right: 6, bottom: 30),
      decoration: BoxDecoration(
        color: Color(
          0x299BBEF8,
        ), // Light blue-grey background matching the image
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
      ),
      child: TextField(
        controller: controller.aadhaarControllers[index],
        focusNode: controller.aadhaarFocusNodes[index],
        keyboardType: TextInputType.number,
        maxLength: 4,
        cursorHeight: 20,
        textAlign: TextAlign.center,
        style: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          letterSpacing: 5,
        ),
        cursorColor: AppColors.primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
          hintText: '____',
          hintFadeDuration: Duration(milliseconds: 100),
          hintStyle: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF222222).withOpacity(0.3),
            letterSpacing: 5,
          ),
        ),
        textAlignVertical: TextAlignVertical.center,
        onTap: () {
          // Position cursor at the end of text (appears centered with textAlign.center)
          final text = controller.aadhaarControllers[index].text;
          controller.aadhaarControllers[index].selection =
              TextSelection.collapsed(offset: text.length);
        },
        onChanged: (value) {
          // Auto-advance to next field when 4 digits are entered
          if (value.length == 4 && index < 2) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.moveToNextAadhaarField(index, context);
            });
          }

          // Handle backspace - when field becomes empty, move to previous field
          if (value.isEmpty && index > 0) {
            Future.delayed(Duration(milliseconds: 10), () {
              if (controller.aadhaarControllers[index].text.isEmpty) {
                controller.moveToPreviousAadhaarField(index, context);
              }
            });
          }
        },
      ),
    );
  }

  // OTP and Mobile Number Input Step
  Widget _buildOtpAndMobileStep(AbhaRegisterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'msg_otp_sent_to_aadhaar_mobile'.tr,
          style: GoogleFonts.lato(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF94A3B8),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        // OTP Input
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Color(0x299BBEF8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFE2E8F0), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildPinCodeField(controller),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'msg_enter_number_to_link_abha'.tr,
          style: GoogleFonts.lato(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF94A3B8),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        // Mobile Number Input
        Builder(
          builder: (context) => CustomTextField(
            controller: controller.mobileController,
            hintText: '1234567890',
            countryCode: '+91',
            keyboardType: TextInputType.phone,
            maxLength: 10,
            onChanged: (value) {
              if (value.length == 10) {
                FocusScope.of(context).unfocus();
              }
            },
          ),
        ),
        const SizedBox(height: 24),
        // Verify Button
        Obx(() {
          final isLoading = controller.isLoadingVerifyOtp.value;
          return DynamicButton(
            text: isLoading ? '' : 'lbl_verify'.tr,
            width: double.infinity,
            height: 50,
            fontSize: 16,
            onPressed: isLoading
                ? null
                : () {
                    controller.handleVerifyOtp();
                  },
            leadingIcon: isLoading
                ? LoadingAnimationWidget.horizontalRotatingDots(
                    color: Colors.white,
                    size: 24,
                  )
                : null,
          );
        }),
      ],
    );
  }

  // Pin Code Field for OTP
  Widget _buildPinCodeField(AbhaRegisterController controller) {
    return PinCodeTextField(
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
        shape: PinCodeFieldShape.circle,
        borderWidth: 0,
        fieldHeight: 45,
        fieldWidth: 35,
        activeFillColor: Colors.transparent,
        selectedFillColor: Colors.transparent,
        inactiveFillColor: Colors.transparent,
        activeColor: Colors.transparent,
        selectedColor: Colors.transparent,
        inactiveColor: Colors.transparent,
        disabledColor: Colors.transparent,
      ),
      cursorColor: AppColors.primaryColor,
      backgroundColor: Colors.transparent,
      onChanged: (value) {
        controller.handleAadhaarOtpChange(value);
      },
      onCompleted: (value) {
        controller.enteredAadhaarOtp.value = value;
      },
    );
  }
}
