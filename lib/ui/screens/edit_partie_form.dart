import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rpg_persona2/services/emoji_service.dart';

import '../../data/models/partie.dart';
import '../../services/image_service.dart';


class EditPartieForm extends StatefulWidget {
  final Partie partie;

  const EditPartieForm({super.key, required this.partie});

  @override
  State<EditPartieForm> createState() => _EditPartieFormState();
}

class _EditPartieFormState extends State<EditPartieForm> {
  File? _galleryFile;
  final ImageService imageService = ImageService();
  final EmojiService emojiService = EmojiService();


  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  late String _tempEmoji;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.partie.name;
    _descController.text = widget.partie.desc ?? '';
    _tempEmoji = widget.partie.emoji;

    if (widget.partie.imgPath != null) {
      _galleryFile = File(widget.partie.imgPath!);
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
                                  controller: _nameController,
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
                              child: _galleryFile == null
                                ? const Center(child: Text("Cliquez pour ajouter une image."))
                                : Center(child: Image.file(_galleryFile!)),
                              )
                          ),
                          SizedBox(height: 24),
                          GestureDetector(
                            onTap: () {
                              // Ferme le clavier texte avant d'ouvrir les emojis
                              FocusScope.of(context).unfocus();

                              emojiService.showEmojiPicker(context, (emoji) {
                                setStateDialog(() {
                                  _tempEmoji = emoji;
                                });
                              });
                            },
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                              child: Text(_tempEmoji, style: const TextStyle(fontSize: 35)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;

                                final partieEdit = widget.partie.copyWith(
                                  name: _nameController.text,
                                  desc: _descController.text.trim().isEmpty
                                      ? null
                                      : _descController.text.trim(),
                                  imgPath: _galleryFile?.path,
                                  emoji: _tempEmoji
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
                    setState(() => _galleryFile = image);
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
                    setState(() => _galleryFile = image);
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