class HospitalModel {
  final String? hospitalName;
  final String? hospitalType;
  final String? department;
  final String? emergencyContanct;
  final String? mainMobileNumber;
  final String? email;
  final String? operatingHours;
  final String? state;
  final String? street;
  final String? city;

  HospitalModel({
    this.hospitalName,
    this.hospitalType,
    this.department,
    this.emergencyContanct,
    this.mainMobileNumber,
    this.email,
    this.operatingHours,
    this.state,
    this.street,
    this.city,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> map) {
    return HospitalModel(
      hospitalName: map['hospitalName'],
      hospitalType: map['hospitalType'],
      email: map['email'],
      mainMobileNumber: map['mainPhoneNumber'],
      operatingHours: map['operatingHours'],
      state: map['state'],
      city: map['city'],
      street: map['street'],
      emergencyContanct: map['emergencyContactNumber'],
      department: map['department'] ?? '-',
    );
  }
}
