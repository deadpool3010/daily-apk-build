// lib/feature/profile/presentation/sections/widgets/abha_card_container.dart
import 'package:bandhucare_new/feature/user_profile/widgets/abha_card_front.dart';
import 'package:bandhucare_new/model/patientModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bandhucare_new/widget/custom_button.dart';

class AbhaCardContainer extends StatelessWidget {
  final PatientModel user; // Your UserModel type

  const AbhaCardContainer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 125,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(237, 242, 247, 1.0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildLeftSection(context)),
            Align(
              alignment: Alignment.topRight,
              child: AbhaCardFront(user: user, width: 150, height: 90),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "ABHA ID",
          style: TextStyle(
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Your Personal Identification",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 12,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        DynamicButton(
          text: "Create Another",
          width: 129,
          height: 35,
          onPressed: () {
            // TODO: Navigate to create ABHA screen
          },
          fontSize: 14,
        ),
      ],
    );
  }
}
