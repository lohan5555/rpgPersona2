import 'package:flutter/material.dart';
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
      body: _partie.isEmpty
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePartieDialog,
        child: const Icon(Icons.add),
      ),
    );
  }



  Future<void> _showCreatePartieDialog() async {
    final TextEditingController controllerNom = TextEditingController();
    final TextEditingController controllerDesc = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nouvelle partie'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: controllerNom,
                  decoration: const InputDecoration(
                    labelText: 'Nom de la partie',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 3,
                  controller: controllerDesc,
                  decoration: const InputDecoration(
                    labelText: 'Description de la partie',
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

                final partie = Partie(
                  name: controllerNom.text.trim(),
                  desc: controllerDesc.text.trim(),
                );

                await partieService.insertPartie(partie);
                await _loadPartie();

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Partie créée')),
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
