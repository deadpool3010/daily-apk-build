import 'package:bandhucare_new/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool showPersonalInfo = false;
  String selectedLanguage = 'English';

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                    Text(
                      'Select Language',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              // Picker
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: [
                      'Kannada',
                      'Malayalam',
                      'Gujarati',
                      'English',
                      'Hindi',
                      'Telugu',
                      'Tamil',
                    ].indexOf(selectedLanguage),
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedLanguage = [
                        'Kannada',
                        'Malayalam',
                        'Gujarati',
                        'English',
                        'Hindi',
                        'Telugu',
                        'Tamil',
                      ][index];
                    });
                  },
                  children: [
                    Center(
                      child: Text('Kannada', style: TextStyle(fontSize: 18)),
                    ),
                    Center(
                      child: Text('Malayalam', style: TextStyle(fontSize: 18)),
                    ),
                    Center(
                      child: Text('Gujarati', style: TextStyle(fontSize: 18)),
                    ),
                    Center(
                      child: Text(
                        'English',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Center(
                      child: Text('Hindi', style: TextStyle(fontSize: 18)),
                    ),
                    Center(
                      child: Text('Telugu', style: TextStyle(fontSize: 18)),
                    ),
                    Center(
                      child: Text('Tamil', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            buildProfile(),
            SizedBox(height: 24),
            buildSeparator(),
            SizedBox(height: 24),
            if (showPersonalInfo) ...[
              buildPersonalInfo(),
              SizedBox(height: 20),
              buildSeparator(),
              SizedBox(height: 24),
              buildHospitalInfo(),
              SizedBox(height: 20),
              buildSeparator(),
            ] else ...[
              buildAbhaSection(),
              SizedBox(height: 24),
              Container(
                width: 360,
                alignment: Alignment.centerLeft,
                child: Text(
                  "Account Settings",
                  style: TextStyle(
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 24),
              buildAccountSettings(),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildAccountSettings() {
    return Container(
      width: 360,
      child: Column(
        children: [
          _buildMenuItem(
            Icons.person_outline,
            'Personal Information',
            onTap: () {
              setState(() {
                showPersonalInfo = !showPersonalInfo;
              });
            },
          ),
          SizedBox(height: 20),
          _buildSeparatorLine(5),
          SizedBox(height: 20),
          _buildMenuItem(
            Icons.language,
            'Language Settings',
            onTap: _showLanguagePicker,
          ),
          SizedBox(height: 20),
          _buildSeparatorLine(5),
          SizedBox(height: 20),
          _buildMenuItem(Icons.notifications_outlined, 'Notification'),
          SizedBox(height: 20),
          _buildSeparatorLine(5),
          SizedBox(height: 20),
          _buildMenuItem(Icons.lock_outline, 'Privacy & Security'),
          SizedBox(height: 20),
          _buildSeparatorLine(5),
          SizedBox(height: 20),
          _buildMenuItem(Icons.qr_code_scanner, 'Scan'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_right, size: 24, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildSeparatorLine(double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(height: height, color: Color(0xFFECF2F7)),
    );
  }

  Widget buildPersonalInfo() {
    return Container(
      width: 360,
      child: Column(
        children: [
          _buildInfoRow('Phone Number', '+91 1234567891'),
          SizedBox(height: 16),
          _buildInfoRow('Email ID', 'siddharth@gmail.com'),
          SizedBox(height: 16),
          _buildInfoRow('Aadhar Number', '1890 2500 3456'),
          SizedBox(height: 16),
          _buildInfoRow('Address', '32 Ambika raw house, Memnagar,\nAhmedabad'),
        ],
      ),
    );
  }

  Widget buildHospitalInfo() {
    return Container(
      width: 360,
      child: Column(
        children: [
          _buildInfoRow('Hospital Name', 'CMC Vellore Hospital'),
          SizedBox(height: 16),
          _buildInfoRow('Section', 'ICU'),
          SizedBox(height: 16),
          _buildInfoRow('Department', 'Cancer Department'),
          SizedBox(height: 16),
          _buildInfoRow('Type', 'Throat Cancer'),
          SizedBox(height: 16),
          _buildInfoRow('Doctor', 'Ms. Madhuri Sharma'),
          SizedBox(height: 16),
          _buildInfoRow('Consultancy Type', 'New'),
          SizedBox(height: 16),
          _buildInfoRow('Group ID', '#91389103'),
          SizedBox(height: 16),
          _buildInfoRow('Patient ID', '1292'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(72, 0, 0, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildAvatar() {
  return Container(
    width: 50,
    height: 50,
    child: Image.asset('assets/Avatar.png', fit: BoxFit.cover),
  );
}

Widget buildSeparator() {
  return Container(height: 5, color: Color(0xFFECF2F7));
}

Widget buildProfile() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 28.0),
    child: Row(
      children: [
        buildAvatar(),
        SizedBox(width: 16), // 16 pixel gap between avatar and Name/Email
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Siddharth",
              style: TextStyle(
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              "siddharth@gmail.com",
              style: TextStyle(
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
        Spacer(), // Pushes edit icon to the end
        Icon(Icons.edit, size: 20, color: Colors.black),
      ],
    ),
  );
}

Widget buildAbhaSection() {
  return Container(
    width: 360,
    height: 125,
    decoration: BoxDecoration(
      color: Color.fromRGBO(237, 242, 247, 1.0),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add your content hereText
              Text(
                "ABHA ID",
                style: TextStyle(
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              Text(
                "Your Personal Identification",
                style: TextStyle(
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 13),
              DynamicButton(
                text: "Create Another",
                width: 129,
                height: 35,
                onPressed: () {},
                fontSize: 14,
              ),
            ],
          ),
          SizedBox(width: 16),
          buildCardFront(width: 140, height: 85),
        ],
      ),
    ),
  );
}

Widget buildCardFront({double width = 360, double height = 198}) {
  // Calculate scale factor based on original size (360x198)
  final scaleFactorW = width / 360;
  final scaleFactorH = height / 198;
  final scaleFactor = (scaleFactorW + scaleFactorH) / 2;

  return SizedBox(
    width: width,
    height: height,
    child: Stack(
      children: [
        // Background image - blank ABHA card
        ClipRRect(
          borderRadius: BorderRadius.circular(24 * scaleFactor),
          child: Image.asset(
            'assets/blank_abha.png',
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),
        ),

        // ABHA Card Content Overlay
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20 * scaleFactorW,
              right: 20 * scaleFactorW,
              top: 75 * scaleFactorH,
              bottom: 16 * scaleFactorH,
            ),
            child: Column(
              children: [
                // User info row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: 62 * scaleFactorW,
                      height: 64 * scaleFactorH,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12 * scaleFactor),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40 * scaleFactor,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(width: 12 * scaleFactorW),

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
                                    fontSize: 12 * scaleFactor,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextSpan(
                                  text: 'Siddharth',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 12 * scaleFactor,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 6 * scaleFactorH),
                          // ABHA No
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Abha No: ',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 11 * scaleFactor,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextSpan(
                                  text: '91 1234 5678 9101',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 11 * scaleFactor,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 6 * scaleFactorH),
                          // ABHA Address
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Abha Address: ',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 11 * scaleFactor,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextSpan(
                                  text: 'Sid2000@abdm',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 11 * scaleFactor,
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
                      width: 45 * scaleFactorW,
                      height: 45 * scaleFactorH,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8 * scaleFactor),
                      ),
                      child: Icon(
                        Icons.qr_code,
                        size: 35 * scaleFactor,
                        color: Colors.black,
                      ),
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
                              fontSize: 11 * scaleFactor,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextSpan(
                            text: 'Male',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 11 * scaleFactor,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 13 * scaleFactorW),
                    // DOB
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'DOB: ',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 11 * scaleFactor,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextSpan(
                            text: '03032004',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 11 * scaleFactor,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 13 * scaleFactorW),
                    // Mobile
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Mobile: ',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 11 * scaleFactor,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextSpan(
                            text: '1234567891',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 11 * scaleFactor,
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
    ),
  );
}
