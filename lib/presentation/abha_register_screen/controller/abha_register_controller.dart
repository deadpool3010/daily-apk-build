import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:bandhucare_new/core/constants/variables.dart' as vars;
import 'package:bandhucare_new/core/utils/validator.dart';

class AbhaRegisterController extends GetxController
    with GetTickerProviderStateMixin {
  // Text Controllers
  late TextEditingController mobileController;

  // TextEditingControllers for Aadhaar fields (3 fields with 4 digits each)
  List<TextEditingController> aadhaarControllers = List.generate(
    3,
    (index) => TextEditingController(),
  );

  // FocusNodes for Aadhaar TextField widgets
  List<FocusNode> aadhaarFocusNodes = List.generate(3, (index) => FocusNode());

  // Animation Controllers
  late AnimationController flipController;
  late Animation<double> flipAnimation;
  late AnimationController slideController;
  late Animation<double> slideAnimation;
  final isCardFlipped = false.obs;
  final isAnimationComplete = false.obs;

  // OTP
  final enteredOtp = ''.obs;
  final enteredAadhaarOtp = ''.obs;

  // Loading States
  final isLoadingGetOtp = false.obs;
  final isLoadingVerifyOtp = false.obs;
  final isLoadingCreateAbha = false.obs;

  // Current Step (0 = Aadhaar input, 1 = OTP/Phone input)
  final currentStep = 0.obs;

  // Session ID (placeholder - should be from API)
  String sessionId = '';

  @override
  void onInit() {
    super.onInit();
    mobileController = TextEditingController();

    // Initialize slide animation
    slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: slideController, curve: Curves.easeOutCubic),
    );

    // Initialize flip animation
    flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: flipController, curve: Curves.easeInOut));

    // Add focus listeners to position cursor correctly
    for (int i = 0; i < aadhaarFocusNodes.length; i++) {
      aadhaarFocusNodes[i].addListener(() {
        if (aadhaarFocusNodes[i].hasFocus) {
          // Position cursor at the end of text (or start if empty)
          // With textAlign.center, this appears centered
          final text = aadhaarControllers[i].text;
          Future.delayed(Duration(milliseconds: 10), () {
            if (!isClosed && aadhaarFocusNodes[i].hasFocus) {
              aadhaarControllers[i].selection = TextSelection.collapsed(
                offset: text.length,
              );
            }
          });
        }
      });
    }

    // Start card animations when screen opens
    startCardAnimations();

    // Listen to step changes and auto-flip card
    ever(currentStep, (step) {
      if (step == 1 && !isCardFlipped.value) {
        // Auto-flip to front when moving to OTP step
        Future.delayed(Duration(milliseconds: 300), () {
          if (!isClosed) {
            flipController.forward();
            isCardFlipped.value = true;
          }
        });
      }
    });
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
    isAnimationComplete.value = false;

    // Start slide animation (left to center)
    slideController.forward().then((_) {
      // After slide completes, start flip animation
      Future.delayed(Duration(milliseconds: 300), () {
        if (!isClosed && !flipController.isAnimating) {
          flipController.forward().then((_) {
            // After flip completes, show content
            if (!isClosed) {
              isCardFlipped.value = true;
              isAnimationComplete.value = true;
              // Focus the first Aadhaar field after animation completes
              Future.delayed(Duration(milliseconds: 300), () {
                if (!isClosed && aadhaarFocusNodes[0].canRequestFocus) {
                  aadhaarFocusNodes[0].requestFocus();
                  // Position cursor at start (offset 0) - with textAlign.center, cursor appears centered
                  Future.delayed(Duration(milliseconds: 50), () {
                    if (!isClosed) {
                      aadhaarControllers[0].selection = TextSelection.collapsed(
                        offset: 0,
                      );
                    }
                  });
                }
              });
            }
          });
        }
      });
    });
  }

  @override
  void onClose() {
    slideController.dispose();
    flipController.dispose();
    mobileController.dispose();
    for (var controller in aadhaarControllers) {
      controller.dispose();
    }
    for (var focusNode in aadhaarFocusNodes) {
      focusNode.dispose();
    }
    super.onClose();
  }

  void toggleCardFlip() {
    if (isCardFlipped.value) {
      flipController.reverse();
    } else {
      flipController.forward();
    }
    isCardFlipped.value = !isCardFlipped.value;
  }

  // Validate Aadhaar number using Validator utility
  bool validateAadhaarNumber(String aadhaar) {
    return Validator.validateAadhaarNumber(aadhaar);
  }

  // Validate OTP using Validator utility
  bool validateOTP(String otp) {
    return Validator.validateOTP(otp);
  }

  // Validate mobile number using Validator utility
  bool validateMobileNumber(String mobile) {
    return Validator.validatePhoneNumber(mobile);
  }

  Future<void> handleGetAadhaarOTP() async {
    String aadhaarNumber =
        aadhaarControllers[0].text +
        aadhaarControllers[1].text +
        aadhaarControllers[2].text;

    // Validate Aadhaar number - this will show snackbar if invalid
    if (aadhaarNumber.isEmpty) {
      Validator.showErrorSnackbar('Please enter your Aadhaar number');
      return;
    }

    if (!validateAadhaarNumber(aadhaarNumber)) {
      return;
    }

    isLoadingGetOtp.value = true;

    try {
      // Call create ABHA API with Aadhaar number
      final result = await createAbhaNumberApi(aadhaarNumber);

      // Check if API returned an error
      if (result['success'] == false) {
        // Show backend error message directly
        String errorMessage = result['message'] ?? 
            result['error'] ?? 
            result['errorMessage'] ?? 
            result['status'] ?? 
            'Something went wrong. Please try again.';
        Validator.showErrorSnackbar(errorMessage);
        return;
      }

      // Extract sessionId from response
      if (result['data'] != null && result['data'] is Map) {
        final data = result['data'] as Map<String, dynamic>;
        final extractedSessionId = data['sessionId']?.toString() ?? '';
        if (extractedSessionId.isNotEmpty) {
          sessionId = extractedSessionId;
          // Also save to global variable
          vars.sessionId = extractedSessionId;
          print('Session ID saved: $sessionId');
        }
      }

      Validator.showSuccessSnackbar(
        result['message'] ?? "OTP sent successfully!",
      );

      // Move to next step (card will auto-flip via ever listener)
      currentStep.value = 1;
    } catch (e) {
      // Extract user-friendly error message using Validator utility
      String errorMessage = Validator.extractErrorMessage(e);
      Validator.showErrorSnackbar(errorMessage);
    } finally {
      isLoadingGetOtp.value = false;
    }
  }

  void handleAadhaarOtpChange(String value) {
    enteredAadhaarOtp.value = value;
  }

  // Move focus to next Aadhaar field
  void moveToNextAadhaarField(int currentIndex, BuildContext? context) {
    if (currentIndex < 2 && !isClosed && context != null) {
      final nextIndex = currentIndex + 1;
      if (nextIndex < aadhaarFocusNodes.length) {
        final nextFocusNode = aadhaarFocusNodes[nextIndex];

        // Use addPostFrameCallback to ensure it runs after current frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!isClosed) {
            // Directly focus next field without unfocusing current
            // This keeps the keyboard open
            FocusScope.of(context).requestFocus(nextFocusNode);

            // Backup: direct requestFocus if FocusScope didn't work
            Future.delayed(Duration(milliseconds: 10), () {
              if (!isClosed &&
                  !nextFocusNode.hasFocus &&
                  nextFocusNode.canRequestFocus) {
                nextFocusNode.requestFocus();
              }
            });
          }
        });
      }
    }
  }

  // Move focus to previous Aadhaar field
  void moveToPreviousAadhaarField(int currentIndex, BuildContext? context) {
    if (currentIndex > 0 && !isClosed) {
      Future.delayed(Duration(milliseconds: 50), () {
        if (!isClosed && currentIndex - 1 >= 0) {
          final prevFocusNode = aadhaarFocusNodes[currentIndex - 1];

          // Use FocusScope to move to previous focusable widget
          if (context != null) {
            FocusScope.of(context).previousFocus();
          }

          // Also ensure the FocusNode gets focus
          if (prevFocusNode.canRequestFocus) {
            prevFocusNode.requestFocus();
          }
        }
      });
    }
  }

  Future<void> handleVerifyOtp() async {
    final otp = enteredAadhaarOtp.value;
    final mobile = mobileController.text.trim();

    // Validate OTP - this will show snackbar if invalid
    if (otp.isEmpty) {
      Validator.showErrorSnackbar('Please enter the OTP');
      return;
    }

    if (!validateOTP(otp)) {
      return;
    }

    // Validate mobile number - this will show snackbar if invalid
    if (mobile.isEmpty) {
      Validator.showErrorSnackbar('Please enter your mobile number');
      return;
    }

    if (!validateMobileNumber(mobile)) {
      return;
    }

    if (sessionId.isEmpty) {
      Validator.showErrorSnackbar('Session expired. Please request OTP again.');
      return;
    }

    isLoadingVerifyOtp.value = true;

    try {
      // Call verify OTP API for Aadhaar with createAbha as verifyFor
      final result = await verifyOtpforAadhaarNumberApi(
        enteredAadhaarOtp.value,
        sessionId,
        mobileController.text.trim(),
      );

      // Check if API returned an error
      if (result['success'] == false) {
        // Show backend error message directly
        String errorMessage = result['message'] ?? 
            result['error'] ?? 
            result['errorMessage'] ?? 
            result['status'] ?? 
            'Something went wrong. Please try again.';
        Validator.showErrorSnackbar(errorMessage);
        return;
      }

      // Extract and update sessionId from response if available
      if (result['data'] != null && result['data'] is Map) {
        final data = result['data'] as Map<String, dynamic>;
        final extractedSessionId = data['sessionId']?.toString() ?? '';
        if (extractedSessionId.isNotEmpty) {
          sessionId = extractedSessionId;
          // Also save to global variable
          vars.sessionId = extractedSessionId;
          print('Session ID updated from verify OTP: $sessionId');
        }
      } else if (result['sessionId'] != null) {
        // Check root level if not in data object
        final extractedSessionId = result['sessionId']?.toString() ?? '';
        if (extractedSessionId.isNotEmpty) {
          sessionId = extractedSessionId;
          // Also save to global variable
          vars.sessionId = extractedSessionId;
          print('Session ID updated from verify OTP: $sessionId');
        }
      }

      Validator.showSuccessSnackbar(
        result['message'] ?? "OTP verified successfully!",
      );

      // Check updateMobile in response to determine navigation
      final updateMobile =
          result['updateMobile'] ?? result['data']?['updateMobile'] ?? false;

      // Navigate based on updateMobile value
      if (updateMobile == true) {
        // If updateMobile is true, navigate to OTP verification screen
        Get.toNamed(AppRoutes.otpVerificationScreen);
      } else {
        // If updateMobile is false or not present, navigate to email verification screen
        Get.toNamed(AppRoutes.emailVerificationAbhaScreen);
      }
    } catch (e) {
      // Extract user-friendly error message using Validator utility
      String errorMessage = Validator.extractErrorMessage(e);
      Validator.showErrorSnackbar(errorMessage);
    } finally {
      isLoadingVerifyOtp.value = false;
    }
  }
}
