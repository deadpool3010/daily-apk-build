import 'package:bandhucare_new/core/app_exports.dart';

enum CheckInCardType { feeling, symptoms }

class Feelings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DailyCheckInCard(
          cardType: CheckInCardType.feeling,
          progress: '1/5',
          backgroundImage: ImageConstant.home_screen_img_1,
          label: 'Daily Check-in with Mitra',
          question: 'How are you feeling today?',
          index: 0,
        ),
        const SizedBox(width: 16),
        DailyCheckInCard(
          cardType: CheckInCardType.symptoms,
          progress: '2/5',
          backgroundImage: ImageConstant.home_screen_img_2,
          label: 'Daily Check-in',
          question: 'Do you have any following Symptoms ?',
          index: 1,
        ),
      ],
    );
  }
}

class DailyCheckInCard extends StatefulWidget {
  final CheckInCardType cardType;
  final String progress;
  final String backgroundImage;
  final String label;
  final String question;
  final int index;

  const DailyCheckInCard({
    super.key,
    required this.cardType,
    required this.progress,
    required this.backgroundImage,
    required this.label,
    required this.question,
    required this.index,
  });

  @override
  State<DailyCheckInCard> createState() => _DailyCheckInCardState();
}

class _DailyCheckInCardState extends State<DailyCheckInCard>
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

    // Smooth slide in from right
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero).animate(
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

    // Subtle rotation animation
    _rotationAnimation = Tween<double>(begin: -0.02, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.9, curve: Curves.easeOut),
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
            child: Container(
              width: 300,
              height: 325,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.backgroundImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Progress Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.progress,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // Bot Avatar and Label - Positioned to overlap image boundary
                  Positioned(
                    left: 10,
                    top: 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Image.asset(
                                  ImageConstant.robot,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 25),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Text(
                            widget.label,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content Section
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 120,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ), // Space for overlapping robot
                          // Question
                          Text(
                            widget.question,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Content based on card type
                          if (widget.cardType == CheckInCardType.feeling)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildEmotionItem(
                                  ImageConstant.happyImage,
                                  'Happy',
                                ),
                                _buildEmotionItem(
                                  ImageConstant.scaredImage,
                                  'Scared',
                                ),
                                _buildEmotionItem(
                                  ImageConstant.angryImage,
                                  'Angry',
                                ),
                                _buildEmotionItem(
                                  ImageConstant.sadImage,
                                  'Wornout',
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      _buildSymptomRadio('Cold'),
                                      const SizedBox(height: 12),
                                      _buildSymptomRadio('Headache'),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    children: [
                                      _buildSymptomRadio('Fever'),
                                      const SizedBox(height: 12),
                                      _buildSymptomRadio('Body pains'),
                                    ],
                                  ),
                                ),
                              ],
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

  Widget _buildEmotionItem(String emoji, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(emoji, width: 35, height: 35),
        Text(
          label,
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomRadio(String label) {
    return GestureDetector(
      onTap: () {
        // Handle selection
      },
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[400]!, width: 2),
              color: Colors.transparent,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
