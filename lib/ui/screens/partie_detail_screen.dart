import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rpg_persona2/data/models/partie.dart';
import 'package:rpg_persona2/data/models/perso.dart';
import 'package:rpg_persona2/ui/components/card/perso_card.dart';
import 'package:rpg_persona2/services/perso_service.dart';
import 'package:rpg_persona2/ui/screens/edit_partie_form.dart';

class PartieDetailPage extends StatefulWidget {
  final Partie partie;
  final Function(Partie) onEdit;
  final VoidCallback onDelete;

  const PartieDetailPage({
    super.key,
    required this.partie,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<PartieDetailPage> createState() => _PartieDetailPageState();
}


class _PartieDetailPageState extends State<PartieDetailPage> {
  final PersoService persoService = PersoService();

  late Partie _partie;
  List<Perso> _perso = [];

  final TextEditingController _controllerNote = TextEditingController();
  final FocusNode _focusNodeNote = FocusNode();
  bool focusText = false;

  @override
  void initState(){
    super.initState();
    _partie = widget.partie;
    _controllerNote.text = _partie.note ?? '';
    _loadPerso();

    // Quand on clic sur la zone de text, on toggle focusText
    _focusNodeNote.addListener(() {
      setState(() {
        focusText = _focusNodeNote.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controllerNote.dispose();
    _focusNodeNote.dispose();
    super.dispose();
  }

  Future<void> _loadPerso() async{
    final perso = await persoService.getAllpersoByPartie(_partie.id!);
    setState(() {
      _perso = perso;
    });
  }

  Future<void> deletePerso(int id) async {
    final perso = _perso.firstWhere((p) => p.id == id);

    //supprime l'image du perso
    final imgPath = perso.imgPath;
    if (imgPath != null && imgPath.contains("rpg_persona2")) {
      final file = File(imgPath);
      if (await file.exists()) {
        await file.delete();
      }
    }

    await persoService.deletePerso(id);
    await persoService.updatePersoListPosition();
    await _loadPerso();
  }

  Future<void> updatePerso(Perso perso) async {
    //on supprime l'ancienne image si on a choisi une nouvelle
    final oldPerso = _perso.firstWhere(
          (p) => p.id == perso.id,
    );
    final oldPath = oldPerso.imgPath;

    await persoService.updatePerso(perso);

    if (oldPath != null &&
        oldPath != perso.imgPath &&
        oldPath.contains("rpg_persona2") &&
        perso.imgPath != null) {
      final oldFile = File(oldPath);
      if (await oldFile.exists()) {
        await oldFile.delete();
      }
    }

    await _loadPerso();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_partie.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditPartieForm(
                    partie: _partie,
                    onChanged: (updatePartie){
                      widget.onEdit(updatePartie);
                      setState(() {
                        _partie = updatePartie;
                      });
                    },
                    onDelete: widget.onDelete,
                  ),
                ),
              );
            },
            icon: Icon(Icons.edit)
          )
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _header(),
            const Divider(height: 0),
            _note(),
            const Divider(height: 0),
            //const SizedBox(height: 5,),
            _persoList()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        onPressed: _showCreatePersoDialog,
        child: const Icon(Icons.add_reaction_outlined),
      ),
    );
  }

  Widget _header() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: focusText ? 9.0 : 6.0,
        end: focusText ? 6.0 : 9.0
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, child){
        return Padding(
          padding: const EdgeInsets.only(top:12, left: 15, right: 15, bottom: 0),
          child: AspectRatio(
            aspectRatio: 16/value,
            child: child
          )
        );
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16)
        ),
        child: _partie.imgPath == null
            ? Image.asset('assets/placeholder/placeholder.jpeg', fit: BoxFit.cover)
            : Image.file(File(_partie.imgPath!), width: 25, height: 25, fit: BoxFit.cover),
      ),
    );
  }

  Widget _note() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        focusNode: _focusNodeNote,
        onTapOutside: ((event) {
          _focusNodeNote.unfocus();
        }),
        controller: _controllerNote,
        maxLines: focusText ? 10 : 4,
        decoration: InputDecoration.collapsed(
          hintText: "Notes de la partie",
          border: InputBorder.none,
        ),
        onChanged: (value) {
          Partie p = _partie.copyWith(note: _controllerNote.text);
          widget.onEdit(p);
        },
      ),
    );
  }

  Widget _persoList() {
    return Expanded(
      child: _perso.isEmpty
        ? const Center(child: Text('Aucun personnage'))
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
          padding: const EdgeInsets.only(left: 10, right: 10),
          itemCount: _perso.length,
          onReorder: (oldIndex, newIndex) async {
            setState(() {
              if (newIndex > oldIndex) newIndex--;

              final item = _perso.removeAt(oldIndex);
              _perso.insert(newIndex, item);
            });

            for (int i = 0; i < _perso.length; i++) {
              _perso[i] = _perso[i].copyWith(listPosition: i);
              await persoService.updatePerso(_perso[i]);
            }
          },
          itemBuilder: (context, index) {
            final perso = _perso[index];

            return PersoCard(
              key: ValueKey(perso.id),
              perso: perso,
              onDelete: () => deletePerso(perso.id!),
              onEdit: updatePerso,
            );
        },
      ),
    );
  }

  Future<void> _showCreatePersoDialog() async {
    final TextEditingController controllerNom = TextEditingController();
    final TextEditingController controllerDesc = TextEditingController();

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
                  'Nouveau personnage',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controllerNom,
                      decoration: InputDecoration(
                        labelText: 'Nom du personnage',
                        //prefixIcon: const Icon(Icons.label_outline),
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
                        labelText: 'Description du personnage',
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
                          if (controllerNom.text.trim().isEmpty) return;

                          final perso = Perso(
                              name: controllerNom.text.trim(),
                              desc: controllerDesc.text.trim(),
                              listPosition: _perso.length,
                              partieId: _partie.id!
                          );

                          await persoService.insertPerso(perso);
                          await _loadPerso();

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(233, 193, 108, 1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Créer'),
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