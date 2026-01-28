import 'dart:ui';
import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/model/homepage_model.dart';
import 'package:bandhucare_new/core/ui/shimmer/shimmer.dart';

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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

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
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
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
              child: Obx(() {
                final controller = Get.find<HomepageController>();
                final isLoading = controller.isLoading.value;
                final allGroups = controller.groups;
                
                // Show shimmer loading effect
                if (isLoading) {
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: 3, // Show 3 shimmer items
                    itemBuilder: (context, index) {
                      return _buildGroupItemShimmer();
                    },
                  );
                }
                
                // Filter groups based on search query
                var filteredGroups = _searchQuery.isEmpty
                    ? allGroups.toList()
                    : allGroups.where((group) {
                        return group.name.toLowerCase().contains(_searchQuery);
                      }).toList();
                
                // Sort groups: active groups first, then inactive
                filteredGroups.sort((a, b) {
                  if (a.isActive && !b.isActive) return -1;
                  if (!a.isActive && b.isActive) return 1;
                  return 0;
                });
                
                if (filteredGroups.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? 'No groups available'
                            : 'No groups found',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: filteredGroups.length,
                  itemBuilder: (context, index) {
                    return _buildGroupItem(filteredGroups[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupItem(HomepageGroup group) {
    final isActive = group.isActive;
    
    return InkWell(
      onTap: () {
        // Set bottom navigation index to 0 (home) when closing
        final controller = Get.find<HomepageController>();
        controller.changeBottomNavIndex(0);
        _closeCard();
        // Get.toNamed(AppRoutes.groupDetailsScreen);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color:Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Group image or icon
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                // Remove colored background; keep circular shape only
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: group.image != null && group.image!.isNotEmpty
                    ? Image.network(
                        group.image!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          // While loading, show shimmer placeholder
                          if (loadingProgress != null) {
                            return Shimmer(
                              child: Container(
                                width: 48,
                                height: 48,
                                color: Colors.white,
                              ),
                            );
                          }
                          // When fully loaded, show the actual image without shimmer
                          return child;
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            ImageConstant.hospitalLogo,
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          );
                        },
                      )
                    : Image.asset(
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
            ),
            const SizedBox(width: 16),
            // Group name
            Expanded(
              child: Text(
                group.name,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isActive ? AppColors.primaryColor : Colors.black,
                ),
              ),
            ),
            // Active indicator or Chevron icon
           
          
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 24,
              ),
            if (isActive) const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupItemShimmer() {
    return Container(
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
          // Group image shimmer
          Shimmer(
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Group name shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer(
                  child: Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Shimmer(
                  child: Container(
                    width: 120,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Chevron icon shimmer
          Shimmer(
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
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


