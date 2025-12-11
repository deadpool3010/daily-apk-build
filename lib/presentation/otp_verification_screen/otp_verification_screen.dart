import 'package:bandhucare_new/core/app_exports.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'controller/otp_verification_controller.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OtpVerificationController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              // BandhuCare Logo
              Positioned(
                left: 24,
                top: 165,
                child: Image.asset(
                  ImageConstant.bandhucareOtpScreen,
                  width: 224.16,
                  height: 57,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 224.16,
                      height: 57,
                      decoration: BoxDecoration(
                        color: Color(0xFF3865FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  },
                ),
              ),
              // OTP Verification heading and description
              Positioned(
                left: 24,
                top: 310,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // OTP Verification heading
                    Text(
                      'OTP Verification',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 30.87 / 20,
                        letterSpacing: 0,
                        color: Color(0xFF3865FF),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description text
                    Text(
                      'An OTP has been sent to your number.\nPlease enter it here.',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        letterSpacing: 0,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              // OTP Input boxes (6 boxes)
              Positioned(
                left: 24,
                top: 420,
                child: Container(
                  width: 360,
                  child: _buildPinCodeField(controller),
                ),
              ),
              // Submit Button
              Positioned(
                left: 24,
                bottom: 100,
                child: Obx(() {
                  final isLoading = controller.isLoading.value;
                  return DynamicButton(
                    text: isLoading ? '' : 'Submit',
                    width: 360,
                    height: 50,
                    fontSize: 16,
                    onPressed: isLoading
                        ? null
                        : () {
                            controller.handleSubmitOtp();
                          },
                    leadingIcon: isLoading
                        ? LoadingAnimationWidget.horizontalRotatingDots(
                            color: Colors.white,
                            size: 24,
                          )
                        : null,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build PinCodeTextField for OTP
  Widget _buildPinCodeField(OtpVerificationController controller) {
    return Obx(() {
      return Container(
        color: Colors.white,
        child: PinCodeTextField(
          appContext: Get.context!,
          length: 6,
          blinkDuration: Duration(milliseconds: 2000),
          enablePinAutofill: true,
          hapticFeedbackTypes: HapticFeedbackTypes.medium,
          useHapticFeedback: true,
          keyboardType: TextInputType.number,
          animationType: AnimationType.scale,
          animationDuration: const Duration(milliseconds: 200),
          enableActiveFill: true,
          enabled: !controller.isLoading.value,
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            borderWidth: 0.5,
            fieldHeight: 50,
            fieldWidth: 50,
            activeFillColor: Colors.white,
            selectedFillColor: Colors.white,
            inactiveFillColor: Colors.white,
            activeColor: AppColors.primaryColor.withOpacity(0.1),
            selectedColor: AppColors.primaryColor.withOpacity(0.1),
            inactiveColor: AppColors.primaryColor.withOpacity(0.1),
            disabledColor: AppColors.primaryColor.withOpacity(0.1),
          ),
          cursorColor: AppColors.primaryColor,
          backgroundColor: Colors.white,
          onChanged: (value) {
            controller.handleOtpChange(value);
          },
          onCompleted: (value) {
            controller.handleOtpChange(value);
          },
        ),
      );
    });
  }
}
