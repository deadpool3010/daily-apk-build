import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/presentation/carehub_home_screen/controller/carehub_home_screen_controller.dart';
import 'package:bandhucare_new/model/homepage_model.dart';
import 'package:bandhucare_new/presentation/home_screen/home_screen_helper.dart';

class CarehubHomeScreen extends StatelessWidget {
  const CarehubHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CarehubHomeScreenController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F9FF),
        body: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xFFF3F9FF),
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              pinned: true,
              expandedHeight: 220,
              floating: false,
              snap: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 20, top: 16),
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
              title: FadeTransition(
                opacity: controller.titleFadeAnimation,
                child: Text(
                  'Care Hub',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ),
              centerTitle: true,
              // bottom: _buildAppBarBottom(controller),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: AnimatedBuilder(
                  animation: controller.titleAnimationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 1 - controller.titleFadeAnimation.value,
                      child: Container(
                        color: const Color(0xFFF3F9FF),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),
                            // CareHub Logo
                            Image.asset(
                              ImageConstant.care_hub,
                              width: 140,
                              height: 140,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Search Bar
                  // FadeTransition(
                  //   opacity: ReverseAnimation(
                  //     controller.searchBarFadeAnimation,
                  //   ),
                  //   child: _buildSearchBar(),
                  // ),

                  const SizedBox(height: 0),

                  // // Test TipTap Button (Remove after testing)
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: ElevatedButton.icon(
                  //     onPressed: BlogScreenNavigationExample.navigateWithTiptapContent,
                  //     icon: const Icon(Icons.article, color: Colors.white),
                  //     label: Text(
                  //       'Test TipTap Blog',
                  //       style: GoogleFonts.lato(
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.w600,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: AppColors.primaryColor,
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 20,
                  //         vertical: 12,
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 0),

                  // Recommended for you Section
                  FadeTransition(
                    opacity: ReverseAnimation(
                      controller.searchBarFadeAnimation,
                    ),
                    child: _buildRecommendedHeader(),
                  ),

                  const SizedBox(height: 16),

                  // Recommended Articles Horizontal List
                  Obx(() {
                    final articles = controller.articles;
                    if (articles.isEmpty && controller.isLoading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (articles.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Builder(
                      builder: (context) {
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
                            itemCount: articles.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 26),
                            itemBuilder: (context, index) {
                              final article = articles[index];
                              // Format date
                              String formattedDate = '';
                              try {
                                final dateTime = DateTime.parse(article.createdAt);
                                final months = [
                                  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                                ];
                                formattedDate =
                                    '${months[dateTime.month - 1]} ${dateTime.day.toString().padLeft(2, '0')}, ${dateTime.year}';
                              } catch (e) {
                                formattedDate = article.createdAt;
                              }
                              return _buildArticleCardFromModel(
                                article,
                                formattedDate,
                                'carehub_recommended_article_$index',
                              );
                            },
                          ),
                        );
                      },
                    );
                  }),

                  const SizedBox(height: 30),

                  // Inspirational Stories Section
                  _buildInspirationalStoriesHeader(),

                  const SizedBox(height: 16),

                  // Inspirational Stories Horizontal List
                  Obx(() {
                    final stories = controller.stories;
                    if (stories.isEmpty && controller.isLoading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (stories.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Builder(
                      builder: (context) {
                        // Rotation list with 4 predefined rotations
                        final rotationList = [0.02, -0.02, 0.03, -0.01];
                        return SizedBox(
                          height: 250,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: stories.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 20),
                            itemBuilder: (context, index) {
                              final story = stories[index];
                              final rotation = rotationList[index % rotationList.length];
                              return _buildInspirationalStoryCard(
                                imageUrl: story.coverImage?.fileUrl ?? '',
                                quote: story.description,
                                patientName: story.title,
                                rotation: rotation,
                                onTap: () {
                                  final arguments = {
                                    'contentId': story.id,
                                    'heroTag': 'carehub_story_${story.id}',
                                    'imageUrl': story.coverImage?.fileUrl ?? '',
                                    'title': story.title,
                                    'date': story.createdAt,
                                  };
                                  Get.toNamed(AppRoutes.blogScreen, arguments: arguments);
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  }),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
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

  Widget _buildArticleCardFromModel(
    CarehubArticle article,
    String formattedDate,
    String heroTag,
  ) {
    return GestureDetector(
      onTap: () {
        final arguments = {
          'contentId': article.id,
          'heroTag': heroTag,
          'imageUrl': article.coverImage?.fileUrl ?? '',
          'title': article.title,
          'date': formattedDate,
          'tags': article.tags.map((tag) => tag['name']).toList(),
        };
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
                child: article.coverImage != null &&
                        article.coverImage!.fileUrl.isNotEmpty
                    ? DelayedImageWithShimmer(
                        imageUrl: article.coverImage!.fileUrl,
                        width: double.infinity,
                        height: 240,
                        fit: BoxFit.cover,
                        fallbackWidget: Container(
                          width: double.infinity,
                          height: 240,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 240,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Article Content
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                article.title,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                formattedDate,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String image,
    required String title,
    required String count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 132,
        height: 122,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color(0xFFF5F9FF), // Light blue
              Color(0xFFCFE4FF), // Darker light blue
            ],
          ),
        ),
        child: Stack(
          children: [
            // Title at top
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Image in center
            Positioned(
              // top: 0,
              left: 12,
              // right: 0,
              bottom: 10,
              child: Image.asset(
                image,
                width: 70,
                height: 70,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 70,
                    height: 70,
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
            // Count at bottom right
            if (count.isNotEmpty)
              Positioned(
                bottom: 8,
                right: 12,
                child: Text(
                  count,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentTypeCard({
    required double width,
    required String image,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {
        // Only navigate for "Healthy Diet" from Content Types
        if (title == 'Healthy Diet') {
          Get.toNamed(
            AppRoutes.contentTypeHomeScreen,
            arguments: {'showHeaderImage': true},
          );
        }
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xFFE5EFFE), // Light blue background
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
                  width: 55,
                  height: 55,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 55,
                      height: 55,
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
              const SizedBox(width: 10),
              // Title - Expanded to prevent overflow
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInspirationalStoryCard({
    required String imageUrl,
    required String quote,
    required String patientName,
    required double rotation,
    required VoidCallback onTap,
  }) {
    // Gradient colors from the design: transparent black (0% opacity) to solid blue #3865FF (100% opacity)
    const gradientStartColor = Color(0xFF000000); // Black
    const gradientEndColor = Color(0xFF3865FF); // Blue
    return Container(
      width: 175,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.15).withOpacity(0.0),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            // Gradient overlay at bottom - matches design: 0% transparent black to 100% solid blue
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      gradientStartColor.withOpacity(0.0), // 0% - transparent black
                      gradientEndColor.withOpacity(1.0), // 100% - solid blue #3865FF
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
            // Content overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quote text
                    // Text(
                    //   '"$quote"',
                    //   style: GoogleFonts.roboto(
                    //     fontSize: 13,
                    //     fontWeight: FontWeight.w500,
                    //     color: Colors.white,
                    //     height: 1.3,
                    //   ),
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    const SizedBox(height: 8),
                    // Patient name
                    Text(
                      '- $patientName',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Read Story button
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Read Story',
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              TablerIcons.arrow_up_right,
                              size: 18,
                              color: Colors.white,
                            ),
                          ],
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

  Widget _buildRecommendedHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recommended for you',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRoutes.articlesScreen,
                arguments: {'type': 'articles'},
              );
            },
            child: Text(
              'View all →',
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspirationalStoriesHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Inspirational Stories just for you',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRoutes.storiesScreen,
                arguments: {'type': 'stories'},
              );
            },
            child: Text(
              'View all →',
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBarBottom(
    CarehubHomeScreenController controller,
  ) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AnimatedBuilder(
        animation: controller.searchBarFadeAnimation,
        builder: (context, child) {
          if (controller.searchBarFadeAnimation.value < 0.01) {
            return const SizedBox.shrink();
          }
          return AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            child: FadeTransition(
              opacity: controller.searchBarFadeAnimation,
              child: SlideTransition(
                position: controller.searchBarSlideAnimation,
                child: Container(
                  color: const Color(0xFFF3F9FF),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [_buildSearchBar()],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
