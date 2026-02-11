import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/core/utils/context_extensions.dart';
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
          bottom: context.hasThreeButtonNavigation,
          child: Column(
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
                        // Animated sections that appear after card flip
                        AnimatedBuilder(
                          animation: controller.flipAnimation,
                          builder: (context, child) {
                            final flipProgress = controller.flipAnimation.value;
                            // Only show sections when flip is complete (front side is showing)
                            // Start fading in when flipProgress > 0.8 (80% complete)
                            final opacity = flipProgress > 0.8
                                ? ((flipProgress - 0.8) / 0.2).clamp(0.0, 1.0)
                                : 0.0;
                            return Opacity(
                              opacity: opacity,
                              child: IgnorePointer(
                                ignoring: opacity < 1.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildHowScanningWorksSection(),
                                    const SizedBox(height: 32),
                                    _buildFaqSection(),
                                    const SizedBox(height: 32),
                                    Center(
                                      child:
                                          _buildNeedFurtherAssistanceSection(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            'lbl_scan_to_join_group'.tr,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          margin: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ],
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

  // Build ABHA Card with flip animation (back to front)
  Widget _buildAbhaCard(AbhaCreatedController controller) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        controller.slideAnimation,
        controller.flipAnimation,
      ]),
      builder: (context, child) {
        // Slide animation: move from left (-200) to center (0)
        final slideProgress = controller.slideAnimation.value;
        final slideOffsetX = -200 * (1 - slideProgress);

        // Flip animation: 3D rotation
        final flipProgress = controller.flipAnimation.value;
        final angle = flipProgress * 3.14159; // 0 to π (180 degrees)
        final isFrontVisible = angle > 1.5708; // π/2 (90 degrees)

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
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(angle),
              child: Container(
                width: 360,
                height: 198,
                child: isFrontVisible
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(3.14159),
                        child: _buildCardFront(controller),
                      )
                    : _buildCardBack(),
              ),
            ),
          ),
        );
      },
    );
  }

  // Card Back (Blank with logo)
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

  // Card Front (with user details)
  Widget _buildCardFront(AbhaCreatedController controller) {
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
                              'lbl_name'.tr,
                              controller.userName.value,
                              12,
                              isValueBold: true,
                            ),
                            const SizedBox(height: 6),
                            _buildCardText(
                              'lbl_abha_no'.tr,
                              controller.abhaNumber.value,
                              11,
                              isValueBold: true,
                            ),
                            const SizedBox(height: 6),
                            _buildCardText(
                              'lbl_abha_address'.tr,
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
                      Expanded(
                        child: _buildCardText(
                          'lbl_gender'.tr,
                          controller.gender.value,
                          11,
                          isValueBold: true,
                        ),
                      ),
                      Expanded(
                        child: _buildCardText(
                          'lbl_dob'.tr,
                          controller.dob.value,
                          11,
                          isValueBold: true,
                        ),
                      ),
                      Expanded(
                        child: _buildCardText(
                          'lbl_mobile'.tr + ': ',
                          controller.mobile.value,
                          11,
                          isValueBold: true,
                        ),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'msg_glad_youre_here'.tr.replaceAll(
              '{name}',
              controller.userName.value,
            ),
            style: GoogleFonts.roboto(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 20 / 22,
              letterSpacing: 0,
              color: Color(0xFF3864FD),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Text(
            'lbl_bandhu_care_tagline'.tr,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 16 / 14,
              letterSpacing: 0,
              color: Color(0xFF94A3B8),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
            'lbl_how_scanning_works'.tr,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(right: 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Color(0xFFE5EFFE),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: _buildStepItem(ImageConstant.step1, 'lbl_scan'.tr),
              ),
              Icon(Icons.arrow_forward, size: 24, color: Color(0xFF334155)),
              Flexible(
                child: _buildStepItem(
                  ImageConstant.step2,
                  'lbl_join_community'.tr,
                ),
              ),
              Icon(Icons.arrow_forward, size: 24, color: Color(0xFF334155)),
              Flexible(
                child: _buildStepItem(
                  ImageConstant.step3,
                  'lbl_access_services'.tr,
                ),
              ),
            ],
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
        Flexible(
          child: Text(
            stepText,
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Build FAQ Section
  Widget _buildFaqSection() {
    final faqQuestions = [
      'lbl_how_to_use_chatbot'.tr,
      'lbl_how_to_scan_and_join'.tr,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'lbl_faqs'.tr,
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
          'lbl_need_further_assistance'.tr,
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          'msg_we_are_here_to_help'.tr,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF94A3B8),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                'lbl_contact_us'.tr,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
