import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'controller/register_homescreen_controller.dart';
import 'package:bandhucare_new/widget/alternative_login_buttons.dart';

class RegisterHomescreen extends StatelessWidget {
  const RegisterHomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterHomescreenController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),

                      // Logo

                      // Logo
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipOval(
                          child: Image.asset(
                            ImageConstant.appLogo,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.medical_services,
                                color: Color(0xFF3864FD),
                                size: 50,
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // App Name
                      Image.asset(
                        ImageConstant.splashBandhuCareText,
                        width: 150,
                        height: 20,
                        fit: BoxFit.contain,
                        color: AppColors.black,
                      ),

                      SizedBox(height: 15),

                      // Tagline
                      Text(
                        'lbl_your_trusted_partner_in_wellness'.tr,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF94A3B8),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 100),

                      // Header Title (with Hero animation)
                      // Hero(
                      //   tag: 'header_title',
                      //   child: Material(
                      //     color: Colors.transparent,
                      //     child: Text(
                      //       'Go ahead and set\nup your account',
                      //       style: GoogleFonts.roboto(
                      //         fontSize: 24,
                      //         fontWeight: FontWeight.w700,
                      //         color: Colors.black87,
                      //         height: 1.2,
                      //       ),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ),
                      // ),

                      // const SizedBox(height: 20),

                      // Instructional Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'msg_please_select_your_preferred_way_to_register'
                                  .tr,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF94A3B8),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Abha ID Button (with Hero animation from Register text)
                      Hero(
                        tag: 'register_to_abha',
                        child: Material(
                          color: Colors.transparent,
                          child: AlternativeLoginButton(
                            label: 'lbl_abha_id'.tr,
                            imagePath: ImageConstant.ayushmanBharat,
                            iconColor: Color(0xFF3864FD),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            width: double.infinity,
                            imageSize: 24,
                            spacing: 12,
                            onTap: () {
                              controller.handleAbhaIdRegistration();
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Or Separator
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Color(0xFFE2E8F0),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'lbl_or'.tr,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Color(0xFFE2E8F0),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Google Button
                      AlternativeLoginButton(
                        label: 'lbl_google'.tr,
                        imagePath: ImageConstant.googleLogo,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        width: double.infinity,
                        imageSize: 24,
                        spacing: 12,
                        onTap: () {
                          controller.handleGoogleRegistration();
                        },
                      ),

                      const SizedBox(height: 16),

                      // Mobile Button
                      AlternativeLoginButton(
                        label: 'lbl_mobile'.tr,
                        icon: BootstrapIcons.telephone_fill,
                        iconColor: Color(0xFF3864FD),
                        iconSize: Size(18, 18),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        width: double.infinity,
                        spacing: 12,
                        onTap: () {
                          controller.handleMobileRegistration();
                        },
                      ),

                      const SizedBox(height: 16),

                      // E-Mail ID Button
                      AlternativeLoginButton(
                        label: 'lbl_email_id'.tr,
                        icon: TablerIcons.mail,
                        iconColor: Color(0xFF3864FD),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        width: double.infinity,
                        spacing: 12,
                        onTap: () {
                          controller.handleEmailRegistration();
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              //  Back Button
              Positioned(
                left: 24,
                top: 20,
                child: GestureDetector(
                  onTap: () {
                    Get.offNamed(AppRoutes.loginScreen);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFE2E8F0), width: 1),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black87,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
