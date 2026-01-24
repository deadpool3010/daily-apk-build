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

class HomepageData {
  final ProfileInfo profileInfo;
  final HospitalInfo hospitalInfo;
  final List<HomepageGroup> groups;

  HomepageData({
    required this.profileInfo,
    required this.hospitalInfo,
    required this.groups,
  });

  factory HomepageData.fromJson(Map<String, dynamic> json) {
    List<HomepageGroup> groupsList = [];
    if (json['groups'] != null && json['groups'] is List) {
      groupsList = (json['groups'] as List)
          .map((group) => HomepageGroup.fromJson(group as Map<String, dynamic>))
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


