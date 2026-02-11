import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/core/ui/widgets/profile/personal_info_section.dart';
import 'package:bandhucare_new/core/utils/context_extensions.dart';
import 'package:bandhucare_new/feature/personal_information/section/persona_information_section.dart';
import 'package:bandhucare_new/feature/user_profile/sections/profile_header.dart';
import 'package:bandhucare_new/feature/user_profile/widgets/seperator_line.dart';

class PersonalInformation extends StatelessWidget {
  const PersonalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: 'Personal Information'),
      body: SafeArea(
        bottom: context.hasThreeButtonNavigation,
        child: Column(
          children: [
            ProfileHeaderSection(),
            SizedBox(height: 24),
            SeperatorLine(),
            SizedBox(height: 24),
            PersonalInfoSection(),
            SizedBox(height: 24),
            SeperatorLine(),
          ],
        ),
      ),
    );
  }
}
