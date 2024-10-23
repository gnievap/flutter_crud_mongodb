import 'package:crud_mongodb/mongo_service.dart';
import 'package:crud_mongodb/pet_model.dart';
import 'package:flutter/material.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  _PetScreenState createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  late TextEditingController _nameController;
  late TextEditingController _typeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _typeController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _insertPet() async {
    var pet = PetModel(id: DateTime.now().toString(), name: _nameController.text, type: _typeController.text);
    await MongoService().insertPet(pet);
    setState(() {});
  }

  void _updatePet(PetModel pet) async {
    await MongoService().updatePet(pet);
    setState(() {});
  }

  void _deletePet(String id) async {
    await MongoService().deletePet(id);
    setState(() {});
  }

  Future<List<PetModel>> _getPets() async {
    return await MongoService().getPets();
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
          FutureBuilder<List<PetModel>>(
            future: _getPets(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              var pets = snapshot.data!;
              return Expanded(
                child: ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    var pet = pets[index];
                    return ListTile(
                      title: Text(pet.name),
                      subtitle: Text('Tipo: ${pet.type}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePet(pet.id),
                      ),
                    );
                  }
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}