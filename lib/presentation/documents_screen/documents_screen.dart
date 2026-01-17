import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/presentation/documents_screen/controller/documents_screen_controller.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentsScreenController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F9FF),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(JamIcons.chevronLeft, size: 26, color: AppColors.black),
          ),
        ),
        leadingWidth: 50,
        title: Text(
          'Documents',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 30),
            // Folder Cards Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildFolderGrid(controller),
            ),
            const SizedBox(height: 30),
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

  Widget _buildFolderGrid(DocumentsScreenController controller) {
    final folders = [
      {
        'title': 'Healthy Diet',
        'previewImage': ImageConstant.care_hub_healthy_diet_img,
      },
      {
        'title': 'New Treatments',
        'previewImage': ImageConstant.care_hub_new_treatments_img,
      },
      {
        'title': 'Self Care',
        'previewImage': ImageConstant.care_hub_self_care_img,
      },
      {
        'title': 'Basic Exercises',
        'previewImage': ImageConstant.care_hub_basic_exercises_img,
      },
      {'title': 'Others', 'previewImage': ImageConstant.care_hub_documents_img},
    ];

    return Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final padding = 20.0;
        final gap = 12.0;
        final availableWidth = screenWidth - (padding * 2);
        final cardWidth = (availableWidth - gap) / 2;
        final cardHeight = 144.0;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: gap,
            mainAxisSpacing: gap,
            childAspectRatio:
                cardWidth / (cardHeight + 32), // cardHeight + title space
          ),
          itemCount: folders.length,
          itemBuilder: (context, index) {
            final folder = folders[index];
            return _buildAnimatedFolderCard(
              controller: controller,
              index: index,
              width: cardWidth,
              height: cardHeight,
              title: folder['title']!,
              previewImage: folder['previewImage']!,
            );
          },
        );
      },
    );
  }

  Widget _buildAnimatedFolderCard({
    required DocumentsScreenController controller,
    required int index,
    required double width,
    required double height,
    required String title,
    required String previewImage,
  }) {
    return FadeTransition(
      opacity: controller.getFadeAnimation(index),
      child: SlideTransition(
        position: controller.getSlideAnimation(index),
        child: ScaleTransition(
          scale: controller.getScaleAnimation(index),
          child: _buildFolderCard(
            width: width,
            height: height,
            title: title,
            previewImage: previewImage,
          ),
        ),
      ),
    );
  }

  Widget _buildFolderCard({
    required double width,
    required double height,
    required String title,
    required String previewImage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Folder image as background
                Positioned.fill(
                  child: Image.asset(
                    ImageConstant.folder_icon,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFE5EFFE),
                        child: const Icon(
                          Icons.folder,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                // Preview Image in top-right
                Positioned(
                  top: 30,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        previewImage,
                        width: width * 0.35,
                        height: width * 0.35,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: width * 0.35,
                            height: width * 0.35,
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
                // CareHub Logo in bottom-left
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      // color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      ImageConstant.care_hub,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image,
                            size: 25,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Title below card
        SizedBox(
          width: width,
          child: Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
