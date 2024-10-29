import 'package:mongo_dart/mongo_dart.dart' as mongo;

class PetModel {
  final mongo.ObjectId id;
  String name;
  String type;

  PetModel({required this.id, required this.name, required this.type});

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'type': type,
    };
  }

  factory PetModel.fromJson(Map<String, dynamic> json) {
    var id = json['_id'];
    if (id is String) {
      try {
        id = mongo.ObjectId.fromHexString(id);
      } catch (e) {
        throw ArgumentError('Invalid ID format: $id');
      }
    } else if (id is! mongo.ObjectId) {
      throw ArgumentError('Expected ObjectId, got: $id');
    }

    return PetModel(
      id: id as mongo.ObjectId,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }
}
