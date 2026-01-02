import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bandhucare_new/presentation/affirmations_screen/controller/affirmations_screen_controller.dart';

class AffirmationsScreen extends StatelessWidget {
  const AffirmationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AffirmationsScreenController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F9FF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF3F9FF),
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                JamIcons.chevronLeft,
                size: 26,
                color: AppColors.black,
              ),
            ),
          ),
          leadingWidth: 50,
          title: Text(
            'Affirmations',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image.asset(
                ImageConstant.care_hub,
                width: 68,
                height: 54,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Daily Affirmation Card
              Center(child: _buildDailyAffirmationCard(context)),

              const SizedBox(height: 30),

              // Just for You Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Just for You :)',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'See All',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Just for You Horizontal List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildJustForYouSection(),
              ),

              const SizedBox(height: 30),

              // Curated for You Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Curated for You',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'See All',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Curated for You Horizontal List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildCuratedForYouSection(),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyAffirmationCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.85,
      height: 234,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: screenWidth * 0.85,
              height: 108,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFF014E99),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 89.37,
            child: Container(
              width: screenWidth * 0.85,
              height: 144.63,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstant.clouds),
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 19,
            bottom: 19,
            child: SizedBox(
              width: 108,
              height: 18,
              child: Text(
                '-Misty Copeland',
                textAlign: TextAlign.right,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    color: const Color(0xFFFFE16B),
                    fontSize: 14.0,
                  ),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Positioned(
            left: 19,
            top: 27,
            right: 19,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: AppColors.white.withOpacity(0.11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Be strong, be fearless, be happy. And believe that anything is possible when you have the right people there to support you.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(color: AppColors.white, fontSize: 13.0),
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJustForYouSection() {
    final images = [
      ImageConstant.care_hub_healthy_diet_img,
      ImageConstant.care_hub_new_treatments_img,
      ImageConstant.care_hub_healthy_diet_img,
      ImageConstant.care_hub_new_treatments_img,
    ];

    // Default description for all items (if not provided)
    const defaultDescription =
        'I woke up to the soft light filtering through my window, and for the first time in a while, I didn\'t rush to check my phone. Instead, I took a deep breath and stretched, feeling my body wake up slowly.';

    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: images.asMap().entries.map((entry) {
            final index = entry.key;
            final image = entry.value;
            final heroTag = 'just_for_you_$index';

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.blogScreen,
                      arguments: {
                        'imageUrl': image,
                        'heroTag': heroTag,
                        'title': 'Affirmation Story',
                        'author': 'CareHub Team',
                        'date': DateTime.now().toString().split(' ')[0],
                        'description': defaultDescription,
                        'tags': ['Affirmations', 'Self Help', 'Motivation'],
                      },
                    );
                  },
                  child: Hero(
                    tag: heroTag,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image,
                            size: 30,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCuratedForYouSection() {
    final images = [
      ImageConstant.care_hub_self_care_img,
      ImageConstant.care_hub_basic_exercises_img,
      ImageConstant.care_hub_healthy_diet_img,
      ImageConstant.care_hub_new_treatments_img,
    ];

    // Default description for all items (if not provided)
    const defaultDescription =
        'I woke up to the soft light filtering through my window, and for the first time in a while, I didn\'t rush to check my phone. Instead, I took a deep breath and stretched, feeling my body wake up slowly.';

    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: images.asMap().entries.map((entry) {
            final index = entry.key;
            final image = entry.value;
            final heroTag = 'curated_$index';

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.blogScreen,
                      arguments: {
                        'imageUrl': image,
                        'heroTag': heroTag,
                        'title': 'Affirmation Story',
                        'author': 'CareHub Team',
                        'date': DateTime.now().toString().split(' ')[0],
                        'description': defaultDescription,
                        'tags': ['Affirmations', 'Self Help', 'Motivation'],
                      },
                    );
                  },
                  child: Hero(
                    tag: heroTag,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image,
                            size: 30,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
