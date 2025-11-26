class PatientModel {
  final String userId;
  final String name;
  final String abhaAddress;
  final String abhaNumber;
  final String mobileNumber;
  final String profilePhoto;
  final String gender;
  final String yearOfBirth;
  final String monthOfBirth;
  final String dayOfBirth;
  final String stateName;
  final String districtName;
  final String subdistrictName;
  final String townName;
  final String address;
  final String pincode;

  PatientModel({
    required this.userId,
    required this.name,
    required this.abhaAddress,
    required this.abhaNumber,
    required this.mobileNumber,
    required this.profilePhoto,
    required this.gender,
    required this.yearOfBirth,
    required this.monthOfBirth,
    required this.dayOfBirth,
    required this.stateName,
    required this.districtName,
    required this.subdistrictName,
    required this.townName,
    required this.address,
    required this.pincode,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      userId: json['userId'],
      name: json['name'],
      abhaAddress: json['abhaAddress'],
      abhaNumber: json['abhaNumber'],
      mobileNumber: json['mobileNumber'],
      profilePhoto: json['profilePhoto'],
      gender: json['gender'],
      yearOfBirth: json['yearOfBirth'],
      monthOfBirth: json['monthOfBirth'],
      dayOfBirth: json['dayOfBirth'],
      stateName: json['stateName'],
      districtName: json['districtName'],
      subdistrictName: json['subdistrictName'],
      townName: json['townName'],
      address: json['address'],
      pincode: json['pincode'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'abhaAddress': abhaAddress,
      'abhaNumber': abhaNumber,
      'mobileNumber': mobileNumber,
      'profilePhoto': profilePhoto,
      'gender': gender,
      'yearOfBirth': yearOfBirth,
      'monthOfBirth': monthOfBirth,
      'dayOfBirth': dayOfBirth,
      'stateName': stateName,
      'districtName': districtName,
      'subdistrictName': subdistrictName,
      'townName': townName,
      'address': address,
      'pincode': pincode,
    };
  }
}
