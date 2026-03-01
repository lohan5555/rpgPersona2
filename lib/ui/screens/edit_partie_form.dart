import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/partie.dart';
import '../../services/image_service.dart';


class EditPartieForm extends StatefulWidget {
  final Partie partie;

  const EditPartieForm({super.key, required this.partie});

  @override
  State<EditPartieForm> createState() => _EditPartieFormState();
}

class _EditPartieFormState extends State<EditPartieForm> {
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

    nameController.text = widget.partie.name;
    descController.text = widget.partie.desc ?? '';

    if (widget.partie.imgPath != null) {
      galleryFile = File(widget.partie.imgPath!);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Modifier une Partie'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
            child:SingleChildScrollView(
              child: Builder(
                builder: (BuildContext context) {
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

                                final partieEdit = widget.partie.copyWith(
                                  name: nameController.text,
                                  desc: descController.text.trim().isEmpty
                                      ? null
                                      : descController.text.trim(),
                                  imgPath: galleryFile?.path,
                                );

                                Navigator.pop(context, partieEdit);
                              },
                              child: const Text('Enregistrer les modifications'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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