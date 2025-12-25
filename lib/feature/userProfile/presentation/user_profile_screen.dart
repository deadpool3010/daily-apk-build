import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bandhucare_new/feature/userProfile/sections/abha_section.dart';
import 'package:bandhucare_new/feature/userProfile/sections/account_settings.dart';
import 'package:bandhucare_new/feature/userProfile/sections/profile_header.dart';
import 'package:bandhucare_new/feature/userProfile/widgets/seperator_line.dart';
import 'package:bandhucare_new/feature/userProfile/widgets/userProfileAppbar.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserProfileAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            ProfileHeaderSection(),
            SizedBox(height: 24),
            SeperatorLine(),
            SizedBox(height: 24),
            AbhaSection(),
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
            AccountSettingsSection(),
          ],
        ),
      ),
    );
  }
}
