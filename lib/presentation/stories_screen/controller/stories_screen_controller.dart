import 'package:get/get.dart';
import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:bandhucare_new/model/homepage_model.dart';

class StoriesScreenController extends GetxController {
  final RxList<CarehubStory> stories = <CarehubStory>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasNextPage = false.obs;
  final int limit = 6;
  bool _hasCalledApi = false;
  String? _type;

  @override
  void onInit() {
    super.onInit();
    // Get type parameter from arguments (default to 'stories')
    final arguments = Get.arguments;
    _type = arguments != null && arguments is Map<String, dynamic>
        ? (arguments['type'] as String? ?? 'stories')
        : 'stories';

    if (!_hasCalledApi) {
      loadStories(type: _type, page: 1, isInitialLoad: true);
    }
  }

  Future<void> loadStories({
    String? type,
    String? tags,
    int page = 1,
    bool isInitialLoad = false,
  }) async {
    // Prevent multiple simultaneous calls
    if (isInitialLoad) {
      if (_hasCalledApi && isLoading.value) {
        return;
      }
    } else {
      if (isLoadingMore.value || !hasNextPage.value) {
        return;
      }
    }

    try {
      if (isInitialLoad) {
        isLoading.value = true;
        errorMessage.value = '';
        _hasCalledApi = true;
      } else {
        isLoadingMore.value = true;
      }

      // Call API with type, page, and limit parameters
      final response = await getCarehubApiService(
        type: type ?? _type,
        tags: tags,
        page: page,
        limit: limit,
      );

      if (response['success'] == true && response['data'] != null) {
        final carehubResponse = CarehubResponse.fromJson(response);

        if (isInitialLoad) {
          // Replace stories for initial load
          stories.value = carehubResponse.data.stories;
        } else {
          // Append stories for pagination
          stories.addAll(carehubResponse.data.stories);
        }

        // Update pagination info
        if (carehubResponse.data.pagination != null) {
          currentPage.value = carehubResponse.data.pagination!.page;
          hasNextPage.value = carehubResponse.data.pagination!.hasNext;
        }

        print('Stories loaded successfully');
        print('Stories count: ${stories.length}');
        print('Current page: ${currentPage.value}, Has next: ${hasNextPage.value}');
      } else {
        throw Exception(response['message'] ?? 'Failed to load stories');
      }
    } catch (e) {
      print('Error loading stories: $e');
      if (isInitialLoad) {
        errorMessage.value = e.toString().replaceAll('Exception: ', '');
        _hasCalledApi = false;
      }
    } finally {
      if (isInitialLoad) {
        isLoading.value = false;
      } else {
        isLoadingMore.value = false;
      }
    }
  }

  Future<void> loadMoreStories({String? tags}) async {
    if (hasNextPage.value && !isLoadingMore.value) {
      await loadStories(
        type: _type,
        tags: tags,
        page: currentPage.value + 1,
        isInitialLoad: false,
      );
    }
  }
}