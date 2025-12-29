import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bandhucare_new/presentation/blog_screen/controller/blog_screen_controller.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BlogScreenController>();
    final article = Get.arguments as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Date
              Text(
                article['date'] ?? 'Nov 09, 2025',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              // Title
              Text(
                article['title'] ?? 'New Diet for Cancer Patients',
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTag('Patient Reference'),
                  _buildTag('Healthy Diet Articles'),
                  _buildTag('Self Help'),
                ],
              ),
              const SizedBox(height: 24),
              // Image Carousel
              _buildImageCarousel(controller),
              const SizedBox(height: 16),
              // Pagination Dots
              _buildPaginationDots(controller),
              const SizedBox(height: 24),
              // Audio Player
              _buildAudioPlayer(controller),
              const SizedBox(height: 24),
              // Article Text
              _buildArticleText(article),
              const SizedBox(height: 24),
              // Author
              Padding(
                padding: const EdgeInsets.only(left: 8,right: 6),
                child: Text(
                '- ${article['author'] ?? 'Dr. Sohail Ali'}',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE5EFFE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget _buildImageCarousel(BlogScreenController controller) {
    return Obx(() {
      final currentPage = controller.currentImagePage.value;
      final images = controller.imagePages[currentPage];
      
      return Column(
        children: [
          // 2x2 Grid
          Row(
            children: [
              Expanded(
                child: _buildImageWithTime(
                  images[0]['image'] ?? '',
                  images[0]['time'] ?? '',
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: _buildImageWithTime(
                  images[1]['image'] ?? '',
                  images[1]['time'] ?? '',
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: _buildImageWithTime(
                  images[2]['image'] ?? '',
                  images[2]['time'] ?? '',
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: _buildImageWithTime(
                  images[3]['image'] ?? '',
                  images[3]['time'] ?? '',
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildImageWithTime(String image, String time) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[300],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 40, color: Colors.grey),
                );
              },
            ),
          ),
          // Time overlay
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                time,
                style: GoogleFonts.lato(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationDots(BlogScreenController controller) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller.imagePages.length,
          (index) => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.currentImagePage.value == index
                  ? AppColors.primaryColor
                  : Colors.grey[300],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAudioPlayer(BlogScreenController controller) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F9FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Play Button
            GestureDetector(
              onTap: () => controller.toggleAudio(),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Animated Waveform
            Expanded(
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      controller.waveformHeights.length,
                      (index) => Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeOut,
                          width: controller.waveformBarWidth,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: controller.waveformHeights[index],
                          decoration: BoxDecoration(
                            color: controller.isPlaying.value
                                ? AppColors.primaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(width: 16),
            // Time
            Text(
              controller.currentTime.value,
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildArticleText(Map<String, dynamic> article) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8,right: 6),
          child: Text(
            'I woke up to the soft light filtering through my window, and for the first time in a while, I didn\'t rush to check my phone. Instead, I took a deep breath and stretched, feeling my body wake up slowly.',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
              height: 1.5,
              
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        const SizedBox(height: 16),
        // Bullet Points
        _buildBulletPoint('The warmth of my morning tea'),
        _buildBulletPoint('A quiet moment to myself before the day starts'),
        _buildBulletPoint('The kindness of a stranger who held the door open for me yesterday'),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 8,right: 6),
          child: Text(
          'I woke up to the soft light filtering through my window, and for the first time in a while, I didn\'t rush to check my phone. Instead, I took a deep breath and stretched, feeling my body wake up slowly.',
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
            height: 1.6,
          ),
          textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8,left: 16,right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 12),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.black,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

