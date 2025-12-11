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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.showAbhaCard.value
                          ? const SizedBox(height: 80)
                          : SizedBox(height: 100),
                      // Welcome Header
                      _buildWelcomeSection(controller),
                      const SizedBox(height: 40),
                      // ABHA Card (only show if not from registration)
                      Obx(() {
                        if (controller.showAbhaCard.value) {
                          return Column(
                            children: [
                              Center(child: _buildAbhaCard(controller)),
                              const SizedBox(height: 40),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      // How Scanning Works Section
                      _buildHowScanningWorksSection(),
                      const SizedBox(height: 40),
                      // FAQ's Section
                      _buildFaqSection(),
                      const SizedBox(height: 40),
                      // Need Further Assistance Section
                      Center(child: _buildNeedFurtherAssistanceSection()),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            // Scan to Join Group Button at bottom
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom > 0
                    ? MediaQuery.of(context).padding.bottom
                    : 16,
                top: 8,
                left: 24,
                right: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: Offset(0, -4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  controller.handleScanToJoinGroup();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0774E9), Color(0xFF0A7FF0)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Scan to Join Group',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

  // Build Welcome Section
  Widget _buildWelcomeSection(AbhaCreatedController controller) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Glad you\'re here, ${controller.userName.value}.',
            style: GoogleFonts.roboto(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 20 / 22,
              letterSpacing: 0,
              color: Color(0xFF3864FD),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Bandhu Care — your trusted partner in wellness.',
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 16 / 14,
              letterSpacing: 0,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      );
    });
  }

  // Build How Scanning Works Section
  Widget _buildHowScanningWorksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'How Scanning Works',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: EdgeInsets.only(right: 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Color(0xFFE5EFFE),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildStepItem(ImageConstant.step1, 'Scan'),
                const SizedBox(width: 10),
                Icon(Icons.arrow_forward, size: 24, color: Color(0xFF334155)),
                const SizedBox(width: 10),
                _buildStepItem(ImageConstant.step2, 'Join Community'),
                const SizedBox(width: 10),
                Icon(Icons.arrow_forward, size: 24, color: Color(0xFF334155)),
                const SizedBox(width: 10),
                _buildStepItem(ImageConstant.step3, 'Access Services'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem(String imagePath, String stepText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Image.asset(
          imagePath,
          width: 70,
          height: 70,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.image, size: 35, color: Colors.grey[400]),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          stepText,
          style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF334155),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Build FAQ Section
  Widget _buildFaqSection() {
    final faqQuestions = [
      'How to Use Chatbot Feature in Bandhucare ?',
      'How to Scan and join Communities ?',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FAQ\'s',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 16),
        ...faqQuestions.map(
          (question) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF334155),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF334155),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Build Need Further Assistance Section
  Widget _buildNeedFurtherAssistanceSection() {
    final controller = Get.find<AbhaCreatedController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Need Further Assistance ?',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We are here to help you!',
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            controller.handleContactUs();
          },
          child: Container(
            width: 200,
            height: 48,
            decoration: BoxDecoration(
              color: Color(0xFFFF9D00),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Contact Us',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
