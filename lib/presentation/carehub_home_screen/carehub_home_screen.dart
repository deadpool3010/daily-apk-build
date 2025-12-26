import 'package:bandhucare_new/core/app_exports.dart';

class CarehubHomeScreen extends StatelessWidget {
  const CarehubHomeScreen({super.key});

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: GestureDetector(
                      onTap: () => Get.back(),
                      child:  Icon(
                    JamIcons.chevronLeft,
                        size: 26,
                        color: AppColors.black,
                      ),
                    ),
            ),
            // Header with back button and logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CareHub Logo - placeholder using text with icon
                  Row(
                    children: [
                      Image.asset(ImageConstant.care_hub, width: 140, height: 140),
                      
                      
                    ],
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 20),
      
            // Search Bar
            Padding(
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            ),
      
            const SizedBox(height: 30),
      
            // Popular Articles Section
            Padding(
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
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 16),
      
            // Popular Articles Horizontal List
            Builder(
              builder: (context) {
                // Dynamic height calculation: image (240) + spacing (10) + title max 2 lines (~48) + spacing (8) + author (~18) + spacing (4) + date (~18) = ~346
                // Using screen height percentage for better responsiveness
                final screenHeight = MediaQuery.of(context).size.height;
                final dynamicHeight = (screenHeight * 0.4).clamp(310.0, 350.0);
                
                return SizedBox(
                  height: dynamicHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 3,
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final articles = [
                        {
                          'image': ImageConstant.care_hub_img_1,
                          'title': 'New Treatment goes viral !!!',
                          'author': 'Dr. Mukesh Kumar',
                          'date': 'Dec 18, 2025',
                        },
                        {
                          'image': ImageConstant.care_hub_img_2,
                          'title': 'New Diet for Cancer Patient',
                          'author': 'Dr. Sohail Ali',
                          'date': 'Nov 09, 2025',
                        },
                        {
                          'image': ImageConstant.care_hub_img_1,
                          'title': 'New Diet for Cancer Patient',
                          'author': 'Dr. Sohail Ali',
                          'date': 'Nov 09, 2025',
                        },
                      ];
                      final article = articles[index];
                      return _buildArticleCard(article);
                    },
                  ),
                );
              },
            ),
      
            // const SizedBox(height: 0),
      
            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
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
                        // color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 16),
      
            // Categories Horizontal List
            SizedBox(
              height: 122,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 4,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final categories = [
                    {
                      'image': ImageConstant.care_hub_article_img,
                      'title': 'Articles',
                      'count': '20+',
                    },
                    {
                      'image': ImageConstant.care_hub_documents_img,
                      'title': 'Documents',
                      'count': '40+',
                    },
                    {
                      'image': ImageConstant.care_hub_affirmation_img,
                      'title': 'Affirmation',
                      'count': '100+',
                    },
                    {
                      'image': ImageConstant.care_hub_people_img,
                      'title': 'People\'s Stories',
                      'count': '40+',
                    },
                  ];
                  final category = categories[index];
                  return _buildCategoryCard(
                    image: category['image']!,
                    title: category['title']!,
                    count: category['count']!,
                  );
                },
              ),
            ),
      
            const SizedBox(height: 30),
      
            // Content Types Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Content Types',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 16),
      
            // Content Types Grid
            Builder(
              builder: (context) {
                final screenWidth = MediaQuery.of(context).size.width;
                final padding = 20.0;
                final gap = 10.0;
                final availableWidth = screenWidth - (padding * 2);
                final cardWidth = (availableWidth - gap) / 2;
                
                final contentTypes = [
                  {
                    'image': ImageConstant.care_hub_healthy_diet_img,
                    'title': 'Healthy Diet',
                  },
                  {
                    'image': ImageConstant.care_hub_new_treatments_img,
                    'title': 'New Treatments',
                  },
                  {
                    'image': ImageConstant.care_hub_self_care_img,
                    'title': 'Self Care',
                  },
                  {
                    'image': ImageConstant.care_hub_basic_exercises_img,
                    'title': 'Basic Exercises',
                  },
                ];
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: contentTypes.map((contentType) {
                      return _buildContentTypeCard(
                        width: cardWidth,
                        image: contentType['image']!,
                        title: contentType['title']!,
                      );
                    }).toList(),
                  ),
                );
              },
            ),
      
            const SizedBox(height: 30),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(Map<String, String> article) {
    return Column(
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
            borderRadius: const BorderRadius.all( Radius.circular(20)),
            child: Image.asset(
              article['image']!,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 140,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                );
              },
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
    );
  }

  Widget _buildCategoryCard({
    required String image,
    required String title,
    required String count,
  }) {
    return Container(
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
                  child: const Icon(Icons.image, size: 30, color: Colors.grey),
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
    );
  }

  Widget _buildContentTypeCard({
    required double width,
    required String image,
    required String title,
  }) {
    return Container(
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
                    child: const Icon(Icons.image, size: 30, color: Colors.grey),
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
    );
  }
}

