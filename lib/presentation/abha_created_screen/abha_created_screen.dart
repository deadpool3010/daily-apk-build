import 'package:bandhucare_new/core/app_exports.dart';
import 'controller/abha_created_controller.dart';

class AbhaCreatedScreen extends StatelessWidget {
  const AbhaCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AbhaCreatedController>();

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
                        // Congratulations Header
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Congratulations!!!',
                                    style: GoogleFonts.roboto(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF3865FF),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Your ABHA ID is created.',
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Logo on the right
                            Image.asset(
                              ImageConstant.appLogo,
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF3865FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        // ABHA Card
                        Center(child: _buildAbhaCard(controller)),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              // Continue Button at bottom
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: DynamicButton(
                  text: 'Continue',
                  width: double.infinity,
                  height: 50,
                  fontSize: 16,
                  onPressed: () {
                    controller.handleContinue();
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Build ABHA Card (Front)
  Widget _buildAbhaCard(AbhaCreatedController controller) {
    return Obx(() {
      return Container(
        width: 360,
        height: 198,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          border: Border.all(color: Colors.black.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
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
                        // Profile Picture
                        Container(
                          width: 62,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                            image: controller.profileImageUrl.value.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(
                                      controller.profileImageUrl.value,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: controller.profileImageUrl.value.isEmpty
                              ? Icon(
                                  Icons.person_outline,
                                  size: 40,
                                  color: Colors.grey[400],
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        // User Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCardText(
                                'Name: ',
                                controller.userName.value,
                                12,
                                isValueBold: true,
                              ),
                              const SizedBox(height: 6),
                              _buildCardText(
                                'Abha No: ',
                                controller.abhaNumber.value,
                                11,
                                isValueBold: true,
                              ),
                              const SizedBox(height: 6),
                              _buildCardText(
                                'Abha Address: ',
                                controller.abhaAddress.value,
                                11,
                                isValueBold: true,
                              ),
                            ],
                          ),
                        ),
                        // QR Code
                        Image.asset(
                          ImageConstant.qrCode,
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.qr_code,
                                size: 30,
                                color: Colors.grey[400],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Spacer(),
                    // Bottom row details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCardText(
                          'Gender: ',
                          controller.gender.value,
                          11,
                          isValueBold: true,
                        ),
                        _buildCardText(
                          'DOB: ',
                          controller.dob.value,
                          11,
                          isValueBold: true,
                        ),
                        _buildCardText(
                          'Mobile: ',
                          controller.mobile.value,
                          11,
                          isValueBold: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Helper method to build card text
  Widget _buildCardText(
    String label,
    String value,
    double fontSize, {
    bool isValueBold = false,
  }) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: GoogleFonts.lato(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.lato(
              fontSize: fontSize,
              fontWeight: isValueBold ? FontWeight.w600 : FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
