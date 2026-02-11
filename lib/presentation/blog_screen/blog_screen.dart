import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/presentation/blog_screen/controller/blog_screen_controller.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/tiptap_renderer.dart';
import 'package:bandhucare_new/presentation/home_screen/home_screen_helper.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BlogScreenController>();
    final article = Get.arguments as Map<String, dynamic>? ?? {};

    // Fetch content by ID if contentId is provided
    final contentId = article['contentId'] as String?;
    if (contentId != null && contentId.isNotEmpty) {
      // Load content only once when screen is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.contentData.value == null &&
            !controller.isLoading.value) {
          controller.loadContentById(contentId);
        }
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F9FF),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 16),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(JamIcons.chevronLeft, size: 26, color: AppColors.black),
          ),
        ),
        leadingWidth: 50,
      ),
      body: Obx(() {
        // Use fetched content if available, otherwise use arguments
        final displayData = controller.contentData.value ?? article;
        final isLoading = controller.isLoading.value;
        final errorMessage = controller.errorMessage.value;
        final hasContentId = contentId != null && contentId.isNotEmpty;

        if (isLoading && hasContentId) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (errorMessage.isNotEmpty && hasContentId) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading content',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Format date from API response if available
        String formattedDate = displayData['date'] ?? '';
        if (formattedDate.isEmpty && displayData['createdAt'] != null) {
          try {
            final dateTime = DateTime.parse(displayData['createdAt']);
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
            formattedDate = displayData['createdAt'] ?? 'Nov 09, 2025';
          }
        }
        if (formattedDate.isEmpty) {
          formattedDate = 'Nov 09, 2025';
        }

        // Get tags from API response
        List<String> tags = [];
        if (displayData['tags'] != null && displayData['tags'] is List) {
          tags = (displayData['tags'] as List)
              .map(
                (tag) => tag is Map
                    ? (tag['name'] ?? tag.toString())
                    : tag.toString(),
              )
              .cast<String>()
              .toList();
        } else if (displayData['tags'] != null &&
            displayData['tags'] is List<String>) {
          tags = List<String>.from(displayData['tags']);
        } else if (article['tags'] != null && article['tags'] is List) {
          tags = (article['tags'] as List)
              .map((tag) => tag.toString())
              .toList();
        }

        // Get author name - handle both Map and String types
        String authorName = 'Dr. Sohail Ali';
        if (displayData['author'] != null) {
          if (displayData['author'] is Map) {
            authorName =
                (displayData['author'] as Map)['name']?.toString() ??
                displayData['author'].toString();
          } else {
            authorName = displayData['author'].toString();
          }
        } else if (article['author'] != null) {
          if (article['author'] is Map) {
            authorName =
                (article['author'] as Map)['name']?.toString() ??
                article['author'].toString();
          } else {
            authorName = article['author'].toString();
          }
        }

        // Get cover image URL
        String? coverImageUrl =
            displayData['coverImage']?['fileUrl'] ??
            displayData['imageUrl'] ??
            article['imageUrl'];

        // Check if audio field exists in API response (only when content is loaded from API)
        // Audio should only show if:
        // 1. Content is loaded from API (hasContentId is true)
        // 2. Audio field exists in the API response and is not null/empty
        final hasAudio =
            hasContentId &&
            controller.contentData.value != null &&
            controller.contentData.value!['audio'] != null &&
            controller.contentData.value!['audio'].toString().isNotEmpty;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Date
                Text(
                  formattedDate,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  displayData['title'] ??
                      article['title'] ??
                      'New Diet for Cancer Patients',
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                // Tags
                if (tags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map((tag) => _buildTag(tag)).toList(),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _buildTags(article),
                  ),
                const SizedBox(height: 24),
                // Hero Image (shown when cover image is available)
                if (coverImageUrl != null && coverImageUrl.isNotEmpty)
                  _buildHeroImageFromUrl(
                    coverImageUrl,
                    article['heroTag'] as String?,
                  ),
                // Image Carousel (shown when hero image is not present)
                if (coverImageUrl == null || coverImageUrl.isEmpty)
                  _buildImageCarousel(controller),
                const SizedBox(height: 16),
                // Pagination Dots (only shown with carousel)
                if (coverImageUrl == null || coverImageUrl.isEmpty)
                  _buildPaginationDots(controller),
                if (hasAudio) SizedBox(height: 24),
                // Audio Player (only show if audio field exists in API response)
                if (hasAudio) _buildAudioPlayer(controller),
                if (hasAudio) const SizedBox(height: 24),
                // Article Text
                _buildArticleText(displayData),
                const SizedBox(height: 24),
                // Author
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 6),
                  child: Text(
                    '- $authorName',
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
        );
      }),
    );
  }

  List<Widget> _buildTags(Map<String, dynamic> article) {
    // If tags are provided in arguments, use them
    if (article['tags'] != null && article['tags'] is List) {
      final tags = article['tags'] as List;
      return tags.map((tag) => _buildTag(tag.toString())).toList();
    }

    // Default tags based on source or fallback to generic tags
    final defaultTags = [
      'Patient Reference',
      'Healthy Diet Articles',
      'Self Help',
    ];

    return defaultTags.map((tag) => _buildTag(tag)).toList();
  }

  Widget _buildHeroImage(Map<String, dynamic> article) {
    final heroTag = article['heroTag'] as String;
    final imageUrl = article['imageUrl'] as String;

    return Hero(
      tag: heroTag,
      child: Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.only(bottom: 24),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 40, color: Colors.grey),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImageFromUrl(String imageUrl, String? heroTag) {
    Widget imageWidget = DelayedImageWithShimmer(
      imageUrl: imageUrl,
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
      fallbackWidget: Container(
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 40, color: Colors.grey),
      ),
    );

    if (heroTag != null && heroTag.isNotEmpty) {
      imageWidget = Hero(tag: heroTag, child: imageWidget);
    }

    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.only(bottom: 24),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: imageWidget,
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFE5EFFE),
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
    // Check if TipTap JSON content is provided
    final tiptapContent = article['tiptapContent'] ?? article['content'];

    if (tiptapContent != null && tiptapContent is Map<String, dynamic>) {
      // Use TipTap renderer for rich content
      return TiptapRenderer(document: tiptapContent);
    }

    // Fallback to static view for backward compatibility
    final description =
        article['description'] ??
        'I woke up to the soft light filtering through my window, and for the first time in a while, I didn\'t rush to check my phone. Instead, I took a deep breath and stretched, feeling my body wake up slowly.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 6),
          child: Text(
            description,
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
        _buildBulletPoint(
          'The kindness of a stranger who held the door open for me yesterday',
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 6),
          child: Text(
            description,
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
      padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
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
