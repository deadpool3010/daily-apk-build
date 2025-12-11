import 'package:bandhucare_new/core/utils/image_constant.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controller/consent_form_controller.dart';

class ConsentFormScreen extends StatelessWidget {
  const ConsentFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConsentFormController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF2563EB),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF2563EB),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 35),
                      Row(
                        children: [
                          Image.asset(
                            ImageConstant.appLogo,
                            width: 32,
                            height: 32,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'lbl_bandhu_care'.tr,
                            style: TextStyle(
                              fontFamily: 'Paggoda',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 35),
                      Text(
                        'lbl_consent_form'.tr,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'msg_by_proceeding_you_confirm'.tr,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334155),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      _buildBulletPoint('msg_authorize_hospital_to_share'.tr),
                      const SizedBox(height: 12),
                      _buildBulletPoint('msg_understand_group_may_include'.tr),
                      const SizedBox(height: 12),
                      _buildBulletPoint('msg_agree_to_hospital_privacy'.tr),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FBFF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF5281E6),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'msg_you_will_be_added_to'.tr,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF111827),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            _buildInfoItem('lbl_department'.tr),
                            const SizedBox(height: 8),
                            _buildInfoItem('lbl_section'.tr),
                            const SizedBox(height: 8),
                            _buildInfoItem('lbl_unit'.tr),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: BoxDecoration(),
                child: Column(
                  children: [
                    Obx(
                      () => Row(
                        children: [
                          GestureDetector(
                            onTap: () => controller.toggleAgreement(),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: controller.isAgreed.value
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFF9CA3AF),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                                color: controller.isAgreed.value
                                    ? const Color(0xFF2563EB)
                                    : Colors.transparent,
                              ),
                              child: controller.isAgreed.value
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: GestureDetector(
                              onTap: () => controller.toggleAgreement(),
                              child: Text(
                                'lbl_i_agree_to_terms'.tr,
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2563EB),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: controller.isAgreed.value
                                ? () {
                                    Get.toNamed(AppRoutes.homeScreen);
                                  }
                                : null,
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 141,
                              ),
                              decoration: BoxDecoration(
                                gradient: controller.isAgreed.value
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFF0988F3),
                                          Color(0xFF0340CC),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      )
                                    : null,
                                color: controller.isAgreed.value
                                    ? null
                                    : const Color(0xFF9CA3AF),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  'lbl_continue'.tr,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: controller.isAgreed.value
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.7),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6, right: 12),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF6B7280),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String text) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF111827),
          ),
        ),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 13,
              color: Color(0xFF111827),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
