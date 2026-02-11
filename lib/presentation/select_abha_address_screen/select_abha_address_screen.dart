import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/core/utils/context_extensions.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'controller/select_abha_address_controller.dart';

class SelectAbhaAddressScreen extends StatelessWidget {
  const SelectAbhaAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SelectAbhaAddressController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFE8F4FD), // Light blue background
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
                      children: [
                        const SizedBox(height: 40),
                        // Header Text
                        _buildHeader(controller),
                        const SizedBox(height: 40),
                        // Logo Section
                        _buildLogoSection(),
                        const SizedBox(height: 40),
                        // ABHA Address Cards
                        Obx(() => _buildAbhaAddressCards(controller)),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom Section with Continue Button
              _buildContinueButton(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(SelectAbhaAddressController controller) {
    return Obx(() {
      final count = controller.abhaAccounts.length;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'lbl_yes_so'.tr,
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3865FF),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'msg_we_found_abha_addresses'.tr
                .replaceAll('{count}', count.toString())
                .replaceAll('{plural}', count != 1 ? 'es' : ''),
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF94A3B8),
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    });
  }

  Widget _buildLogoSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular Logo with Dashed Circles
        Stack(
          alignment: Alignment.center,
          children: [
            // Center logo/icon
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                ImageConstant.ayushmanBharat,
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Text below logo
        // Column(
        //   children: [
        //     Text(
        //       'Ayushman Bharat Digital Mission',
        //       style: GoogleFonts.roboto(
        //         fontSize: 14,
        //         fontWeight: FontWeight.w500,
        //         color: Color(0xFFFF6B35), // Reddish-orange
        //         height: 1.2,
        //       ),
        //     ),
        //     Text(
        //       'Digital Mission',
        //       style: GoogleFonts.lato(
        //         fontSize: 12,
        //         fontWeight: FontWeight.w400,
        //         color: Color(0xFF94A3B8),
        //         height: 1.2,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildAbhaAddressCards(SelectAbhaAddressController controller) {
    if (controller.abhaAccounts.isEmpty) {
      return Center(
        child: Text(
          'lbl_no_abha_addresses_found'.tr,
          style: GoogleFonts.lato(fontSize: 14, color: Color(0xFF94A3B8)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(controller.abhaAccounts.length, (index) {
        final account = controller.abhaAccounts[index];
        final isSelected = controller.selectedIndex.value == index;

        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildAbhaCard(controller, account, index, isSelected),
        );
      }),
    );
  }

  Widget _buildAbhaCard(
    SelectAbhaAddressController controller,
    Map<String, dynamic> account,
    int index,
    bool isSelected,
  ) {
    final abhaAddress = account['abhaAddress']?.toString() ?? '';
    final name = account['name']?.toString() ?? '';

    return GestureDetector(
      onTap: () => controller.selectAccount(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xFF3865FF) : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ABHA Address
                  Text(
                    abhaAddress,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3865FF),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Name
                  Text(
                    name,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF94A3B8),
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Radio Button
            _buildCustomRadioButton(isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomRadioButton(bool isSelected) {
    if (isSelected) {
      // Selected state: Blue inner circle with outer ring and glow
      return Container(
        width: 24,
        height: 24,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring with glow effect
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF3865FF).withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF3865FF).withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
            // Inner filled circle
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3865FF),
              ),
            ),
          ],
        ),
      );
    } else {
      // Unselected state: Empty circle with grey border
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Color(0xFFCBD5E1), width: 2),
        ),
      );
    }
  }

  Widget _buildContinueButton(SelectAbhaAddressController controller) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DynamicButton(
          text: isLoading ? '' : 'lbl_continue'.tr,
          width: double.infinity,
          height: 50,
          fontSize: 16,
          onPressed: isLoading ? null : controller.handleNext,
          leadingIcon: isLoading
              ? LoadingAnimationWidget.horizontalRotatingDots(
                  color: Colors.white,
                  size: 24,
                )
              : null,
        ),
      );
    });
  }
}
