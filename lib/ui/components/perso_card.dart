import 'package:flutter/material.dart';
import 'package:rpg_persona2/data/models/perso.dart';

class PersoCard extends StatelessWidget{
  final Perso perso;
  final VoidCallback onDelete;

  const PersoCard({
    super.key,
    required this.perso,
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
                    perso.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    perso.desc ?? "",
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
                    content: const Text('Êtes-vous sur de vouloir supprimer ce personnage ? Cette action est définitive.'),
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