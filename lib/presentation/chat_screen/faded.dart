import 'package:bandhucare_new/core/app_exports.dart';

class FadedBlurPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw faded gradient
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0),
          Colors.white.withOpacity(0.5),
          Colors.white,
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3); // Add blur

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
