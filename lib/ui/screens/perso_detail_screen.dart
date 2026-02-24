import 'package:flutter/material.dart';
import 'package:rpg_persona2/data/models/perso.dart';

import '../../data/models/stat.dart';
import '../../services/stat_service.dart';
import '../components/stat_card.dart';

class PersoDetailPage extends StatefulWidget {
  final Perso perso;

  const PersoDetailPage({super.key, required this.perso});

  @override
  State<PersoDetailPage> createState() => _PersoDetailPageState();
}


class _PersoDetailPageState extends State<PersoDetailPage> {
  final StatService statservice = StatService();

  List<Stat> _stat = [];

  @override
  void initState(){
    super.initState();
    _loadStat();
  }

  Future<void> _loadStat() async{
    final stat = await statservice.getAllStatByPerso(widget.perso.id!);
    setState(() {
      _stat = stat;
    });
  }

  Future<void> deleteStat(int id) async {
    await statservice.deleteStat(id);
    await _loadStat();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Statistique supprimée')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.perso.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Statistique :'),
              ],
            ),
          ),
          Expanded(
            child: _stat.isEmpty
                ? const Center(child: Text('Aucune statistique'))
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _stat.length,
              itemBuilder: (context, index) {
                final stat = _stat[index];
                return StatCard(stat: stat, onDelete: () => deleteStat(_stat[index].id!));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateStatDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateStatDialog() async {
    final TextEditingController controllerNom = TextEditingController();
    final TextEditingController controllerValeur = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nouvelle statistique'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: controllerNom,
                  decoration: const InputDecoration(
                    labelText: 'Statistique',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controllerValeur,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Valeur de la statistique',
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
                if (controllerValeur.text.trim().isEmpty) return;
                if(int.tryParse(controllerValeur.text.trim()) == null) return;

                final stat = Stat(
                    name: controllerNom.text.trim(),
                    valeur: int.parse(controllerValeur.text.trim()),
                    persoId: widget.perso.id!
                );

                await statservice.insertStat(stat);
                await _loadStat();

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Stat créée')),
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