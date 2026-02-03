class CityModel {
  int? id;
  String? name;

  CityModel({this.id, this.name});

  factory CityModel.fromJson(Map<String, dynamic> map) {
    return CityModel(id: map['id'], name: map['name']);
  }
}

