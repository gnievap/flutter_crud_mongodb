class PetModel {
  final String id;
  final String name;
  final String type;

  PetModel({required this.id, required this.name, required this.type});

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'type': type,
    };
  }

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
    );
  }
}
