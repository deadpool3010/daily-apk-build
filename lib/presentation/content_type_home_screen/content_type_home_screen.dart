import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/presentation/content_type_home_screen/controller/content_type_home_screen_controller.dart';

class ContentTypeHomeScreen extends StatelessWidget {
  const ContentTypeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContentTypeHomeScreenController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: controller.showHeaderImage
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: controller.showHeaderImage
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F9FF),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20, top: 16),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                JamIcons.chevronLeft,
                size: 26,
                color: controller.showHeaderImage
                    ? Colors.white
                    : AppColors.black,
              ),
            ),
          ),
          leadingWidth: 50,
        ),
        extendBodyBehindAppBar: controller.showHeaderImage,
        body: SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with image and fixed search bar (conditionally shown)
              if (controller.showHeaderImage)
                SizedBox(
                  width: double.infinity,
                  height: 220,
                  child: Stack(
                    children: [
                      // Image
                      Positioned.fill(
                        child: Image.asset(
                          ImageConstant.content_type_img_1,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: const Color(0xFFF3F9FF));
                          },
                        ),
                      ),

                      // Bottom shadow / fade (FORCED on top)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 160, // MUST be visible
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0xFFF3F9FF), // noticeable
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (controller.showHeaderImage) const SizedBox(height: 20),
              if (!controller.showHeaderImage) const SizedBox(height: 10),
              _buildSearchBar(),
              // Main Content
              Container(
                color: Color(0xFFF3F9FF),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Article Cards Section
                    // Popular Articles Section
                    _buildPopularArticlesHeader(),

                    const SizedBox(height: 16),

                    // Popular Articles Horizontal List
                    Builder(
                      builder: (context) {
                        // Dynamic height calculation: image (240) + spacing (10) + title max 2 lines (~48) + spacing (8) + author (~18) + spacing (4) + date (~18) = ~346
                        // Using screen height percentage for better responsiveness
                        final screenHeight = MediaQuery.of(context).size.height;
                        final dynamicHeight = (screenHeight * 0.4).clamp(
                          310.0,
                          350.0,
                        );

                        return SizedBox(
                          height: dynamicHeight,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: 4,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 26),
                            itemBuilder: (context, index) {
                              final articles = [
                                {
                                  'image': ImageConstant.care_hub_img_2,
                                  'title': 'New Treatment goes viral !!!',
                                  'author': 'Dr. Mukesh Kumar',
                                  'date': 'Dec 18, 2025',
                                },
                                {
                                  'image': ImageConstant.care_hub_img_3,
                                  'title': 'New Diet for Cancer Patient',
                                  'author': 'Dr. Sohail Ali',
                                  'date': 'Nov 09, 2025',
                                },
                                {
                                  'image': ImageConstant.care_hub_img_2,
                                  'title': 'New Diet for Cancer Patient',
                                  'author': 'Dr. Sohail Ali',
                                  'date': 'Nov 09, 2025',
                                },
                                {
                                  'image': ImageConstant.care_hub_img_3,
                                  'title': 'New Diet for Cancer Patient',
                                  'author': 'Dr. Sohail Ali',
                                  'date': 'Nov 09, 2025',
                                },
                              ];
                              final article = articles[index];
                              return _buildArticleCard(
                                article,
                                'popular_article_$index',
                              );
                            },
                          ),
                        );
                      },
                    ),

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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularArticlesHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Popular Articles for you',
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
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Articles, Documents, People\'s Stories....',
          hintStyle: GoogleFonts.lato(
            fontSize: 14,
            color: const Color(0xFFB8B8B8),
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.1),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.1),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.1),
              width: 1,
            ),
          ),
          suffixIcon: const Icon(
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
    );
  }

  Widget _buildArticleCard(Map<String, String> article, String heroTag) {
    return GestureDetector(
      onTap: () {
        final arguments = Map<String, dynamic>.from(article);
        arguments['heroTag'] = heroTag;
        arguments['imageUrl'] = article['image'];
        // Add tags for article content type
        arguments['tags'] = [
          'Patient Reference',
          'Healthy Diet Articles',
          'Self Help',
        ];
        Get.toNamed(AppRoutes.blogScreen, arguments: arguments);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Hero(
                tag: heroTag,
                child: Image.asset(
                  article['image']!,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 240,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Article Content
          Text(
            article['title']!,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '- ${article['author']!}',
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            article['date']!,
            style: GoogleFonts.lato(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryColor,
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

    // Default description for all items
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
            final heroTag = 'content_just_for_you_$index';

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
                        'title': 'Article Story',
                        'author': 'CareHub Team',
                        'date': DateTime.now().toString().split(' ')[0],
                        'description': defaultDescription,
                        'tags': [
                          'Patient Reference',
                          'Healthy Diet Articles',
                          'Self Help',
                        ],
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

    // Default description for all items
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
            final heroTag = 'content_curated_$index';

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
                        'title': 'Article Story',
                        'author': 'CareHub Team',
                        'date': DateTime.now().toString().split(' ')[0],
                        'description': defaultDescription,
                        'tags': [
                          'Patient Reference',
                          'Healthy Diet Articles',
                          'Self Help',
                        ],
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
