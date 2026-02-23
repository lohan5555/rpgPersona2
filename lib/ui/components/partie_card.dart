import 'package:flutter/material.dart';

import '../../data/models/partie.dart';
import '../screens/partie_detail_screen.dart';

class PartieCard extends StatelessWidget{
  final Partie partie;
  final VoidCallback onDelete;

  const PartieCard({
    super.key,
    required this.partie,
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PartieDetailPage(partie: partie),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partie.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    partie.desc ?? "",
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
                    content: const Text('Êtes-vous sur de vouloir supprimer cette partie ? Cette action est définitive.'),
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