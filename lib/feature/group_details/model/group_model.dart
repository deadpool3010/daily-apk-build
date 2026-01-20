class GroupModel {
  final String id;
  final String name;
  final String createdDate;
  final String hospitalName;
  final String ward;
  final bool isActive;
  final String? department;
  final String? groupType;

  GroupModel({
    required this.id,
    required this.name,
    required this.createdDate,
    required this.hospitalName,
    required this.ward,
    required this.isActive,
    this.department,
    this.groupType,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? json['groupName'] ?? '',
      createdDate: json['createdDate'] ?? json['createdOn'] ?? '',
      hospitalName: json['hospitalName'] ?? '',
      ward: json['ward'] ?? json['wardName'] ?? '',
      isActive: json['isActive'] ?? json['status'] == 'active',
      department: json['department'],
      groupType: json['groupType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdDate': createdDate,
      'hospitalName': hospitalName,
      'ward': ward,
      'isActive': isActive,
      'department': department,
      'groupType': groupType,
    };
  }
}

