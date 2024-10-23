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
}
