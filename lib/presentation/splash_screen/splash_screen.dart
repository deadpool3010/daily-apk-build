import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'dart:math' as math;
import 'package:bandhucare_new/core/utils/image_constant.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Precache login header image for better user experience
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final imageProvider = AssetImage(ImageConstant.loginHeader);
      precacheImage(imageProvider, context).catchError((error) {
        // Silently handle errors - image will load normally when needed
        debugPrint('Failed to precache login header image: $error');
      });
    });

    // GetX Controller
    final controller = Get.find<SplashController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final centerX = screenWidth / 2;
    final centerY = screenHeight / 2;

    return AnimatedBuilder(
      animation: Listenable.merge([
        controller.backgroundProgress,
        controller.logoColor,
        controller.rightCircleColor,
        controller.belowHandColor,
        controller.textColor,
        controller.logoFadeOpacity,
        controller.rightCircleFadeOpacity,
        controller.belowHandFadeOpacity,
        controller.textFadeOpacity,
        controller.logoFadeOutOpacity,
        controller.rightCircleFadeOutOpacity,
        controller.belowHandFadeOutOpacity,
        controller.textFadeOutOpacity,
      ]),
      builder: (context, child) {
        // Status bar matches background gradient start when it reaches top area (progress > 0.7)
        final statusBarColor = controller.backgroundProgress.value > 0.95
            ? const Color(0xFF3865FF) // Lighter blue from gradient
            : Colors.white;
        final statusBarBrightness = controller.backgroundProgress.value > 0.7
            ? Brightness.light
            : Brightness.dark;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: statusBarColor,
            statusBarIconBrightness: statusBarBrightness,
            systemNavigationBarColor: Colors.transparent,
            statusBarBrightness: statusBarBrightness,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // Background reveal animation (bottom to top)
                Positioned(
                  left: 0,
                  bottom: 0,
                  width: screenWidth,
                  height: screenHeight * controller.backgroundProgress.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF3865FF), // Lighter blue
                          const Color(0xFF223D99), // Darker blue
                        ],
                      ),
                    ),
                  ),
                ),

                // Right Circle (Crescent) - flips horizontally and wraps around
                AnimatedBuilder(
                  animation: Listenable.merge([
                    controller.rightCircleOpacity,
                    controller.rightCircleScale,
                    controller.rightCircleController,
                    controller.rightCircleColor,
                    controller.rightCircleFadeOpacity,
                    controller.rightCircleFadeOutOpacity,
                  ]),
                  builder: (context, child) {
                    // Interpolate between start (right) and end (left) positions
                    final progress = controller.rightCircleController.value;
                    final circleFilterColor = controller.rightCircleColor.value;

                    // Start position: right side off-screen
                    // End position: left side wrapped around (from Figma: left: 108.25)
                    final startX = screenWidth; // Start from right off-screen
                    final endX = 108.25;
                    final currentX = startX + (endX - startX) * progress;

                    // Vertical position from Figma: top: 298.59
                    final startY =
                        centerY - 73; // Approximate starting position
                    final endY = 298.59;
                    final currentY = startY + (endY - startY) * progress;

                    return Positioned(
                      left: currentX,
                      top: currentY,
                      child: Opacity(
                        opacity: controller.rightCircleOpacity.value,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..scale(controller.rightCircleScale.value)
                            ..rotateY(math.pi * progress), // Flip horizontally
                          child: Stack(
                            children: [
                              // Original image with fade-out
                              Opacity(
                                opacity: circleFilterColor != null
                                    ? controller.rightCircleFadeOutOpacity.value
                                    : 1.0,
                                child: Container(
                                  width: 137,
                                  height: 147,
                                  child: Image.asset(
                                    ImageConstant.splashRightCircle,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 137,
                                        height: 147,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF60A5FA,
                                          ).withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(
                                            70,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // White version with fade-in
                              if (circleFilterColor != null)
                                Opacity(
                                  opacity:
                                      controller.rightCircleFadeOpacity.value,
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      circleFilterColor,
                                      BlendMode.srcIn,
                                    ),
                                    child: Container(
                                      width: 137,
                                      height: 147,
                                      child: Image.asset(
                                        ImageConstant.splashRightCircle,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                width: 137,
                                                height: 147,
                                                decoration: BoxDecoration(
                                                  color: circleFilterColor,
                                                  borderRadius:
                                                      BorderRadius.circular(70),
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Center Logo (appears on top)
                AnimatedBuilder(
                  animation: Listenable.merge([
                    controller.centerLogoScale,
                    controller.logoColor,
                    controller.logoFadeOpacity,
                    controller.logoFadeOutOpacity,
                  ]),
                  builder: (context, child) {
                    final logoFilterColor = controller.logoColor.value;

                    return Positioned(
                      left: 137.32,
                      top: 358.69,
                      child: Transform.scale(
                        scale: controller.centerLogoScale.value,
                        child: Stack(
                          children: [
                            // Original image with fade-out
                            Opacity(
                              opacity: logoFilterColor != null
                                  ? controller.logoFadeOutOpacity.value
                                  : 1.0,
                              child: SizedBox(
                                width: 106,
                                height: 79,
                                child: Image.asset(
                                  ImageConstant.splashCenter,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 106,
                                      height: 79,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        size: 45,
                                        color: Color(0xFF282C34),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // White version with fade-in
                            if (logoFilterColor != null)
                              Opacity(
                                opacity: controller.logoFadeOpacity.value,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    logoFilterColor,
                                    BlendMode.srcIn,
                                  ),
                                  child: SizedBox(
                                    width: 106,
                                    height: 79,
                                    child: Image.asset(
                                      ImageConstant.splashCenter,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 106,
                                              height: 79,
                                              decoration: BoxDecoration(
                                                color: logoFilterColor,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 10,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.person,
                                                size: 45,
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Below Hand - comes from bottom, centers below logo
                AnimatedBuilder(
                  animation: Listenable.merge([
                    controller.belowHandOpacity,
                    controller.belowHandPosition,
                    controller.belowHandColor,
                    controller.belowHandFadeOpacity,
                    controller.belowHandFadeOutOpacity,
                  ]),
                  builder: (context, child) {
                    // Calculate position from Figma: left: 91.36, top: 280.41
                    final progress = controller.belowHandController.value;
                    final handFilterColor = controller.belowHandColor.value;
                    final startY = screenHeight; // Start from bottom off-screen
                    final endY = 280.41; // Final position from Figma
                    final currentY = startY + (endY - startY) * progress;

                    return Positioned(
                      left: 91.36,
                      top: currentY,
                      child: Opacity(
                        opacity: controller.belowHandOpacity.value,
                        child: Stack(
                          children: [
                            // Original image with fade-out
                            Opacity(
                              opacity: handFilterColor != null
                                  ? controller.belowHandFadeOutOpacity.value
                                  : 1.0,
                              child: Container(
                                width: 225,
                                height: 221,
                                child: Image.asset(
                                  ImageConstant.splashBelowHand,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 225,
                                      height: 221,
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF1E40AF,
                                        ).withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(
                                          110,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // White version with fade-in
                            if (handFilterColor != null)
                              Opacity(
                                opacity: controller.belowHandFadeOpacity.value,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    handFilterColor,
                                    BlendMode.srcIn,
                                  ),
                                  child: Container(
                                    width: 225,
                                    height: 221,
                                    child: Image.asset(
                                      ImageConstant.splashBelowHand,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 225,
                                              height: 221,
                                              decoration: BoxDecoration(
                                                color: handFilterColor,
                                                borderRadius:
                                                    BorderRadius.circular(110),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // BandhuCare Text
                AnimatedBuilder(
                  animation: Listenable.merge([
                    controller.textOpacity,
                    controller.textColor,
                    controller.textFadeOpacity,
                    controller.textFadeOutOpacity,
                  ]),
                  builder: (context, child) {
                    final textFilterColor = controller.textColor.value;
                    final textColorValue =
                        textFilterColor ?? const Color(0xFF1E3A8A);

                    return Positioned(
                      left: centerX - 100,
                      bottom: 150,
                      child: Opacity(
                        opacity: controller.textOpacity.value,
                        child: Stack(
                          children: [
                            // Original text with fade-out
                            Opacity(
                              opacity: textFilterColor != null
                                  ? controller.textFadeOutOpacity.value
                                  : 1.0,
                              child: Image.asset(
                                ImageConstant.splashBandhuCareText,
                                width: 200,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Text(
                                    'Bandhu Care',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: textColorValue,
                                    ),
                                  );
                                },
                              ),
                            ),
                            // White version with fade-in
                            if (textFilterColor != null)
                              Opacity(
                                opacity: controller.textFadeOpacity.value,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    textFilterColor,
                                    BlendMode.srcIn,
                                  ),
                                  child: Image.asset(
                                    ImageConstant.splashBandhuCareText,
                                    width: 200,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Text(
                                        'Bandhu Care',
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: textFilterColor,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
