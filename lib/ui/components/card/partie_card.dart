import 'package:flutter/material.dart';

import '../../../data/models/partie.dart';
import '../../screens/partie_detail_screen.dart';

class PartieCard extends StatelessWidget{
  final Partie partie;
  final VoidCallback onDelete;
  final void Function(Partie) onEdit;

  const PartieCard({
    super.key,
    required this.partie,
    required this.onDelete,
    required this.onEdit
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: ContinuousRectangleBorder(),
      child:Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PartieDetailPage(partie: partie, onEdit: onEdit),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        partie.emoji,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            partie.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          if (partie.desc != null && partie.desc!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              partie.desc!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
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
          Divider(height: 0)
        ],
      )
    );
  }

}