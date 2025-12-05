import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SharedWithHeart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 302,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildGradientText(
            'Shared',
            fontSize: 80,
            lineHeight: 62.84,
            letterSpacing: 1.6, // 2% of 80px
          ),
          const SizedBox(height: 4),
          _buildGradientText(
            'with heart.',
            fontSize: 80,
            lineHeight: 62.84,
            letterSpacing: 1.6, // 2% of 80px
          ),
        ],
      ),
    );
  }

  Widget _buildGradientText(
    String text, {
    required double fontSize,
    required double lineHeight,
    required double letterSpacing,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          const Color(0xFF397BE9).withOpacity(0.4),
          const Color(0xFF0040FF).withOpacity(0.4),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      child: Text(
        text,
        style: GoogleFonts.alumniSans(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: lineHeight / fontSize, // Convert to relative line height
          letterSpacing: letterSpacing,
          color: Colors.white, // This will be masked by the gradient
        ),
      ),
    );
  }
}
