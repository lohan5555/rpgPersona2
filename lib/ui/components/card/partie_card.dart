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
      margin: const EdgeInsets.only(bottom: 0),
      shape: ContinuousRectangleBorder(),
      child:Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PartieDetailPage(partie: partie, onEdit: onEdit, onDelete: onDelete,),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          partie.emoji,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                partie.name,
                                style: Theme.of(context).textTheme.titleLarge,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              if (partie.desc != null && partie.desc!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  partie.desc!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Icon(Icons.drag_handle),
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