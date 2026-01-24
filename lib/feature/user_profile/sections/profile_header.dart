import 'dart:async';
import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/core/controller/session_controller.dart';
import 'package:bandhucare_new/feature/user_profile/widgets/avatar.dart';
import 'package:bandhucare_new/core/ui/shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionController>(
      builder: (sessionController) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Row(
          children: [
            Avatar(),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DelayedTextWithShimmer(
                  text: "${sessionController.user?.name ?? ''}",
                  style: TextStyle(
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                _DelayedTextWithShimmer(
                  text: () {
                    final user = sessionController.user;
                    final email = user?.email;
                    final abhaAddress = user?.abhaAddress;
                    final mobile = user?.mobile;
                    
                    if (email != null && email.isNotEmpty) {
                      return email;
                    } else if (abhaAddress != null && abhaAddress.isNotEmpty) {
                      return abhaAddress;
                    } else if (mobile != null && mobile.isNotEmpty) {
                      return mobile;
                    } else {
                      return '—';
                    }
                  }(),
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
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF397BE9).withOpacity(0.16),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.edit, size: 20, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

class _DelayedTextWithShimmer extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _DelayedTextWithShimmer({
    required this.text,
    required this.style,
  });

  @override
  State<_DelayedTextWithShimmer> createState() => _DelayedTextWithShimmerState();
}

class _DelayedTextWithShimmerState extends State<_DelayedTextWithShimmer> {
  bool _showText = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showText = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showText || widget.text.isEmpty) {
      return Shimmer(
        child: Container(
          width: 120,
          height: widget.style.fontSize ?? 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }

    return Text(
      widget.text,
      style: widget.style,
    );
  }
}
