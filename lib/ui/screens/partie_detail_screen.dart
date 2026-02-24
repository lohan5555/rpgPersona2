import 'package:flutter/material.dart';
import 'package:rpg_persona2/data/models/partie.dart';
import 'package:rpg_persona2/data/models/perso.dart';
import 'package:rpg_persona2/ui/components/perso_card.dart';
import 'package:rpg_persona2/services/perso_service.dart';

class PartieDetailPage extends StatefulWidget {
  final Partie partie;

  const PartieDetailPage({super.key, required this.partie});

  @override
  State<PartieDetailPage> createState() => _PartieDetailPageState();
}


class _PartieDetailPageState extends State<PartieDetailPage> {
  final PersoService persoService = PersoService();

  List<Perso> _perso = [];

  @override
  void initState(){
    super.initState();
    _loadPerso();
  }

  Future<void> _loadPerso() async{
    final perso = await persoService.getAllpersoByPartie(widget.partie.id!);
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
        title: Text(widget.partie.name),
      ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date de début : ${widget.partie.dateDebut.toLocal()}'),
                  Text('Date de fin : ${widget.partie.dateFin.toLocal()}'),
                ],
              ),
            ),
            Expanded(
              child: _perso.isEmpty
                  ? const Center(child: Text('Aucun personnage'))
                  : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _perso.length,
                itemBuilder: (context, index) {
                  final perso = _perso[index];
                  return PersoCard(perso: perso, onDelete: () => deletePerso(_perso[index].id!));
                },
              ),
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePersoDialog,
        child: const Icon(Icons.add_reaction_outlined),
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
                  partieId: widget.partie.id!
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