class StateModel {
  int? id;
  String? name;
  String? code;

  StateModel({this.id, this.name, this.code});

  factory StateModel.fromJson(Map<String, dynamic> map) {
    return StateModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      code: map['state_code'] ?? '',
    );
  }
}
