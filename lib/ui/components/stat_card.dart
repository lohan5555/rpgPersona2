import 'package:flutter/material.dart';

import '../../data/models/stat.dart';

class StatCard extends StatelessWidget{
  final Stat stat;
  final VoidCallback onDelete;

  const StatCard({
    super.key,
    required this.stat,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
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
                      stat.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stat.valeur.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => showDialog<String>(
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
                              onDelete()
                            },
                            child: const Text('OK')),
                      ],
                    ),
                  ),
                )
              ],
            )
        ),
      ),
    );
  }

}