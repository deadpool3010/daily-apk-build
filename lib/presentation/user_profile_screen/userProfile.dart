import 'package:bandhucare_new/core/app_exports.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool showPersonalInfo = false;
  String selectedLanguage = 'English';

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
      width: MediaQuery.of(context).size.width,
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
          _buildSeparatorLine(3),
          SizedBox(height: 20),
          _buildMenuItem(
            Icons.language,
            'Language Settings',
            onTap: () async {
              final result = await Get.toNamed(AppRoutes.simpleLanguageScreen);
              if (result != null && result is String) {
                setState(() {
                  selectedLanguage = result;
                });
              }
            },
          ),
          SizedBox(height: 20),
          _buildSeparatorLine(3),
          SizedBox(height: 20),
          _buildMenuItem(Icons.notifications_outlined, 'Notification'),
          SizedBox(height: 20),
          _buildSeparatorLine(3),
          // _buildMenuItem(
          //   Icons.lock_outline,
          //   'Privacy & Security',
          //   onTap: () => Get.toNamed(AppRoutes.privacyScreen),
          // ),
          //      SizedBox(height: 20),
          // _buildSeparatorLine(5),
          SizedBox(height: 20),
          _buildMenuItem(Icons.qr_code_scanner, 'Scan'),
          SizedBox(height: 20),
          _buildSeparatorLine(3),
          SizedBox(height: 20),
          _buildMenuItem(
            Icons.logout,
            'Logout',
            onTap: () => logoutBottomSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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
    child: Image.asset('assets/images/Avatar.png', fit: BoxFit.cover),
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
