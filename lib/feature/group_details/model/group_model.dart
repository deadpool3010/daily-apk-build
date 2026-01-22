class GroupMember {
  final String userId;
  final String userType;
  final String id;
  final String? profilePhoto;
  final String name;

  GroupMember({
    required this.userId,
    required this.userType,
    required this.id,
    this.profilePhoto,
    required this.name,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      userId: json['userId'] ?? '',
      userType: json['userType'] ?? '',
      id: json['_id'] ?? '',
      profilePhoto: json['profilePhoto'],
      name: json['name'] ?? '',
    );
  }
}

class GroupModel {
  final String id;
  final String name;
  final String createdDate;
  final String? image;
  final String? associatedNodeId;
  final String? associatedNodeType;
  final String? associatedNodeName;
  final String? contactPersonName;
  final String? contactEmail;
  final String? contactNumber;
  final String? address;
  final List<GroupMember> members;
  final bool isActive;

  GroupModel({
    required this.id,
    required this.name,
    required this.createdDate,
    this.image,
    this.associatedNodeId,
    this.associatedNodeType,
    this.associatedNodeName,
    this.contactPersonName,
    this.contactEmail,
    this.contactNumber,
    this.address,
    required this.members,
    required this.isActive,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    // Parse createdAt to formatted date
    String formattedDate = '';
    if (json['createdAt'] != null) {
      try {
        final dateTime = DateTime.parse(json['createdAt']);
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
          'Dec'
        ];
        formattedDate =
            'Created on ${months[dateTime.month - 1]} ${dateTime.day}${_getDaySuffix(dateTime.day)}, ${dateTime.year}';
      } catch (e) {
        formattedDate = json['createdAt'] ?? '';
      }
    }

    // Parse members
    List<GroupMember> membersList = [];
    if (json['members'] != null && json['members'] is List) {
      membersList = (json['members'] as List)
          .map((member) => GroupMember.fromJson(member as Map<String, dynamic>))
          .toList();
    }

    return GroupModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      createdDate: formattedDate,
      image: json['image'],
      associatedNodeId: json['associatedNodeId'],
      associatedNodeType: json['associatedNodeType'],
      associatedNodeName: json['associatedNodeName'],
      contactPersonName: json['contactPersonName'],
      contactEmail: json['contactEmail'],
      contactNumber: json['contactNumber'],
      address: json['address'],
      members: membersList,
      isActive: json['isActive'] ?? false,
    );
  }

  static String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  // Helper getters for UI compatibility
  String get hospitalName {
    // Try to extract hospital name from address
    if (address != null && address!.isNotEmpty) {
      // Simple extraction - can be improved
      return address!.split(',').first.trim();
    }
    return '';
  }

  String get ward {
    // Try to extract ward from address or return empty
    return '';
  }

  String get location {
    // Combine hospital name and ward if available
    if (hospitalName.isNotEmpty) {
      return hospitalName;
    }
    return address ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdDate': createdDate,
      'image': image,
      'associatedNodeId': associatedNodeId,
      'associatedNodeType': associatedNodeType,
      'associatedNodeName': associatedNodeName,
      'contactPersonName': contactPersonName,
      'contactEmail': contactEmail,
      'contactNumber': contactNumber,
      'address': address,
      'members': members.map((m) => m.toJson()).toList(),
      'isActive': isActive,
    };
  }
}

extension GroupMemberExtension on GroupMember {
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userType': userType,
      '_id': id,
      'profilePhoto': profilePhoto,
      'name': name,
    };
  }
}

