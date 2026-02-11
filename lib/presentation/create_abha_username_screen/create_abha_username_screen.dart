import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/core/utils/context_extensions.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'controller/create_abha_username_controller.dart';

class CreateAbhaUsernameScreen extends StatelessWidget {
  const CreateAbhaUsernameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateAbhaUsernameController>();

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
          top: false,
          bottom: context.hasThreeButtonNavigation,
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
                        // Title
                        Text(
                          'lbl_create_your_unique_abha_address'.tr,
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            letterSpacing: 0,
                            color: Color(0xFF3865FF),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        // Instructions
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBulletPoint(
                              'msg_unique_username_for_health_records'.tr,
                            ),
                            const SizedBox(height: 12),
                            _buildBulletPoint('msg_username_requirements'.tr),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Username Input Field
                        _buildUsernameInput(controller),
                        const SizedBox(height: 24),
                        // Suggestions
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                'lbl_suggestions'.tr,
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF64748B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 8),
                              Obx(
                                () => Row(
                                  children: [_buildSuggestions(controller)],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              // Submit Button at bottom
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Obx(() {
                  final isLoading = controller.isLoading.value;
                  return DynamicButton(
                    text: isLoading ? '' : 'lbl_submit'.tr,
                    width: double.infinity,
                    height: 50,
                    fontSize: 16,
                    onPressed: isLoading
                        ? null
                        : () {
                            controller.handleSubmitUsername();
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

  // Build bullet point
  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6, right: 8),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF64748B),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Color(0xFF64748B),
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Build username input field
  Widget _buildUsernameInput(CreateAbhaUsernameController controller) {
    return Obx(() {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xFF9BBEF8).withOpacity(0.16),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFE2E8F0), width: 1),
        ),
        child: Row(
          children: [
            // Text input
            Expanded(
              child: TextField(
                controller: controller.usernameController,
                keyboardType: TextInputType.text,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'lbl_enter_username'.tr,
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.hintTextColor,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            // Validation checkmark
            if (controller.isUsernameValid.value)
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.check_circle, color: Colors.green, size: 20),
              ),
            // @abdm button
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Color(0xFF3865FF),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  '@abdm',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Build suggestions
  Widget _buildSuggestions(CreateAbhaUsernameController controller) {
    if (controller.suggestions.isEmpty) {
      return SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: controller.suggestions.map((suggestion) {
        return GestureDetector(
          onTap: () {
            controller.selectSuggestion(suggestion);
          },
          child: Row(
            children: [
              Text(
                '$suggestion@abdm',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3865FF),
                ),
              ),
              SizedBox(width: 2),
              Text(
                ',',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3865FF),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
