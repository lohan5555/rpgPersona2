import 'package:flutter/material.dart';

import '../../../data/models/stat.dart';

class StatCard extends StatefulWidget {
  final Stat stat;
  final VoidCallback onDelete;
  final void Function(Stat) onEdit;

  const StatCard({
    super.key,
    required this.stat,
    required this.onDelete,
    required this.onEdit
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard>{



  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onLongPress: _showDeleteStatDialog,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                widget.stat.name,
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  IconButton(
                      icon: Image.asset(
                        "assets/button/moinsEntier.png",
                        width: 20,
                        height: 20,
                      ),
                    onPressed: () async {
                      final statEdit = widget.stat.copyWith(
                          valeur: round1(widget.stat.valeur-1),
                      );
                      widget.onEdit(statEdit);
                    }
                  ),
                  IconButton(
                      icon: Image.asset(
                        "assets/button/moinsDecimal.png",
                        width: 20,
                        height: 20,
                      ),
                      onPressed: () async {
                        final statEdit = widget.stat.copyWith(
                          valeur: round1(widget.stat.valeur-0.1),
                        );
                        widget.onEdit(statEdit);
                      }
                  ),
                  widget.stat.valeur-widget.stat.valeur.toInt()==0
                    ?Text(
                      widget.stat.valeur.toInt().toString(),
                      style: TextStyle(fontSize: 30),
                    )
                    :Text(
                      widget.stat.valeur.toString(),
                      style: TextStyle(fontSize: 30),
                    ),
                  IconButton(
                      icon: Image.asset(
                        "assets/button/plusDecimal.png",
                        width: 20,
                        height: 20,
                      ),
                      onPressed: () async {
                        final statEdit = widget.stat.copyWith(
                          valeur: round1(widget.stat.valeur+0.1),
                        );
                        widget.onEdit(statEdit);
                      }
                  ),
                  IconButton(
                      icon: Image.asset(
                        "assets/button/plusEntier.png",
                        width: 20,
                        height: 20,
                      ),
                    onPressed: () async {
                      final statEdit = widget.stat.copyWith(
                          valeur: round1(widget.stat.valeur+1),
                      );
                      widget.onEdit(statEdit);
                    }
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //fonction pour éviter les valeurs style 16.59999999999994
  double round1(double v) => double.parse(v.toStringAsFixed(1));

  Future<void> _showDeleteStatDialog() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Center(child: Text('Attention !')),
        content: const Text('Êtes-vous sur de vouloir supprimer cette statistique ? Cette action est définitive.'),
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
                    onPressed: () => {
                      Navigator.pop(context, 'OK'),
                      widget.onDelete()
                    },
                    child: const Text('OK')
                  )
                ),
              ],
            )
          ]
      ),
    );
  }

}