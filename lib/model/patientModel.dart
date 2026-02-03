class PatientModel {
  final String id;
  final String name;
  final String? email;
  final String? mobile;
  final String? abhaAddress;
  final String? abhaNumber;
  final String? profilePhoto;
  final String? gender;
  final String? yearOfBirth;
  final String? monthOfBirth;
  final String? dayOfBirth;
  final String? address;
  final String? state;
  final String? city;

  const PatientModel({
    required this.id,
    required this.name,
    this.email,
    this.mobile,
    this.abhaAddress,
    this.abhaNumber,
    this.profilePhoto,
    this.gender,
    this.yearOfBirth,
    this.monthOfBirth,
    this.dayOfBirth,
    this.address,
    this.state,
    this.city,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['_id'] ?? json['userId'] ?? '',
      name: json['name'] ?? json['fullName'] ?? '',
      email: json['email'],
      mobile: json['mobileNumber'],
      abhaAddress: json['abhaAddress'],
      abhaNumber: json['abhaNumber'],
      profilePhoto: json['profilePhoto'],
      gender: json['gender'],
      yearOfBirth: json['yearOfBirth'],
      address: json['address'],
      monthOfBirth: json['monthOfBirth'],
      dayOfBirth: json['dayOfBirth'],
      state: json['stateName'],
      city: json['subdistrictName'],
    );
  }
}
