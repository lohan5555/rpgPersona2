import 'package:flutter/material.dart';
import 'package:rpg_persona2/ui/components/card/partie_card.dart';

import '../../data/models/partie.dart';
import '../../services/partie_service.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PartieService partieService = PartieService();

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
    await partieService.updateParie(partie);
    await _loadPartie();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partie modifiée')),
    );
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
            : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _partie.length,
          itemBuilder: (context, index) {
            final partie = _partie[index];

            return PartieCard(
              partie: partie,
              onDelete: () => deletePartie(_partie[index].id!),
              onEdit: updatePartie);
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

                        _showEmojiPicker(context, (emoji) {
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
                        labelText: 'Description',
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

  void _showEmojiPicker(BuildContext context, Function(String) onEmojiSelected) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                    child: EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        onEmojiSelected(emoji.emoji);
                        Navigator.pop(context);
                      },
                      config: const Config(
                        height: 256,
                        checkPlatformCompatibility: true,
                        categoryViewConfig: CategoryViewConfig(
                          backgroundColor: Color.fromRGBO(250, 240, 227, 0),
                          indicatorColor: Colors.black,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.black
                        ),
                        emojiViewConfig: EmojiViewConfig(
                          backgroundColor: Color.fromRGBO(250, 240, 227, 0),
                          columns: 7,
                          emojiSizeMax: 28,
                        ),
                        bottomActionBarConfig: BottomActionBarConfig(
                          showBackspaceButton: false,
                          showSearchViewButton: false,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        );
      },
    );
  }
}
