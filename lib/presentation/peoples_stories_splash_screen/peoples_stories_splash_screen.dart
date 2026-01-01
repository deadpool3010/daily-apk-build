import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bandhucare_new/presentation/peoples_stories_splash_screen/controller/peoples_stories_splash_controller.dart';

class PeoplesStoriesSplashScreen extends StatelessWidget {
  const PeoplesStoriesSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized (binding uses lazyPut)
    Get.find<PeoplesStoriesSplashController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F9FF),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F9FF),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: GetBuilder<PeoplesStoriesSplashController>(
              builder: (controller) {
                return AnimatedBuilder(
                  animation: controller.animationController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Third ring (outermost) - lightest
                        _buildRing(
                          scale: controller.thirdRingAnimation.value,
                          opacity:
                              (1.0 - controller.thirdRingAnimation.value * 0.6)
                                  .clamp(0.0, 1.0),
                          color: const Color(0xFFE8F2FF),
                        ),
                        // Second ring (middle)
                        _buildRing(
                          scale: controller.secondRingAnimation.value,
                          opacity:
                              (1.0 - controller.secondRingAnimation.value * 0.5)
                                  .clamp(0.0, 1.0),
                          color: const Color(0xFFD4E7FF),
                        ),
                        // First ring (innermost) - slightly darker
                        _buildRing(
                          scale: controller.firstRingAnimation.value,
                          opacity:
                              (1.0 - controller.firstRingAnimation.value * 0.4)
                                  .clamp(0.0, 1.0),
                          color: const Color(0xFFC1DCFF),
                        ),
                        // Center circle - white
                        Opacity(
                          opacity: controller.centerCircleAnimation.value,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRing({
    required double scale,
    required double opacity,
    required Color color,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
        ),
      ),
    );
  }
}
