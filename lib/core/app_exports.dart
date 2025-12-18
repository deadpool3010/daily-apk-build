// ==================== Flutter Core ====================
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter/cupertino.dart' hide RefreshCallback;
export 'package:flutter/rendering.dart';
export 'package:jam_icons/jam_icons.dart';

// ==================== State Management ====================
export 'package:get/get.dart';

// ==================== Third Party Packages ====================
export 'package:google_fonts/google_fonts.dart';
export 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:pin_code_fields/pin_code_fields.dart';
export 'package:mobile_scanner/mobile_scanner.dart';

// ==================== Services ====================
export 'package:bandhucare_new/services/shared_pref_localization.dart';
export 'package:bandhucare_new/services/variables.dart';

// ==================== Localization ====================
export 'package:bandhucare_new/localization/app_localization.dart';

// ==================== Core Network ====================
export 'package:bandhucare_new/core/network/api_services.dart';

// ==================== Common Dart Libraries ====================
export 'dart:async';
export 'dart:convert';
export 'dart:math' show Random, pi, sin, cos;

// ==================== Widgets ====================
export 'package:bandhucare_new/widget/custom_chat_screen_bottom.dart';
export 'package:bandhucare_new/widget/custom_chat_screen_header.dart';
export 'package:bandhucare_new/widget/custom_app_bar.dart';
export 'package:bandhucare_new/widget/toggle_switch.dart';
export 'package:bandhucare_new/widget/custom_bottom_navbar.dart';
export 'package:bandhucare_new/widget/custom_bottom_text.dart';
export 'package:bandhucare_new/widget/custom_feelings_widget.dart';
export 'package:bandhucare_new/widget/custom_journey_cards.dart';
export 'package:bandhucare_new/widget/choose_language_drop_down.dart';
export 'package:bandhucare_new/widget/custom_button.dart';
export 'package:bandhucare_new/widget/custom_calendar.dart';
export 'package:bandhucare_new/widget/upcoming_previous_widget.dart';
export 'package:bandhucare_new/widget/abha_section_user_profile.dart';
export 'package:bandhucare_new/widget/logout_bottomsheet.dart';
export 'package:bandhucare_new/widget/common_login_register_header.dart';
export 'package:bandhucare_new/widget/custom_text_field.dart';
export 'package:bandhucare_new/widget/alternative_login_buttons.dart';
// ==================== Utils ====================
export 'package:bandhucare_new/core/utils/image_constant.dart';
export 'package:bandhucare_new/theme/app_theme.dart';

// ==================== Routes ====================
export 'package:bandhucare_new/presentation/chat_screen/chat_bot_screen.dart';
export 'package:bandhucare_new/presentation/my_appointment_screen/my_appointment.dart';
export 'package:bandhucare_new/presentation/your_reminders_screen/your_reminders_screen.dart';
export 'package:bandhucare_new/presentation/home_screen/home_screen.dart';
export 'package:bandhucare_new/presentation/home_screen/controller/home_screen_controller.dart';
export 'package:bandhucare_new/routes/app_routes.dart';
export 'package:bandhucare_new/presentation/join_community_screen/controller/join_community_controller.dart';
export 'package:bandhucare_new/presentation/language_setting_screen/controller/language_setting_controller.dart';
export 'package:bandhucare_new/presentation/login_screen/binding/login_screen_binding.dart';
export 'package:bandhucare_new/presentation/login_screen/controller/login_screen_controller.dart';
export 'package:bandhucare_new/presentation/scan_qr_screen/controller/scan_qr_controller.dart';
export 'package:bandhucare_new/presentation/splash_screen/controller/splash_controller.dart';
