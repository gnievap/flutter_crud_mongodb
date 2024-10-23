import 'package:crud_mongodb/pet_screen.dart';
import 'package:flutter/material.dart';

import 'mongo_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoService().connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PetScreen(),
    );
  }
}

