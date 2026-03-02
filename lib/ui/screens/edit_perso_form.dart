import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/perso.dart';
import '../../services/image_service.dart';


class EditPersoForm extends StatefulWidget {
  final Perso perso;

  const EditPersoForm({super.key, required this.perso});

  @override
  State<EditPersoForm> createState() => _EditPersoFormState();
}

class _EditPersoFormState extends State<EditPersoForm> {
  File? galleryFile;
  final ImageService imageService = ImageService();

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    nameController.text = widget.perso.name;
    descController.text = widget.perso.desc ?? '';

    if (widget.perso.imgPath != null) {
      galleryFile = File(widget.perso.imgPath!);
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
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Nom :"),
                                    TextFormField(
                                      controller: nameController,
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
                                      controller: descController,
                                      validator: (value) {return null;},
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24),

                              SizedBox(
                                  height: 200.0,
                                  width: 300.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showPicker(context: context);
                                    },
                                    child: galleryFile == null
                                        ? const Center(child: Text("Cliquez pour ajouter une image."))
                                        : Center(child: Image.file(galleryFile!)),
                                  )
                              ),
                              SizedBox(height: 24),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) return;

                                    final persoEdit = widget.perso.copyWith(
                                        name: nameController.text,
                                        desc: descController.text.trim().isEmpty
                                            ? null
                                            : descController.text.trim(),
                                        imgPath: galleryFile?.path,
                                    );

                                    Navigator.pop(context, persoEdit);
                                  },
                                  child: const Text('Enregistrer les modifications'),
                                ),
                              ),
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
                title: const Text('Photo Library'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await imageService.pickAndSaveImage(ImageSource.gallery);
                  if (image != null) {
                    setState(() => galleryFile = image);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await imageService.pickAndSaveImage(ImageSource.camera);
                  if (image != null) {
                    setState(() => galleryFile = image);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}