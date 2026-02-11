import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/presentation/articles_screen/controller/articles_screen_controller.dart';
import 'package:bandhucare_new/model/homepage_model.dart';
import 'package:bandhucare_new/presentation/home_screen/home_screen_helper.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ArticlesScreenController());
    
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
                color: AppColors.black,
              ),
            ),
          ),
          leadingWidth: 50,
          title: Text(
            'Articles',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 16),
              child: Image.asset(
                ImageConstant.care_hub,
                width: 100,
                height: 100,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 40),
            // Category Tabs
            _buildCategoryTabs(controller),
            const SizedBox(height: 32),
            
            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading articles',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.errorMessage.value,
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
                
                final articles = controller.articles;
                if (articles.isEmpty) {
                  return Center(
                    child: Text(
                      'No articles found',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Popular Articles for you Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Popular Articles for you',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Articles Grid View with 2 columns
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          key: const PageStorageKey('articles_grid'),
                          scrollDirection: Axis.vertical,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: articles.length,
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
                            return _buildArticleCard(
                              article,
                              formattedDate,
                              'articles_article_${article.id}',
                              key: ValueKey(article.id),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(ArticlesScreenController controller) {
    return Obx(() {
      final tags = controller.allTags;
      if (tags.isEmpty) {
        return const SizedBox.shrink();
      }
      
      return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: tags.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final tag = tags[index];
            return Obx(() {
              final isSelected = controller.isTagSelected(tag.id);
              return GestureDetector(
                onTap: () => controller.toggleTag(tag.id),
                child: Container(
                  key: ValueKey('tag_${tag.id}'),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      tag.name,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.black,
                      ),
                    ),
                  ),
                ),
              );
            });
          },
        ),
      );
    });
  }

  Widget _buildArticleCard(
    CarehubArticle article,
    String formattedDate,
    String heroTag, {
    Key? key,
  }) {
    return GestureDetector(
      key: key,
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
          Expanded(
            child: Container(
              width: double.infinity,
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
                          height: double.infinity,
                          fit: BoxFit.cover,
                          fallbackWidget: Container(
                            width: double.infinity,
                            height: double.infinity,
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
                          height: double.infinity,
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
          ),
          const SizedBox(height: 10),
          // Article Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              formattedDate,
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF979797),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

