import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:bandhucare_new/services/variables.dart';
import 'package:bandhucare_new/core/network/api_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginController extends GetxController with GetTickerProviderStateMixin {
  // OTP state managed via GetX
  final enteredOtp = ''.obs;
  final otpFieldKey = 0.obs;
  final enteredAadhaarOtp = ''.obs;
  final aadhaarFieldKey = 0.obs;

  final currentPage =
      1.obs; // Start at page 1 (language selection moved to separate screen)
  final isDropdownExpanded = false.obs;
  final isCreatingNewAbha = false.obs;
  final isCardFlipped = false.obs;
  final selectedAbhaIndex = 0.obs;
  final createSubPage = 0.obs;
  late TextEditingController phoneController;
  late TextEditingController emailAddressController;
  late TextEditingController abhaAddressController;
  final selectedUserData = <String, dynamic>{}.obs;
  late List<TextEditingController> abhaNumberControllers;
  List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final isAbhaAddressValid = false.obs;
  final abhaAddressSuggestions =
      <String>[].obs; // Reactive list for suggestions
  final isLoadingSuggestions = false.obs; // Loading state for suggestions
  List<TextEditingController> aadhaarNumberControllers = List.generate(
    3,
    (index) => TextEditingController(),
  );
  List<TextEditingController> verificationOtpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final isLoadingSignIn = false.obs;
  final isLoadingVerifyOtp = false.obs;
  final isLoadingSelectAccount = false.obs;
  final showGetOtpHint = true.obs; // Show hint for Get OTP button
  List<Map<String, dynamic>> abhaAccounts = [];
  final profileDetails = Rxn<Map<String, dynamic>>(); // Make it observable
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());
  late Animation<double> dropdownAnimation;
  late Animation<double> flipAnimation;
  late AnimationController slideController;
  late Animation<double> slideAnimation;
  late AnimationController flipController;
  late AnimationController dropdownController;
  late List<AnimationController> otpAnimationControllers;
  late List<Animation<double>> otpScaleAnimations;
  late List<AnimationController> verificationOtpAnimationControllers;
  late List<Animation<double>> verificationOtpScaleAnimations;

  @override
  void onInit() {
    super.onInit();
    _initializeTextControllers();
    _initializeAnimations();

    // Listen to currentPage changes and trigger animations when page 3 is reached
    ever(currentPage, (int page) {
      if (page == 3 && !isCreatingNewAbha.value) {
        // Start animations when page 3 is reached
        Future.delayed(Duration(milliseconds: 100), () {
          if (!slideController.isAnimating && !flipController.isAnimating) {
            startCardAnimations();
          }
        });
      }
    });
  }

  bool _controllersInitialized = false;

  void _disposeTextControllers() {
    // Only dispose if controllers have been initialized
    if (!_controllersInitialized) return;

    // Safely dispose text controllers
    try {
      phoneController.dispose();
    } catch (e) {
      // Controller already disposed, ignore
    }

    try {
      emailAddressController.dispose();
    } catch (e) {
      // Controller already disposed, ignore
    }

    try {
      abhaAddressController.dispose();
    } catch (e) {
      // Controller already disposed, ignore
    }

    try {
      for (var controller in otpControllers) {
        controller.dispose();
      }
    } catch (e) {
      // Controllers already disposed, ignore
    }

    try {
      for (var controller in abhaNumberControllers) {
        controller.dispose();
      }
    } catch (e) {
      // Controllers already disposed, ignore
    }

    try {
      for (var controller in aadhaarNumberControllers) {
        controller.dispose();
      }
    } catch (e) {
      // Controllers already disposed, ignore
    }

    try {
      for (var controller in verificationOtpControllers) {
        controller.dispose();
      }
    } catch (e) {
      // Controllers already disposed, ignore
    }

    _controllersInitialized = false;
  }

  @override
  void onClose() {
    // Dispose text controllers safely
    _disposeTextControllers();

    // Dispose focus nodes
    try {
      for (var focusNode in otpFocusNodes) {
        focusNode.dispose();
      }
    } catch (e) {
      // Focus nodes already disposed
    }

    // Dispose animation controllers
    try {
      slideController.dispose();
    } catch (e) {
      // Already disposed
    }

    try {
      flipController.dispose();
    } catch (e) {
      // Already disposed
    }

    try {
      dropdownController.dispose();
    } catch (e) {
      // Already disposed
    }

    try {
      for (var controller in otpAnimationControllers) {
        controller.dispose();
      }
    } catch (e) {
      // Already disposed
    }

    try {
      for (var controller in verificationOtpAnimationControllers) {
        controller.dispose();
      }
    } catch (e) {
      // Already disposed
    }

    super.onClose();
  }

  void _initializeTextControllers() {
    // Dispose existing controllers if any (in case of reinitialization)
    _disposeTextControllers();

    phoneController = TextEditingController();
    emailAddressController = TextEditingController();
    abhaAddressController = TextEditingController();
    otpControllers = List.generate(6, (index) => TextEditingController());
    abhaNumberControllers = List.generate(
      3,
      (index) => TextEditingController(),
    );
    verificationOtpControllers = List.generate(
      6,
      (index) => TextEditingController(),
    );

    _controllersInitialized = true;
  }

  void toggleCardFlip() {
    if (isCardFlipped.value) {
      // flipController.reverse();
    } else {
      flipController.forward();
    }
    isCardFlipped.value = !isCardFlipped.value;
  }

  void _initializeAnimations() {
    // Slide animation (left to center)
    slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: slideController, curve: Curves.easeOutCubic),
    );

    // Flip animation
    flipController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: flipController, curve: Curves.easeInOutCubic),
    );

    dropdownController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    dropdownAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: dropdownController, curve: Curves.easeInOut),
    );

    // Initialize OTP field animations
    otpAnimationControllers = List.generate(
      6,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );
    otpScaleAnimations = otpAnimationControllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 1.2,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    verificationOtpAnimationControllers = List.generate(
      6,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );
    verificationOtpScaleAnimations = verificationOtpAnimationControllers.map((
      controller,
    ) {
      return Tween<double>(
        begin: 1.0,
        end: 1.2,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();
  }

  // bool _validateAbhaAddress(String value) {
  //   // Min 8 characters, Max 18 characters
  //   if (value.length < 8 || value.length > 18) {
  //     return false;
  //   }

  //   // Count special characters (only dot and underscore allowed)
  //   int dotCount = value.split('.').length - 1;
  //   int underscoreCount = value.split('_').length - 1;

  //   // Maximum 1 dot and/or 1 underscore
  //   if (dotCount > 1 || underscoreCount > 1) {
  //     return false;
  //   }

  //   // Check for any other special characters
  //   RegExp allowedPattern = RegExp(r'^[a-zA-Z0-9._]+$');
  //   if (!allowedPattern.hasMatch(value)) {
  //     return false;
  //   }

  //   return true;
  // }

  // Call SignIn API
  Future<void> handleGetOTP() async {
    // Hide hint when button is clicked
    showGetOtpHint.value = false;

    String phone = phoneController.text.trim();

    if (phone.isEmpty || phone.length != 10) {
      Fluttertoast.showToast(
        msg: "Please enter a valid 10-digit phone number",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    isLoadingSignIn.value = true;

    try {
      final result = await signInApi(phone);
      print('');
      print('========================================');
      print('✅ ✅ ✅ SignIn API SUCCESS ✅ ✅ ✅');
      print('========================================');
      print('📦 Full Response: $result');
      print('📊 Success: ${result['success']}');
      print('📨 Message: ${result['message']}');
      print('📋 Data: ${result['data']}');
      print('🔑 SessionId: $sessionId');
      print('========================================');
      print('');

      Fluttertoast.showToast(
        msg: "OTP sent successfully!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      print('');
      print('========================================');
      print('❌ ❌ ❌ SignIn API FAILED ❌ ❌ ❌');
      print('========================================');
      print('Error: $e');
      print('========================================');
      print('');

      // Extract the actual error message
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: Exception: ', '');
      } else if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoadingSignIn.value = false;
    }
  }

  // Future<void> _handleGetAadhaarNumberOTP() async {
  //   String aadhaarNumber = aadhaarNumberControllers.map((c) => c.text).join('');

  //   if (aadhaarNumber.isEmpty || aadhaarNumber.length != 12) {
  //     Fluttertoast.showToast(
  //       msg: "Please enter a valid 12-digit aadhaar number",
  //       toastLength: Toast.LENGTH_SHORT,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //     return;
  //   }

  //     isLoadingSignIn.value = true;

  //   try {
  //     final result = await createAbhaNumberApi(aadhaarNumber);
  //     print('');
  //     print('========================================');
  //     print('✅ ✅ ✅ SignIn API SUCCESS ✅ ✅ ✅');
  //     print('========================================');
  //     print('📦 Full Response: $result');
  //     print('📊 Success: ${result['success']}');
  //     print('📨 Message: ${result['message']}');
  //     print('📋 Data: ${result['data']}');
  //     print('🔑 SessionId: ${result['data']['sessionId']}');
  //     sessionId = result['data']['sessionId'] as String;
  //     print('========================================');
  //     print('');

  //     Fluttertoast.showToast(
  //       msg: "OTP sent successfully!",
  //       toastLength: Toast.LENGTH_SHORT,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //     );

  //     // Move to next sub-page after successful OTP send
  //     createSubPage.value = 1;
  //   } catch (e) {
  //     print('');
  //     print('========================================');
  //     print('❌ ❌ ❌ SignIn API FAILED ❌ ❌ ❌');
  //     print('========================================');
  //     print('Error: $e');
  //     print('========================================');
  //     print('');

  //     // Extract the actual error message
  //     String errorMessage = e.toString();
  //     if (errorMessage.startsWith('Exception: Exception: ')) {
  //       errorMessage = errorMessage.replaceFirst('Exception: Exception: ', '');
  //     } else if (errorMessage.startsWith('Exception: ')) {
  //       errorMessage = errorMessage.replaceFirst('Exception: ', '');
  //     }

  //     Fluttertoast.showToast(
  //       msg: errorMessage,
  //       toastLength: Toast.LENGTH_LONG,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //   } finally {
  //     isLoadingSignIn.value = false;
  //   }
  // }

  // Future<void> _handleOTPChange(String value, int index) async {
  //   if (value.length == 1 && index < 5) {
  //     // Digit entered - move to next field
  //     otpFocusNodes[index + 1].requestFocus();
  //   }

  //   // Check if all 6 OTP digits are filled
  //   String otp = otpControllers.map((c) => c.text).join('');
  //   if (otp.length == 6) {
  //     print('========================================');
  //     print('✅ All 6 OTP digits entered: $otp');
  //     print('🚀 Calling VerifyOtp API automatically...');
  //     print('========================================');
  //     await _verifyOTPforMobileNumber(otp);
  //   }
  // }

  // Future<void> _handleAadhaarNumberOTPChange(String value, int index) async {

  //   if (value.length == 1 && index < 5) {
  //     // Digit entered - move to next field
  //     otpFocusNodes[index + 1].requestFocus();
  //   }

  //   // Just check if all 6 OTP digits are filled (don't auto-verify)
  //   String otp = otpControllers.map((c) => c.text).join('');
  //   if (otp.length == 6) {
  //     print('========================================');
  //     print('✅ All 6 OTP digits entered: $otp');
  //     print('📝 Ready for verification - Click Verify button');
  //     print('========================================');
  //   }
  // }

  //   // Call VerifyOTP API
  //   Future<void> _verifyOTPforMobileNumber(String otp) async {
  //   if (sessionId.isEmpty) {
  //     print('❌ SessionId is empty!');
  //     Fluttertoast.showToast(
  //       msg: "Session expired. Please request OTP again.",
  //       toastLength: Toast.LENGTH_SHORT,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //     return;
  //   }

  //   setState(() {
  //     isLoadingVerifyOtp = true;
  //   });

  //   try {
  //     final result = await verifyOtpforabhaMobileApi(otp, sessionId);
  //     print('');
  //     print('========================================');
  //     print('✅ ✅ ✅ VerifyOTP API SUCCESS ✅ ✅ ✅');
  //     print('========================================');
  //     print('📦 Full Response: $result');
  //     print('📊 Success: ${result['success']}');
  //     print('📨 Message: ${result['message']}');
  //     print('📋 Data: ${result['data']}');
  //     print('========================================');
  //     print('');

  //     Fluttertoast.showToast(
  //       msg: "OTP verified successfully!",
  //       toastLength: Toast.LENGTH_SHORT,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //     );

  //     // Store accounts data and new sessionId if available
  //     if (result['data'] != null) {
  //       // Update sessionId from VerifyOtp response
  //       if (result['data']['sessionId'] != null) {
  //         sessionId = result['data']['sessionId'] as String;
  //         print('🔄 SessionId updated: $sessionId');
  //       }

  //       // Store accounts
  //       if (result['data']['accounts'] != null) {
  //         List<dynamic> accounts = result['data']['accounts'];
  //         setState(() {
  //           abhaAccounts = accounts
  //               .map(
  //                 (account) => {
  //                   'abhaNumber': account['abhaNumber'] ?? '',
  //                   'name': account['name'] ?? '',
  //                   'abhaAddress': account['abhaAddress'] ?? '',
  //                 },
  //               )
  //               .toList();
  //           selectedAbhaIndex = null; // Reset selection
  //         });

  //         print('========================================');
  //         print('📋 Stored ${abhaAccounts.length} ABHA accounts');
  //         print('🔑 Using SessionId: $sessionId');
  //         print('========================================');

  //         // Close OTP overlay screen

  //         // Don't navigate automatically - user will click Next button manually
  //       }
  //     }
  //   } catch (e) {
  //     print('');
  //     print('========================================');
  //     print('❌ ❌ ❌ VerifyOTP API FAILED ❌ ❌ ❌');
  //     print('========================================');
  //     print('Error: $e');
  //     print('========================================');
  //     print('');

  //     // Extract the actual error message
  //     String errorMessage = e.toString();
  //     if (errorMessage.startsWith('Exception: Exception: ')) {
  //       errorMessage = errorMessage.replaceFirst('Exception: Exception: ', '');
  //     } else if (errorMessage.startsWith('Exception: ')) {
  //       errorMessage = errorMessage.replaceFirst('Exception: ', '');
  //     }

  //     Fluttertoast.showToast(
  //       msg: errorMessage,
  //       toastLength: Toast.LENGTH_LONG,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //   } finally {
  //     setState(() {
  //       isLoadingVerifyOtp = false;
  //     });
  //   }
  // }

  //   Future<Map<String, dynamic>?> _verifyOTPforAadhaarNumber(String otp) async {
  //   if (sessionId.isEmpty) {
  //     print('❌ SessionId is empty!');
  //     Fluttertoast.showToast(
  //       msg: "Session expired. Please request OTP again.",
  //       toastLength: Toast.LENGTH_SHORT,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //     return null;
  //   }

  //   setState(() {
  //     isLoadingVerifyOtp = true;
  //   });

  //   try {
  //     final result = await verifyOtpforAadhaarNumberApi(
  //       otp,
  //       sessionId,
  //       phoneController.text.trim(),
  //     );
  //     print('');
  //     print('========================================');
  //     print('✅ ✅ ✅ VerifyOTP API SUCCESS ✅ ✅ ✅');
  //     print('========================================');
  //     print('📦 Full Response: $result');
  //     print('📊 Success: ${result['success']}');
  //     print('📨 Message: ${result['message']}');
  //     print('📋 Data: ${result['data']}');
  //     print('🔄 UpdateMobile: ${result['data']?['updateMobile']}');
  //     sessionId = result['data']['sessionId'] as String;

  //     print('========================================');
  //     print('');

  //     Fluttertoast.showToast(
  //       msg: "OTP verified successfully!",
  //       toastLength: Toast.LENGTH_SHORT,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //     );

  //     // Store accounts data and new sessionId if available
  //     if (result['data'] != null) {
  //       // Update sessionId from VerifyOtp response
  //       if (result['data']['sessionId'] != null) {
  //         sessionId = result['data']['sessionId'] as String;
  //         print('🔄 SessionId updated: $sessionId');
  //       }
  //     }

  //     return result; // Return the result for checking updateMobile
  //   } catch (e) {
  //     print('');
  //     print('========================================');
  //     print('❌ ❌ ❌ VerifyOTP API FAILED ❌ ❌ ❌');
  //     print('========================================');
  //     print('Error: $e');
  //     print('========================================');
  //     print('');

  //     // Extract the actual error message
  //     String errorMessage = e.toString();
  //     if (errorMessage.startsWith('Exception: Exception: ')) {
  //       errorMessage = errorMessage.replaceFirst('Exception: Exception: ', '');
  //     } else if (errorMessage.startsWith('Exception: ')) {
  //       errorMessage = errorMessage.replaceFirst('Exception: ', '');
  //     }

  //     Fluttertoast.showToast(
  //       msg: errorMessage,
  //       toastLength: Toast.LENGTH_LONG,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );

  //     return null; // Return null on error
  //   } finally {
  //     setState(() {
  //       isLoadingVerifyOtp = false;
  //     });
  //   }
  // }

  //    // Call SelectAccount API
  //   Future<void> _selectAccount() async {

  //   if (sessionId.isEmpty) {
  //     print('❌ SessionId is empty!');
  //     Fluttertoast.showToast(
  //       msg: "Session expired. Please try again.",
  //       toastLength: Toast.LENGTH_SHORT,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //     return;
  //   }

  //   setState(() {
  //     isLoadingSelectAccount = true;
  //   });

  //   try {
  //     String selectedAbhaNumber =
  //         abhaAccounts[selectedAbhaIndex!]['abhaNumber'];
  //     String selectedName = abhaAccounts[selectedAbhaIndex!]['name'];
  //     String selectedAddress = abhaAccounts[selectedAbhaIndex!]['abhaAddress'];

  //     final result = await selectAccountApi(sessionId, selectedAbhaNumber);
  //     print('');
  //     print('========================================');
  //     print('✅ ✅ ✅ SelectAccount API SUCCESS ✅ ✅ ✅');
  //     print('========================================');
  //     print('📦 Full Response: $result');
  //     print('📊 Success: ${result['success']}');
  //     print('📨 Message: ${result['message']}');
  //     print('📋 Data: ${result['data']}');
  //     accessToken = result['data']['accessToken'] as String;
  //     refreshToken = result['data']['refreshToken'] as String;
  //     print('🎯 Selected Account:');
  //     print('   Name: $selectedName');
  //     print('   Address: $selectedAddress');
  //     print('   Number: $selectedAbhaNumber');
  //     print('========================================');
  //     print('');

  //     Fluttertoast.showToast(
  //       msg: "Account selected successfully!",
  //       toastLength: Toast.LENGTH_SHORT,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //     );

  //     // Store profile details for ABHA card
  //     if (result['data'] != null && result['data']['profileDetails'] != null) {
  //       setState(() {
  //         profileDetails = result['data']['profileDetails'];
  //       });
  //       print('💾 Profile details stored successfully');
  //     }

  //     // Navigate to page 3 (Welcome screen with ABHA card)
  //     setState(() {
  //       currentPage = 3;
  //     });
  //   } catch (e) {
  //     print('');
  //     print('========================================');
  //     print('❌ ❌ ❌ SelectAccount API FAILED ❌ ❌ ❌');
  //     print('========================================');
  //     print('Error: $e');
  //     print('========================================');
  //     print('');

  //     // Extract the actual error message
  //     String errorMessage = e.toString();
  //     if (errorMessage.startsWith('Exception: Exception: ')) {
  //       errorMessage = errorMessage.replaceFirst('Exception: Exception: ', '');
  //     } else if (errorMessage.startsWith('Exception: ')) {
  //       errorMessage = errorMessage.replaceFirst('Exception: ', '');
  //     }

  //     Fluttertoast.showToast(
  //       msg: errorMessage,
  //       toastLength: Toast.LENGTH_LONG,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //   } finally {
  //     setState(() {
  //       isLoadingSelectAccount = false;
  //     });
  //   }
  // }

  //   Future<void> _handleAddMeToCommunity() async {
  //   if (accessToken.isEmpty) {
  //     Fluttertoast.showToast(
  //       msg: "Access token not found. Please try again.",
  //       toastLength: Toast.LENGTH_SHORT,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //     return;
  //   }

  //   setState(() {
  //     isLoadingAddMeToCommunity = true;
  //   });

  //   try {
  //     final result = await addMeToCommunityApi();
  //     print('');
  //     print('========================================');
  //     print('✅ ✅ ✅ AddMeToCommunity API SUCCESS ✅ ✅ ✅');
  //     print('========================================');
  //     print('📦 Full Response: $result');
  //     print('📊 Success: ${result['success']}');
  //     print('📨 Message: ${result['message']}');
  //     print('📋 Data: ${result['data']}');
  //     print('========================================');
  //     print('');

  //     // Update accessToken and refreshToken from response
  //     // Check in data object first, then root level
  //     if (result['data'] != null) {
  //       if (result['data']['accessToken'] != null) {
  //         accessToken = result['data']['accessToken'] as String;
  //         print('🔄 AccessToken updated: $accessToken');
  //       }
  //       if (result['data']['refreshToken'] != null) {
  //         refreshToken = result['data']['refreshToken'] as String;
  //         print('🔄 RefreshToken updated: $refreshToken');
  //       }
  //     }
  //     // Also check at root level if not found in data
  //     if (result['accessToken'] != null) {
  //       accessToken = result['accessToken'] as String;
  //       print('🔄 AccessToken updated (root level): $accessToken');
  //     }
  //     if (result['refreshToken'] != null) {
  //       refreshToken = result['refreshToken'] as String;
  //       print('🔄 RefreshToken updated (root level): $refreshToken');
  //     }

  //     Fluttertoast.showToast(
  //       msg: result['message'] ?? "Successfully added to community!",
  //       toastLength: Toast.LENGTH_SHORT,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //     );

  //     // Navigate to homepage after successful API call
  //     Navigator.pushReplacementNamed(context, '/home');
  //   } catch (e) {
  //     print('');
  //     print('========================================');
  //     print('❌ ❌ ❌ AddMeToCommunity API FAILED ❌ ❌ ❌');
  //     print('========================================');
  //     print('Error: $e');
  //     print('========================================');
  //     print('');

  //     // Extract the actual error message
  //     String errorMessage = e.toString();
  //     if (errorMessage.startsWith('Exception: Exception: ')) {
  //       errorMessage = errorMessage.replaceFirst('Exception: Exception: ', '');
  //     } else if (errorMessage.startsWith('Exception: ')) {
  //       errorMessage = errorMessage.replaceFirst('Exception: ', '');
  //     }

  //     Fluttertoast.showToast(
  //       msg: errorMessage,
  //       toastLength: Toast.LENGTH_LONG,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //   } finally {
  //     setState(() {
  //       isLoadingAddMeToCommunity = false;
  //     });
  //   }
  // }

  void toggleDropdown() {
    if (isDropdownExpanded.value) {
      dropdownController.reverse();
    } else {
      dropdownController.forward();
    }
    isDropdownExpanded.value = !isDropdownExpanded.value;
  }

  void nextPage() {
    if (currentPage.value < 3) {
      // Ensure OTP text controller is initialized when navigating to page 1
      if (currentPage.value == 1 && !isClosed) {
        enteredOtp.value = '';
        otpFieldKey.value++;
      }
      // Initialize selected user data when navigating to page 3
      if (currentPage.value == 2 && selectedUserData.isEmpty) {
        if (selectedAbhaIndex.value < abhaAccounts.length) {
          selectedUserData.value = abhaAccounts[selectedAbhaIndex.value];
        } else if (abhaAccounts.isNotEmpty) {
          // Default to first user if no selection
          selectedUserData.value = abhaAccounts[0];
          selectedAbhaIndex.value = 0;
        }
      }
      currentPage.value++;

      // Start card animations when reaching page 3
      if (currentPage.value == 3) {
        Future.delayed(Duration(milliseconds: 100), () {
          startCardAnimations();
        });
      }
    } else {
      // Navigate to homepage
      Get.offAllNamed('/home');
    }
  }

  void startCardAnimations() {
    // Only start if not already animating or completed
    if (slideController.isAnimating || flipController.isAnimating) {
      return;
    }

    // Reset animations
    slideController.reset();
    flipController.reset();
    isCardFlipped.value = false;

    // Start slide animation (left to center)
    slideController.forward().then((_) {
      // After slide completes, start flip animation
      Future.delayed(Duration(milliseconds: 300), () {
        if (!flipController.isAnimating) {
          flipController.forward();
          isCardFlipped.value = true;
        }
      });
    });
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      // Reset create flag when going back to page 1 (OTP screen)
      if (currentPage.value == 1) {
        isCreatingNewAbha.value = false;
        if (!isClosed) {
          enteredOtp.value = '';
          otpFieldKey.value++;
        }
      }
    }
  }

  void goToCreateAbha() {
    isCreatingNewAbha.value = true;
    currentPage.value = 2;
  }

  void selectAbhaAddress(int index) {
    selectedAbhaIndex.value = index;
    // Store selected user data
    if (index < abhaAccounts.length) {
      selectedUserData.value = abhaAccounts[index];
    }
  }

  // Fetch ABHA Address Suggestions
  Future<void> fetchAbhaAddressSuggestions() async {
    if (sessionId.isEmpty) {
      print('❌ SessionId is empty! Cannot fetch suggestions.');
      return;
    }

    isLoadingSuggestions.value = true;

    try {
      final result = await getAbhaAddressSuggestionsApi(sessionId);
      print('');
      print('========================================');
      print('✅ ABHA Address Suggestions API SUCCESS');
      print('========================================');
      print('📦 Full Response: $result');
      print('========================================');
      print('');

      if (result['success'] == true && result['data'] != null) {
        // Get suggestions from data.suggestions array
        abhaAddressSuggestions.value = List<String>.from(
          result['data']['suggestions'] ?? [],
        );
        print('💡 Loaded ${abhaAddressSuggestions.length} suggestions');
        print('📋 Suggestions: $abhaAddressSuggestions');
      }
    } catch (e) {
      print('');
      print('========================================');
      print('❌ Failed to fetch ABHA suggestions');
      print('========================================');
      print('Error: $e');
      print('========================================');
      print('');
    } finally {
      isLoadingSuggestions.value = false;
    }
  }

  // Select suggestion and fill text field
  void selectSuggestion(String suggestion) {
    abhaAddressController.text = suggestion;
    isAbhaAddressValid.value = _validateAbhaAddress(suggestion);
    print('✅ Selected suggestion: $suggestion');
  }

  // Validate ABHA Address
  bool _validateAbhaAddress(String value) {
    // Min 8 characters, Max 18 characters
    if (value.length < 8 || value.length > 18) {
      return false;
    }

    // Count special characters (only dot and underscore allowed)
    int dotCount = value.split('.').length - 1;
    int underscoreCount = value.split('_').length - 1;

    // Maximum 1 dot and/or 1 underscore
    if (dotCount > 1 || underscoreCount > 1) {
      return false;
    }

    // Check for any other special characters
    RegExp allowedPattern = RegExp(r'^[a-zA-Z0-9._]+$');
    if (!allowedPattern.hasMatch(value)) {
      return false;
    }

    return true;
  }

  // Handle OTP change and auto-verify
  void handleOTPChange(String value) {
    enteredOtp.value = value;
    // Check if all 6 OTP digits are filled
    if (enteredOtp.value.length == 6 && !isLoadingVerifyOtp.value) {
      print('========================================');
      print('✅ All 6 OTP digits entered: ${enteredOtp.value}');
      print('🚀 Calling VerifyOtp API automatically...');
      print('========================================');
      // Set loading state immediately to show animation
      isLoadingVerifyOtp.value = true;
      // Add 2 second delay before calling API
      Future.delayed(Duration(seconds: 2), () {
        if (!isClosed && isLoadingVerifyOtp.value) {
          verifyOTPforMobileNumber(enteredOtp.value);
        }
      });
    }
  }

  // Call VerifyOTP API
  Future<void> verifyOTPforMobileNumber(String otp) async {
    if (sessionId.isEmpty) {
      print('❌ SessionId is empty!');
      isLoadingVerifyOtp.value = false;
      Fluttertoast.showToast(
        msg: "Session expired. Please request OTP again.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Loading state is already set in handleOTPChange if called from there
    // But set it here too in case method is called directly
    if (!isLoadingVerifyOtp.value) {
      isLoadingVerifyOtp.value = true;
    }

    try {
      final result = await verifyOtpforabhaMobileApi(otp, sessionId);
      print('');
      print('========================================');
      print('✅ ✅ ✅ VerifyOTP API SUCCESS ✅ ✅ ✅');
      print('========================================');
      print('📦 Full Response: $result');
      print('📊 Success: ${result['success']}');
      print('📨 Message: ${result['message']}');
      print('📋 Data: ${result['data']}');
      print('========================================');
      print('');

      Fluttertoast.showToast(
        msg: "OTP verified successfully!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Store accounts data and new sessionId if available
      if (result['data'] != null) {
        // Update sessionId from VerifyOtp response
        if (result['data']['sessionId'] != null) {
          sessionId = result['data']['sessionId'] as String;
          print('🔄 SessionId updated: $sessionId');
        }

        // Store accounts
        if (result['data']['accounts'] != null) {
          List<dynamic> accounts = result['data']['accounts'];
          abhaAccounts = accounts
              .map(
                (account) => {
                  'abhaNumber': account['abhaNumber'] ?? '',
                  'name': account['name'] ?? '',
                  'abhaAddress': account['abhaAddress'] ?? '',
                },
              )
              .toList();

          print('========================================');
          print('📋 Stored ${abhaAccounts.length} ABHA accounts');
          print('🔑 Using SessionId: $sessionId');
          print('========================================');

          // Navigate to select ABHA address screen if multiple accounts found
          Get.toNamed(
            AppRoutes.selectAbhaAddressScreen,
            arguments: {'abhaAccounts': abhaAccounts},
          );
        }
      }
    } catch (e) {
      print('');
      print('========================================');
      print('❌ ❌ ❌ VerifyOTP API FAILED ❌ ❌ ❌');
      print('========================================');
      print('Error: $e');
      print('========================================');
      print('');

      // Extract the actual error message
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: Exception: ', '');
      } else if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoadingVerifyOtp.value = false;
    }
  }

  // Navigate to create ABHA flow
  void goToCreateAbhaFlow() {
    isCreatingNewAbha.value = true;
    createSubPage.value = 0;
    currentPage.value = 2;
  }
}
