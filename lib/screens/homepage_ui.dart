import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feelings.dart';

class HomepageUI extends StatelessWidget {
  const HomepageUI({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF9),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Header background image (scrollable)
              SizedBox(
                width: size.width,
                height: size.height * 0.3, // 30% of screen height
                child: Image.asset(
                  'assets/headerimage.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),

              // Daily check-in header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Daily check-in with Mitra ',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 24 / 18, // line-height / font-size
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                    ),
                    Image.asset('assets/robot.png', width: 24, height: 24),
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Categories",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 24 / 18, // line-height / font-size
                    letterSpacing: 0,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Category container
              Center(child: categories()),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Daily Affirmation/Remainders",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 24 / 18, // line-height / font-size
                    letterSpacing: 0,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Horizontal scrollable affirmation cards
              Container(
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

              const SizedBox(height: 20),
              // Warriors section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Meet Our Strong Warriors",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 24 / 18,
                    letterSpacing: 0,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Horizontal scrollable warrior cards
              Container(
                height: 355,
                decoration: BoxDecoration(color: const Color(0xFFFFFCF9)),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  itemCount: 3,
                  separatorBuilder: (context, index) =>
                      Container(width: 25, color: const Color(0xFFFFFCF9)),
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
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
        _buildCategoryItem('health_calander.png', 'Health \nCalander'),
        _buildCategoryItem('file_manager.png', 'Manage \nFiles'),
        _buildCategoryItem('robot.png', 'Mitra'),
        _buildCategoryItem('my_clinic.png', 'My Clinic'),
      ],
    ),
  );
}

Widget _buildCategoryItem(String iconPath, String label) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/$iconPath',
          width: 48,
          height: 48,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
        const SizedBox(height: 8),
        Text(
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
      ],
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
            children: [
              // Image with padding (polaroid style)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.grey[300]!, Colors.grey[400]!],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),

              // Title and description in white space below image (polaroid style)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 9,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Pin/clip at the top
        Positioned(
          top: 5,
          left: 95,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(Icons.push_pin, color: Colors.white, size: 20),
          ),
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
                    image: AssetImage('assets/clouds.png'),
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
              top: 121,
              child: SizedBox(
                width: 108,
                height: 18,
                child: Text(
                  '-Misty Copeland',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xFFFFE16A),
                    fontSize: 14,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                    height: 1.14,
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
                  color: Colors.white.withValues(alpha: 0.11),
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
                        '“Be strong, be fearless, be happy. And believe that anything is possible when you have the right people there to support you.”',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          height: 1.38,
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

class SharedWithHeart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 302,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Shared',
            style: GoogleFonts.alumniSans(
              color: const Color(0x7F397BE9),
              fontSize: 75,
              fontWeight: FontWeight.w700,
              height: 0.75,
              letterSpacing: 1.00,
            ),
          ),
          Text(
            'with heart.',
            style: GoogleFonts.alumniSans(
              color: const Color(0x7F397BE9),
              fontSize: 75,
              fontWeight: FontWeight.w700,
              height: 1.0,
              letterSpacing: 1.00,
            ),
          ),
        ],
      ),
    );
  }
}
