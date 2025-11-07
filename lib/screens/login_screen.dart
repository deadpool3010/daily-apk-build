import 'package:bandhucare_new/screens/button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  String selectedLanguage = 'English';
  int currentPage = 0; // Track which section is visible (0-3)
  bool isDropdownExpanded = false; // Track dropdown state
  bool isCreatingNewAbha =
      false; // Track if user clicked "Create" to follow different path
  TextEditingController phoneController = TextEditingController();
  List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  // ABHA Number input controllers (3 fields with 4 digits each)
  List<TextEditingController> abhaNumberControllers = List.generate(
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
    super.dispose();
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

  // Show OTP Verification Screen (overlay)
  void _showOTPVerificationScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // BandhuCare Logo
                Positioned(
                  left: 24,
                  top: 165,
                  child: Image.asset(
                    'assets/bandhucare_otp_screen.png',
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
                        child: Center(
                          child: Text(
                            'BandhuCare',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                        return Container(
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
                                FocusScope.of(context).nextFocus();
                              }
                            },
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
                      // Verify OTP and close screen
                      String otp = verificationOtpControllers
                          .map((c) => c.text)
                          .join('');
                      print('OTP Entered: $otp');
                      Navigator.of(
                        context,
                      ).pop(true); // Close OTP screen with success
                    },
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 24,
                  child: IconButton(
                    icon: Icon(Icons.close, size: 30, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // After OTP screen closes, navigate to Page 3 to show ABHA card
    setState(() {
      currentPage = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
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
                        'assets/choose_language.png',
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

                if (currentPage == 3) const Spacer(),

                // Navigation Dots and Next Button
                _buildBottomNavigation(),

                const SizedBox(height: 30),
              ],
            ),

            // OTP Screen - Welcome Section (Page 1)
            if (currentPage == 1) _buildOTPSection(),

            // Phone Number Input (Page 1)
            if (currentPage == 1) _buildPhoneNumberInput(),

            // OTP Input and Get OTP Button (Page 1)
            if (currentPage == 1) _buildOTPInputSection(),

            // Other Login Options (Page 1)
            if (currentPage == 1) _buildOtherLoginOptions(),

            // Page 2: ABHA Address Selection Section (if ABHA found)
            if (currentPage == 2 && !isCreatingNewAbha)
              _buildAbhaAddressSection(),

            // Page 2: Create New ABHA Section (if user clicked Create)
            if (currentPage == 2 && isCreatingNewAbha)
              _buildCreateAbhaSection(),

            // Page 3: Welcome Screen (for both ABHA found and create flows)
            if (currentPage == 3) _buildWelcomeSection(),

            // ABHA Card - Page 3 (for both ABHA found and create flows)
            if (currentPage == 3) _buildAbhaCard(),

            // Ayushman Bharat Image - Fixed Position (Page 2 - ABHA Address Screen, only if not creating)
            if (currentPage == 2 && !isCreatingNewAbha)
              Positioned(
                left: 152,
                top: 219,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(147.48),
                  child: Image.asset(
                    'assets/ayush_man_bharat.png',
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
                  'assets/st.png',
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
    );
  }

  // Section 4: Welcome Screen (Page 3 - ABHA Found)
  Widget _buildWelcomeSection() {
    return Positioned(
      left: 24,
      top: 128,
      child: Container(
        width: 279,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main heading - different text based on flow
            Text(
              isCreatingNewAbha
                  ? 'Congratulations, your ABHA ID is created!'
                  : 'Glad you\'re here, Siddharth.',
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

  // ABHA Card Widget with Flip Animation (Page 3)
  Widget _buildAbhaCard() {
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
                        child: buildCardFront(),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        'assets/back_abha.png',
        width: 360,
        height: 198,
        fit: BoxFit.fill,
      ),
    );
  }

  // Card Front (shown after flip)
  Widget buildCardFront() {
    return Stack(
      children: [
        // Background image - blank ABHA card
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            'assets/blank_abha.png',
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
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey[600],
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
                                  text: 'Siddharth',
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
                                  text: '91 1234 5678 9101',
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
                                  text: 'Sid2000@abdm',
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
                            text: 'Male',
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
                            text: '03032004',
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
                            text: '1234567891',
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
            // Main heading - "We found 2 ABHA Addresses"
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

            // Subtext - "Please choose one."
            Text(
              'We found 2 ABHA Addresses. Please choose one.',
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

            // ABHA Address Card 1
            _buildAbhaAddressCard(
              abhaAddress: '572628292792928@abdm',
              name: 'Sara Arjun',
            ),

            const SizedBox(height: 16),

            // ABHA Address Card 2
            _buildAbhaAddressCard(
              abhaAddress: '849271638492716@abdm',
              name: 'Sara Arjun',
            ),
          ],
        ),
      ),
    );
  }

  // ABHA Address Card Widget
  Widget _buildAbhaAddressCard({
    required String abhaAddress,
    required String name,
  }) {
    return Center(
      child: Container(
        width: 360,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFE2E8F0), width: 1),
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
            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFE2E8F0), width: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section: Create New ABHA (Page 2 - when user clicks Create)
  Widget _buildCreateAbhaSection() {
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

            // ABHA Number Input Fields (3 fields with 4 digits each)
            _buildAbhaNumberInput(),

            const SizedBox(height: 24),

            // Phone Number Input (for Create flow)
            _buildPhoneNumberInputContent(),

            const SizedBox(height: 16),

            // OTP Input (for Create flow)
            _buildOTPInputContent(),

            const SizedBox(height: 24),

            // Verify Button
            DynamicButton(
              text: 'Verify',
              onPressed: () {
                // Show OTP verification screen
                _showOTPVerificationScreen();
              },
            ),
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
              'assets/blank_abha.png',
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
  Widget _buildAbhaNumberInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // First 4-digit field
        _buildAbhaDigitField(0),

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
        _buildAbhaDigitField(1),

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
        _buildAbhaDigitField(2),
      ],
    );
  }

  // Individual 4-digit input field
  Widget _buildAbhaDigitField(int index) {
    return Container(
      width: 80,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0x299BBEF8), // 16% opacity (0x29 = 41 in decimal ≈ 16%)
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
      ),
      child: TextField(
        controller: abhaNumberControllers[index],
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

  // Page 3: Create ABHA Form Page (when user is creating new ABHA)
  Widget _buildCreateAbhaFormPage() {
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
              'Fill ABHA Details',
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
              'Please provide your information to create ABHA.',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 16 / 14,
                letterSpacing: 0,
                color: Color(0xFF94A3B8),
              ),
            ),

            const SizedBox(height: 40),

            // Form fields will go here
            // For now, just a placeholder message
            Center(
              child: Container(
                padding: EdgeInsets.all(40),
                child: Text(
                  'Page 3: Create ABHA Form\n\n(Form fields will be added here)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          ],
        ),
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
              onTap: () {
                setState(() {
                  isCreatingNewAbha = true;
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
  Widget _buildPhoneNumberInput() {
    return Positioned(
      left: 24,
      top: 370,
      child: _buildPhoneNumberInputContent(),
    );
  }

  // Phone Number Input Content (reusable without Positioned)
  Widget _buildPhoneNumberInputContent() {
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

          // Phone input field
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
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
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

  // Other Login Options (Page 1 - OTP Screen)
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

  // Login Option Button Widget
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
  Widget _buildOTPInputSection() {
    return Positioned(left: 24, top: 470, child: _buildOTPInputContent());
  }

  // OTP Input Content (reusable without Positioned)
  Widget _buildOTPInputContent() {
    return Container(
      height: 50,
      width: 360,
      decoration: BoxDecoration(
        color: Color(0x299BBEF8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
      ),
      child: Row(
        children: [
          // OTP Input Boxes Section (no dividers)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Container(
                    width: 28,
                    child: TextField(
                      controller: otpControllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: 18,
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
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
          ),

          // Get OTP Button (width: 84, height: 34)
          Container(
            width: 84,
            height: 34,
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3864FD),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                padding: EdgeInsets.fromLTRB(13, 7, 13, 7),
              ),
              child: Text(
                'Get OTP',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
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
  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
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
                      : const Color(0xFFE2E8F0), // Inactive dot - light gray
                ),
              );
            }),
          ),

          // Previous and Next Buttons (Right)
          Row(
            children: [
              // Previous Button (only show if not on first page)
              if (currentPage > 0) ...[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentPage--;
                      // Reset create flag when going back to page 1 (OTP screen)
                      if (currentPage == 1) {
                        isCreatingNewAbha = false;
                      }
                    });
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
              GestureDetector(
                onTap: () {
                  // Navigate to next page or section
                  if (currentPage < 3) {
                    setState(() {
                      currentPage++;
                    });
                  } else {
                    // Final page - navigate to homepage
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3864FD),
                    borderRadius: BorderRadius.circular(23.5), // Radius 23.5px
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3864FD).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
