import 'package:bandhucare_new/core/export_file/app_exports.dart';

class JourneyCard extends StatefulWidget {
  final String? imageUrl;
  final String? imageAsset;
  final String title;
  final String description;
  final String buttonText;
  final double rotation;
  final int index;

  const JourneyCard({
    super.key,
    this.imageUrl,
    this.imageAsset,
    required this.title,
    required this.description,
    required this.buttonText,
    this.rotation = 0.0,
    required this.index,
  }) : assert(
         imageUrl != null || imageAsset != null,
         'Either imageUrl or imageAsset must be provided',
       );

  @override
  State<JourneyCard> createState() => _JourneyCardState();
}

class _JourneyCardState extends State<JourneyCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Smooth fade in animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Smooth slide in from bottom
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    // Smooth scale animation with bounce
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Rotation animation
    _rotationAnimation =
        Tween<double>(
          begin: widget.rotation - 0.05,
          end: widget.rotation,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
          ),
        );

    // Start animation with delay based on index
    Future.delayed(Duration(milliseconds: widget.index * 200), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: RotationTransition(
            turns: _rotationAnimation,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Polaroid card
                Container(
                  width: 220,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image with padding (polaroid style)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                              image: widget.imageUrl != null
                                  ? NetworkImage(widget.imageUrl!)
                                        as ImageProvider
                                  : AssetImage(widget.imageAsset!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Title and description in white space below image
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.title,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Flexible(
                                child: Text(
                                  widget.description,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: AppColors.black.withOpacity(0.6),
                                      fontSize: 9.4,
                                    ),
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF397BE9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.buttonText,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 11.0,
                                      ),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Pin/clip at the top
                Positioned(
                  top: -20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      ImageConstant.pin_icon,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
