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
      hospitalName: map['hospitalName']?.toString(),
      hospitalType: map['hospitalType']?.toString(),
      email: map['email']?.toString(),
      mainMobileNumber: map['mainPhoneNumber']?.toString(),
      operatingHours: map['operatingHours']?.toString(),
      state: map['state']?.toString(),
      city: map['city']?.toString(),
      street: map['street']?.toString(),
      emergencyContanct: map['emergencyContactNumber']?.toString(),
      department: map['department']?.toString() ?? '-',
    );
  }
}
