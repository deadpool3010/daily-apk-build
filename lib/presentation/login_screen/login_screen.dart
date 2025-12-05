import 'package:bandhucare_new/core/app_exports.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Add these at the top of your State class (where you have otpControllers)
// List<TextEditingController> otpControllers = List.generate(
//   6,
//   (_) => TextEditingController(),
// );
//List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  String selectedLanguage = 'English';
  int currentPage = 0; // Track which section is visible (0-3)
  bool isDropdownExpanded = false; // Track dropdown state
  bool isCreatingNewAbha =
      false; // Track if user clicked "Create" to follow different path
  int createSubPage =
      0; // Track create mode sub-page (0 = Aadhaar input, 1 = OTP/Phone input)
  //TextEditingController phoneController = TextEditingController();

  TextEditingController emailAddressController = TextEditingController();
  TextEditingController abhaAddressController = TextEditingController();
  bool isAbhaAddressValid = false; // Track if ABHA address is valid

  // ABHA Number input controllers (3 fields with 4 digits each)
  List<TextEditingController> aadhaarNumberControllers = List.generate(
    3,
    (index) => TextEditingController(),
  );

  // OTP Verification screen controllers (6 digits)
  List<TextEditingController> verificationOtpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  // ABHA Card flip animation
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool isCardFlipped = false;

  // API loading states
  bool isLoadingSignIn = false;
  bool isLoadingVerifyOtp = false;
  bool isLoadingSelectAccount = false;

  // Store accounts from API response
  List<Map<String, dynamic>> abhaAccounts = [];
  int? selectedAbhaIndex; // Track which ABHA card is selected

  // Store profile details from SelectAccount API
  Map<String, dynamic>? profileDetails;

  @override
  void initState() {
    super.initState();
    // Initialize flip animation
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    abhaAddressController.dispose();
    super.dispose();
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

  void _toggleCardFlip() {
    setState(() {
      if (isCardFlipped) {
        _flipController.reverse();
      } else {
        _flipController.forward();
      }
      isCardFlipped = !isCardFlipped;
    });
  }

  // Call SignIn API

  Future<void> _handleGetAadhaarNumberOTP() async {
    String aadhaarNumber = aadhaarNumberControllers.map((c) => c.text).join('');

    if (aadhaarNumber.isEmpty || aadhaarNumber.length != 12) {
      Fluttertoast.showToast(
        msg: "Please enter a valid 12-digit aadhaar number",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Get controller and set loading state
    final controller = Get.find<LoginController>();
    controller.isLoadingSignIn.value = true;

    try {
      final result = await createAbhaNumberApi(aadhaarNumber);
      print('');
      print('========================================');
      print('✅ ✅ ✅ SignIn API SUCCESS ✅ ✅ ✅');
      print('========================================');
      print('📦 Full Response: $result');
      print('📊 Success: ${result['success']}');
      print('📨 Message: ${result['message']}');
      print('📋 Data: ${result['data']}');
      print('🔑 SessionId: ${result['data']['sessionId']}');
      sessionId = result['data']['sessionId'] as String;
      print('========================================');
      print('');

      Fluttertoast.showToast(
        msg: "OTP sent successfully!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Move to next sub-page after successful OTP send
      setState(() {
        createSubPage = 1;
      });
      // Sync with controller
      controller.createSubPage.value = 1;
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
      controller.isLoadingSignIn.value = false;
    }
  }

  // Auto-verify OTP when all 6 digits are entered (done)
  void _handleOTPChange(LoginController controller, String value) async {
    controller.enteredOtp.value = value;
    // Check if all 6 OTP digits are filled

    if (controller.enteredOtp.value.length == 6) {
      print('========================================');
      print('✅ All 6 OTP digits entered: ${controller.enteredOtp.value}');
      print('🚀 Calling VerifyOtp API automatically...');
      print('========================================');
      await _verifyOTPforMobileNumber(controller, controller.enteredOtp.value);
    }
  }

  // done getx
  void _handleAadhaarNumberOTPChange(
    LoginController controller,
    String value,
  ) async {
    controller.enteredAadhaarOtp.value = value;

    // Check if all 6 OTP digits are filled (don't auto-verify)
    if (value.length == 6) {
      print('========================================');
      print('✅ All 6 OTP digits entered: $value');
      print('📝 Ready for verification - Click Verify button');
      print('========================================');
      await _verifyOTPforAadhaarNumber(controller, value);
    } else {
      debugPrint('Aadhaar OTP Changed: $value (Length: ${value.length})');
    }
  }

  // Call VerifyOTP API
  Future<void> _verifyOTPforMobileNumber(
    LoginController controller,
    String otp,
  ) async {
    if (sessionId.isEmpty) {
      print('❌ SessionId is empty!');
      Fluttertoast.showToast(
        msg: "Session expired. Please request OTP again.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      isLoadingVerifyOtp = true;
    });

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
          setState(() {
            abhaAccounts = accounts
                .map(
                  (account) => {
                    'abhaNumber': account['abhaNumber'] ?? '',
                    'name': account['name'] ?? '',
                    'abhaAddress': account['abhaAddress'] ?? '',
                  },
                )
                .toList();
            selectedAbhaIndex = null; // Reset selection
          });
          // Sync with controller
          final controller = Get.find<LoginController>();
          controller.abhaAccounts = abhaAccounts;

          print('========================================');
          print('📋 Stored ${abhaAccounts.length} ABHA accounts');
          print('🔑 Using SessionId: $sessionId');
          print('========================================');

          // Close OTP overlay screen

          // Don't navigate automatically - user will click Next button manually
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
      setState(() {
        isLoadingVerifyOtp = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _verifyOTPforAadhaarNumber(
    LoginController controller,
    String otp,
  ) async {
    if (sessionId.isEmpty) {
      print('❌ SessionId is empty!');
      Fluttertoast.showToast(
        msg: "Session expired. Please request OTP again.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }

    setState(() {
      isLoadingVerifyOtp = true;
    });

    try {
      final result = await verifyOtpforAadhaarNumberApi(
        otp,
        sessionId,
        controller.phoneController.text.trim(),
      );
      print('');
      print('========================================');
      print('✅ ✅ ✅ VerifyOTP API SUCCESS ✅ ✅ ✅');
      print('========================================');
      print('📦 Full Response: $result');
      print('📊 Success: ${result['success']}');
      print('📨 Message: ${result['message']}');
      print('📋 Data: ${result['data']}');
      print('🔄 UpdateMobile: ${result['data']?['updateMobile']}');
      sessionId = result['data']['sessionId'] as String;

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
      }

      return result; // Return the result for checking updateMobile
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

      return null; // Return null on error
    } finally {
      setState(() {
        isLoadingVerifyOtp = false;
      });
    }
  }

  // Call SelectAccount API
  Future<void> _selectAccount() async {
    if (selectedAbhaIndex == null) {
      Fluttertoast.showToast(
        msg: "Please select an ABHA account",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    if (sessionId.isEmpty) {
      print('❌ SessionId is empty!');
      Fluttertoast.showToast(
        msg: "Session expired. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      isLoadingSelectAccount = true;
    });
    // Sync with controller
    final controller = Get.find<LoginController>();
    controller.isLoadingSelectAccount.value = true;

    try {
      String selectedAbhaNumber =
          abhaAccounts[selectedAbhaIndex!]['abhaNumber'];
      String selectedName = abhaAccounts[selectedAbhaIndex!]['name'];
      String selectedAddress = abhaAccounts[selectedAbhaIndex!]['abhaAddress'];
      final result = await selectAccountApi(sessionId, selectedAbhaNumber);
      print('');
      print('========================================');
      print('✅ ✅ ✅ SelectAccount API SUCCESS ✅ ✅ ✅');
      print('========================================');
      print('📦 Full Response: $result');

      // print('📊 Success: ${result['success']}');
      // print('📨 Message: ${result['message']}');
      // print('📋 Data: ${result['data']}');

      accessToken = result['data']['accessToken'] as String;
      refreshToken = result['data']['refreshToken'] as String;
      final sharedPrefs = SharedPrefLocalization();
      await sharedPrefs.saveTokens(accessToken, refreshToken);
      await sharedPrefs.saveUserInfo(result['data']['profileDetails']);

      final hasPersistedUser = await sharedPrefs.hasPersistedUser();
      if (hasPersistedUser) {
        final persistedTokens = await sharedPrefs.getTokens();
        final persistedUserInfo = await sharedPrefs.getUserInfoMap();
        print('💾 Stored selected account locally for $selectedName');
        print('   Tokens cached: $persistedTokens');
        print('   User info cached: $persistedUserInfo');
      } else {
        print(
          '⚠️ User persistence failed even after saving tokens and user info.',
        );
      }

      print('🎯 Selected Account:');
      print('   Name: $selectedName');
      print('   Address: $selectedAddress');
      print('   Number: $selectedAbhaNumber');
      print('========================================');
      print('');

      Fluttertoast.showToast(
        msg: "Account selected successfully!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Store profile details for ABHA card
      if (result['data'] != null && result['data']['profileDetails'] != null) {
        setState(() {
          profileDetails = result['data']['profileDetails'];
        });
        // Sync with controller
        final controller = Get.find<LoginController>();
        controller.profileDetails.value = Map<String, dynamic>.from(
          result['data']['profileDetails'],
        );
        print('💾 Profile details stored successfully');
      }

      // Navigate to page 3 (Welcome screen with ABHA card)
      setState(() {
        currentPage = 3;
      });
      // Sync with controller
      final controller = Get.find<LoginController>();
      controller.currentPage.value = 3;
    } catch (e) {
      print('');
      print('========================================');
      print('❌ ❌ ❌ SelectAccount API FAILED ❌ ❌ ❌');
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
      setState(() {
        isLoadingSelectAccount = false;
      });
      // Sync with controller
      final controller = Get.find<LoginController>();
      controller.isLoadingSelectAccount.value = false;
    }
  }

  // Show OTP Verification Screen (overlay)
  void _showOTPVerificationScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          List<TextEditingController> verificationOtpControllers =
              List.generate(6, (_) => TextEditingController());
          List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

          void focusPreviousBox(int index) {
            if (index > 0) {
              FocusScope.of(context).requestFocus(focusNodes[index - 1]);
            }
          }

          void focusNextBox(int index) {
            if (index < 5) {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            }
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // BandhuCare Logo
                Positioned(
                  left: 24,
                  top: 165,
                  child: Image.asset(
                    'assets/images/bandhucare_otp_screen.png',
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
                ),
                // OTP Verification heading and description
                Positioned(
                  left: 24,
                  top: 310,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // OTP Verification heading
                      Text(
                        'OTP Verification',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 30.87 / 20,
                          letterSpacing: 0,
                          color: Color(0xFF3865FF),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Description text
                      Text(
                        'An OTP has been sent to your number. Please enter it here.',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 20 / 14,
                          letterSpacing: 0,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                // OTP Input boxes (6 boxes)
                Positioned(
                  left: 24,
                  top: 420,
                  child: Container(
                    width: 360,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return RawKeyboardListener(
                          focusNode: FocusNode(),
                          onKey: (RawKeyEvent event) {
                            if (event.logicalKey ==
                                    LogicalKeyboardKey.backspace &&
                                event.runtimeType == RawKeyDownEvent &&
                                verificationOtpControllers[index]
                                    .text
                                    .isEmpty) {
                              focusPreviousBox(index);
                            }
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0x299BBEF8),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Color(0xFFE2E8F0),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: verificationOtpControllers[index],
                              focusNode: focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (value) {
                                if (value.length == 1 && index < 5) {
                                  focusNextBox(index);
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                // Verify Button
                Positioned(
                  left: 24,
                  bottom: 100,
                  child: DynamicButton(
                    text: 'Submit',
                    width: 360,
                    onPressed: () {
                      String otp = verificationOtpControllers
                          .map((c) => c.text)
                          .join('');
                      print('OTP Entered: $otp');
                      Navigator.of(context).pop(
                        true,
                      ); // Navigate to email address verification screen
                      _emailAddressVerification();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //overlay screen for email address verification
  void _emailAddressVerification() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Positioned(
                  left: 24,
                  top: 165,
                  child: Image.asset(
                    'assets/imagesbandhucare_otp_screen.png',
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
                ),
                Positioned(
                  left: 24,
                  top: 310,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Address heading
                      Text(
                        'Enter Email Address',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 30.87 / 20,
                          letterSpacing: 0,
                          color: Color(0xFF3865FF),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Description text
                      Text(
                        'This Email Address is used for all communications\nrelated to ABHA',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 20 / 14,
                          letterSpacing: 0,
                          color: Colors.red,
                        ),
                      ),

                      const SizedBox(height: 24),

                      _buildEmailAddressInputContent(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Submit Button
                Positioned(
                  left: 24,
                  bottom: 150,
                  child: DynamicButton(
                    text: 'Submit',
                    width: 360,
                    onPressed: () async {
                      final result = await verifyEmailApi(
                        emailAddressController.text.trim(),
                        sessionId,
                      );
                      print('Email: ${emailAddressController.text}');
                      if (result['success'] == true) {
                        Navigator.of(context).pop(true);
                        // Navigate to create ABHA address screen
                        _createYourAbhaAddress();
                      } else {
                        Fluttertoast.showToast(
                          msg: result['message'] ?? 'Unknown error',
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
                  ),
                ),

                // Skip button
                Positioned(
                  left: 24,
                  bottom: 100,
                  child: SizedBox(
                    width: 360,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        // Navigate to create ABHA address screen even if skipped
                        _createYourAbhaAddress();
                      },
                      child: Text(
                        'Skip for now',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // After email screen closes, go to welcome screen
    setState(() {
      currentPage = 3;
    });
  }

  void _createYourAbhaAddress() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext dialogContext) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Positioned(
                  left: 24,
                  top: 165,
                  child: Image.asset(
                    'assets/images/bandhucare_otp_screen.png',
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
                ),
                Positioned(
                  left: 24,
                  top: 310,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Address heading
                      Text(
                        'Create Your Unique ABHA Address',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 30.87 / 20,
                          letterSpacing: 0,
                          color: Color(0xFF3865FF),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Description text
                      SizedBox(
                        width: 360,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 20 / 14,
                              letterSpacing: 0,
                              color: Colors.grey,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '• ABHA (Ayushman Bharat Health Account) address is a unique username that allows you to share and access your health records digitally. It is similar to an email address, but it is only used for health records.\n',
                              ),
                              TextSpan(
                                text:
                                    '• To create ABHA address, it should have Min - 8 characters, Max - 18 characters, special characters allowed - 1 dot (.) and/or 1 underscore (_).',
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ABHA Address Input
                      _buildAbhaAddressInput(),
                    ],
                  ),
                ),

                // Submit Button
                Positioned(
                  left: 24,
                  bottom: 100,
                  child: DynamicButton(
                    text: 'Submit',
                    width: 360,
                    onPressed: () async {
                      String abhaAddress = abhaAddressController.text.trim();

                      if (!_validateAbhaAddress(abhaAddress)) {
                        Fluttertoast.showToast(
                          msg:
                              "Please enter a valid ABHA address (8-18 characters, max 1 dot and/or 1 underscore)",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.orange,
                          textColor: Colors.white,
                        );
                        return;
                      }

                      try {
                        print('Creating ABHA Address: $abhaAddress@abdm');
                        print('SessionId: $sessionId');

                        final result = await createAbhaAddressApi(
                          abhaAddress,
                          sessionId,
                        );
                        accessToken = result['data']['accessToken'] as String;
                        refreshToken = result['data']['refreshToken'] as String;

                        print('CreateAbhaAddress API Response: $result');

                        if (result['success'] == true) {
                          Fluttertoast.showToast(
                            msg:
                                result['message'] ??
                                'ABHA Address created successfully!',
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );
                          // Return the result with profileDetails
                          Navigator.of(dialogContext).pop(result);
                        } else {
                          Fluttertoast.showToast(
                            msg:
                                result['message'] ??
                                'Failed to create ABHA address',
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        }
                      } catch (e) {
                        print('Error creating ABHA address: $e');
                        Fluttertoast.showToast(
                          msg:
                              "Error: ${e.toString().replaceAll('Exception: ', '')}",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // After creating ABHA address, extract profileDetails and go to welcome screen
    if (result != null && result['success'] == true) {
      // Extract profileDetails from API response
      if (result['data'] != null && result['data']['profileDetails'] != null) {
        setState(() {
          profileDetails = Map<String, dynamic>.from(
            result['data']['profileDetails'],
          );
          currentPage = 3;
        });
        // Sync with controller
        final controller = Get.find<LoginController>();
        controller.profileDetails.value = Map<String, dynamic>.from(
          result['data']['profileDetails'],
        );
        controller.currentPage.value = 3;
        print('Profile Details stored: $profileDetails');
      } else {
        setState(() {
          currentPage = 3;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping anywhere on the screen
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: Stack(
              children: [
                // Main Content (only for pages 0, 1, 2)
                if (currentPage != 3)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),

                      // Section 1: Language Selection (Page 0)
                      if (currentPage == 0) _buildLanguageSection(),

                      const SizedBox(height: 40),

                      // Illustration Image
                      if (currentPage == 0)
                        Expanded(
                          child: Center(
                            child: Image.asset(
                              'assets/images/choose_language.png',
                              width: 300,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 300,
                                  height: 300,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                      if (currentPage == 1) const Spacer(),

                      if (currentPage == 2) const Spacer(),

                      // Navigation Dots and Next Button (only for pages 0, 1, 2)
                      _buildBottomNavigation(controller),

                      const SizedBox(height: 30),
                    ],
                  ),

                // OTP Screen - Welcome Section (Page 1)
                if (currentPage == 1) _buildOTPSection(),

                // Phone Number Input (Page 1)
                if (currentPage == 1) _buildPhoneNumberInput(controller),

                // OTP Input and Get OTP Button (Page 1)
                if (currentPage == 1) _buildOTPInputSection(controller),

                // Other Login Options (Page 1)
                if (currentPage == 1) _buildOtherLoginOptions(),

                // Page 2: Header with Back Button
                if (currentPage == 2)
                  Positioned(
                    left: 24,
                    top: 40,
                    child: Row(
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentPage = 1;
                              // Clear ABHA accounts data
                              abhaAccounts.clear();
                              selectedAbhaIndex = null;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFFE2E8F0),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(0xFF3864FD),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Page 2: ABHA Address Selection Section (if ABHA found)
                if (currentPage == 2 && !isCreatingNewAbha)
                  _buildAbhaAddressSection(),

                // Page 2: Create New ABHA Section (if user clicked Create)
                if (currentPage == 2 && isCreatingNewAbha)
                  _buildCreateAbhaSection(controller),

                // Page 3: Welcome Screen (for both ABHA found and create flows)
                if (currentPage == 3) _buildWelcomeSection(),

                // ABHA Card - Page 3 (for both ABHA found and create flows)
                if (currentPage == 3 && !isCreatingNewAbha)
                  _buildAbhaCard(controller),
                if (currentPage == 3 && isCreatingNewAbha)
                  _buildNewAbhaCard(controller),

                // Bottom Navigation for Page 3 - Positioned at bottom
                if (currentPage == 3)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _buildBottomNavigation(controller),
                  ),

                // Ayushman Bharat Image - Fixed Position (Page 2 - ABHA Address Screen, only if not creating)
                if (currentPage == 2 && !isCreatingNewAbha)
                  Positioned(
                    left: 152,
                    top: 219,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(147.48),
                      child: Image.asset(
                        'assets/images/ayush_man_bharat.png',
                        width: 104,
                        height: 101,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 104,
                            height: 101,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(147.48),
                            ),
                            child: const Icon(
                              Icons.medical_information,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                // Stethoscope Image - Fixed Position (Page 1 - OTP Screen)
                if (currentPage == 1)
                  Positioned(
                    left: -12,
                    top: 103,
                    child: Image.asset(
                      'assets/images/st.png',
                      width: 95,
                      height: 104,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 95,
                          height: 104,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.medical_services,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section 4: Welcome Screen (Page 3 - ABHA Found)
  Widget _buildWelcomeSection() {
    final mediaQuery = MediaQuery.of(context);
    return Positioned(
      left: 24,
      top:
          mediaQuery.padding.top + 20, // Better spacing from top with safe area
      right: 24,
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main heading - different text based on flow
            Text(
              isCreatingNewAbha
                  ? 'Congratulations, your ABHA ID is created!'
                  : 'Glad you\'re here, ${profileDetails?['name'] ?? 'N/A'}.',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 20 / 22, // line-height / font-size
                letterSpacing: 0,
                color: Color(0xFF3864FD),
              ),
            ),

            const SizedBox(height: 14),

            // Subtext
            Text(
              'Bandhu Care — your trusted partner in wellness.',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 16 / 14, // line-height / font-size
                letterSpacing: 0,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowScanningWorksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'How Scanning Works',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Color(0xFFE5EFFE),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(width: 14),
              _buildStepItem(ImageConstant.step1, 'Step 1'),
              const SizedBox(width: 10),
              Icon(Icons.arrow_forward, size: 24, color: Color(0xFF334155)),
              const SizedBox(width: 10),
              _buildStepItem(ImageConstant.step2, 'Step 2'),
              const SizedBox(width: 10),
              Icon(Icons.arrow_forward, size: 24, color: Color(0xFF334155)),
              const SizedBox(width: 10),
              _buildStepItem(ImageConstant.step3, 'Step 3'),
              const SizedBox(width: 14),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem(String imagePath, String stepText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Image.asset(imagePath, width: 80, height: 80),
        const SizedBox(height: 10),
        Text(
          stepText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFaqSection() {
    final faqQuestions = [
      'How to Use Chatbot Feature in Bandhucare ?',
      'How to Scan and join Communities ?',
      'How to Use Chatbot Feature in Bandhucare ?',
      'How to Scan and join Communities ?',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'FAQ\'s',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF334155),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...faqQuestions.map(
          (question) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: TextStyle(
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
        ),
      ],
    );
  }

  Widget _buildNeedFurtherAssistanceSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Need Further Assistance ?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We are here to help you!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 48,
              decoration: BoxDecoration(
                color: Color(0xFFFF9D00),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Handle contact us action
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Center(
                    child: Text(
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ABHA Card Widget with Flip Animation (Page 3)
  Widget _buildAbhaCard(LoginController controller) {
    // Ensure animations start when widget is built for page 3
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.currentPage.value == 3 &&
          !controller.isCreatingNewAbha.value &&
          !controller.slideController.isAnimating &&
          !controller.flipController.isAnimating &&
          controller.slideAnimation.value == 0.0) {
        controller.startCardAnimations();
      }
    });

    return Positioned(
      left: 14,
      top: 160, // Reduced gap from welcome section
      right: 0,
      bottom: 0, // Content goes to bottom, will be covered by bottom sheet
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).padding.bottom +
              80, // Minimal space for bottom sheet
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: controller.toggleCardFlip,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  controller.slideAnimation,
                  controller.flipAnimation,
                ]),
                builder: (context, child) {
                  final slideProgress = controller.slideAnimation.value;
                  final flipProgress = controller.flipAnimation.value;
                  final angle = flipProgress * 3.14159; // 0 to π
                  final isFrontVisible =
                      angle > 1.5708; // π/2 - when past halfway, show front

                  // Slide animation: from left (-200) to center (0)
                  final slideOffsetX = -200 * (1 - slideProgress);

                  // Enhanced flip animation with scale and position
                  final scale =
                      1.0 -
                      (0.1 *
                          (flipProgress < 0.5
                              ? flipProgress * 2
                              : (1 - flipProgress) * 2));
                  final flipOffsetX =
                      (flipProgress < 0.5
                          ? flipProgress * 2
                          : (1 - flipProgress) * 2) *
                      20;

                  // Combine slide and flip offsets
                  final totalOffsetX = slideOffsetX + flipOffsetX;

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(
                      //       0.1 + (flipProgress * 0.1),
                      //     ),
                      //     blurRadius: 16 + (flipProgress * 8),
                      //     offset: Offset(0, 4 + (flipProgress * 2)),
                      //     spreadRadius: 0,
                      //   ),
                      // ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..translate(totalOffsetX, 0.0)
                          ..scale(scale)
                          ..rotateY(angle),
                        child: Container(
                          width: 360,
                          height: 198,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.transparent,
                          ),
                          child: isFrontVisible
                              ? Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..rotateY(3.14159),
                                  child: _buildCardFront(controller),
                                )
                              : _buildCardBack(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 28),
            // Sections below card with fade-in animation (only after flip completes)
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
                        SizedBox(height: 32),
                        _buildFaqSection(),
                        SizedBox(height: 32),
                        _buildNeedFurtherAssistanceSection(),
                        SizedBox(height: 32), // Extra spacing at bottom
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewAbhaCard(LoginController controller) {
    return Positioned(
      left: 24,
      top: 218,
      child: GestureDetector(
        onTap: _toggleCardFlip,
        child: AnimatedBuilder(
          animation: _flipAnimation,
          builder: (context, child) {
            // Calculate rotation angle
            final angle = _flipAnimation.value * 3.14159; // pi radians
            final isBackVisible = angle > 1.5708; // pi/2

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateY(angle),
              child: Container(
                width: 360,
                height: 198,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: isBackVisible
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(3.14159),
                        child: buildNewCardFront(controller),
                      )
                    : _buildCardBack(),
              ),
            );
          },
        ),
      ),
    );
  }

  // Card Back (shown initially)
  Widget _buildCardBack() {
    return Container(
      width: 360,
      height: 210,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
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
                  // Blue background with design pattern
                  Image.asset(
                    ImageConstant.cardUpDesign,
                    width: 360,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Color(0xFF4A90E2));
                    },
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Center Large Ayushman Bharat Logo
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
      ),
    );
  }

  // Card Front (shown after flip)
  Widget _buildCardFront(LoginController controller) {
    // Access profileDetails from controller (make it reactive)
    return Obx(() {
      // Get profile details from controller - dynamic data
      final profileData = controller.profileDetails.value;
      return Container(
        width: 360,
        height: 198,
        margin: EdgeInsets.only(left: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,

          border: Border.all(color: Colors.black.withOpacity(0.1)),
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
                          ),
                          child: profileData?['profilePhoto'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    profileData!['profilePhoto'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.grey[600],
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                        ),
                        const SizedBox(width: 12),
                        // User Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCardText(
                                'Name: ',
                                profileData?['name'] ?? 'N/A',
                                12,
                              ),
                              const SizedBox(height: 6),
                              _buildCardText(
                                'Abha No: ',
                                profileData?['abhaNumber']
                                        ?.toString()
                                        .replaceAll('-', ' ') ??
                                    'N/A',
                                11,
                              ),
                              const SizedBox(height: 6),
                              _buildCardText(
                                'Abha Address: ',
                                profileData?['abhaAddress'] ?? 'N/A',
                                11,
                              ),
                            ],
                          ),
                        ),
                        // QR Code
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Image.asset(
                            ImageConstant.qrCode,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    // Bottom row details
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCardText(
                          'Gender: ',
                          profileData?['gender'] == 'M'
                              ? 'Male'
                              : profileData?['gender'] == 'F'
                              ? 'Female'
                              : profileData?['gender'] ?? 'N/A',
                          11,
                        ),
                        const SizedBox(width: 13),
                        _buildCardText(
                          'DOB: ',
                          profileData != null
                              ? '${(profileData['dayOfBirth']?.toString() ?? '').padLeft(2, '0')}${(profileData['monthOfBirth']?.toString() ?? '').padLeft(2, '0')}${profileData['yearOfBirth'] ?? ''}'
                              : 'N/A',
                          11,
                        ),
                        const SizedBox(width: 13),
                        _buildCardText(
                          'Mobile: ',
                          profileData?['mobileNumber']?.toString() ?? 'N/A',
                          11,
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

  // Helper method to build card text with label and value
  Widget _buildCardText(String label, String value, double fontSize) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: fontSize,
              fontWeight: fontSize == 12 ? FontWeight.w700 : FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNewCardFront(LoginController controller) {
    return Stack(
      children: [
        // Background image - blank ABHA card
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            'assets/images/blank_abha.png',
            width: 360,
            height: 198,
            fit: BoxFit.fill,
          ),
        ),

        // ABHA Card Content Overlay
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 75, bottom: 16),
            child: Column(
              children: [
                // User info row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: 62,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        profileDetails?['profilePhoto'] ??
                            Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Name, ABHA No, ABHA Address
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Name: ',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextSpan(
                                  text: profileDetails?['name'] ?? 'N/A',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          // ABHA No
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Abha No: ',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      profileDetails?['abhaNumber']
                                          ?.toString()
                                          .replaceAll('-', ' ') ??
                                      'N/A',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          // ABHA Address
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Abha Address: ',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextSpan(
                                  text: profileDetails?['abhaAddress'] ?? 'N/A',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // QR Code
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.qr_code, size: 35, color: Colors.black),
                    ),
                  ],
                ),

                Spacer(),

                // Bottom row - Gender, DOB, Mobile
                Row(
                  children: [
                    // Gender
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Gender: ',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextSpan(
                            text: profileDetails?['gender'] == 'M'
                                ? 'Male'
                                : profileDetails?['gender'] == 'F'
                                ? 'Female'
                                : profileDetails?['gender'] ?? 'N/A',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 13),
                    // DOB
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'DOB: ',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextSpan(
                            text: profileDetails != null
                                ? '${profileDetails!['dayOfBirth']?.toString().padLeft(2, '0')}${profileDetails!['monthOfBirth']?.toString().padLeft(2, '0')}${profileDetails!['yearOfBirth']}'
                                : 'N/A',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 13),
                    // Mobile
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Mobile: ',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextSpan(
                            text:
                                profileDetails?['mobileNumber']?.toString() ??
                                'N/A',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Section 3: ABHA Address Selection (Page 2)
  Widget _buildAbhaAddressSection() {
    return Positioned(
      left: 24,
      top: 128,
      child: Container(
        width: 357,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main heading
            Text(
              'Yayy!!',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 20 / 22, // line-height / font-size
                letterSpacing: 0,
                color: Color(0xFF3864FD),
              ),
            ),

            const SizedBox(height: 14),

            // Subtext with dynamic count
            Text(
              'We found ${abhaAccounts.length} ABHA Address${abhaAccounts.length > 1 ? 'es' : ''}. Please choose one.',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 16 / 14, // line-height / font-size
                letterSpacing: 0,
                color: Color(0xFF94A3B8),
              ),
            ),

            const SizedBox(height: 180),

            // Dynamic ABHA Address Cards
            ...List.generate(
              abhaAccounts.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index < abhaAccounts.length - 1 ? 16 : 0,
                ),
                child: _buildAbhaAddressCard(
                  abhaAddress: abhaAccounts[index]['abhaAddress'],
                  name: abhaAccounts[index]['name'],
                  abhaNumber: abhaAccounts[index]['abhaNumber'],
                  index: index,
                  isSelected: selectedAbhaIndex == index,
                  onTap: () {
                    setState(() {
                      selectedAbhaIndex = index;
                    });
                    print('========================================');
                    print('✅ Selected ABHA Account:');
                    print('Address: ${abhaAccounts[index]['abhaAddress']}');
                    print('Name: ${abhaAccounts[index]['name']}');
                    print('Number: ${abhaAccounts[index]['abhaNumber']}');
                    print('========================================');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ABHA Address Card Widget (done)
  Widget _buildAbhaAddressCard({
    required String abhaAddress,
    required String name,
    required String abhaNumber,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 360,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Color(0xFF3864FD) : Color(0xFFE2E8F0),
              width: isSelected ? 2 : 1,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ABHA Address
                    Text(
                      abhaAddress,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3864FD),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Name
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              // Radio button (selected/unselected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Color(0xFF3864FD) : Color(0xFFE2E8F0),
                    width: 2,
                  ),
                  color: isSelected ? Color(0xFF3864FD) : Colors.transparent,
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section: Create New ABHA (Page 2 - when user clicks Create)
  Widget _buildCreateAbhaSection(LoginController controller) {
    return Positioned(
      left: 24,
      top: 128,
      child: Container(
        width: 360,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main heading
            Text(
              'Create ABHA Card',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 20 / 22,
                letterSpacing: 0,
                color: Color(0xFF3864FD),
              ),
            ),

            const SizedBox(height: 14),

            // Subtext
            Text(
              'Please fill in the details below.',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 16 / 14,
                letterSpacing: 0,
                color: Color(0xFF94A3B8),
              ),
            ),

            const SizedBox(height: 30),

            // Blank ABHA Card
            _buildBlankAbhaCard(),

            const SizedBox(height: 24),

            // Show different content based on createSubPage
            if (createSubPage == 0) ...[
              // Page 1: Aadhaar Number Input
              _buildAadhaarNumberInput(),
            ] else if (createSubPage == 1) ...[
              // Page 2: OTP and Phone Number Input
              _buildAadhaarNumberInputContent(controller),

              const SizedBox(height: 16),

              // Phone Number Input (for Create flow)
              _buildPhoneNumberInputContent(controller),

              const SizedBox(height: 24),

              // Verify Button (only on sub-page 1)
              DynamicButton(
                text: 'Verify',
                onPressed: isLoadingVerifyOtp
                    ? null
                    : () async {
                        // Get OTP from PinCodeTextField (stored in enteredAadhaarOtp)
                        String otp = controller.enteredAadhaarOtp.value.trim();

                        // Get mobile number
                        String mobileNumber = controller.phoneController.text
                            .trim();

                        // Validate OTP
                        if (otp.isEmpty || otp.length != 6) {
                          Fluttertoast.showToast(
                            msg: "Please enter complete 6-digit OTP",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.orange,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        // Validate mobile number
                        if (mobileNumber.isEmpty || mobileNumber.length != 10) {
                          Fluttertoast.showToast(
                            msg: "Please enter a valid 10-digit mobile number",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.orange,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        // Call verify OTP for Aadhaar
                        final result = await _verifyOTPforAadhaarNumber(
                          controller,
                          otp,
                        );

                        // Check if result is not null and has data
                        if (result != null && result['data'] != null) {
                          bool updateMobile =
                              result['data']['updateMobile'] ?? false;

                          print('🔍 Checking updateMobile: $updateMobile');

                          if (updateMobile == true) {
                            // If updateMobile is true, show OTP verification screen
                            print(
                              '📱 updateMobile is TRUE - Showing OTP verification screen',
                            );
                            _showOTPVerificationScreen();
                          } else {
                            // If updateMobile is false, go directly to email address screen
                            print(
                              '📧 updateMobile is FALSE - Going directly to email address screen',
                            );
                            _emailAddressVerification();
                          }
                        }
                      },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Blank ABHA Card Widget (for creating new ABHA)
  Widget _buildBlankAbhaCard() {
    return Container(
      width: 360,
      height: 198,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
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
          // Background image - blank ABHA card
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/images/blank_abha.png',
              width: 360,
              height: 198,
              fit: BoxFit.fill,
            ),
          ),

          // ABHA Card Content Overlay (all empty/placeholder)
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 75,
                bottom: 16,
              ),
              child: Column(
                children: [
                  // User info row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar placeholder
                      Container(
                        width: 62,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Name, ABHA No, ABHA Address (empty placeholders)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name - empty
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Name: ',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  TextSpan(
                                    text: '___________',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            // ABHA No - empty
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Abha No: ',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  TextSpan(
                                    text: '__  ____  ____  ____',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            // ABHA Address - empty
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Abha Address: ',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  TextSpan(
                                    text: '________@abdm',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // QR Code placeholder
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.qr_code,
                          size: 35,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),

                  Spacer(),

                  // Bottom row - Gender, DOB, Mobile (empty placeholders)
                  Row(
                    children: [
                      // Gender - empty
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Gender: ',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                            TextSpan(
                              text: '____',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 13),
                      // DOB - empty
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'DOB: ',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                            TextSpan(
                              text: '________',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 13),
                      // Mobile - empty
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Mobile: ',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                            TextSpan(
                              text: '__________',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
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

  // ABHA Number Input Fields (3 fields with 4 digits, separated by -)
  Widget _buildAadhaarNumberInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // First 4-digit field
        _buildAadhaarDigitField(0),

        // Separator -
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '-',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ),

        // Second 4-digit field
        _buildAadhaarDigitField(1),

        // Separator -
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '-',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ),

        // Third 4-digit field
        _buildAadhaarDigitField(2),
      ],
    );
  }

  // Individual 4-digit input field
  Widget _buildAadhaarDigitField(int index) {
    return Container(
      width: 80,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0x299BBEF8), // 16% opacity (0x29 = 41 in decimal ≈ 16%)
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
      ),
      child: TextField(
        controller: aadhaarNumberControllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 4,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          letterSpacing: 4,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
          hintText: '----',
          hintStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black45,
            letterSpacing: 4,
          ),
        ),
        onChanged: (value) {
          if (value.length == 4 && index < 2) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  // Section 2: OTP Screen Widget
  Widget _buildOTPSection() {
    return Positioned(
      left: 24,
      top: 291,
      child: Container(
        width: 266,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Welcome back" text
            Text(
              'Welcome back',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 20 / 22, // line-height / font-size
                letterSpacing: 0,
                color: Color(0xFF3864FD),
              ),
            ),

            const SizedBox(height: 14),

            // "Don't have Abha Address? Create" text
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  isCreatingNewAbha = true;
                  createSubPage = 0; // Reset to first sub-page
                  currentPage = 2; // Navigate to page 2 with blank ABHA card
                });
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't have Abha Address? ",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 16 / 14, // line-height / font-size
                        letterSpacing: 0,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    TextSpan(
                      text: 'Create',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 16 / 14, // line-height / font-size
                        letterSpacing: 0,
                        color: Color(0xFF3864FD),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Phone Number Input Field (Page 1 - OTP Screen)
  Widget _buildPhoneNumberInput(LoginController controller) {
    return Positioned(
      left: 24,
      top: 370,
      child: _buildPhoneNumberInputContent(controller),
    );
  }

  Widget _buildEmailAddressInputContent() {
    return Container(
      width: 360,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0x299BBEF8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFE2E8F0), width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: emailAddressController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      counterText: '', // Hide character counter
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ABHA Address Input Widget (like the design provided) ()
  Widget _buildAbhaAddressInput() {
    return Container(
      width: 360,
      height: 50,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0x289BBDF7),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Stack(
        children: [
          // Input field for ABHA address
          Positioned(
            left: 0,
            top: 0,
            right: 110,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 21),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: abhaAddressController,
                  onChanged: (value) {
                    setState(() {
                      isAbhaAddressValid = _validateAbhaAddress(value);
                    });
                    print('ABHA Address: $value, Valid: $isAbhaAddressValid');
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter username',
                    hintStyle: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(
                    color: const Color(0xFF222222),
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                  ),
                ),
              ),
            ),
          ),

          // Checkmark icon (only show when valid)
          if (isAbhaAddressValid)
            Positioned(
              left: 240,
              top: 13,
              child: Image.asset(
                'assets/imagesbadge-check.png',
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  );
                },
              ),
            ),

          // @abdm badge
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 87,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF4D7EE7),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  '@abdm',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // (done)
  Widget _buildPhoneNumberInputContent(LoginController controller) {
    return Container(
      width: 360,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label text
          Text(
            'Enter the Number which contain Abha Address',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
          ),

          const SizedBox(height: 8),

          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0x299BBEF8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFE2E8F0), width: 1),
            ),
            child: Row(
              children: [
                // Country code
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '+91',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3864FD),
                    ),
                  ),
                ),

                // Divider
                Container(width: 1, height: 30, color: Color(0xFFE2E8F0)),

                // Phone number input
                Expanded(
                  child: TextField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    onChanged: (value) {
                      // Close keyboard automatically when 10 digits are entered
                      if (value.length == 10) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'xxxxxxxxxx',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      counterText: '', // Hide character counter
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Other Login Options (Page 1 - OTP Screen) (done) no Getx required
  Widget _buildOtherLoginOptions() {
    return Positioned(
      left: 24,
      top: 540,
      child: Container(
        width: 360,
        child: Column(
          children: [
            // Divider with text
            Row(
              children: [
                Expanded(
                  child: Divider(color: Color(0xFFCBD5E1), thickness: 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Other Login Options',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(color: Color(0xFFCBD5E1), thickness: 1),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Three buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ABHA Number Button
                _buildLoginOptionButton('ABHA Number'),

                // ABHA Address Button
                _buildLoginOptionButton('ABHA Address'),

                // Aadhar ID Button
                _buildLoginOptionButton('Aadhar ID'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Login Option Button Widget (done)// no Getx required
  Widget _buildLoginOptionButton(String title) {
    return Container(
      width: 110,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // OTP Input and Get OTP Button (Page 1 - OTP Screen)
  Widget _buildOTPInputSection(LoginController controller) {
    return Positioned(
      left: 24,
      top: 470,
      child: _buildOTPInputContent(controller),
    );
  }

  // OTP Input Content (reusable without Positioned) (done)
  Widget _buildOTPInputContent(LoginController controller) {
    return Stack(
      children: [
        Container(
          height: 50,
          width: 360,
          decoration: BoxDecoration(
            color: Color(0x299BBEF8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE2E8F0), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 16, top: 4),
                  child: _buildPinCodeField(controller),
                ),
              ),
              Container(
                width: 84,
                height: 34,
                margin: const EdgeInsets.only(right: 8),
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoadingSignIn.value
                        ? null
                        : () => controller.handleGetOTP(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3864FD),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.fromLTRB(13, 7, 13, 7),
                    ),
                    child: controller.isLoadingSignIn.value
                        ? SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Get OTP',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Loading overlay when verifying OTP
        Obx(
          () => controller.isLoadingVerifyOtp.value
              ? Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF3864FD),
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }

  // Build PinCodeTextField with safety checks (done)
  Widget _buildPinCodeField(LoginController controller) {
    return PinCodeTextField(
      key: ValueKey(
        'otp_field_${controller.currentPage.value}_${controller.otpFieldKey.value}',
      ),
      appContext: Get.context!,
      length: 6,
      keyboardType: TextInputType.number,
      animationType: AnimationType.scale,
      animationDuration: const Duration(milliseconds: 200),
      enableActiveFill: false,
      enabled: !controller.isLoadingVerifyOtp.value, // Disable when verifying
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.circle,
        borderWidth: 0,
        fieldHeight: 40,
        fieldWidth: 35,
        activeFillColor: Colors.transparent,
        selectedFillColor: Colors.transparent,
        inactiveFillColor: Colors.transparent,
        activeColor: Colors.transparent,
        selectedColor: Colors.transparent,
        inactiveColor: Colors.transparent,
      ),
      cursorColor: AppColors.primaryColor,
      backgroundColor: Colors.transparent,
      onChanged: (value) {
        _handleOTPChange(controller, value);
      },
      onCompleted: (value) {
        controller.enteredOtp.value = value;
        debugPrint('OTP Completed: $value');
        // Optionally auto-verify when OTP is complete
        // _handleVerifyOTP(controller);
      },
    );
  }

  Widget _buildAadhaarNumberInputContent(LoginController controller) {
    return Stack(
      children: [
        Container(
          height: 50,
          width: 360,
          decoration: BoxDecoration(
            color: Color(0x299BBEF8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE2E8F0), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
            child: _buildAadhaarPinCodeField(controller),
          ),
        ),

        // Loading overlay when verifying OTP
        Obx(
          () => controller.isLoadingVerifyOtp.value
              ? Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF3864FD),
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }

  // Build PinCodeTextField for Aadhaar number with safety checks (done)
  Widget _buildAadhaarPinCodeField(LoginController controller) {
    return PinCodeTextField(
      key: ValueKey(
        'aadhaar_field_${controller.currentPage.value}_${controller.aadhaarFieldKey.value}',
      ),
      appContext: Get.context!,
      length: 6,
      keyboardType: TextInputType.number,
      animationType: AnimationType.scale,
      animationDuration: const Duration(milliseconds: 200),
      enableActiveFill: false,
      enabled: !controller.isLoadingVerifyOtp.value, // Disable when verifying
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.circle,
        borderWidth: 0,
        fieldHeight: 40,
        fieldWidth: 35,
        activeFillColor: Colors.transparent,
        selectedFillColor: Colors.transparent,
        inactiveFillColor: Colors.transparent,
        activeColor: Colors.transparent,
        selectedColor: Colors.transparent,
        inactiveColor: Colors.transparent,
      ),
      cursorColor: AppColors.primaryColor,
      backgroundColor: Colors.transparent,
      onChanged: (value) {
        _handleAadhaarNumberOTPChange(controller, value);
      },
      onCompleted: (value) {
        controller.enteredAadhaarOtp.value = value;
        debugPrint('Aadhaar OTP Completed: $value');
        // Optionally auto-verify when Aadhaar OTP is complete
        // handleVerifyAadhaarOTP(controller);
      },
    );
  }

  // Section 1: Language Selection Widget
  Widget _buildLanguageSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Choose Language" text
          Text(
            'Choose Language',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 20 / 22, // line-height / font-size
              letterSpacing: 0,
              color: Color(0xFF3864FD),
            ),
          ),

          const SizedBox(height: 14),

          // "What language would you like the app to be in?" text
          Text(
            'What language would you like the app to be in?',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 16 / 14, // line-height / font-size
              letterSpacing: 0,
              color: Color(0xFF94A3B8),
            ),
          ),

          const SizedBox(height: 30), // Gap between text and dropdown
          // Language Dropdown Selector
          _buildLanguageDropdown(),
        ],
      ),
    );
  }

  // Custom Language Dropdown Widget
  Widget _buildLanguageDropdown() {
    List<String> languages = [
      'English',
      'Telugu',
      'Gujarati',
      'Tamil',
      'Hindi',
      'Malayalam',
    ];

    return Column(
      children: [
        // Dropdown Header (always visible)
        GestureDetector(
          onTap: () {
            setState(() {
              isDropdownExpanded = !isDropdownExpanded;
            });
          },
          child: Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: isDropdownExpanded
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    )
                  : BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedLanguage,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  isDropdownExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),

        // Expanded Options List
        if (isDropdownExpanded)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: languages.where((lang) => lang != selectedLanguage).map(
                (language) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLanguage = language;
                        isDropdownExpanded = false;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        language,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
      ],
    );
  }

  // Bottom Navigation with Dots, Previous and Next Buttons
  Widget _buildBottomNavigation(LoginController controller) {
    return Obx(() {
      final isPage3 = controller.currentPage.value == 3;
      final mediaQuery = MediaQuery.of(context);

      return AnimatedBuilder(
        animation: controller.flipAnimation,
        builder: (context, child) {
          final flipProgress = controller.flipAnimation.value;
          final isFlipComplete = flipProgress >= 1.0;

          // On page 3 with flip complete, show "Scan to Join Group" button
          if (isPage3 && isFlipComplete) {
            return Container(
              padding: EdgeInsets.only(
                bottom: mediaQuery.padding.bottom > 0
                    ? mediaQuery.padding.bottom
                    : 16,
                top: 8, // Reduced top padding to bring it closer to content
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
                  Get.toNamed(AppRoutes.scanQrScreen);
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
                  child: Material(
                    color: Colors.transparent,
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          // Normal navigation for other pages
          return Padding(
            padding: EdgeInsets.fromLTRB(
              23,
              0,
              23,
              mediaQuery.padding.bottom + 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Navigation Dots (Left)
                Row(
                  children: List.generate(4, (index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == currentPage
                            ? const Color(0xFF3864FD) // Active dot - blue
                            : const Color(
                                0xFFE2E8F0,
                              ), // Inactive dot - light gray
                      ),
                    );
                  }),
                ),

                // Previous and Next Buttons (Right)
                Row(
                  children: [
                    // Previous Button (only show if not on first page or first sub-page)
                    if (currentPage > 0 ||
                        (currentPage == 2 &&
                            isCreatingNewAbha &&
                            createSubPage > 0)) ...[
                      GestureDetector(
                        onTap: () {
                          // Handle create sub-pages
                          if (currentPage == 2 &&
                              isCreatingNewAbha &&
                              createSubPage > 0) {
                            setState(() {
                              createSubPage--;
                            });
                            controller.createSubPage.value--;
                          } else {
                            setState(() {
                              currentPage--;
                              // Reset create flag and sub-page when going back to page 1 (OTP screen)
                              if (currentPage == 1) {
                                isCreatingNewAbha = false;
                                createSubPage = 0;
                              }
                            });
                            controller.previousPage();
                          }
                        },
                        child: Container(
                          width: 47,
                          height: 47,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF3864FD),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12), // Gap between buttons
                    ],

                    // Next Button
                    if (currentPage < 3)
                      Obx(
                        () => GestureDetector(
                          onTap:
                              (isLoadingSelectAccount ||
                                  controller.isLoadingSignIn.value)
                              ? null
                              : () async {
                                  // Page 1: Check if OTP is verified and ABHA accounts are loaded
                                  if (currentPage == 1) {
                                    if (abhaAccounts.isEmpty) {
                                      Fluttertoast.showToast(
                                        msg: "Please verify OTP first",
                                        toastLength: Toast.LENGTH_SHORT,
                                        backgroundColor: Colors.orange,
                                        textColor: Colors.white,
                                      );
                                      return;
                                    }
                                    // Navigate to page 2 (ABHA selection)
                                    setState(() {
                                      currentPage = 2;
                                    });
                                    controller.currentPage.value = 2;
                                  }
                                  // Page 2: Different logic based on create vs select flow
                                  else if (currentPage == 2) {
                                    if (isCreatingNewAbha) {
                                      // Creating new ABHA - handle sub-pages
                                      if (createSubPage == 0) {
                                        // Call API to get OTP, then move to second sub-page
                                        await _handleGetAadhaarNumberOTP();
                                        // Note: createSubPage will be set to 1 inside _handleGetAadhaarNumberOTP on success
                                      } else if (createSubPage == 1) {
                                        // Move to page 3 (Welcome screen)
                                        setState(() {
                                          currentPage = 3;
                                        });
                                        controller.currentPage.value = 3;
                                      }
                                    } else {
                                      // Selecting existing ABHA - call SelectAccount API
                                      await _selectAccount();
                                    }
                                  } else if (currentPage < 3) {
                                    // Navigate to next page
                                    setState(() {
                                      currentPage++;
                                    });
                                    controller.nextPage();
                                  }
                                },
                          child: Container(
                            width: 47,
                            height: 47,
                            decoration: BoxDecoration(
                              color:
                                  (isLoadingSelectAccount ||
                                      controller.isLoadingSignIn.value)
                                  ? const Color(0xFF3864FD).withOpacity(0.6)
                                  : const Color(0xFF3864FD),
                              borderRadius: BorderRadius.circular(
                                23.5,
                              ), // Radius 23.5px
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF3864FD,
                                  ).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child:
                                (isLoadingSelectAccount ||
                                    controller.isLoadingSignIn.value)
                                ? const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
