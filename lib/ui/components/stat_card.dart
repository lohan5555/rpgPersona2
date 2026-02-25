import 'package:flutter/material.dart';

import '../../data/models/stat.dart';

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
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onLongPress: _showDeleteStatDialog,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.stat.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.stat.valeur.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.minimize),
                          onPressed: () async {
                            final statEdit = widget.stat.copyWith(
                                valeur: widget.stat.valeur-1,
                            );
                            widget.onEdit(statEdit);
                          }
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            final statEdit = widget.stat.copyWith(
                                valeur: widget.stat.valeur+1,
                            );
                            widget.onEdit(statEdit);
                          }
                        )
                      ],
                    )
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }

  Future<void> _showDeleteStatDialog() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Attention'),
        content: const Text('Êtes-vous sur de vouloir supprimer cette statistique ? Cette action est définitive.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Annuler'),
          ),
          TextButton(
              onPressed: () => {
                Navigator.pop(context, 'OK'),
                widget.onDelete()
              },
              child: const Text('OK')),
        ],
      ),
    );
  }

}