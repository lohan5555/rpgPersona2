import 'dart:async';
import 'dart:io';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/perso.dart';
import '../../services/image_service.dart';
import 'crop_screen.dart';


class EditPersoForm extends StatefulWidget {
  final Perso perso;
  final Function(Perso) onChanged;

  const EditPersoForm({
    super.key,
    required this.perso,
    required this.onChanged
  });

  @override
  State<EditPersoForm> createState() => _EditPersoFormState();
}

class _EditPersoFormState extends State<EditPersoForm> {
  File? _galleryFile;
  final ImageService imageService = ImageService();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  late CustomImageCropController _cropController;

  Timer? _debounce;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _cropController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.perso.name;
    _descController.text = widget.perso.desc ?? '';
    _cropController = CustomImageCropController();

    if (widget.perso.imgPath != null) {
      _galleryFile = File(widget.perso.imgPath!);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Modifier un perso'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
          child:SingleChildScrollView(
            child: Builder(
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setStateDialog) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 24),
                              _form(),
                              SizedBox(height: 24),
                              _displayImg(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
            ),
          )
      ),
    );
  }

  Widget _form(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nom :"),
          TextFormField(
            controller: _nameController,
            onChanged: (_) => _autoSave(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un nom';
              }
              return null;
            },
          ),
          SizedBox(height: 20),

          Text("Description :"),
          TextFormField(
            controller: _descController,
            onChanged: (_) => _autoSave(),
            validator: (value) {return null;},
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _displayImg(){
    return Column(
      children: [
        SizedBox(
          height: 200.0,
          width: 300.0,
          child: GestureDetector(
            onTap: () {
              _showPicker(context: context);
            },
            child: _galleryFile == null
                ? const Center(child: Text("Cliquez pour ajouter une image."))
                : Center(child: Image.file(_galleryFile!)),
          )
        ),
        if (_galleryFile != null) ...[
          SizedBox(height: 5),
          Center(child: Text("Cliquez pour modifier", style: TextStyle(color: Colors.grey)),)
        ]
      ],
    );
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galerie'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await imageService.pickAndSaveImage(ImageSource.gallery);
                  if (image != null) {
                    _startCrop(image);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Appareil photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await imageService.pickAndSaveImage(ImageSource.camera);
                  if (image != null) {
                    _startCrop(image);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _startCrop(File file) async {
    // On ouvre la page de crop et on attend le résultat
    final MemoryImage? croppedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropPage(
            imageFile: file,
            controller: _cropController,
            shape: CustomCropShape.Circle
        ),
      ),
    );

    if (croppedImage != null) {
      // Convertir MemoryImage en File pour l'enregistrer physiquement
      final tempFile = await imageService.saveByteImage(croppedImage.bytes);
      setState(() {
        _galleryFile = tempFile;
      });
      _autoSave();
    }
  }

  // Sauvegarde après que l'utilisateur ait modifier un champ, avec un debonce de 500ms pour évité le spam
  void _autoSave() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (!_formKey.currentState!.validate()) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final updatedPerso = widget.perso.copyWith(
        name: _nameController.text,
        desc: _descController.text.trim(),
        imgPath: _galleryFile?.path,
      );
      widget.onChanged(updatedPerso);

    });
  }
}