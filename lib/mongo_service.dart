import 'package:crud_mongodb/pet_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static final MongoService _instance = MongoService._internal();
  late Db _db;

  MongoService._internal();

  factory MongoService() {
    return _instance;
  }

  Future<void> connect() async {
    _db = await Db.create('mongodb+srv://gnieva:<db_password>@cluster0.1hqs0.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0');
    await _db.open();
  }

  Db get db => _db;

  Future<void> insertPet(PetModel pet) async {
    var collection = _db.collection('pets');
    await collection.insertOne(pet.toJson());
  }

  Future<List<PetModel>> getPets() async {
    var collection = _db.collection('pets');
    var pets = await collection.find().toList();
    return pets.map((pet) => PetModel.fromJson(pet)).toList();
  }

  Future<void> updatePet(PetModel pet) async {
    var collection = _db.collection('pets');
    await collection.updateOne(
      where.eq('_id', pet.id),
      modify.set('name', pet.name).set('type', pet.type),
    );
  }

  Future<void> deletePet(String id) async {
    var collection = _db.collection('pets');
    await collection.remove(where.eq('_id', id)); 
  }
}
