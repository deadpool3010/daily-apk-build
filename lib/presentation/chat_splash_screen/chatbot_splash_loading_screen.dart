import 'dart:ui';
import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/presentation/chat_splash_screen/controller/controller.dart';

class ChatbotSplashLoadingScreen extends StatefulWidget {
  const ChatbotSplashLoadingScreen({super.key});

  @override
  State<ChatbotSplashLoadingScreen> createState() =>
      _ChatbotSplashLoadingScreenState();
}

class _ChatbotSplashLoadingScreenState extends State<ChatbotSplashLoadingScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(ChatbotSplashScreenController());
  late AnimationController _animationController;
  Animation<double>? _bounceAnimation;
  bool _animationInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize controller first

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800), // Faster transition
      vsync: this,
    );
  }

  void _initializeAnimation(double screenHeight) {
    if (_animationInitialized) return;
    _animationInitialized = true;

    // Calculate Mitra container position
    // Mitra is at bottom: 250, height: 132
    // So its top position = screenHeight - 250 - 132
    const mitraBottomOffset = 250.0;
    const mitraContainerHeight = 132.0;
    final mitraTopPosition =
        screenHeight - mitraBottomOffset - mitraContainerHeight;

    // Robot image height is 139.77, so we want robot's bottom to align with Mitra's top
    // Robot top position = mitraTopPosition - robotHeight
    const robotHeight = 139.77;
    final landingPosition = mitraTopPosition - robotHeight;

    // Start position (from top of screen)
    final startPosition = 200.0;

    // Bounce height (relative to landing position)
    // Single bounce up height
    final settleOffset = 30.0; // Final settle position

    setState(() {
      _bounceAnimation = TweenSequence<double>([
        // Initial drop down to Mitra top
        TweenSequenceItem(
          tween: Tween<double>(
            begin: startPosition,
            end: landingPosition,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 40, // 40% of animation time
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: landingPosition,
            end: landingPosition - settleOffset,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 15, // 15% of animation time
        ),
      ]).animate(_animationController);
    });

    // Start animation and navigate when done
    _animationController.forward().then((_) {
      controller.onAnimationComplete();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Initialize animation with screen height on first build
    if (!_animationInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_animationInitialized) {
          _initializeAnimation(screenHeight);
        }
      });
    }

    return Scaffold(
      backgroundColor: Color(0xFF5C83F3),
      body: Stack(
        children: [
          // First star with gradient and layer blur - partially visible at top
          Positioned(
            left: 150,
            top: -300,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFAF8EF6), // #AF8EF6 at 0%
                      Color(0xFFF5DAFB), // #F5DAFB at 100%
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Second star with gradient and layer blur
          Positioned(
            top: 500,
            right: 300,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFAF8EF6), // #AF8EF6 at 0%
                      Color(0xFFF5DAFB), // #F5DAFB at 100%
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 300,
            top: 750,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFAF8EF6), // #AF8EF6 at 0%
                      Color(0xFFF5DAFB), // #F5DAFB at 100%
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Robot image at specific position
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Image(
                image: AssetImage(ImageConstant.introducing),
                fit: BoxFit.contain,
                height: 48,
                width: 212,
              ),
            ),
          ),

          // Mitra widget at specific position (using simple Container to avoid rendering conflicts)
          Positioned(
            bottom: 250,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 150,
                height: 132,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Image(
                    image: AssetImage(ImageConstant.bandhu_splash),
                    fit: BoxFit.contain,
                    height: 28,
                    width: 99,
                  ),
                ),
              ),
            ),
          ),

          // Robot with bounce animation - placed AFTER Mitra so it appears on top
          if (_bounceAnimation != null)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Positioned(
                  top: _bounceAnimation!.value,
                  left: 0,
                  right: 0,
                  child: RepaintBoundary(child: child!),
                );
              },
              child: Center(
                child: Image(
                  image: AssetImage(ImageConstant.mitra_robot),
                  fit: BoxFit.contain,
                  height: 139.77,
                  width: 88.24,
                ),
              ),
            )
          else
            // Show robot at start position until animation is ready
            Positioned(
              top: 200.0,
              left: 0,
              right: 0,
              child: Center(
                child: Image(
                  image: AssetImage(ImageConstant.mitra_robot),
                  fit: BoxFit.contain,
                  height: 139.77,
                  width: 88.24,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
