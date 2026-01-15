import 'package:bandhucare_new/feature/hospital_information/section/google_map_section.dart';
import 'package:bandhucare_new/feature/hospital_information/section/hospital_section.dart';
import 'package:bandhucare_new/feature/user_profile/sections/profile_header.dart';
import 'package:bandhucare_new/feature/user_profile/widgets/seperator_line.dart';
import 'package:bandhucare_new/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';

class HospitalInformation extends StatelessWidget {
  const HospitalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: 'Hospital Information'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderSection(),
            SizedBox(height: 24),
            SeperatorLine(),
            SizedBox(height: 24),
            HospitalInformationSection(),
            SizedBox(height: 24),
            GoogleMapSection(),
          ],
        ),
      ),
    );
  }
}
