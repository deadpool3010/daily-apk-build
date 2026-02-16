class ProfileInfo {
  final String id;
  final String userId;
  final String email;
  final String name;
  final String? profilePhoto;
  final String createdAt;
  final String updatedAt;

  ProfileInfo({
    required this.id,
    required this.userId,
    required this.email,
    required this.name,
    this.profilePhoto,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profilePhoto: json['profilePhoto'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class HospitalInfo {
  final String id;
  final String hospitalName;
  final String? image;

  HospitalInfo({
    required this.id,
    required this.hospitalName,
    this.image,
  });

  factory HospitalInfo.fromJson(Map<String, dynamic> json) {
    return HospitalInfo(
      id: json['_id'] ?? '',
      hospitalName: json['hospitalName'] ?? '',
      image: json['image'],
    );
  }
}

class HomepageGroup {
  final String id;
  final String name;
  final String? image;
  final bool isActive;

  HomepageGroup({
    required this.id,
    required this.name,
    this.image,
    required this.isActive,
  });

  factory HomepageGroup.fromJson(Map<String, dynamic> json) {
    return HomepageGroup(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      isActive: json['isActive'] ?? false,
    );
  }
}

class ArticleAuthor {
  final String id;
  final String name;

  ArticleAuthor({
    required this.id,
    required this.name,
  });

  factory ArticleAuthor.fromJson(Map<String, dynamic> json) {
    return ArticleAuthor(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class CoverImage {
  final String fileUrl;
  final String? fileAltText;
  final String? fileTitle;

  CoverImage({
    required this.fileUrl,
    this.fileAltText,
    this.fileTitle,
  });

  factory CoverImage.fromJson(Map<String, dynamic> json) {
    return CoverImage(
      fileUrl: json['fileUrl'] ?? '',
      fileAltText: json['fileAltText'],
      fileTitle: json['fileTitle'],
    );
  }
}

class HomepageArticle {
  final String id;
  final String title;
  final CoverImage? coverImage;
  final String createdBy;
  final String createdAt;
  final ArticleAuthor author;

  HomepageArticle({
    required this.id,
    required this.title,
    this.coverImage,
    required this.createdBy,
    required this.createdAt,
    required this.author,
  });

  factory HomepageArticle.fromJson(Map<String, dynamic> json) {
    return HomepageArticle(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      coverImage: json['coverImage'] != null
          ? CoverImage.fromJson(json['coverImage'] as Map<String, dynamic>)
          : null,
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] ?? '',
      author: ArticleAuthor.fromJson(
        json['author'] as Map<String, dynamic>,
      ),
    );
  }
}

class StoryPatient {
  final String id;
  final String name;

  StoryPatient({
    required this.id,
    required this.name,
  });

  factory StoryPatient.fromJson(Map<String, dynamic> json) {
    return StoryPatient(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class HomepageStory {
  final String id;
  final String title;
  final String description;
  final CoverImage? coverImage;
  final String createdBy;
  final String createdAt;
  final ArticleAuthor author;
  final StoryPatient patient;

  HomepageStory({
    required this.id,
    required this.title,
    required this.description,
    this.coverImage,
    required this.createdBy,
    required this.createdAt,
    required this.author,
    required this.patient,
  });

  factory HomepageStory.fromJson(Map<String, dynamic> json) {
    return HomepageStory(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'] != null
          ? CoverImage.fromJson(json['coverImage'] as Map<String, dynamic>)
          : null,
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] ?? '',
      author: ArticleAuthor.fromJson(
        json['author'] as Map<String, dynamic>,
      ),
      patient: StoryPatient.fromJson(
        json['patient'] as Map<String, dynamic>,
      ),
    );
  }
}

class HomepageData {
  final ProfileInfo profileInfo;
  final HospitalInfo hospitalInfo;
  final List<HomepageGroup> groups;
  final List<HomepageArticle> articles;
  final List<HomepageStory> stories;

  HomepageData({
    required this.profileInfo,
    required this.hospitalInfo,
    required this.groups,
    required this.articles,
    required this.stories,
  });

  factory HomepageData.fromJson(Map<String, dynamic> json) {
    List<HomepageGroup> groupsList = [];
    if (json['groups'] != null && json['groups'] is List) {
      groupsList = (json['groups'] as List)
          .map((group) => HomepageGroup.fromJson(group as Map<String, dynamic>))
          .toList();
    }

    List<HomepageArticle> articlesList = [];
    if (json['articles'] != null && json['articles'] is List) {
      articlesList = (json['articles'] as List)
          .map((article) =>
              HomepageArticle.fromJson(article as Map<String, dynamic>))
          .toList();
    }

    List<HomepageStory> storiesList = [];
    if (json['stories'] != null && json['stories'] is List) {
      storiesList = (json['stories'] as List)
          .map((story) =>
              HomepageStory.fromJson(story as Map<String, dynamic>))
          .toList();
    }

    return HomepageData(
      profileInfo: ProfileInfo.fromJson(
        json['profileInfo'] as Map<String, dynamic>,
      ),
      hospitalInfo: HospitalInfo.fromJson(
        json['hospitalInfo'] as Map<String, dynamic>,
      ),
      groups: groupsList,
      articles: articlesList,
      stories: storiesList,
    );
  }
}

class HomepageResponse {
  final bool success;
  final int statusCode;
  final String message;
  final HomepageData data;
  final String timestamp;

  HomepageResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory HomepageResponse.fromJson(Map<String, dynamic> json) {
    return HomepageResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: HomepageData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] ?? '',
    );
  }
}

// CareHub Models
class CarehubArticle {
  final String id;
  final String title;
  final String category;
  final CoverImage? coverImage;
  final List<Map<String, dynamic>> tags;
  final String createdAt;
  final String updatedAt;

  CarehubArticle({
    required this.id,
    required this.title,
    required this.category,
    this.coverImage,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CarehubArticle.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> tagsList = [];
    if (json['tags'] != null && json['tags'] is List) {
      tagsList = (json['tags'] as List)
          .map((tag) => tag as Map<String, dynamic>)
          .toList();
    }

    return CarehubArticle(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      coverImage: json['coverImage'] != null
          ? CoverImage.fromJson(json['coverImage'] as Map<String, dynamic>)
          : null,
      tags: tagsList,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class CarehubStory {
  final String id;
  final String title;
  final String category;
  final String description;
  final CoverImage? coverImage;
  final List<Map<String, dynamic>> tags;
  final String patientId;
  final String createdAt;
  final String updatedAt;

  CarehubStory({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    this.coverImage,
    required this.tags,
    required this.patientId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CarehubStory.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> tagsList = [];
    if (json['tags'] != null && json['tags'] is List) {
      tagsList = (json['tags'] as List)
          .map((tag) => tag as Map<String, dynamic>)
          .toList();
    }

    return CarehubStory(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'] != null
          ? CoverImage.fromJson(json['coverImage'] as Map<String, dynamic>)
          : null,
      tags: tagsList,
      patientId: json['patientId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class CarehubPagination {
  final int page;
  final int limit;
  final int total;
  final bool hasNext;

  CarehubPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.hasNext,
  });

  factory CarehubPagination.fromJson(Map<String, dynamic> json) {
    return CarehubPagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 6,
      total: json['total'] ?? 0,
      hasNext: json['hasNext'] ?? false,
    );
  }
}

class CarehubTag {
  final String id;
  final String name;

  CarehubTag({
    required this.id,
    required this.name,
  });

  factory CarehubTag.fromJson(Map<String, dynamic> json) {
    return CarehubTag(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class CarehubTags {
  final List<CarehubTag> all;
  final List<CarehubTag> selected;

  CarehubTags({
    required this.all,
    required this.selected,
  });

  factory CarehubTags.fromJson(Map<String, dynamic> json) {
    List<CarehubTag> allTags = [];
    if (json['all'] != null && json['all'] is List) {
      allTags = (json['all'] as List)
          .map((tag) => CarehubTag.fromJson(tag as Map<String, dynamic>))
          .toList();
    }

    List<CarehubTag> selectedTags = [];
    if (json['selected'] != null && json['selected'] is List) {
      selectedTags = (json['selected'] as List)
          .map((tag) => CarehubTag.fromJson(tag as Map<String, dynamic>))
          .toList();
    }

    return CarehubTags(
      all: allTags,
      selected: selectedTags,
    );
  }
}

class CarehubData {
  final List<CarehubArticle> articles;
  final List<CarehubStory> stories;
  final CarehubPagination? pagination;
  final CarehubTags? tags;

  CarehubData({
    required this.articles,
    required this.stories,
    this.pagination,
    this.tags,
  });

  factory CarehubData.fromJson(Map<String, dynamic> json) {
    List<CarehubArticle> articlesList = [];
    if (json['articles'] != null && json['articles'] is List) {
      articlesList = (json['articles'] as List)
          .map((article) =>
              CarehubArticle.fromJson(article as Map<String, dynamic>))
          .toList();
    }

    List<CarehubStory> storiesList = [];
    if (json['stories'] != null && json['stories'] is List) {
      storiesList = (json['stories'] as List)
          .map((story) => CarehubStory.fromJson(story as Map<String, dynamic>))
          .toList();
    }

    CarehubPagination? paginationData;
    if (json['pagination'] != null) {
      paginationData = CarehubPagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      );
    }

    CarehubTags? tagsData;
    if (json['tags'] != null) {
      tagsData = CarehubTags.fromJson(
        json['tags'] as Map<String, dynamic>,
      );
    }

    return CarehubData(
      articles: articlesList,
      stories: storiesList,
      pagination: paginationData,
      tags: tagsData,
    );
  }
}

class CarehubResponse {
  final bool success;
  final int statusCode;
  final String message;
  final CarehubData data;
  final String timestamp;

  CarehubResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory CarehubResponse.fromJson(Map<String, dynamic> json) {
    return CarehubResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: CarehubData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] ?? '',
    );
  }
}



