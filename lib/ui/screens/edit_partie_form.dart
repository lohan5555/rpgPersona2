import 'dart:async';
import 'dart:io';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rpg_persona2/services/emoji_service.dart';
import 'package:rpg_persona2/ui/screens/home_screen.dart';

import '../../data/models/partie.dart';
import '../../services/image_service.dart';
import 'crop_screen.dart';


class EditPartieForm extends StatefulWidget {
  final Partie partie;
  final Function(Partie) onChanged;
  final VoidCallback onDelete;

  const EditPartieForm({
    super.key,
    required this.partie,
    required this.onChanged,
    required this.onDelete,
  });

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

    _nameController.text = widget.partie.name;
    _descController.text = widget.partie.desc ?? '';
    _tempEmoji = widget.partie.emoji;
    _cropController = CustomImageCropController();

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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                title: const Center(child: Text('Attention !')),
                content: const Text('Êtes-vous sur de vouloir supprimer cette partie ? Cette action est définitive.'),
                actions: [
                  Row(
                    children: [
                      Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
                          )
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromRGBO(233, 193, 108, 1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.pop(context, 'OK');
                            widget.onDelete();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Partie supprimée avec succès')),
                            );

                            // navigue jusqu'à la racine
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          child: const Text('OK')
                        )
                      ),
                    ],
                  )
                ]
              ),
            ),
          )
        ],
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
                          SizedBox(height: 24),
                          _displayEmoji(setStateDialog),
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

  Widget _displayEmoji(StateSetter setStateDialog){
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // Ferme le clavier texte avant d'ouvrir les emojis
            FocusScope.of(context).unfocus();

            emojiService.showEmojiPicker(context, (emoji) {
              setStateDialog(() {
                _tempEmoji = emoji;
              });
              _autoSave();
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: Text(_tempEmoji, style: const TextStyle(fontSize: 40)),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: Color.fromRGBO(233, 193, 108, 1), shape: BoxShape.circle),
            child: const Icon(Icons.edit, size: 14, color: Colors.white),
          ),
        ),
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
            shape: CustomCropShape.Ratio
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
      final updatedPartie = widget.partie.copyWith(
        name: _nameController.text,
        desc: _descController.text.trim(),
        imgPath: _galleryFile?.path,
        emoji: _tempEmoji,
      );
      widget.onChanged(updatedPartie);

    });
  }
}