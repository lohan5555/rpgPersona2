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

  const PartieDetailPage({
    super.key,
    required this.partie,
    required this.onEdit
  });

  @override
  State<PartieDetailPage> createState() => _PartieDetailPageState();
}


class _PartieDetailPageState extends State<PartieDetailPage> {
  final PersoService persoService = PersoService();
  late Partie _partie;

  List<Perso> _perso = [];

  final TextEditingController controllerNote = TextEditingController();

  @override
  void initState(){
    super.initState();
    _partie = widget.partie;
    controllerNote.text = _partie.note ?? '';
    _loadPerso();
  }

  Future<void> _loadPerso() async{
    final perso = await persoService.getAllpersoByPartie(_partie.id!);
    setState(() {
      _perso = perso;
    });
  }

  Future<void> deletePerso(int id) async {
    await persoService.deletePerso(id);
    await _loadPerso();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Personnage supprimée')),
    );
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
              final partieEdit = await Navigator.push<Partie>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditPartieForm(partie: _partie),
                ),
              );
              if (partieEdit != null) {
                widget.onEdit(partieEdit);
                setState(() {
                  _partie = partieEdit;
                });
              }
            },
            icon: Icon(Icons.edit))
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _header(),
            const Divider(height: 0,),
            _note(),
            _persoList()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePersoDialog,
        child: const Icon(Icons.add_reaction_outlined),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(top:12, left: 15, right: 15, bottom: 0),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
              //bottom: Radius.circular(16),
              top: Radius.circular(16)
          ),
          child: _partie.imgPath == null
              ? Image.asset('assets/placeholder.jpeg', fit: BoxFit.cover)
              : Image.file(File(_partie.imgPath!), width: 25, height: 25, fit: BoxFit.cover),
        ),
      )
    );
  }

  Widget _note() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: controllerNote,
        maxLines: 6,
        decoration: const InputDecoration(
          labelText: 'Notes de la partie',
          alignLabelWithHint: true,
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          Partie p = _partie.copyWith(note: controllerNote.text);
          widget.onEdit(p);
        },
      ),
    );
  }

  Widget _persoList() {
    return Expanded(
      child: _perso.isEmpty
          ? const Center(child: Text('Aucun personnage'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _perso.length,
        itemBuilder: (context, index) {
          final perso = _perso[index];
          return PersoCard(
            perso: perso,
            onDelete: () => deletePerso(perso.id!),
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
        return AlertDialog(
          title: const Text('Nouveau personnage'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: controllerNom,
                  decoration: const InputDecoration(
                    labelText: 'Nom du personnage',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 3,
                  controller: controllerDesc,
                  decoration: const InputDecoration(
                    labelText: 'Description du personnage',
                    border: OutlineInputBorder(),
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controllerNom.text.trim().isEmpty) return;

                final perso = Perso(
                  name: controllerNom.text.trim(),
                  desc: controllerDesc.text.trim(),
                  partieId: _partie.id!
                );

                await persoService.insertPerso(perso);
                await _loadPerso();

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Perso créée')),
                );
              },
              child: const Text('Créer'),
            ),
          ],
        );
      },
    );
  }
}