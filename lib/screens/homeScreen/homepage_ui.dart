import 'package:bandhucare_new/constant/colors.dart';
import 'package:bandhucare_new/constant/image_constant.dart';
import 'package:bandhucare_new/general_widget_&_classes/bottom_text.dart';
import 'package:bandhucare_new/general_widget_&_classes/custom_bottom_navbar.dart';
import 'package:bandhucare_new/routes/routes.dart';
import 'package:bandhucare_new/screens/homeScreen/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../screens/feelings.dart';

bool isBottomNavVisible = true;

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

    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF9),
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
        ),
        child: Stack(
          children: [
            // CustomScrollView with SliverAppBar
            CustomScrollView(
              controller: scrollController,
              slivers: [
                // SliverAppBar with flexible space for header image
                SliverAppBar(
                  expandedHeight: size.height * 0.3,
                  floating: false,
                  pinned: false,
                  snap: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Header background image
                        Image.asset(
                          ImageConstant.headerImage,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                        // Header content overlay
                        Positioned(
                          top: statusBarHeight + 50,
                          right: 10,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.asset(
                                  ImageConstant.hospitalLogo,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: const Color.fromARGB(255, 27, 4, 4),
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: statusBarHeight + 50,
                          left: size.width * 0.05,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Namaste',
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color: AppColors.orangeColor,
                                        fontSize: 24.0,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Siddharth Ji',
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color: AppColors.darkOrangeColor,
                                        fontSize: 24.0,
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
                  ),
                ),

                // Scrollable content
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Daily check-in header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              'Daily check-in with Mitra ',
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Image.asset(
                              ImageConstant.robot,
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Horizontal scrollable feelings cards
                      Container(
                        height: 260,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [Feelings()],
                        ),
                      ),

                      // Additional content can go here
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Categories",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: AppColors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Category container
                      Center(child: categories()),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Daily Affirmation/Remainders",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: AppColors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Horizontal scrollable affirmation cards
                      SizedBox(
                        height: 250,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: 3,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            return DailyAffirmation();
                          },
                        ),
                      ),

                      const SizedBox(height: 30),
                      // Warriors section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Meet Our Strong Warriors",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: AppColors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Horizontal scrollable warrior cards
                      Container(
                        height: 355,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFCF9),
                        ),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),
                          itemCount: 3,
                          separatorBuilder: (context, index) => Container(
                            width: 25,
                            color: const Color(0xFFFFFCF9),
                          ),
                          itemBuilder: (context, index) {
                            final titles = [
                              "Sita Amma's Journey",
                              "Natasha's Journey",
                              "Prashanth's Story",
                            ];
                            final rotations = [0.05, -0.02, -0.05];
                            return _buildWarriorCard(
                              titles[index],
                              "After her 6-month treatment, Sita Amma began walking every morning again. She says, \"I found my strength in small steps and big smiles.\"",
                              rotations[index],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Shared with heart text
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: SharedWithHeart(),
                      ),

                      const SizedBox(height: 40),
                      // Add bottom padding for bottom navigation bar
                      const SizedBox(height: 100),
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
    );
  }
}

Widget categories() {
  return Container(
    width: 360,
    height: 120,
    decoration: BoxDecoration(
      color: const Color(0xFFFBF3E3),
      borderRadius: BorderRadius.circular(24),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryItem(
          ImageConstant.healthCalander,
          'Health \nCalander',
          onTap: () {
            Get.toNamed(AppRoutes.healthCalendar);
          },
        ),
        _buildCategoryItem(ImageConstant.fileManager, 'Manage \nFiles'),
        _buildCategoryItem(ImageConstant.robot, 'Mitra'),
        _buildCategoryItem(ImageConstant.myClinic, 'My Clinic'),
      ],
    ),
  );
}

Widget _buildCategoryItem(String iconPath, String label, {Function()? onTap}) {
  return Expanded(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: 48,
            height: 48,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 16 / 13, // line-height / font-size
                letterSpacing: 0,
                color: Colors.black,
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

Widget _buildWarriorCard(String title, String description, double rotation) {
  return Transform.rotate(
    angle: rotation,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        // Polaroid card
        Container(
          width: 220,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image with padding (polaroid style)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  height: 160,
                  child: Image.network(
                    'https://t4.ftcdn.net/jpg/06/33/37/89/360_F_633378965_iRc8bqmOoxkrAlYKvNcBqUhqGXNBmfTB.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Title and description in white space below image (polaroid style)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: AppColors.black,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Flexible(
                        child: Text(
                          description,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: AppColors.black.withOpacity(0.6),
                              fontSize: 9.4,
                            ),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF397BE9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Read Story',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: AppColors.white,
                                fontSize: 11.0,
                              ),
                            ),
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

        // Pin/clip at the top
        Positioned(
          top: -20,
          left: 0,
          right: 0,
          child: Image.asset(ImageConstant.clip_icon, width: 50, height: 50),
        ),
      ],
    ),
  );
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
                  '-Misty Copeland',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: const Color(0xFFFFE16B),
                      fontSize: 14.0,
                    ),
                  ),
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
                        '"Be strong, be fearless, be happy. And believe that anything is possible when you have the right people there to support you."',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color: AppColors.white,
                            fontSize: 13.0,
                          ),
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
    ],
  );
}
