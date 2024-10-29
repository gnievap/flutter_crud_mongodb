import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import 'mongo_service.dart';
import 'pet_model.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  _PetScreenState createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  List<PetModel> pets = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _typeController = TextEditingController();
    _fetchPets();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _fetchPets() async {
    pets = await MongoService().getPets();
    setState(() {});
  }

  void _insertPet() async {
    var pet = PetModel(id: mongo.ObjectId(), name: _nameController.text, type: _typeController.text);
    await MongoService().insertPet(pet);
    _fetchPets();
  }

  void _updatePet(PetModel pet) async {
    await MongoService().updatePet(pet);
    _fetchPets();
  }

  void _deletePet(mongo.ObjectId id) async {
    await MongoService().deletePet(id);
    _fetchPets();
  }

  void _showEditDialog(PetModel pet) {
    _nameController.text = pet.name;
    _typeController.text = pet.type;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Mascota'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                pet.name = _nameController.text;
                pet.type = _typeController.text;
                _updatePet(pet);
                Navigator.of(context).pop();
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MongoDB CRUD')),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: _typeController,
            decoration: const InputDecoration(labelText: 'Tipo'),
          ),
          ElevatedButton(
            onPressed: _insertPet,
            child: const Text('Insertar Mascota'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                var pet = pets[index];
                return ListTile(
                  title: Text(pet.name),
                  subtitle: Text('Tipo: ${pet.type}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditDialog(pet),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePet(pet.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
