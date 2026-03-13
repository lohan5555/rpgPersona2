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
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        title: const Center(child: Text('Attention !')),
                        content: const Text('Êtes-vous sur de vouloir supprimer cette partie ? Cette action est définitive.'),
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
                                    onDelete()
                                  },
                                  child: const Text('OK')
                                )
                              ),
                            ],
                          )
                        ]
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