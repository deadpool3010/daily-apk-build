import 'dart:ui';
import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/core/utils/image_constant.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:flutter/material.dart';

class SearchGroupsCard extends StatefulWidget {
  final VoidCallback onClose;
  final GlobalKey? hospitalIconKey;

  const SearchGroupsCard({
    super.key,
    required this.onClose,
    this.hospitalIconKey,
  });

  @override
  State<SearchGroupsCard> createState() => _SearchGroupsCardState();
}

class _SearchGroupsCardState extends State<SearchGroupsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  // Sample groups data
  final List<Map<String, String>> _groups = [
    {'name': 'CMC Main Group - June', 'id': '1'},
    {'name': 'Paediatric Care Team Group', 'id': '2'},
    {'name': 'Paediatric Post Care Team Group', 'id': '3'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closeCard() {
    _controller.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Reserve a bit more space so bottom nav area is never blurred
    final bottomNavHeight = 85.0;
    final screenSize = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          children: [
            // Blurred background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: bottomNavHeight,
              child: GestureDetector(
                onTap: _closeCard,
                behavior: HitTestBehavior.opaque,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
            ),
            // Speech bubble card
            Positioned(
              bottom: bottomNavHeight,
              left: 20,
              right: 20,
              child: IgnorePointer(
                ignoring: false,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: _buildSpeechBubbleCard(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeechBubbleCard() {
    return CustomPaint(
      painter: SpeechBubblePainter(),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE7EEF4),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Groups',
                    hintStyle: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFFB8B8B8),
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFE7EEF4),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      TablerIcons.search,
                      size: 24,
                      color: Color(0xFFB8B8B8),
                    ),
                  ),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            // Groups list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: _groups.length,
                itemBuilder: (context, index) {
                  return _buildGroupItem(_groups[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupItem(Map<String, String> group) {
    return InkWell(
      onTap: () {
        _closeCard();
        Get.toNamed(AppRoutes.groupDetailsScreen);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Medical icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                ImageConstant.hospitalLogo,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.medical_services,
                    color: Colors.white,
                    size: 24,
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            // Group name
            Expanded(
              child: Text(
                group['name'] ?? '',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            // Chevron icon
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    // Main rounded rectangle
    final borderRadius = 16.0;
    final pointerWidth = 20.0;
    final pointerHeight = 12.0;
    final pointerOffset = size.width * 0.5; // Center of the card

    // Top-left corner
    path.moveTo(borderRadius, 0);
    // Top edge
    path.lineTo(size.width - borderRadius, 0);
    // Top-right corner
    path.quadraticBezierTo(size.width, 0, size.width, borderRadius);
    // Right edge
    path.lineTo(size.width, size.height - pointerHeight - borderRadius);
    // Bottom-right corner (before pointer)
    path.quadraticBezierTo(
      size.width,
      size.height - pointerHeight,
      size.width - borderRadius,
      size.height - pointerHeight,
    );
    // Pointer (speech bubble tail)
    path.lineTo(pointerOffset + pointerWidth / 2, size.height - pointerHeight);
    path.lineTo(pointerOffset, size.height);
    path.lineTo(pointerOffset - pointerWidth / 2, size.height - pointerHeight);
    // Bottom-left corner (after pointer)
    path.lineTo(borderRadius, size.height - pointerHeight);
    path.quadraticBezierTo(
      0,
      size.height - pointerHeight,
      0,
      size.height - pointerHeight - borderRadius,
    );
    // Left edge
    path.lineTo(0, borderRadius);
    // Top-left corner
    path.quadraticBezierTo(0, 0, borderRadius, 0);

    path.close();

    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawPath(path, shadowPaint);

    // Draw main shape
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

