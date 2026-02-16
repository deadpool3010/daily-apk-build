import 'package:get/get.dart';
import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:bandhucare_new/model/homepage_model.dart';

class ArticlesScreenController extends GetxController {
  final RxList<CarehubArticle> articles = <CarehubArticle>[].obs;
  final RxList<CarehubTag> allTags = <CarehubTag>[].obs;
  final RxList<String> selectedTagIds = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  bool _hasCalledApi = false;
  String? _type;

  @override
  void onInit() {
    super.onInit();
    // Get type parameter from arguments (default to 'articles')
    final arguments = Get.arguments;
    _type = arguments != null && arguments is Map<String, dynamic>
        ? (arguments['type'] as String? ?? 'articles')
        : 'articles';
    
    if (!_hasCalledApi) {
      loadArticles(type: _type);
    }
  }

  Future<void> loadArticles({String? type, String? tags}) async {
    if (_hasCalledApi && isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      _hasCalledApi = true;

      // Call API with type parameter
      final response = await getCarehubApiService(type: type ?? _type, tags: tags);

      if (response['success'] == true && response['data'] != null) {
        final carehubResponse = CarehubResponse.fromJson(response);

        // Update tags from API response first (before articles to prevent double rebuild)
        if (carehubResponse.data.tags != null) {
          allTags.value = carehubResponse.data.tags!.all;
          // Set selected tags from API response (selected array)
          selectedTagIds.value = carehubResponse.data.tags!.selected
              .map((tag) => tag.id)
              .toList();
        }

        // Update articles observable - use assignAll to maintain list identity when possible
        if (articles.isEmpty || articles.length != carehubResponse.data.articles.length) {
          articles.value = carehubResponse.data.articles;
        } else {
          // Try to update in place if same length
          articles.assignAll(carehubResponse.data.articles);
        }

        print('Articles loaded successfully');
        print('Articles count: ${articles.length}');
        print('Tags count: ${allTags.length}');
        print('Selected tags: ${selectedTagIds.length}');
      } else {
        throw Exception(response['message'] ?? 'Failed to load articles');
      }
    } catch (e) {
      print('Error loading articles: $e');
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      _hasCalledApi = false;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleTag(String tagId) {
    if (selectedTagIds.contains(tagId)) {
      // Deselect tag
      selectedTagIds.remove(tagId);
    } else {
      // Select tag
      selectedTagIds.add(tagId);
    }
    
    // Reload articles with selected tags
    _hasCalledApi = false;
    final tagsParam = selectedTagIds.isEmpty 
        ? null 
        : selectedTagIds.join(',');
    loadArticles(type: _type, tags: tagsParam);
  }

  bool isTagSelected(String tagId) {
    return selectedTagIds.contains(tagId);
  }
}

