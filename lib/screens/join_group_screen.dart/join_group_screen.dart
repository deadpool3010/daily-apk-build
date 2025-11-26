import 'dart:convert';

import 'package:bandhucare_new/constant/image_constant.dart';
import 'package:bandhucare_new/constant/variables.dart';
import 'package:bandhucare_new/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GroupListItem> groups = _parseGroupArguments(Get.arguments);
    final qr_code_data = Get.arguments;
    uniqueCode = qr_code_data['uniqueCode'];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFE0E4F2),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF1B2559),
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const AnimatedQrIllustration(),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x14333A66),
                        blurRadius: 24,
                        offset: Offset(0, -8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Expanded(
                          child: groups.isEmpty
                              ? _NoGroupFound()
                              : ListView.separated(
                                  itemCount: groups.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final group = groups[index];
                                    return _GroupCard(
                                      title: group.title,
                                      createdOn: group.createdOn,
                                      hospital: group.hospital,
                                      onJoinTap: () {
                                        Get.toNamed(
                                          AppRoutes.joinCommunityScreen,
                                          arguments: {
                                            'groupId': group.groupId,
                                            'groupName': group.title,
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedQrIllustration extends StatefulWidget {
  const AnimatedQrIllustration({super.key});

  @override
  State<AnimatedQrIllustration> createState() => AnimatedQrIllustrationState();
}

class AnimatedQrIllustrationState extends State<AnimatedQrIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController scanLineController;
  late final Animation<double> scanLinePosition;

  static const double qrSize = 240;

  @override
  void initState() {
    super.initState();
    scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    scanLinePosition = CurvedAnimation(
      parent: scanLineController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    scanLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: qrSize + 48,
      child: Center(
        child: Container(
          width: qrSize + 32,
          height: qrSize + 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A0F172A),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Center(
            child: SizedBox(
              width: qrSize,
              height: qrSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(ImageConstant.qrBorder, fit: BoxFit.contain),
                  Image.asset(
                    ImageConstant.qrCode,
                    width: qrSize,
                    height: qrSize,
                  ),
                  AnimatedBuilder(
                    animation: scanLinePosition,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment(0, scanLinePosition.value * 2 - 1),
                        child: child,
                      );
                    },
                    child: Container(
                      width: qrSize * 0.86,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDB623),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFDB623).withOpacity(0.4),
                            blurRadius: 18,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.title,
    required this.createdOn,
    required this.hospital,
    required this.onJoinTap,
  });

  final String title;
  final String createdOn;
  final String hospital;
  final VoidCallback onJoinTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14333A66),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
                Image.asset(
                  ImageConstant.appLogo,
                  width: 44,
                  height: 44,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(width: 6),
                Text(
                  createdOn,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    hospital,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 10,
                    ),
                    elevation: 0,
                  ),
                  onPressed: onJoinTap,
                  child: const Text(
                    'Join Group',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: List.generate(
                    4,
                    (index) => Transform.translate(
                      offset: Offset(-8.0 * index, 0),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: const Color(0xFFE5E7EB),
                          child: Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GroupListItem {
  const GroupListItem({
    required this.title,
    required this.createdOn,
    required this.hospital,
    required this.groupId,
  });

  final String title;
  final String createdOn;
  final String hospital;
  final String groupId;
}

class _NoGroupFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.group_outlined, size: 48, color: Color(0xFF9CA3AF)),
          SizedBox(height: 12),
          Text(
            'No group information available.\nPlease rescan the QR code.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

List<GroupListItem> _parseGroupArguments(dynamic args) {
  if (args == null) return [];

  List<Map<String, dynamic>> rawGroups = [];

  // If we receive a String, attempt to decode JSON
  if (args is String) {
    try {
      final decoded = jsonDecode(args);
      args = decoded;
    } catch (_) {
      return [];
    }
  }

  if (args is Map<String, dynamic>) {
    rawGroups = [args];
  } else if (args is List) {
    rawGroups = args.whereType<Map<String, dynamic>>().toList();
  }

  return rawGroups.map((group) {
    final createdAt = group['createdAt'] as String?;
    final formattedDate = createdAt != null
        ? _formatDate(createdAt)
        : 'Created date unavailable';
    return GroupListItem(
      title: group['groupName']?.toString() ?? 'Unnamed Group',
      createdOn: formattedDate,
      hospital: group['name']?.toString() ?? 'Unknown Facility',
      groupId: group['groupId']?.toString() ?? '',
    );
  }).toList();
}

String _formatDate(String isoString) {
  try {
    final date = DateTime.parse(isoString).toLocal();
    return 'Created on ${_monthName(date.month)} ${date.day}, ${date.year}';
  } catch (_) {
    return 'Created date unavailable';
  }
}

String _monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  if (month < 1 || month > 12) return '';
  return months[month - 1];
}
