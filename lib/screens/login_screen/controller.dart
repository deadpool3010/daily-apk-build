import 'package:bandhucare_new/constant/variables.dart';
import 'package:bandhucare_new/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginController extends GetxController with GetTickerProviderStateMixin {
  // OTP state managed via GetX
  final enteredOtp = ''.obs;
  final otpFieldKey = 0.obs;
  final enteredAadhaarOtp = ''.obs;
  final aadhaarFieldKey = 0.obs;

  final currentPage = 0.obs;
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

  @override
  void onClose() {
    // Dispose text controllers
    phoneController.dispose();
    emailAddressController.dispose();
    abhaAddressController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var controller in abhaNumberControllers) {
      controller.dispose();
    }
    for (var controller in aadhaarNumberControllers) {
      controller.dispose();
    }
    for (var controller in verificationOtpControllers) {
      controller.dispose();
    }
    // Dispose focus nodes
    for (var focusNode in otpFocusNodes) {
      focusNode.dispose();
    }
    // Dispose animation controllers
    slideController.dispose();
    flipController.dispose();
    dropdownController.dispose();
    for (var controller in otpAnimationControllers) {
      controller.dispose();
    }
    for (var controller in verificationOtpAnimationControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  void _initializeTextControllers() {
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
      if (currentPage.value == 0 && !isClosed) {
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
    if (currentPage.value > 0) {
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
}
