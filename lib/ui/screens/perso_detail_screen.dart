import 'package:flutter/material.dart';
import 'package:rpg_persona2/data/models/perso.dart';
import 'package:rpg_persona2/ui/components/perso_general.dart';
import 'package:rpg_persona2/ui/components/perso_inventaire.dart';
import 'package:rpg_persona2/ui/components/perso_statistique.dart';

import '../../data/models/stat.dart';
import '../../services/stat_service.dart';
import 'edit_perso_form.dart';

class PersoDetailPage extends StatefulWidget {
  final Perso perso;
  final Function(Perso) onEdit;

  const PersoDetailPage({super.key, required this.perso, required this.onEdit});

  @override
  State<PersoDetailPage> createState() => _PersoDetailPageState();
}


class _PersoDetailPageState extends State<PersoDetailPage> {
  final StatService statservice = StatService();
  int currentPageIndex = 1;
  late Perso _perso;

  List<Stat> _stat = [];

  @override
  void initState(){
    super.initState();
    _perso = widget.perso;
    _loadStat();
  }

  Future<void> _loadStat() async{
    final stat = await statservice.getAllStatByPerso(_perso.id!);
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

  Future<void> updateStat(Stat stat) async{
    await statservice.updateStat(stat);
    await _loadStat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_perso.name),
        actions: [
          IconButton(
              onPressed: () async{
                final persoEdit = await Navigator.push<Perso>(
                  context,
                    MaterialPageRoute(
                      builder: (_) => EditPersoForm(perso: _perso),
                    )
                );
                if (persoEdit != null) {
                  widget.onEdit(persoEdit);
                  setState(() {
                    _perso = persoEdit;
                  });
                }
              }, icon: Icon(Icons.edit)
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          PersoStatistique(stat: _stat, onDelete: deleteStat, onEdit: updateStat),
          PersoGeneral(perso: _perso, onEdit: widget.onEdit),
          PersoInventaire()
        ],
      ),
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: [
            NavigationDestination(
                icon: Icon(Icons.query_stats_outlined),
                selectedIcon: Icon(Icons.query_stats),
                label: 'Statistique'),
            NavigationDestination(
                icon: Icon(Icons.person_outlined),
                selectedIcon: Icon(Icons.person),
                label: 'Général'),
            NavigationDestination(
                icon: Icon(Icons.backpack_outlined),
                selectedIcon: Icon(Icons.backpack),
                label: 'Inventaire')
          ]
      ),
      floatingActionButton: currentPageIndex==0
        ? FloatingActionButton(
          onPressed: _showCreateStatDialog,
          child: const Icon(Icons.add),
        )
        : Container(),
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
                if(double.tryParse(controllerValeur.text.trim()) == null ) return;

                final stat = Stat(
                    name: controllerNom.text.trim(),
                    valeur: double.parse(controllerValeur.text.trim()),
                    persoId: _perso.id!
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