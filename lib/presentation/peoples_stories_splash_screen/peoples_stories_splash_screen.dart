import 'dart:math' as math;

import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/presentation/peoples_stories_splash_screen/controller/peoples_stories_splash_controller.dart';

class PeoplesStoriesSplashScreen extends StatelessWidget {
  const PeoplesStoriesSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PeoplesStoriesSplashController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F9FF),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer circle - largest (background ring)
                        // Displayed directly without any animation - shows immediately on screen open
                        Container(
                          width: 440,
                          height: 440,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(
                              0.5,
                            ), // Light blue-grey
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: const Offset(2, 2),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                              // BoxShadow(
                              //   color: Colors.white.withOpacity(0.8),
                              //   offset: const Offset(-2, -2),
                              //   blurRadius: 6,
                              //   spreadRadius: 0,
                              // ),
                            ],
                          ),
                        ),
                        // Middle circle (background ring)
                        Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(
                              0.7,
                            ), // Light blue-grey
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                offset: const Offset(2, 2),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8),
                                offset: const Offset(-2, -2),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                        // Inner circle - smallest, white, raised (background ring)
                        Container(
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8),
                                offset: const Offset(-3, -3),
                                blurRadius: 8,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: const Offset(3, 3),
                                blurRadius: 8,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),

                        // Center Image - Zoom in then zoom out animation (small -> normal -> larger)
                        GetBuilder<PeoplesStoriesSplashController>(
                          builder: (ctrl) {
                            return AnimatedBuilder(
                              animation: ctrl.centerImageController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: ctrl.centerScaleAnimation.value,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        ImageConstant.care_hub_people_img,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[300],
                                                child: Icon(
                                                  Icons.person,
                                                  size: 60,
                                                  color: Colors.grey[600],
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        // Orbiting Profile Images - Animated from outside to inside
                        // Positioned relative to Stack center - animations slide from outside to these positions
                        // Size variations: some small (65), some normal (75), some larger (80)
                        // Rotation variations: left tilt (negative), right tilt (positive), straight (0 or small)
                        _buildOrbitingImageAnimated(
                          controller,
                          context,
                          0,
                          -70,
                          -360,
                          -0.1, // Right tilt
                          60.0, // Normal size
                        ),
                        _buildOrbitingImageAnimated(
                          controller,
                          context,
                          0,
                          0,
                          -310,
                          0.15, // Right tilt
                          53.0, // Normal size
                        ), // Top Center
                        _buildOrbitingImageAnimated(
                          controller,
                          context,
                          1,
                          100,
                          -285,
                          -0.05, // Left tilt
                          65.0, // Small size
                        ), // Top Right
                        _buildOrbitingImageAnimated(
                          controller,
                          context,
                          2,
                          160,
                          -190,
                          0.15, // Right tilt
                          75.0, // Normal size
                        ),
                        // _buildOrbitingImageAnimated(
                        //   controller,
                        //   context,
                        //   3,
                        //   180,
                        //   -260,
                        //   0.15, // Right tilt
                        //   60.0, // Normal size
                        // ), // Right
                        _buildOrbitingImageAnimated(
                          controller,
                          context,
                          3,
                          120,
                          -60,
                          0.1, // Left tilt
                          80.0, // Larger size
                        ), // Bottom Right
                        _buildOrbitingImageAnimated(
                          controller,
                          context,
                          4,
                          0,
                          -10,
                          0.05, // Slight right tilt
                          65.0, // Small size
                        ), // Bottom Center
                        _buildOrbitingImageAnimated(
                          controller,
                          context,
                          5,
                          -100,
                          -50,
                          -0.2, // Left tilt
                          68.0, // Normal size
                        ), // Bottom Left
                        _buildOrbitingImageAnimated(
                          controller,
                          context,
                          6,
                          -160,
                          -160,
                          -0.05, // Right tilt
                          60.0, // Medium-small size
                        ), // Left
                        _buildOrbitingImageAnimated(
                          controller,
                          context,
                          7,
                          -120,
                          -270,
                          -0.15, // Left tilt
                          70.0, // Normal size
                        ), // Top Left
                      ],
                    ),
                  ),

                  // Main Heading - Animated from bottom to top
                  GetBuilder<PeoplesStoriesSplashController>(
                    builder: (ctrl) {
                      return SlideTransition(
                        position: ctrl.headingSlideAnimation,
                        child: FadeTransition(
                          opacity: ctrl.headingFadeAnimation,
                          child: Text(
                            'Voices That Inspire\nThrough Stories.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                              height: 1.2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Subtitle - Animated from bottom to top
                  GetBuilder<PeoplesStoriesSplashController>(
                    builder: (ctrl) {
                      return SlideTransition(
                        position: ctrl.subtitleSlideAnimation,
                        child: FadeTransition(
                          opacity: ctrl.subtitleFadeAnimation,
                          child: Text(
                            'A Space to Be Heard. A Community That Understands.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF898A8D),
                              height: 1.4,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Explore Stories Button - Animated from bottom to top
                  GetBuilder<PeoplesStoriesSplashController>(
                    builder: (ctrl) {
                      return SlideTransition(
                        position: ctrl.buttonSlideAnimation,
                        child: FadeTransition(
                          opacity: ctrl.buttonFadeAnimation,
                          child: _buildExploreButton(context),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildCircularProfileLayout(
  //   BuildContext context,
  //   PeoplesStoriesScreenController controller,
  //   Size screenSize,
  // ) {
  //   final centerSize = 100.0; // Central image size
  //   final orbitImageSize = 70.0; // Size of orbiting profile pictures

  //   final containerHeight = 380.0;
  //   final containerWidth = screenSize.width;
  //   final centerX = containerWidth / 2;
  //   final centerY = containerHeight / 2;

  //   return SizedBox(
  //     height: containerHeight,
  //     width: double.infinity,
  //     child: Stack(
  //       alignment: Alignment.center,
  //       children: [
  //         // Concentric rings background - Neumorphic style rounded containers
  //         // Matching the shared image design with raised inner circle and depressed outer rings
  //         ...List.generate(3, (ringIndex) {
  //           final ringSize = 200.0 + (ringIndex * 90.0); // Larger rings
  //           final isInnermost = ringIndex == 0;

  //           // Innermost circle is white and raised (lighter), outer circles are depressed (darker)
  //           final color = isInnermost
  //               ? Colors.white
  //               : const Color(0xFFE8F0F7); // Light blue-grey for outer rings

  //           // Shadows for neumorphic effect
  //           final shadows = isInnermost
  //               ? [
  //                   // Raised effect - lighter shadow on top-left, darker on bottom-right
  //                   BoxShadow(
  //                     color: Colors.white.withOpacity(0.8),
  //                     offset: const Offset(-3, -3),
  //                     blurRadius: 8,
  //                     spreadRadius: 0,
  //                   ),
  //                   BoxShadow(
  //                     color: Colors.grey.withOpacity(0.2),
  //                     offset: const Offset(3, 3),
  //                     blurRadius: 8,
  //                     spreadRadius: 0,
  //                   ),
  //                 ]
  //               : [
  //                   // Depressed effect - darker shadow on top-left, lighter on bottom-right
  //                   BoxShadow(
  //                     color: Colors.grey.withOpacity(0.3),
  //                     offset: const Offset(2, 2),
  //                     blurRadius: 6,
  //                     spreadRadius: 0,
  //                   ),
  //                   BoxShadow(
  //                     color: Colors.white.withOpacity(0.8),
  //                     offset: const Offset(-2, -2),
  //                     blurRadius: 6,
  //                     spreadRadius: 0,
  //                   ),
  //                 ];

  //           return Positioned(
  //             left: centerX - ringSize / 2,
  //             top: centerY - ringSize / 2,
  //             child: Container(
  //               width: ringSize,
  //               height: ringSize,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: color,
  //                 boxShadow: shadows,
  //               ),
  //             ),
  //           );
  //         }),

  //         // // Subtle circular gradient overlay - behind images
  //         // Positioned(
  //         //   left: centerX - 200,
  //         //   top: centerY - 200,
  //         //   child: Container(
  //         //     width: 400,
  //         //     height: 400,
  //         //     decoration: BoxDecoration(
  //         //       shape: BoxShape.circle,
  //         //       gradient: RadialGradient(
  //         //         colors: [
  //         //           Colors.white.withOpacity(0.1),
  //         //           Colors.white.withOpacity(0.0),
  //         //         ],
  //         //       ),
  //         //     ),
  //         //   ),
  //         // ),

  //         // Animated Center Image - Zoom out to zoom in
  //         // AnimatedBuilder(
  //         //   animation: controller.centerImageController,
  //         //   builder: (context, child) {
  //         //     return Transform.scale(
  //         //       scale: controller.centerScaleAnimation.value,
  //         //       child: Opacity(
  //         //         opacity: controller.centerOpacityAnimation.value,
  //         //         child: Container(
  //         //           width: centerSize,
  //         //           height: centerSize,
  //         //           decoration: BoxDecoration(
  //         //             borderRadius: BorderRadius.circular(16),
  //         //             color: Colors
  //         //                 .white, // White background to ensure rings don't show through
  //         //             boxShadow: [
  //         //               BoxShadow(
  //         //                 color: Colors.black.withOpacity(0.1),
  //         //                 blurRadius: 15,
  //         //                 offset: const Offset(0, 5),
  //         //               ),
  //         //             ],
  //         //           ),
  //         //           child: ClipRRect(
  //         //             borderRadius: BorderRadius.circular(16),
  //         //             child: Image.asset(
  //         //               ImageConstant.care_hub_people_img,
  //         //               fit: BoxFit.cover,
  //         //               errorBuilder: (context, error, stackTrace) {
  //         //                 return Container(
  //         //                   color: Colors.grey[300],
  //         //                   child: Icon(
  //         //                     Icons.person,
  //         //                     size: 60,
  //         //                     color: Colors.grey[600],
  //         //                   ),
  //         //                 );
  //         //               },
  //         //             ),
  //         //           ),
  //         //         ),
  //         //       ),
  //         //     );
  //         //   },
  //         // ),

  //         // // Animated Orbiting Profile Pictures - Come from outside
  //         // // You can manually edit the left/top values below to position images as needed

  //         // // Image 0 - Top Center
  //         // // Edit finalLeft/finalTop (3rd and 4th parameters) to adjust final position
  //         // _buildOrbitingImage(
  //         //   controller,
  //         //   0,
  //         //   centerX + 0,
  //         //   centerY - 120,
  //         //   centerX + 0,
  //         //   centerY - 390,
  //         //   -0.1,
  //         //   centerSize,
  //         //   orbitImageSize,
  //         // ),

  //         // // Image 1 - Top Right
  //         // _buildOrbitingImage(
  //         //   controller,
  //         //   1,
  //         //   centerX + 85,
  //         //   centerY - 85,
  //         //   centerX + 255,
  //         //   centerY - 255,
  //         //   0.05,
  //         //   centerSize,
  //         //   orbitImageSize,
  //         // ),

  //         // // Image 2 - Right
  //         // _buildOrbitingImage(
  //         //   controller,
  //         //   2,
  //         //   centerX + 120,
  //         //   centerY + 0,
  //         //   centerX + 360,
  //         //   centerY + 0,
  //         //   0.1,
  //         //   centerSize,
  //         //   orbitImageSize,
  //         // ),

  //         // // Image 3 - Bottom Right
  //         // _buildOrbitingImage(
  //         //   controller,
  //         //   3,
  //         //   centerX + 85,
  //         //   centerY + 85,
  //         //   centerX + 255,
  //         //   centerY + 255,
  //         //   -0.05,
  //         //   centerSize,
  //         //   orbitImageSize,
  //         // ),

  //         // // Image 4 - Bottom Center
  //         // _buildOrbitingImage(
  //         //   controller,
  //         //   4,
  //         //   centerX + 0,
  //         //   centerY + 120,
  //         //   centerX + 0,
  //         //   centerY + 360,
  //         //   0.08,
  //         //   centerSize,
  //         //   orbitImageSize,
  //         // ),

  //         // // Image 5 - Bottom Left
  //         // _buildOrbitingImage(
  //         //   controller,
  //         //   5,
  //         //   centerX - 110,
  //         //   centerY + 85,
  //         //   centerX - 255,
  //         //   centerY + 255,
  //         //   -0.1,
  //         //   centerSize,
  //         //   orbitImageSize,
  //         // ),

  //         // // Image 6 - Left
  //         // _buildOrbitingImage(
  //         //   controller,
  //         //   6,
  //         //   centerX - 135,
  //         //   centerY + 0,
  //         //   centerX - 360,
  //         //   centerY + 0,
  //         //   0.15,
  //         //   centerSize,
  //         //   orbitImageSize,
  //         // ),

  //         // // Image 7 - Top Left
  //         // _buildOrbitingImage(
  //         //   controller,
  //         //   7,
  //         //   centerX - 110,
  //         //   centerY - 85,
  //         //   centerX - 255,
  //         //   centerY - 255,
  //         //   -0.12,
  //         //   centerSize,
  //         //   orbitImageSize,
  //         // ),

  //         // // Image 8 - Top Left (slightly different angle)
  //         // _buildOrbitingImage(
  //         //   controller,
  //         //   8,
  //         //   centerX - 80,
  //         //   centerY - 140,
  //         //   centerX - 300,
  //         //   centerY - 300,
  //         //   0.2,
  //         //   centerSize,
  //         //   orbitImageSize,
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  // // Helper method to build animated orbiting images
  // // You can easily edit finalLeft/finalTop to position images
  // Widget _buildOrbitingImage(
  //   PeoplesStoriesScreenController controller,
  //   int index,
  //   double finalLeft,
  //   double finalTop,
  //   double startLeft,
  //   double startTop,
  //   double rotationAngle,
  //   double centerSize,
  //   double orbitImageSize,
  // ) {
  //   return AnimatedBuilder(
  //     animation: controller.getOrbitAnimation(index),
  //     builder: (context, child) {
  //       final animationValue = controller.getOrbitAnimation(index).value;

  //       // Interpolate from outside position to final position
  //       final currentLeft =
  //           startLeft + (finalLeft - startLeft) * animationValue;
  //       final currentTop = startTop + (finalTop - startTop) * animationValue;

  //       // Scale from 0.3 to 1.0 (small to normal size)
  //       final scale = 0.3 + (1.0 - 0.3) * animationValue;

  //       // Opacity from 0 to 1
  //       final opacity = animationValue;

  //       return Positioned(
  //         left: currentLeft - (orbitImageSize * scale) / 2,
  //         top: currentTop - (orbitImageSize * scale) / 2,
  //         child: Opacity(
  //           opacity: opacity,
  //           child: Transform.rotate(
  //             angle: rotationAngle * animationValue, // Rotate as it animates in
  //             child: Transform.scale(
  //               scale: scale,
  //               child: Container(
  //                 width: orbitImageSize,
  //                 height: orbitImageSize,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(12),
  //                   color: Colors.grey[300],
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withOpacity(0.1),
  //                       blurRadius: 8,
  //                       offset: const Offset(0, 3),
  //                     ),
  //                   ],
  //                 ),
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(12),
  //                   child: _getProfileImage(index),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Helper method to build animated orbiting images (outside to inside)
  // offsetX and offsetY are the final positions from Stack center
  // Images animate from outside (further away) to these final positions
  // size: varies per image (some small, some normal, some larger)
  // rotationAngle: varies per image (left tilt = negative, right tilt = positive)
  Widget _buildOrbitingImageAnimated(
    PeoplesStoriesSplashController controller,
    BuildContext context,
    int index,
    double offsetX,
    double offsetY,
    double rotationAngle,
    double orbitImageSize,
  ) {
    // Calculate direction vector from center to final position
    final distance = math.sqrt(offsetX * offsetX + offsetY * offsetY);
    final directionX = distance > 0 ? offsetX / distance : 0.0;
    final directionY = distance > 0 ? offsetY / distance : 0.0;

    // Start position is further outside (3x the distance)
    const outsideMultiplier = 3.0;
    final startOffsetX = offsetX + (directionX * distance * outsideMultiplier);
    final startOffsetY = offsetY + (directionY * distance * outsideMultiplier);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final centerX = screenWidth / 2;
    final centerY = screenHeight / 2;

    // Final positions
    final finalLeft = centerX + offsetX - orbitImageSize / 2;
    final finalTop = centerY + offsetY - orbitImageSize / 2;

    // Start positions
    final startLeft = centerX + startOffsetX - orbitImageSize / 2;
    final startTop = centerY + startOffsetY - orbitImageSize / 2;

    return AnimatedBuilder(
      animation: controller.getOrbitAnimation(index),
      builder: (context, child) {
        final animationValue = controller.getOrbitAnimation(index).value;

        // Interpolate from outside position to final position
        final currentLeft =
            startLeft + (finalLeft - startLeft) * animationValue;
        final currentTop = startTop + (finalTop - startTop) * animationValue;

        // Scale from small (0.3) to final size (1.0) as it comes in
        final scale = 0.3 + (1.0 - 0.3) * animationValue;

        // Opacity fade in
        final opacity = animationValue;

        // Final rotation angle (applied immediately, not animated during slide-in)
        final finalRotation = rotationAngle;

        return Positioned(
          left: currentLeft,
          top: currentTop,
          child: Opacity(
            opacity: opacity,
            child: Transform.rotate(
              angle: finalRotation,
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: orbitImageSize,
                  height: orbitImageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _getProfileImage(index),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // // Helper method to build static orbiting images (no animation)
  // // left and top are offsets from Stack center (since Stack has alignment.center)
  // Widget _buildOrbitingImageStatic(
  //   BuildContext context,
  //   int index,
  //   double offsetX,
  //   double offsetY,
  //   double rotationAngle,
  // ) {
  //   const orbitImageSize = 75.0;

  //   return Positioned(
  //     left:
  //         MediaQuery.of(context).size.width / 2 + offsetX - orbitImageSize / 2,
  //     top:
  //         MediaQuery.of(context).size.height / 2 + offsetY - orbitImageSize / 2,
  //     child: Transform.rotate(
  //       angle: rotationAngle,
  //       child: Container(
  //         width: orbitImageSize,
  //         height: orbitImageSize,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(12),
  //           color: Colors.grey[300],
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.1),
  //               blurRadius: 8,
  //               offset: const Offset(0, 3),
  //             ),
  //           ],
  //         ),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(12),
  //           child: _getProfileImage(index),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _getProfileImage(int index) {
    // Using available images from ImageConstant - cycling through available images
    final imageAssets = [
      ImageConstant.care_hub_img_1,
      ImageConstant.care_hub_img_2,
      ImageConstant.care_hub_img_3,
      ImageConstant.care_hub_healthy_diet_img,
      ImageConstant.care_hub_new_treatments_img,
      ImageConstant.care_hub_self_care_img,
      ImageConstant.care_hub_basic_exercises_img,
      ImageConstant.care_hub_article_img,
      ImageConstant.care_hub_documents_img,
    ];

    final imagePath = imageAssets[index % imageAssets.length];

    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Fallback colors if image fails to load
        final colors = [
          Colors.blue[300],
          Colors.green[300],
          Colors.orange[300],
          Colors.purple[300],
          Colors.pink[300],
          Colors.teal[300],
          Colors.amber[300],
          Colors.red[300],
          Colors.cyan[300],
        ];

        return Container(
          color: colors[index % colors.length],
          child: Icon(Icons.person, size: 35, color: Colors.white),
        );
      },
    );
  }

  Widget _buildExploreButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Use offNamed to replace the splash screen route
        // This ensures back button goes to previous screen (home) instead of splash
        Get.offNamed(AppRoutes.peoplesStoriesScreen);
      },
      child: Container(
        width: 260,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            100,
          ), // Fully rounded (pill shape)
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3865FF), // Bright blue from design
              Color(0xFF223D99), // Darker blue from design
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Explore Stories',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                JamIcons.chevronsRight,
                color: AppColors.black,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
