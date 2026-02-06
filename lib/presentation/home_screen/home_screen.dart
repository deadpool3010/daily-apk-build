import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/core/controller/session_controller.dart';
import 'package:bandhucare_new/core/utils/string_utils.dart';
import 'package:bandhucare_new/presentation/home_screen/home_screen_helper.dart';
import 'package:bandhucare_new/widget/appointment_card.dart';
import 'package:bandhucare_new/model/homepage_model.dart';

bool isBottomNavVisible = true;

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

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  late final HomepageController controller;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomepageController>();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isBottomNavVisible) {
          setState(() => isBottomNavVisible = false);
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // user scrolls UP → show
        if (!isBottomNavVisible) {
          setState(() => isBottomNavVisible = true);
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        // Close app when back is pressed on home screen
        SystemNavigator.pop();
      },
      child: GetBuilder<SessionController>(
        builder: (sessionController) => Scaffold(
          backgroundColor: const Color(0xFFF3F9FF),
          extendBodyBehindAppBar: true,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            ),
            child: Stack(
              children: [
                // CustomScrollView with SliverAppBar
                CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    // SliverAppBar with flexible space for header image
                    SliverAppBar(
                      expandedHeight: size.height * 0.13,
                      floating: false,
                      pinned: false,
                      snap: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        systemNavigationBarColor: Colors.transparent,
                        statusBarIconBrightness: Brightness.dark,
                      ),
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Header background image
                            Positioned(
                              top: statusBarHeight + 20,
                              right: 20,
                              child: Row(
                                children: [
                                  // Bell Icon with light blue background
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3F2FD),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(TablerIcons.bell, size: 26),
                                        const SizedBox(width: 10),
                                        Obx(() {
                                          final hospitalImage =
                                              controller.hospitalImageUrl.value;
                                          return SizedBox(
                                            width: 40,
                                            height: 40,
                                            child:
                                                hospitalImage != null &&
                                                    hospitalImage.isNotEmpty
                                                ? ClipOval(
                                                    child:
                                                        DelayedImageWithShimmer(
                                                          imageUrl:
                                                              hospitalImage,
                                                          width: 40,
                                                          height: 40,
                                                          fit: BoxFit.contain,
                                                          fallbackWidget:
                                                              Image.asset(
                                                                ImageConstant
                                                                    .hospitalLogo,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                        ),
                                                  )
                                                : Image.asset(
                                                    ImageConstant.hospitalLogo,
                                                    fit: BoxFit.contain,
                                                  ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: statusBarHeight + 20,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: Color(0xFF898A8D),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    () {
                                      final userName =
                                          sessionController.user?.name;
                                      return userName != null &&
                                              userName.isNotEmpty
                                          ? '${StringUtils.getFirstName(userName)}!'
                                          : 'Hello!';
                                    }(),
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Scrollable content
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Horizontal scrollable feelings cards
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: AppointmentCard(),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Quick Actions Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Quick Actions',
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _buildQuickActions(),
                          ),
                          const SizedBox(height: 30),

                          // Articles Curated just for you Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Articles Curated just for you',
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    'See All',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Articles Horizontal List
                          Obx(() {
                            final articles = controller.articles;
                            if (articles.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Builder(
                              builder: (context) {
                                final screenHeight = MediaQuery.of(
                                  context,
                                ).size.height;
                                final dynamicHeight = (screenHeight * 0.4)
                                    .clamp(310.0, 350.0);
                                return SizedBox(
                                  height: dynamicHeight,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    itemCount: articles.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(width: 16),
                                    itemBuilder: (context, index) {
                                      final article = articles[index];
                                      // Format date
                                      String formattedDate = '';
                                      try {
                                        final dateTime = DateTime.parse(
                                          article.createdAt,
                                        );
                                        final months = [
                                          'Jan',
                                          'Feb',
                                          'Mar',
                                          'Apr',
                                          'May',
                                          'Jun',
                                          'Jul',
                                          'Aug',
                                          'Sep',
                                          'Oct',
                                          'Nov',
                                          'Dec',
                                        ];
                                        formattedDate =
                                            '${months[dateTime.month - 1]} ${dateTime.day.toString().padLeft(2, '0')}, ${dateTime.year}';
                                      } catch (e) {
                                        formattedDate = article.createdAt;
                                      }
                                      return _buildArticleCardFromModel(
                                        article,
                                        formattedDate,
                                        'home_article_$index',
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }),
                          // const SizedBox(height: 30),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 20),
                          //   child: Text(
                          //     'Daily Affirmations / Reminders',
                          //     style: GoogleFonts.roboto(
                          //       textStyle: TextStyle(
                          //         color: AppColors.black,
                          //         fontSize: 18.0,
                          //         fontWeight: FontWeight.w500,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: 14),
                          // Horizontal scrollable affirmation cards
                          // SizedBox(
                          //   height: 250,
                          //   child: ListView.separated(
                          //     scrollDirection: Axis.horizontal,
                          //     padding: const EdgeInsets.symmetric(
                          //       horizontal: 20,
                          //     ),
                          //     itemCount: 3,
                          //     separatorBuilder: (context, index) =>
                          //         const SizedBox(width: 16),
                          //     itemBuilder: (context, index) {
                          //       return DailyAffirmation();
                          //     },
                          //   ),
                          // ),
                          const SizedBox(height: 14),

                          // Meet Our Strong Warriors Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Meet Our Strong Warriors',
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Horizontal scrollable journey cards with thread background
                          Container(
                            height: 355,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F9FF),
                            ),
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
                                  itemCount: 3,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 50),
                                  itemBuilder: (context, index) {
                                    final journeyData = [
                                      {
                                        'imageUrl':
                                            'https://t4.ftcdn.net/jpg/06/33/37/89/360_F_633378965_iRc8bqmOoxkrAlYKvNcBqUhqGXNBmfTB.jpg',
                                        'title': 'Sita Amma\'s Journey',
                                        'description':
                                            'After her 6-month treatment, Sita Amma began walking every morning again. She says, "I found my strength in small steps and big smiles."',
                                        'buttonText': 'Read her Story',
                                        'rotation': 0.02,
                                      },
                                      {
                                        'imageUrl':
                                            'https://t4.ftcdn.net/jpg/06/33/37/89/360_F_633378965_iRc8bqmOoxkrAlYKvNcBqUhqGXNBmfTB.jpg',
                                        'title': 'Natasha\'s Journey',
                                        'description':
                                            'After her 6-month treatment, Natasha began walking every morning again. She says, "I found my strength in small steps and big smiles."',
                                        'buttonText': 'Read her Story',
                                        'rotation': -0.02,
                                      },
                                      {
                                        'imageUrl':
                                            'https://t4.ftcdn.net/jpg/06/33/37/89/360_F_633378965_iRc8bqmOoxkrAlYKvNcBqUhqGXNBmfTB.jpg',
                                        'title': 'Prashanth\'s Story',
                                        'description':
                                            'After his 6-month treatment, Prashanth began walking every morning again. He says, "I found my strength in small steps and big smiles."',
                                        'buttonText': 'Read his Story',
                                        'rotation': 0.03,
                                      },
                                    ];
                                    final data = journeyData[index];
                                    return JourneyCard(
                                      imageUrl: data['imageUrl'] as String,
                                      title: data['title'] as String,
                                      description:
                                          data['description'] as String,
                                      buttonText: data['buttonText'] as String,
                                      rotation: data['rotation'] as double,
                                      index: index,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Shared with heart section
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 24,
                              right: 20,
                              top: 30,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Main text "Shared with heart." with gradient
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      Color(0xFF397BE9).withOpacity(0.4),
                                      Color(0xFF0040FF).withOpacity(0.6),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ).createShader(bounds),
                                  child: Text(
                                    'Shared\nwith heart.',
                                    style: GoogleFonts.alumniSans(
                                      textStyle: TextStyle(
                                        fontSize: 85.0,
                                        fontWeight: FontWeight.w700,
                                        height:
                                            62.84 /
                                            80.0, // Line height: 62.84px
                                        letterSpacing: 1.6, // 2% of 80px
                                        color: Colors
                                            .white, // Will be masked by gradient
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Subtitle "-Built for BandhuCare"
                                Text(
                                  '-Built for BandhuCare',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      color: Color(0xFF4D7EE7),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),

                // Custom bottom navigation bar overlaid on top
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedSlide(
                    duration: Duration(milliseconds: 280),
                    curve: Curves.easeInOut,
                    // 👇 Slide down (hide) & slide up (show)
                    offset: isBottomNavVisible ? Offset(0, 0) : Offset(0, 1),

                    child: CustomBottomBar(controller: controller),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuickActionItem(
          image: ImageConstant.my_clinic,
          label: 'My Clinic',
        ),
        _buildQuickActionItem(
          image: ImageConstant.health_calendar,
          label: 'Health Calendar',
          route: AppRoutes.healthCalendar,
        ),
        _buildQuickActionItem(
          image: ImageConstant.mitra_robot,
          label: 'Bandhu',
          route: AppRoutes.chatbotSplashLoadingScreen,
          // route: Routes.bandhu,
        ),
        _buildQuickActionItem(
          image: ImageConstant.care_hub,
          label: 'Care Hub',
          route: AppRoutes.carehubHomeScreen,
        ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required String label,
    required String image,
    String? route,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                if (route != null) {
                  Get.toNamed(route);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4EEFE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: AppColors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointmentCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF3865FF), // Stop 1: 0% - #3865FF
            const Color(0xFF223D99), // Stop 2: 100% - #223D99
          ],
        ),
        borderRadius: BorderRadius.circular(27),
      ),
      child: Row(
        children: [
          // Left side - Day and Date
          Container(
            padding: const EdgeInsets.only(
              left: 13,
              right: 13,
              top: 11,
              bottom: 11,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE5EFFE), // Stop 1: 0% - #3865FF
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Thu',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Color(0xFF21231E), // Lighter blue
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '23',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Color(0xFF3865FF),
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Right side - Appointment details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appointment with Dr. Vishnu',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: AppColors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Therapy Session',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: AppColors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Color(0xFFDEFF4A),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '11 Am - 01 Pm',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
    HomepageArticle article,
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
          'author': article.author.name,
          'date': formattedDate,
          'tags': ['Patient Reference', 'Healthy Diet Articles', 'Self Help'],
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
                child:
                    article.coverImage != null &&
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
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      '- ${article.author.name}',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
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
}

Widget DailyAffirmation() {
  return Column(
    children: [
      Container(
        width: 317,
        height: 234,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 317,
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
                width: 317,
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
              left: 192,
              top: 135,
              child: SizedBox(
                width: 108,
                height: 18,
                child: Text(
                  'lbl_misty_copeland'.tr,
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
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: AppColors.white.withOpacity(0.11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    SizedBox(
                      width: 249,
                      child: Text(
                        'msg_daily_affirmation_quote'.tr,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color: AppColors.white,
                            fontSize: 13.0,
                          ),
                        ),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
