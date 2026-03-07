import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rpg_persona2/services/emoji_service.dart';
import 'package:rpg_persona2/ui/components/card/partie_card.dart';

import '../../data/models/partie.dart';
import '../../services/partie_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PartieService partieService = PartieService();
  final EmojiService emojiService = EmojiService();

  List<Partie> _partie = [];

  @override
  void initState(){
    super.initState();
    _loadPartie();
  }

  Future<void> _loadPartie() async{
    final partie = await partieService.getAllpartie();
    setState(() {
      _partie = partie;
    });
  }

  Future<void> deletePartie(int id) async {
    await partieService.deletePartie(id);
    await _loadPartie();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partie supprimée')),
    );
  }

  Future<void> updatePartie(Partie partie) async {
    //on supprime l'ancienne image si on a choisi une nouvelle
    final oldPartie = _partie.firstWhere(
          (p) => p.id == partie.id,
    );
    final oldPath = oldPartie.imgPath;

    await partieService.updateParie(partie);

    if (oldPath != null &&
        oldPath != partie.imgPath &&
        oldPath.contains("rpg_persona2") &&
        partie.imgPath != null) {
      final oldFile = File(oldPath);
      if (await oldFile.exists()) {
        await oldFile.delete();
      }
    }
    await _loadPartie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: _partie.isEmpty
          ? const Center(child: Text('Aucune partie'))
          : ReorderableListView.builder(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            itemCount: _partie.length,
            onReorder: (oldIndex, newIndex) async {
              setState(() {
                if (newIndex > oldIndex) newIndex--;

                final item = _partie.removeAt(oldIndex);
                _partie.insert(newIndex, item);
              });

              for (int i = 0; i < _partie.length; i++) {
                _partie[i] = _partie[i].copyWith(listPosition: i);
                await partieService.updateParie(_partie[i]);
              }
            },
            itemBuilder: (context, index) {
              final partie = _partie[index];

              return PartieCard(
                key: ValueKey(partie.id), // IMPORTANT
                partie: partie,
                onDelete: () => deletePartie(partie.id!),
                onEdit: updatePartie,
              );
            },
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePartieDialog,
        child: const Icon(Icons.add),
      ),
    );
  }



  Future<void> _showCreatePartieDialog() async {
    final TextEditingController controllerNom = TextEditingController();
    final TextEditingController controllerDesc = TextEditingController();
    String tempEmoji = "⚔️";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Nouvelle partie'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Ferme le clavier texte avant d'ouvrir les emojis
                        FocusScope.of(context).unfocus();

                        emojiService.showEmojiPicker(context, (emoji) {
                          setStateDialog(() {
                            tempEmoji = emoji;
                          });
                        });
                      },
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        child: Text(tempEmoji, style: const TextStyle(fontSize: 35)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controllerNom,
                      decoration: const InputDecoration(
                        labelText: 'Nom de la partie',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controllerDesc,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Description/Système de jeu',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (controllerNom.text.isEmpty) return;

                    final partie = Partie(
                      name: controllerNom.text.trim(),
                      desc: controllerDesc.text.trim(),
                      emoji: tempEmoji,
                      listPosition: _partie.length
                    );

                    await partieService.insertPartie(partie);
                    _loadPartie();
                    Navigator.pop(context);
                  },
                  child: const Text("Créer"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
