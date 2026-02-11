import 'dart:convert';
import 'package:bandhucare_new/core/utils/context_extensions.dart';
import 'package:bandhucare_new/core/utils/image_constant.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/tiptap_renderer.dart';
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
    final groupData = Get.arguments as Map<String, dynamic>? ?? {};

    // Extract consentForm from group data
    Map<String, dynamic>? consentFormData;

    // Debug: Print received data structure
    // print(
    //   'Consent Form Screen - Received groupData keys: ${groupData.keys.toList()}',
    // );

    // Try to get consentForm from nested group structure
    String? consentFormString;

    if (groupData['group'] != null &&
        groupData['group'] is Map<String, dynamic>) {
      final group = groupData['group'] as Map<String, dynamic>;
      //   print('Consent Form Screen - Group keys: ${group.keys.toList()}');
      consentFormString = group['consentForm'] as String?;
    } else if (groupData['consentForm'] != null) {
      // Fallback: check if consentForm is directly in groupData
      consentFormString = groupData['consentForm'] as String?;
      //  print('Consent Form Screen - Found consentForm directly in groupData');
    }

    // Parse the JSON string if found
    if (consentFormString != null && consentFormString.isNotEmpty) {
      // print(
      //   'Consent Form Screen - consentFormString length: ${consentFormString.length}',
      // );
      // print(
      //   'Consent Form Screen - consentFormString preview: ${consentFormString.substring(0, consentFormString.length > 150 ? 150 : consentFormString.length)}...',
      // );

      try {
        consentFormData = jsonDecode(consentFormString) as Map<String, dynamic>;
        //    print('Consent Form Screen - ✅ Successfully parsed TipTap JSON');
        // print(
        //   'Consent Form Screen - TipTap content type: ${consentFormData['type']}',
        // );
        // print(
        //   'Consent Form Screen - TipTap content nodes count: ${(consentFormData['content'] as List?)?.length ?? 0}',
        // );
      } catch (e) {
        // print('Consent Form Screen - ❌ Error parsing consentForm JSON: $e');
        // print('Consent Form Screen - Full JSON string: $consentFormString');
      }
    } else {
      // print('Consent Form Screen - ⚠️ consentFormString is null or empty');
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: context.hasThreeButtonNavigation,
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
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
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
                      // Render TipTap content from API response
                      if (consentFormData != null)
                        _buildTiptapContent(consentFormData)
                      else
                        _buildLoadingOrError(),
                      const SizedBox(height: 24),
                      // Container(
                      //   width: double.infinity,
                      //   padding: const EdgeInsets.all(16),
                      //   decoration: BoxDecoration(
                      //     color: const Color(0xFFF9FBFF),
                      //     borderRadius: BorderRadius.circular(12),
                      //     border: Border.all(
                      //       color: const Color(0xFF5281E6),
                      //       width: 1,
                      //     ),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         'msg_you_will_be_added_to'.tr,
                      //         style: TextStyle(
                      //           fontFamily: 'Lato',
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500,
                      //           color: Color(0xFF111827),
                      //         ),
                      //         maxLines: 1,
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //       const SizedBox(height: 12),
                      //       _buildInfoItem('lbl_department'.tr),
                      //       const SizedBox(height: 8),
                      //       _buildInfoItem('lbl_section'.tr),
                      //       const SizedBox(height: 8),
                      //       _buildInfoItem('lbl_unit'.tr),
                      //     ],
                      //   ),
                      // ),
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
                                    Get.offAllNamed(AppRoutes.homeScreen);
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

  /// Build TipTap content from API response
  Widget _buildTiptapContent(Map<String, dynamic> consentFormData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8),
      child: TiptapRenderer(document: consentFormData),
    );
  }

  /// Build loading or error state
  Widget _buildLoadingOrError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          'Loading consent form...',
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}
