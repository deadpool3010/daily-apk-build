import 'package:bandhucare_new/core/export_file/app_exports.dart';

class PeoplesStoriesScreen extends StatelessWidget {
  const PeoplesStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
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
            'People\'s Stories',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w500,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Most Recents Section
              _buildMostRecentsSection(),
              const SizedBox(height: 40),
              // All time Favorites Section
              _buildAllTimeFavoritesSection(),
              const SizedBox(height: 10),
              // True Strength Section
              _buildTrueStrengthSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMostRecentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Most Recents',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to all recents
                },
                child: Text(
                  'See All',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Two side-by-side story cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _buildRecentStoryCard(
                  heroTag: 'story_1',
                  imageUrl: ImageConstant.peoples_stories_img_1,
                  quote: 'I found strength I didn\'t know I had.',
                  author: 'Shreya',
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.blogScreen,
                      arguments: {
                        'imageUrl': ImageConstant.peoples_stories_img_1,
                        'heroTag': 'story_1',
                        'title': 'I found strength I didn\'t know I had.',
                        'author': 'Shreya',
                        'date': DateTime.now().toString().split(' ')[0],
                        'tags': ['People\'s Stories', 'Inspiration', 'Journey'],
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildRecentStoryCard(
                  heroTag: 'story_2',
                  imageUrl: ImageConstant.peoples_stories_img_1,
                  quote: 'My journey reshaped ho I see life.',
                  author: 'Radhamma',
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.blogScreen,
                      arguments: {
                        'imageUrl': ImageConstant.peoples_stories_img_1,
                        'heroTag': 'story_2',
                        'title': 'My journey reshaped ho I see life.',
                        'author': 'Radhamma',
                        'date': DateTime.now().toString().split(' ')[0],
                        'tags': ['People\'s Stories', 'Inspiration', 'Journey'],
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentStoryCard({
    required String heroTag,
    required String imageUrl,
    required String quote,
    required String author,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image with Hero Animation
            Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
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
            // Purple gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
                    Color(0xFF3865FF).withOpacity(0.4),
                    Color(0xFF3865FF).withOpacity(0.7),
                  ],
                  stops: const [0.0, 0.3, 0.5, 0.8, 1.0],
                ),
              ),
            ),
            // Quote and button overlay
            Positioned(
              bottom: -6,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '"$quote"\n-$author',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    const SizedBox(height: 12),
                    // Read Story Button
                    GestureDetector(
                      onTap: () {
                        // Navigate to story
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Read Story',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
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

  Widget _buildAllTimeFavoritesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All time Favorites',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to all favorites
                },
                child: Text(
                  'See All',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Journey Cards with thread background
        Container(
          height: 355,
          decoration: const BoxDecoration(color: Color(0xFFF3F9FF)),
          child: Stack(
            children: [
              // Background thread/string
              Positioned(
                top: 25,
                left: 0,
                right: 0,
                child: CustomPaint(painter: ThreadPainter()),
              ),
              // Journey cards
              ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 15,
                  bottom: 15,
                ),
                itemCount: 2,
                separatorBuilder: (context, index) => const SizedBox(width: 50),
                itemBuilder: (context, index) {
                  final journeyData = [
                    {
                      'imageUrl':
                          'https://t4.ftcdn.net/jpg/06/33/37/89/360_F_633378965_iRc8bqmOoxkrAlYKvNcBqUhqGXNBmfTB.jpg',
                      'title': 'Sita Amma\'s Journey',
                      'description':
                          'After her 6-month treatment, Sita Amma began walking every morning again. She says, "I found my strength in small steps and big smiles."',
                      'buttonText': 'Read Her Story',
                      'rotation': 0.01,
                    },
                    {
                      'imageUrl':
                          'https://t4.ftcdn.net/jpg/06/33/37/89/360_F_633378965_iRc8bqmOoxkrAlYKvNcBqUhqGXNBmfTB.jpg',
                      'title': 'Natasha\'s Journey',
                      'description':
                          'After her 6-month treatment, walking every morning again. "I found my strength in small smiles."',
                      'buttonText': 'Read Her Story',
                      'rotation': -0.02,
                    },
                  ];
                  final data = journeyData[index];
                  return JourneyCard(
                    imageUrl: data['imageUrl'] as String,
                    title: data['title'] as String,
                    description: data['description'] as String,
                    buttonText: data['buttonText'] as String,
                    rotation: data['rotation'] as double,
                    index: index,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrueStrengthSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'True Strength',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to all quotes
                },
                child: Text(
                  'See All',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Quote Cards ListView
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 3,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final quotesData = [
                {
                  'quote':
                      'I learned that strength doesn\'t always look loud—it often looks like simply continuing.',
                  'name': 'Manish Reddy',
                  'affiliation': 'Student, Gitan College',
                  'imageUrl':
                      'https://t4.ftcdn.net/jpg/06/33/37/89/360_F_633378965_iRc8bqmOoxkrAlYKvNcBqUhqGXNBmfTB.jpg',
                },
                {
                  'quote':
                      'Every small step forward is a victory worth celebrating on this journey.',
                  'name': 'Priya Sharma',
                  'affiliation': 'Teacher, Delhi School',
                  'imageUrl':
                      'https://t4.ftcdn.net/jpg/06/33/37/89/360_F_633378965_iRc8bqmOoxkrAlYKvNcBqUhqGXNBmfTB.jpg',
                },
                {
                  'quote':
                      'Hope is not the absence of struggle, but finding light within it.',
                  'name': 'Rajesh Kumar',
                  'affiliation': 'Engineer, Tech Corp',
                  'imageUrl':
                      'https://t4.ftcdn.net/jpg/06/33/37/89/360_F_633378965_iRc8bqmOoxkrAlYKvNcBqUhqGXNBmfTB.jpg',
                },
              ];
              final data = quotesData[index];
              return _buildQuoteCard(
                quote: data['quote'] as String,
                name: data['name'] as String,
                affiliation: data['affiliation'] as String,
                imageUrl: data['imageUrl'] as String,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteCard({
    required String quote,
    required String name,
    required String affiliation,
    required String imageUrl,
  }) {
    return Container(
      width: 360,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE5EFFE),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quote icon and dots
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF3865FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  TablerIcons.quote,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF3865FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Quote text
          Expanded(
            child: Text(
              quote,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
                height: 1.5,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 20),
          // Author info
          Row(
            children: [
              // Profile picture
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 24,
                        color: Colors.grey[600],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name and affiliation
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      affiliation,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black.withOpacity(0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for the thread/string background
class ThreadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          const Color(0xFFD0D0D0) // Light gray thread color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw horizontal thread line at approximately bottom third of the container
    final threadY = size.height * 0.65; // Position thread at bottom third
    canvas.drawLine(Offset(0, threadY), Offset(size.width, threadY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
