import 'package:flutter/material.dart';
import 'package:rpg_persona2/services/emoji_service.dart';
import 'package:rpg_persona2/services/perso_service.dart';
import 'package:rpg_persona2/ui/components/card/partie_card.dart';

import '../../data/models/partie.dart';
import '../../data/models/perso.dart';
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
  final PersoService persoService = PersoService();

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
    final partie = _partie.firstWhere((p) => p.id == id);
    final List<Perso> perso = await persoService.getAllpersoByPartie(id);

    await partieService.deletePartie(id, perso, partie);
    await partieService.updatePartieListPosition();
    await _loadPartie();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partie supprimée')),
    );
  }

  Future<void> miseAJourPartie(Partie partie) async {
    //on supprime l'ancienne image si on a choisi une nouvelle
    final oldPartie = _partie.firstWhere((p) => p.id == partie.id,);
    await partieService.updateParie(partie, oldPartie.imgPath);

    await _loadPartie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: SafeArea(
        child: _partie.isEmpty
          ? const Center(child: Text('Créez votre première partie !'))
          : ReorderableListView.builder(
            proxyDecorator: (Widget child, int index, Animation<double> animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget? child) {
                  return Material(
                    color: Colors.transparent,
                    child: child,
                  );
                },
                child: child,
              );
            },
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
                await partieService.updateParie(_partie[i], _partie[i].imgPath);
              }
            },
            itemBuilder: (context, index) {
              final partie = _partie[index];

              return PartieCard(
                key: ValueKey(partie.id), // IMPORTANT
                partie: partie,
                onDelete: () => deletePartie(partie.id!),
                onEdit: miseAJourPartie,
              );
            },
          ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
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
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: const Center(
                child: Text(
                  'Nouvelle aventure',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            emojiService.showEmojiPicker(context, (emoji) {
                              setStateDialog(() => tempEmoji = emoji);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey[300]!, width: 1),
                            ),
                            child: Text(tempEmoji, style: const TextStyle(fontSize: 40)),
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
                    ),
                    const SizedBox(height: 30),

                    TextField(
                      controller: controllerNom,
                      decoration: InputDecoration(
                        labelText: 'Nom de la partie',
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: controllerDesc,
                      decoration: InputDecoration(
                        labelText: 'Système de jeu',
                        //prefixIcon: const Icon(Icons.auto_stories_outlined),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (controllerNom.text.isEmpty) return;
                          final partie = Partie(
                            name: controllerNom.text.trim(),
                            desc: controllerDesc.text.trim(),
                            emoji: tempEmoji,
                            listPosition: _partie.length,
                          );
                          await partieService.insertPartie(partie);
                          _loadPartie();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(233, 193, 108, 1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Créer", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
