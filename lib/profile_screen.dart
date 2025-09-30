import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _picker = ImagePicker();
  XFile? _imageFile;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _ageController.text = prefs.getString('age') ?? '';
      _cityController.text = prefs.getString('city') ?? '';
      _stateController.text = prefs.getString('state') ?? '';
      final imagePath = prefs.getString('profile_image_path');
      if (imagePath != null && imagePath.isNotEmpty) {
        _imageFile = XFile(imagePath);
      }
    });
  }

  Future<void> _saveProfileData() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final prefs = await SharedPreferences.getInstance();

    if (_imageFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(_imageFile!.path);
      final savedImage = await File(
        _imageFile!.path,
      ).copy('${appDir.path}/$fileName');
      await prefs.setString('profile_image_path', savedImage.path);
    }

    await prefs.setString('name', _nameController.text);
    await prefs.setString('age', _ageController.text);
    await prefs.setString('city', _cityController.text);
    await prefs.setString('state', _stateController.text);

    if (!mounted) return;

    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Perfil salvo com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: <Widget>[
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.blue.shade100,
                    backgroundImage: _imageFile != null
                        ? FileImage(File(_imageFile!.path))
                        : null,
                    child: _imageFile == null
                        ? const Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nome',
              hintText: 'Digite o seu nome completo',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _ageController,
            decoration: InputDecoration(
              labelText: 'Idade',
              hintText: 'Digite sua idade',
              prefixIcon: const Icon(Icons.cake_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: 'Cidade',
              hintText: 'Onde você mora',
              prefixIcon: const Icon(Icons.location_city_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _stateController,
            decoration: InputDecoration(
              labelText: 'Estado',
              hintText: 'Seu estado',
              prefixIcon: const Icon(Icons.map_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            icon: const Icon(Icons.save_alt_outlined),
            label: const Text('Salvar Alterações'),
            onPressed: _saveProfileData,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
