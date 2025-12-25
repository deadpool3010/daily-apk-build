// lib/feature/profile/presentation/sections/widgets/abha_card_front.dart

import 'package:bandhucare_new/model/patientModel.dart';
import 'package:flutter/material.dart';

class AbhaCardFront extends StatelessWidget {
  final PatientModel user; // Your UserModel type
  final double width;
  final double height;

  const AbhaCardFront({
    super.key,
    required this.user,
    this.width = 360,
    this.height = 198,
  });

  @override
  Widget build(BuildContext context) {
    final scaleFactorW = width / 360;
    final scaleFactorH = height / 198;
    final scaleFactor = (scaleFactorW + scaleFactorH) / 2;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          _buildCardBackground(scaleFactor),
          Positioned.fill(
            child: _buildCardContent(scaleFactorW, scaleFactorH, scaleFactor),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBackground(double scaleFactor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24 * scaleFactor),
      child: Image.asset(
        'assets/images/blank_abha.png',
        width: width,
        height: height,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildCardContent(
    double scaleFactorW,
    double scaleFactorH,
    double scaleFactor,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20 * scaleFactorW,
        right: 20 * scaleFactorW,
        top: 75 * scaleFactorH,
        bottom: 16 * scaleFactorH,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTopSection(scaleFactorW, scaleFactorH, scaleFactor),
          const Spacer(),
          _buildBottomSection(scaleFactorW, scaleFactor),
        ],
      ),
    );
  }

  Widget _buildTopSection(
    double scaleFactorW,
    double scaleFactorH,
    double scaleFactor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileImage(scaleFactorW, scaleFactorH, scaleFactor),
        SizedBox(width: 12 * scaleFactorW),
        Expanded(child: _buildUserInfo(scaleFactor, scaleFactorH)),
        _buildQRCode(scaleFactorW, scaleFactorH, scaleFactor),
      ],
    );
  }

  Widget _buildProfileImage(
    double scaleFactorW,
    double scaleFactorH,
    double scaleFactor,
  ) {
    return Container(
      width: 62 * scaleFactorW,
      height: 64 * scaleFactorH,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12 * scaleFactor),
      ),
      child: user.profilePhoto != null && user.profilePhoto!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12 * scaleFactor),
              child: Image.network(
                user.profilePhoto!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.person,
                  size: 40 * scaleFactor,
                  color: Colors.grey[600],
                ),
              ),
            )
          : Icon(Icons.person, size: 40 * scaleFactor, color: Colors.grey[600]),
    );
  }

  Widget _buildUserInfo(double scaleFactor, double scaleFactorH) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInfoRow(
          label: 'Name: ',
          value: user.name ?? 'N/A',
          scaleFactor: scaleFactor,
          fontSize: 12,
        ),
        SizedBox(height: 6 * scaleFactorH),
        _buildInfoRow(
          label: 'Abha No: ',
          value: user.abhaNumber ?? 'N/A',
          scaleFactor: scaleFactor,
          fontSize: 11,
        ),
        SizedBox(height: 6 * scaleFactorH),
        _buildInfoRow(
          label: 'Abha Address: ',
          value: user.abhaAddress ?? 'N/A',
          scaleFactor: scaleFactor,
          fontSize: 11,
        ),
      ],
    );
  }

  Widget _buildQRCode(
    double scaleFactorW,
    double scaleFactorH,
    double scaleFactor,
  ) {
    return Container(
      width: 45 * scaleFactorW,
      height: 45 * scaleFactorH,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8 * scaleFactor),
      ),
      child: Icon(Icons.qr_code, size: 35 * scaleFactor, color: Colors.black),
    );
  }

  Widget _buildBottomSection(double scaleFactorW, double scaleFactor) {
    return Row(
      children: [
        Flexible(
          child: _buildInfoRow(
            label: 'Gender: ',
            value: _getGenderText(user.gender),
            scaleFactor: scaleFactor,
            fontSize: 11,
          ),
        ),
        SizedBox(width: 13 * scaleFactorW),
        Flexible(
          child: _buildInfoRow(
            label: 'DOB: ',
            value: _formatDob(),
            scaleFactor: scaleFactor,
            fontSize: 11,
          ),
        ),
        SizedBox(width: 13 * scaleFactorW),
        Flexible(
          child: _buildInfoRow(
            label: 'Mobile: ',
            value: user.mobile ?? 'N/A',
            scaleFactor: scaleFactor,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required double scaleFactor,
    required double fontSize,
  }) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: fontSize * scaleFactor,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: fontSize * scaleFactor,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getGenderText(String? gender) {
    if (gender == null || gender.isEmpty) return 'N/A';
    switch (gender.toUpperCase()) {
      case 'M':
        return 'Male';
      case 'F':
        return 'Female';
      case 'O':
        return 'Other';
      default:
        return gender;
    }
  }

  String _formatDob() {
    final day = user.dayOfBirth;
    final month = user.monthOfBirth;
    final year = user.yearOfBirth;

    if (day == null || month == null || year == null) return 'N/A';

    return '${day.toString().padLeft(2, '0')}'
        '${month.toString().padLeft(2, '0')}'
        '$year';
  }
}
