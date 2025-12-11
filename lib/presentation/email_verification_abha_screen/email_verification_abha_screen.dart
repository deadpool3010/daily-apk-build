import 'package:bandhucare_new/core/app_exports.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'controller/email_verification_abha_controller.dart';

class EmailVerificationAbhaScreen extends StatelessWidget {
  const EmailVerificationAbhaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmailVerificationAbhaController>();

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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        // Success Message (Top)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'msg_mobile_number_saved_for_abha'.tr,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.green,
                                  height: 1.4,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        // BandhuCare Logo
                        Image.asset(
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
                        const SizedBox(height: 40),
                        // Enter Email Address heading and description
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Heading
                            Text(
                              'lbl_enter_email_address'.tr,
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                height: 30.87 / 20,
                                letterSpacing: 0,
                                color: Color(0xFF3865FF),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            // Description in red
                            Text(
                              'msg_email_will_be_used_for_abha'.tr,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                                letterSpacing: 0,
                                color: Colors.red,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Email Input Field
                        CustomTextField(
                          controller: controller.emailController,
                          hintText: 'Siddharth@gmail.com',
                          textStyle: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                          hintStyle: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.hintTextColor,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom Section - Verify Button and Skip link
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Verify Button
                    Obx(() {
                      final isLoading = controller.isLoading.value;
                      return DynamicButton(
                        text: isLoading ? '' : 'lbl_verify'.tr,
                        width: double.infinity,
                        height: 50,
                        fontSize: 16,
                        onPressed: isLoading
                            ? null
                            : () {
                                controller.handleVerifyEmail();
                              },
                        leadingIcon: isLoading
                            ? LoadingAnimationWidget.horizontalRotatingDots(
                                color: Colors.white,
                                size: 24,
                              )
                            : null,
                      );
                    }),
                    const SizedBox(height: 16),
                    // Skip for now link
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          controller.handleSkip();
                        },
                        child: Text(
                          'lbl_skip_for_now'.tr,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
